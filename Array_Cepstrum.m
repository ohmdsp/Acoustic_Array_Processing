function Array_Cepstrum(data,Fs)

% Filename:         Array_Cepstrum.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         June 20,2005; Mar.1,2021
%
% Computes the Harmonic Period Analysis (Cepstrum) Representation 
% of the input acoustic array data.
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
% gram      - 2D cepstrum gram (not output)
%
% Needed Filed:
%   plot_color_gram_cepstrum.m
%
%==========================================================================

[M,N] = size(data);
chan = input(['Input array channel for analysis (example: 1): ']);
Ts = 1/Fs;
data = data(:,chan);
data = data - mean(data);

n_anal = input('Enter analysis window size in samples to use (example: 1024): ');
n_step = input('Enter step between analysis windows in samples (example: 64): ');
n_display = floor((M-n_anal)/n_step)+1;  % number of output frames
disp(['These choices will generate ',int2str(n_display),' displayed cepstrum lines.'])
gram = zeros(n_display,n_anal/2);  % pre-assign 2-D size of gram display
titletext = ['Harmonic Period Analysis (Cepstrum) of Channel ',int2str(chan)];
n = 1:n_anal;
for k=1:n_display
    temp = abs(ifft(log(abs(fft(data(n))))))';
    %temp = abs(ifft(log(abs(fft(hamming(n_anal).*data(n))))))';
    gram(k,1:n_anal/2)= temp(1:n_anal/2);
    n = n+n_step;
end
pdata = sum(gram).*1/n_display;

plot_color_gram_cepstrum(gram,data,pdata,Fs,n_step,titletext)
