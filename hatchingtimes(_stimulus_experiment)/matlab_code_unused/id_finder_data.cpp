/* File: id_finder.cpp
 *
 * Description: Takes an array of vibration point from MATLAB
 *   and parameter values used to define intervals and durations.
 *   Calls a function to find intervals and durations, and returns
 *   an array of interval lengths, an array of duration lengths,
 *   and the number of intervals and durations. These return values
 *   are put into MATLAB space.
 *
 * Author: Ming Guo
 * Created: 12/7/12
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "mex.h"

#define _Out_
#define _In_
#define _InOut_

#define NOISE_THRESHOLD_VALUES prhs[0]
#define MIN_INTERVAL_VALUES    prhs[1]
#define MIN_DURATION_VALUES    prhs[2]
#define VIBRATION_DATA         prhs[3]
#define DELTA_T                prhs[4]
#define INTERVAL_RANGE         prhs[5]
#define DURATION_RANGE         prhs[6]

#define MATLAB_WORKSPACE_VALUE "base"

#define PER_MINUTE_RATE_IN_SECONDS 60
#define MAX_NUM_ID 10000

#define RESULTS_VARIABLE_NAME "results"

#define STATUS_FAILED(x) (x != 0)

/* Function: idFinder
 *
 * Description: Finds intervals and durations of vibration
 *   array based on threshold values for noise, min interval
 *   length, and min duration length. Note that timescale is 
 *   not included in this function. minInterval and minDuration 
 *   are integers representing the index numbers in the vibration 
 *   array. The timescale is expected to be calculated in MATLAB. 
 *   Also, although vibrations being analyzed are expected to 
 *   start and end with durations, this function does not perform 
 *   that check.
 *
 * Parameters:
 *     threshold: Noise threshold, above which is considered signal,
 *       below which is considered noise.
 *     minInterval: Minimum length for an interval. If an interval is
 *       shorter than minInterval, it is included as part of the durations
 *       that surround it. 
 *     minDuration: Minimum length for an duration. If an duration is
 *       shorter than minDuration, it is included as part of the intervals
 *       that surround it. 
 *     vibration: double array of vibration data points
 *     numDataPoints: number of data points in the vibration array
 *     numIntervals: output number of intervals found
 *     numDurations: output number of durations found
 *     intervalLengths: output int array containing the lengths of all 
 *       intervals found, in order
 *     durationLengths: output int array containing the lengths of all
 *       durations found, in order
 *     durationFirst: boolean indication whether or not a duration came
 *       first in the vibration data
 */
