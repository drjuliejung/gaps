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

#define NOISE_THRESHOLD prhs[0]
#define MIN_INTERVAL    prhs[1]
#define MIN_DURATION    prhs[2]
#define VIBRATION_DATA  prhs[3]

#define MATLAB_WORKSPACE_VALUE "caller"

#define NUM_INTERVALS_VARIABLE_NAME "num_intervals"
#define NUM_DURATIONS_VARIABLE_NAME "num_durations"
#define INTERVAL_LENGTHS_VARIABLE_NAME "interval_lengths"
#define DURATION_LENGTHS_VARIABLE_NAME "duration_lengths"
#define DURATION_FIRST_VARIABLE_NAME "duration_first"

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
    if (nrhs != 4)
    {
        mexErrMsgTxt("Usage: id_finder(<noise threshold>, <min interval>, <min duration>, <double array of vibration info>).\n");
    }
    
	// check if function has no left hand side arguments
    if (nlhs != 0)
    {
        mexErrMsgTxt("Does not return any left hand side outputs.\n");
    } 
    
	// check that noise threshold is a scalar of type double
    if (!mxIsDouble(NOISE_THRESHOLD) || mxGetNumberOfElements(NOISE_THRESHOLD) != 1)
    {
        mexErrMsgTxt("Noise threshold must be a scalar of type double.\n");
    }
	
	// check that min interval is a scalar of type double
    if (!mxIsDouble(MIN_INTERVAL) || mxGetNumberOfElements(MIN_INTERVAL) != 1)
    {
        mexErrMsgTxt("Min interval must be a scalar of type double.\n");
    }
	
	// check that min duration is a scalar of type double
    if (!mxIsDouble(MIN_DURATION) || mxGetNumberOfElements(MIN_DURATION) != 1)
    {
        mexErrMsgTxt("Min duration must be a scalar of type double.\n");
    }
	
	// check that vibration data is a 1-dimensional array of type double
	if (!mxIsDouble(VIBRATION_DATA) || mxGetNumberOfDimensions(VIBRATION_DATA) != 2)
    {
        mexErrMsgTxt("Vibration data must be an array of type double.\n");
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
void getMatlabInputInfo(_Out_ double *threshold,
						_Out_ int *minInterval,
						_Out_ int *minDuration,
						_Out_ int *numDataPoints,
						_Out_ double **vibration,
						_In_ const mxArray **prhs)
{
	// retrieve scalar values from MATLAB input and check
	// that their values
	*threshold = mxGetScalar(NOISE_THRESHOLD);
	
	if (*threshold < 0)
	{
		mexErrMsgTxt("Noise threshold must be a non-negative value.\n");
	}
	
	*minInterval = (int) mxGetScalar(MIN_INTERVAL);
	*minDuration = (int) mxGetScalar(MIN_DURATION);
	
	if (*minInterval < 1 || *minDuration < 1)
	{
		mexErrMsgTxt("Min interval and min duration values must be 1 or greater.\n");
	}
	
	// get the number of elements in VIBRATION_DATA array
	*numDataPoints = mxGetNumberOfElements(VIBRATION_DATA);
	
	// if number of data points is less than 1, error
	if (*numDataPoints < 1)
	{
		mexErrMsgTxt("At least one vibration data point required.\n");
	}
	
	// get vibration data
	*vibration = (double *)mxGetData(VIBRATION_DATA);
}

/* Function: createOutputScalar
 *
 * Description: Create a double scalar MATLAB array using value
 *   passed to function.
 *
 * Parameters:
 *     scalar: Value to populate the double scalar mxArray.
 *
 * Returns: newly created double scalar mxArray.
 */
mxArray *createOutputScalar(_In_ double scalar)
{
    // create output mxArray for scalar value
    mxArray *outputScalar = mxCreateDoubleScalar(scalar);
    
    if (outputScalar == NULL)
    {
        return NULL;
    }
    
    return outputScalar;
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
mxArray *createOutputArray(_In_ int *array,
						   _In_ int arraySize)
{
	// mxCreateNumbericArray requires const int value for number
	// of columns, so we create a mwSize variable with the array
	// size
	mwSize size[1];
    size[0] = (mwSize) arraySize;
	
    // create output mxArray for input array
    mxArray *outputArray = mxCreateNumericArray(1, size, mxINT32_CLASS, mxREAL);
	
    if (outputArray == NULL)
    {
        return NULL;
    }
	
	// copy values of input array to newly created mxArray
	int *outputArrayData = (int *)mxGetData(outputArray);
	memcpy(outputArrayData, array, arraySize * sizeof(int));
	
    return outputArray;
}

/* Function: createOutputBool
 *
 * Description: Create a double scalar MATLAB array using value
 *   passed to function.
 *
 * Parameters:
 *     scalar: Value to populate the double scalar mxArray.
 *
 * Returns: newly created double scalar mxArray.
 */
mxArray *createOutputBool(_In_ bool value)
{
    // create output mxArray for scalar value
    mxArray *outputBool = mxCreateLogicalScalar(value);
    
    if (outputBool == NULL)
    {
        return NULL;
    }
    
    return outputBool;
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
	
	double threshold;
	int minInterval;
	int minDuration;
	int numDataPoints;
	double *vibration;
	
	// get the matlab input info in form to pass to idFinder function
	getMatlabInputInfo(&threshold, &minInterval, &minDuration, &numDataPoints, &vibration, prhs);
	
	int numIntervals;
	int numDurations;
	
	// allocate memory for intervalLengths and durationLengths arrays
	int *intervalLengths = (int *)malloc((int)(numDataPoints/minInterval) * sizeof(int));
	int *durationLengths = (int *)malloc((int)(numDataPoints/minDuration) * sizeof(int));
	
	if (intervalLengths == NULL || durationLengths == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	bool durationFirst;
	
	// call idFinder
	idFinder(threshold, minInterval, minDuration, vibration, numDataPoints, &numIntervals, &numDurations, intervalLengths, durationLengths, &durationFirst);
	
	// create output mxArrays for numIntervals, numDuraitons, intervalLengths,
	// durationLengths, and durationFirst boolean value to pass back to MATLAB
	mxArray *outputNumIntervals = createOutputScalar((double)numIntervals);
	mxArray *outputNumDurations = createOutputScalar((double)numDurations);
	
	if (outputNumDurations == NULL || outputNumIntervals == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	mxArray *outputIntervalLengths = createOutputArray(intervalLengths, numIntervals);
	mxArray *outputDurationLengths = createOutputArray(durationLengths, numDurations);
	
	if (outputIntervalLengths == NULL || outputDurationLengths == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	mxArray *outputDurationFirst = createOutputBool(durationFirst);
	
	if (outputDurationFirst == NULL)
	{
		mexErrMsgTxt("Out of memory error.\n");
	}
	
	// pass output values to MATLAB space
    int numIntervalsOutputStatus = mexPutVariable(MATLAB_WORKSPACE_VALUE, NUM_INTERVALS_VARIABLE_NAME, outputNumIntervals);
	int numDurationsOutputStatus = mexPutVariable(MATLAB_WORKSPACE_VALUE, NUM_DURATIONS_VARIABLE_NAME, outputNumDurations);
	
    int intervalLengthsOutputStatus = mexPutVariable(MATLAB_WORKSPACE_VALUE, INTERVAL_LENGTHS_VARIABLE_NAME, outputIntervalLengths);
	int durationLengthsOutputStatus = mexPutVariable(MATLAB_WORKSPACE_VALUE, DURATION_LENGTHS_VARIABLE_NAME, outputDurationLengths);
	
	int durationFirstOutputStatus = mexPutVariable(MATLAB_WORKSPACE_VALUE, DURATION_FIRST_VARIABLE_NAME, outputDurationFirst);
    
    // cleanup
    mxDestroyArray(outputNumIntervals);
    mxDestroyArray(outputNumDurations);
	mxDestroyArray(outputIntervalLengths);
	mxDestroyArray(outputDurationLengths);
	mxDestroyArray(outputDurationFirst);
	
	free(intervalLengths);
	free(durationLengths);
    
    // error if sending outputs to MATLAB failed
    if (STATUS_FAILED(numIntervalsOutputStatus) || 
        STATUS_FAILED(numDurationsOutputStatus) ||
		STATUS_FAILED(intervalLengthsOutputStatus) ||
		STATUS_FAILED(durationLengthsOutputStatus) ||
		STATUS_FAILED(durationFirstOutputStatus))
    {
        mexErrMsgTxt("Could not put variables in MATLAB workspace.\n");
    }
}


