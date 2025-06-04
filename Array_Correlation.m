function    [] = Array_Correlation(data,Fs)

% Filename:         Array_Correlation.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 20, 2005
%
% Creates correlation plots for array data and finds maximum correlation
% time.
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
% [M N]     - size of data array
% tcpk      - array of times for the correlation peaks of each channel
%
% Needed m-files:
%   correlation_sequence.m
%
%==========================================================================
%==========================================================================
[M,N] = size(data);
%-ACS Estimates
choice = input(['Would you like to compute and plot the auto-correlation analysis (1=YES,0=NO)? ']);
if choice == 1
max_lag = input('Enter maximum lags to use for autocorrelation (example: 512): ');
bias_c = input('Enter bias choice (1=biased,2=unbiased): ');
figure('Name','Array Auto Correlations');
if bias_c == 1
    bias = 'biased';
elseif bias_c == 2
    bias = 'unbiased';
else
end
acs_matrix = zeros(N,2*max_lag+1);
for i = 1:N
    x = data(:,i);
    r = correlation_sequence(max_lag,bias,x)'; 
    acs_matrix(i,:) = r;
end
lm = max(max(acs_matrix));
ax = -max_lag:max_lag;
for i = 1:N
    subplot(4,2,i)
    plot(ax,real(acs_matrix(i,:)));
    ylim([-lm lm]) 
    xlabel('Lags')
    ylabel(['ACS Amp Ch = ',num2str(i)]) 
end
else
end
%-Compute CCS Estimates
choice = input(['Would you like to compute and plot the cross-correlation analysis (1=YES,0=NO)? ']);
if choice == 1
    max_lag = input('Enter maximum lags to use for autocorrelation (example: 512): ');
    bias_c = input('Enter bias choice (1=biased,2=unbiased): ');
    if bias_c == 1
        bias = 'biased';
    elseif bias_c == 2
        bias = 'unbiased';
    else
    end
    ccs_matrix = zeros(N,2*max_lag+1);
    ch_ccs = input(['Input reference channel to cross correlate with (example: 1): ']);
    figure('Name','Array Cross Correlations');
for i = 1:N
    x = data(:,ch_ccs);
    y = data(:,i);
    r = correlation_sequence(max_lag,bias,x,y)'; 
    ccs_matrix(i,:) = r;
end
ax = -max_lag:max_lag;
lm = max(max(ccs_matrix));
for i = 1:N
    subplot(4,2,i)
    plot(ax,real(ccs_matrix(i,:)));
    ylim([-lm lm])  
    xlabel('Lags')
    ylabel(['CCS Amp Ch = ',num2str(i)])
end

else
end
