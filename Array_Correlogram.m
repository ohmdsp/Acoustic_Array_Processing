function    Array_Correlogram(data,Fs)

% Filename:         Array_Correlogram.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 21, 2005
%
% Computes the 2-D correlogram representation using 
% acoustic array input data
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
% gram      - 2D TF gram (not output)
%
% Needed m-files:
%   correlation_sequence.m
%
%==========================================================================
%==========================================================================
[M,N] = size(data);
Ts=1/Fs;
%M=length(data);
channel_1 = input('Select reference channel number (example: 1): ');
channel_2 = input('Select channel number to correlate against reference channel (example: 2): ');
x1 = data(:,channel_1);
x2 = data(:,channel_2);
clear data;
max_lag = input('Input maximum lag value (example 256): ');
n_anal = input('Enter analysis window size, must be bigger that maximum lag value (example: 512):  ');
n_step = input('Enter overlap between analysis windows (example: 128): ');
n_display=fix((M-n_anal)/n_step)+1;
disp(['These choices will generate ',int2str(n_display),' displayed correlation lines.'])
gram=zeros(n_display,2*max_lag+1);  % pre-assign 2-D size of gram display
titletext=['Time-vs.-Lag Correlogram of Channels ',([int2str(channel_1) ',' int2str(channel_2)])];

n=1:n_anal';
for k=1:n_display
    temp = correlation_sequence(max_lag,'unbiased',x1(n),x2(n))';
    gram(k,:)=temp;%(1:(2*max_lag +1));
    n=n+n_step;
end
overlap=n_anal-n_step;
interval = n_anal;
data1 = x1;
data2 = x2;
plot_color_gram_correlogram(gram,data1,data2,Fs,interval,n_step,overlap,titletext)