void idFinder(_In_ double threshold,
			  _In_ int minInterval,
			  _In_ int minDuration,
			  _In_ double *vibration,
			  _In_ int numDataPoints,
			  _Out_ int *numIntervals,
			  _Out_ int *numDurations,
			  _Out_ int *intervalLengths,
			  _Out_ int *durationLengths,
			  _Out_ bool *durationFirst)
{
	*numIntervals = 0;
	*numDurations = 0;
	
	// curLen is the length of current interval or duration
	int curLen = 0;
	
	// switchLen is the length of the interval or duration we just switched
	// into, to keep track of whether or not it meets minInterval or minDuration
	int switchLen = 0;
	
	// boolean value indication whether we are currently in an interval or
	// duration
	bool isDuration;
	
	if (fabs(vibration[0]) < threshold)
	{
		isDuration = false;
	}
	else 
	{
		isDuration = true;
	}
	
	
	// go through each value in the vibrations array
	for (int i = 0; i < numDataPoints; i++)
    {
		// the value is less than the threshold to be considered a duration
		if (fabs(vibration[i]) < threshold)
		{
			// if we're currently in a duration, then we see if we've seen
			// enough >minInterval values in a row to switch over to being in
			// an interval
			if (isDuration)
			{
				switchLen++;
				
				if (switchLen >= minInterval)
				{					
					isDuration = false;
					(*numIntervals)++;
					
					if (*numDurations > 0)
					{
						durationLengths[(*numDurations)-1] = curLen;
					}
					else 
					{
						durationLengths[0] = curLen;
						(*numDurations)++;
						
						*durationFirst = true;
					}
					
					
					curLen = switchLen;
					switchLen = 0;
				}
			}
			
			// if we're currently in an interval, then just increment
			// the interval length. Also, reset counter for duration
			// if we previously saw duration values, but their length
			// didn't meet the min duraiton length
			else
			{
				if (switchLen != 0)
				{
					curLen += switchLen;
					switchLen = 0;
				}
				
				curLen++;	      
			}
		}
		
		// ditto for values that are above threshold to be considered durations
		else
		{
			if (!isDuration)
			{
				switchLen++;
				
				if (switchLen >= minDuration)
				{	
					isDuration = true;
					(*numDurations)++;
					
					if (*numIntervals > 0)
					{
						intervalLengths[(*numIntervals)-1] = curLen;
					}
					else 
					{
						intervalLengths[0] = curLen;
						(*numIntervals)++;
						
						*durationFirst = false;
					}
					
					
					curLen = switchLen;
					switchLen = 0;
				}
			}
			else
			{
				if (switchLen != 0)
				{
					curLen += switchLen;
					switchLen = 0;
				}
				
				curLen++;
			}
		}
    }
	
	// set the length of whatever was last to respective
	// length array
	if (isDuration)
    {
		if (*numDurations > 0)
		{
			durationLengths[(*numDurations)-1] = curLen;
		}
		else 
		{
			durationLengths[0] = curLen;
			(*numDurations)++;
			
			*durationFirst = true;
		}
		
    }
	else
    {
		if (*numIntervals > 0)
		{
			intervalLengths[(*numIntervals)-1] = curLen;
		}
		else {
			intervalLengths[0] = curLen;
			(*numIntervals)++;
			
			*durationFirst = false;
		}
		
    }
}

void countNumIntervalsDurationsInPeakHatchingRange(_In_ int numIntervals,
												   _In_ int numDurations,
												   _In_ int *intervalLengths, 
												   _In_ int *durationLengths,
												   _In_ int *intervalRange, 
												   _In_ int *durationRange,
												   _Out_ int *numIntervalsInPeak, 
												   _Out_ int *numDurationsInPeak)
{		
	*numIntervalsInPeak = 0;
	*numDurationsInPeak = 0;
	
	for (int i = 0; i < numIntervals; i++)
	{
		if (intervalLengths[i] >= intervalRange[0] && intervalLengths[i] <= intervalRange[1])
		{
			(*numIntervalsInPeak)++;
		}
	}
	
	for (int i = 0; i < numDurations; i++)
	{
		if (durationLengths[i] >= durationRange[0] && durationLengths[i] <= durationRange[1])
		{
			(*numDurationsInPeak)++;
		}
	}
}


/* Function: validateMexFunctionInputs
 *
 * Description: Does initial input validation for mexFunction.
 *
 * Parameters:
 *     nlhs: Number of expected left hand side outputs to MATLAB.
 *     nrhs: Number of right hand side inputs from MATLAB.
 *     prhs: Array of pointers to right hand side input data.
 */
