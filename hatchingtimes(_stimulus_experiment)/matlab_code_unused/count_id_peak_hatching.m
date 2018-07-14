% Function: count_id_peak_hatching
% 
% Description: Counts the number of intervals and durations that are passed
%     to it whose lengths are within given interval and duration ranges.
%     Also counts the number of interval/duration sequences in which an
%     adjacent interval and duration are both with the ranges. The interval
%     and duration arrays are interlaced to create the full sequence,
%     because intervals and durations are always alternating.
%
% Parameters:
%     interval_lengths: array of interval lengths (found by id_finder)
%     duration_lengths: array of duration lengths (found by id_finder)
%     duration_first: boolean indicating whether an interval or a duration
%         comes first
%     delta_t: sampling rate of the data
%     i_range: a 2-element vector, in which the first element is the lower
%         bound of the interval range and the second element is the upper
%         bound of the interval range
%     d_range: a 2-element vector, in which the first element is the lower
%         bound of the duration range and the second element is the upper
%         bound of the duration range
%
% Returns:
%     num_i_peak: number of intervals that fall within the interval range
%     num_d_peak: number of durations that fall within the duration range
%     num_seq_peak: number of interval/duration sequences in which an
%         adjacent interval and duration are both within their ranges
%
% Author: Ming Guo
% Created: 1/2/13
function [num_i_peak, num_d_peak, num_seq_peak] = ...
    count_id_peak_hatching (interval_lengths, duration_lengths, duration_first, delta_t, i_range, d_range)

% assert that the interval and duration arrays don't have a size difference
% greater than 1
assert(abs(numel(interval_lengths)-numel(duration_lengths)) < 2, ...
      'interval_lengths and duration_lengths array cannot be have a size difference greater than 1.');

num_i_peak = 0;
num_d_peak = 0;
num_seq_peak = 0;

% merge the interval and duration arrays into a single sequence array that
% alternates between intervals and durations, and starts with a duration if
% duration_first is true, interval if false
first = interval_lengths;
second = duration_lengths;

if duration_first
    first = duration_lengths;
    second = interval_lengths;
end

num_first = numel(first);
num_second = numel(second);

seq_array = zeros(num_first*2, 1);

if num_first > num_second
    seq_array = zeros(num_first*2 - 1, 1);
end

for i = 1:numel(seq_array)
    if mod(i, 2) == 1
        seq_array(i) = first(uint8(i/2));
    else
        seq_array(i) = second(uint8(i/2));
    end    
end

prev_is_peak = 0;

% loop through sequence array
for i = 1:numel(seq_array)
   length = delta_t * seq_array(i);

   % get whether current index is interval or duration
   is_duration = (duration_first && mod(i,2) == 1) || (~duration_first && mod(i,2) == 0);
   
   is_peak = 0;
   
   % check if current value is within respective range, and increment
   % respective counter if so
   if is_duration
       if length >= d_range(1) && length <= d_range(2)
           num_d_peak = num_d_peak + 1;
           is_peak = 1;
       end
   else
       if length >= i_range(1) && length <= i_range(2)
           num_i_peak = num_i_peak + 1;
           is_peak = 1;
       end
   end   
   
   % if current value is within respective range, check if the previous
   % value was also within range, and if so, increment sequence counter.
   % Reset prev_is_peak flag.
   if is_peak
       if prev_is_peak
           num_seq_peak = num_seq_peak + 1;
       end
       
       prev_is_peak = 1;
   else
       prev_is_peak = 0;
   end
end


