function    data_filtered = Array_Data_LPFilter(data,Fs)
% Filename:         Array_Data_LPFilter.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 20, 2005
%
% Applies low pass filter to data in order to better match response given
% array geometry.
%
%==========================================================================

[M,N] = size(data);

fpass = input('Input desired LP filter cutoff frequency (Must be < Fs/3): ');
if fpass > Fs/3
    error('Try selecting a lower frequency.');
end

%--Design filter and apply
data_filtered = lowpass(data,fpass,Fs);