void validateMexFunctionInputs(_In_ int nlhs,
							   _In_ int nrhs,
							   _In_ const mxArray **prhs)
{  
	// check if function has four right hand side arguments
    if (nrhs != 7)
    {
        mexErrMsgTxt("Usage: id_finder_data(<noise thresholds>, <min intervals>, <min durations>, <cell of double arrays of vibration info>), <delta T value>, <interval range>, <duration range>.\n");
    }
	
	// check if function has no left hand side arguments
    if (nlhs != 0)
    {
        mexErrMsgTxt("Does not return any left hand side outputs.\n");
    } 
    
	// check that noise thresholds is a 1-D array of type double with at least 1 element
    if (!mxIsDouble(NOISE_THRESHOLD_VALUES) || mxGetNumberOfDimensions(NOISE_THRESHOLD_VALUES) != 2)
    {
        mexErrMsgTxt("Noise threshold values must be an arry of type double.\n");
    }
	
	// check that min intervals is an array of type double with at least 1 element
    if (!mxIsDouble(MIN_INTERVAL_VALUES) || mxGetNumberOfDimensions(MIN_INTERVAL_VALUES) != 2)
    {
        mexErrMsgTxt("Min interval must be a scalar of type double.\n");
    }
	
	// check that min durations is an array of type double with at least 1 element
    if (!mxIsDouble(MIN_DURATION_VALUES) || mxGetNumberOfDimensions(MIN_DURATION_VALUES) != 2)
    {
        mexErrMsgTxt("Min duration must be a scalar of type double.\n");
    }
	
	// check that vibration data is a cell with at least 1 element
	if (!mxIsCell(VIBRATION_DATA))
    {
        mexErrMsgTxt("Vibration data must be a cell.\n");
    }	
	
	// check that delta t is a scalar of type double
	if (!mxIsDouble(DELTA_T) || mxGetNumberOfElements(DELTA_T) != 1)
	{
		mexErrMsgTxt("Delta T must be a scalar of type double.\n");
	}
	
	if (!mxIsDouble(INTERVAL_RANGE) || mxGetNumberOfDimensions(INTERVAL_RANGE) != 2 || mxGetNumberOfElements(INTERVAL_RANGE) != 2)
	{
		mexErrMsgTxt("Interval range must be a 1-D array of type double with 2 elements.\n");
	}
	
	if (!mxIsDouble(DURATION_RANGE) || mxGetNumberOfDimensions(DURATION_RANGE) != 2 || mxGetNumberOfElements(DURATION_RANGE) != 2)
	{
		mexErrMsgTxt("Duration range must be a 1-D array of type double with 2 elements.\n");
	}
}

/* Function: getMatlabInputInfo
 *
 * Description: Gets the MATLAB input info to pass to id_finder function
 *
 * Parameters:
 *     threshold: Noise threshold
 *     minInterval: Min interval length
 *     minDuration: Min duration length
 *     numDataPoints: Number of vibration data points
 *     vibration: Vibration data points array
 */
void getMatlabInputInfo(_Out_ int *numThresholds,
						_Out_ double **thresholds,
						_Out_ int *numMinIntervals,
						_Out_ int **minIntervals,
						_Out_ int *numMinDurations,
						_Out_ int **minDurations,
						_Out_ int *numVibrations,
						_Out_ int **numDataPointsForEachVibration,
						_Out_ double ***vibrations,
						_Out_ double *deltaT,
						_Out_ int *intervalRange,
						_Out_ int *durationRange,
						_In_ const mxArray **prhs)
{
	*deltaT = mxGetScalar(DELTA_T);
	
	if (*deltaT <= 0)
	{
		mexErrMsgTxt("Delta T must be positive.\n");
	}
	
	*numThresholds = mxGetNumberOfElements(NOISE_THRESHOLD_VALUES);	
	
	if (*numThresholds < 1)
	{
		mexErrMsgTxt("At least one threshold value required.\n");
	}	
	
	*thresholds = (double *)mxGetData(NOISE_THRESHOLD_VALUES);
	
	*numMinIntervals = mxGetNumberOfElements(MIN_INTERVAL_VALUES);
	
	if (*numMinIntervals < 1)
	{
		mexErrMsgTxt("At least one min interval value required.\n");
	}	
	
	*minIntervals = (int *)malloc((*numMinIntervals) * sizeof(int));
	
	if (*minIntervals == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	double *minIntervalInSeconds = (double *)mxGetData(MIN_INTERVAL_VALUES);
							 
	for (int i = 0; i < *numMinIntervals; i++)
	{
		(*minIntervals)[i] = (int)(minIntervalInSeconds[i]/(*deltaT));
		
		if ((*minIntervals)[i] < 1)
		{
			mexErrMsgTxt("Min interval value too low for the sampling rate.\n");
		}
	}
	
	*numMinDurations = mxGetNumberOfElements(MIN_DURATION_VALUES);
	
	if (*numMinDurations < 1)
	{
		mexErrMsgTxt("At least one min duration value required.\n");
	}
	
	*minDurations = (int *)malloc((*numMinDurations) * sizeof(int));
	
	if (*minDurations == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	double *minDurationInSeconds = (double *)mxGetData(MIN_DURATION_VALUES);
	
	for (int i = 0; i < *numMinDurations; i++)
	{
		(*minDurations)[i] = (int)(minDurationInSeconds[i]/(*deltaT));
		
		if ((*minDurations)[i] < 1)
		{
			mexErrMsgTxt("Min duration value too low for the sampling rate.\n");
		}
	}
	
	*numVibrations = mxGetNumberOfElements(VIBRATION_DATA);
	
	if (*numVibrations < 1)
	{
		mexErrMsgTxt("At least one vibration required.\n");
	}
	
	*numDataPointsForEachVibration = (int *)malloc((*numVibrations) * sizeof(int));
	
	if (*numDataPointsForEachVibration == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	*vibrations = (double **)malloc((*numVibrations) * sizeof(double *));
	
	if (*vibrations == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	for (int i = 0; i < *numVibrations; i++)
	{
		mxArray *curCell =  mxGetCell(VIBRATION_DATA, i);
		
		(*numDataPointsForEachVibration)[i] = mxGetNumberOfElements(curCell);
		
		if ((*numDataPointsForEachVibration)[i] < 1)
		{
			mexErrMsgTxt("At least one vibration data point required for each vibration.\n");
		}
		
		(*vibrations)[i] = (double *)mxGetData(curCell);			
	}
	
	double *intervalRangeInSeconds = (double *)mxGetData(INTERVAL_RANGE);
	
	intervalRange[0] = (int)(intervalRangeInSeconds[0]/(*deltaT));
	intervalRange[1] = (int)(intervalRangeInSeconds[1]/(*deltaT));
	
	if (intervalRange[0] < 1 || intervalRange[1] < 1)
	{
		mexErrMsgTxt("Interval range values too low for the sampling rate.\n");
	}
	
	if (intervalRange[0] >= intervalRange[1])
	{
		mexErrMsgTxt("Interval range lower value must be smaller than interval range upper value.\n");
	}
	
	double *durationRangeInSeconds = (double *)mxGetData(DURATION_RANGE);
	
	durationRange[0] = (int)(durationRangeInSeconds[0]/(*deltaT));
	durationRange[1] = (int)(durationRangeInSeconds[1]/(*deltaT));
	
	if (durationRange[0] < 1 || durationRange[1] < 1)
	{
		mexErrMsgTxt("Duration range values too low for the sampling rate.\n");
	}
	
	if (durationRange[0] >= durationRange[1])
	{
		mexErrMsgTxt("Duration range lower value must be smaller than duration range upper value.\n");
	}
}

/* Function: createOutputArray
 *
 * Description: Create a int32 MATLAB array using int array
 *   passed to function.
 *
 * Parameters:
 *     array: array to populate the mxArray.
 *     arraySize: length of input array
 *
 * Returns: newly created int32 mxArray.
 */
mxArray *createOutput2DArray(_In_ double *array,
							 _In_ int numRows,
							 _In_ int numColumns)
{	
    // create output mxArray for input array
    mxArray *outputArray = mxCreateDoubleMatrix((mwSize)numRows, (mwSize)numColumns, mxREAL);
	
    if (outputArray == NULL)
    {
        return NULL;
    }
	
	// copy values of input array to newly created mxArray
	double *outputArrayData = (double *)mxGetData(outputArray);
	memcpy(outputArrayData, array, numRows * numColumns * sizeof(double));
	
    return outputArray;	
}

/* Function: mexFunction
 *
 * Description: Gateway function from MATLAB to C/C++. Handles input 
 *     from MATLAB and output to MATLAB. plhs is not used, because
 *     of a memory leak issue I have encountered in the past with
 *     it, that appears to be a bug with MEX. Instead, I use
 *     mexPutVariable to return values back to MATLAB space.
 *
 * Parameters:
 *     nlhs: Number of expected left hand side outputs to MATLAB.
 *     plhs: Array of pointers to expected left hand side output data. Unused 
 *       due to memory leak issue (possible MEX bug??).
 *     nrhs: Number of right hand side inputs from MATLAB.
 *     prhs: Array of pointers to right hand side input data.
 */
void mexFunction(_In_ int nlhs,
				 _Out_ mxArray **plhs,
				 _In_ int nrhs,
				 _In_ const mxArray **prhs)
{  
	// initial validation of inputs from MATLAB
    validateMexFunctionInputs(nlhs, nrhs, prhs);
	
	int numThresholds;
	double *thresholds;
	int numMinIntervals;
	int *minIntervals;
	int numMinDurations;
	int *minDurations;
	int numVibrations;
	int *numDataPointsForEachVibration;
	double **vibrations;
	double deltaT;
	int intervalRange[2];
	int durationRange[2];
	
	// get the matlab input info in form to pass to idFinder function
	getMatlabInputInfo(&numThresholds,
					   &thresholds, 
					   &numMinIntervals,
					   &minIntervals, 
					   &numMinDurations,
					   &minDurations, 
					   &numVibrations,
					   &numDataPointsForEachVibration,
					   &vibrations, 
					   &deltaT,
					   intervalRange,
					   durationRange, 
					   prhs);
	
	double *results = (double *)malloc((numThresholds * numMinIntervals * numMinDurations * 5) * sizeof(double));
	
	if (results == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}	
	
	// allocate memory for intervalLengths and durationLengths arrays
	int *intervalLengths = (int *)malloc(MAX_NUM_ID * sizeof(int));
	int *durationLengths = (int *)malloc(MAX_NUM_ID * sizeof(int));
	
	if (intervalLengths == NULL || durationLengths == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	int rowCount = 0;
	
	for (int i = 0; i < numThresholds; i++)
	{
		for (int j = 0; j < numMinIntervals; j++)
		{
			for (int k = 0; k < numMinDurations; k++)
			{
				// sum variables for each rate to calculate the mean over all vibrations
				double sumIntervalPeakRate = 0;
				double sumDurationPeakRate = 0;
				
				double rate = PER_MINUTE_RATE_IN_SECONDS/deltaT;
				
				for (int v = 0; v < numVibrations; v++)
				{
					int numIntervals;
					int numDurations;														
					bool durationFirst;
					
					// call idFinder
					idFinder(thresholds[i], minIntervals[j], minDurations[k], vibrations[v], numDataPointsForEachVibration[v], &numIntervals, &numDurations, intervalLengths, durationLengths, &durationFirst);
					
					int numIntervalsInPeak;
					int numDurationsInPeak;
					
					countNumIntervalsDurationsInPeakHatchingRange(numIntervals, numDurations, intervalLengths, durationLengths, intervalRange, durationRange, &numIntervalsInPeak, &numDurationsInPeak);
					
					double intervalsInPeakRate = rate * ((double)numIntervalsInPeak/numDataPointsForEachVibration[v]);
					double durationsInPeakRate = rate * ((double)numDurationsInPeak/numDataPointsForEachVibration[v]);
					
					
					sumIntervalPeakRate += intervalsInPeakRate;
					sumDurationPeakRate += durationsInPeakRate;					
				}
				
				double meanIntervalsInPeakRate = sumIntervalPeakRate/numVibrations;
				double meanDurationsInPeakRate = sumDurationPeakRate/numVibrations;
				
				results[rowCount++] = thresholds[i];
				results[rowCount++] = minIntervals[j] * deltaT;
				results[rowCount++] = minDurations[k] * deltaT;
				results[rowCount++] = meanIntervalsInPeakRate;
				results[rowCount++] = meanDurationsInPeakRate;				
			}			
		}
	}
		
	mxArray *resultsOutputMatrix = createOutput2DArray(results, 5, numThresholds*numMinIntervals*numMinDurations);
	
	if (resultsOutputMatrix == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	// pass output values to MATLAB space
    int resultsOutputStatus = mexPutVariable(MATLAB_WORKSPACE_VALUE, RESULTS_VARIABLE_NAME, resultsOutputMatrix);
    
    // cleanup
    mxDestroyArray(resultsOutputMatrix);
	
	free(minIntervals);
	free(minDurations);
	free(numDataPointsForEachVibration);
	free(vibrations);
	free(results);	
	free(intervalLengths);
	free(durationLengths);
	
    // error if sending outputs to MATLAB failed
    if (STATUS_FAILED(resultsOutputStatus))
    {
        mexErrMsgTxt("Could not put variables in MATLAB workspace.\n");
    }
}


