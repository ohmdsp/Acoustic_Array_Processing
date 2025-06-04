function    Array_TFR_STFT(data,Fs,chan)
%
% Filename:         Array_TFR_STFT.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         June 20,2005; Mar.1,2021
%
% Computes the STFT (Classical Short-Time Fourier Transform) 
% Time-Frequency Representation using acoustic array input data
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
% chan      - array channel used
% gram      - 2D TF gram (not output)
%
% Needed Files:
%   plot_color_gram_STFT.m
%
%==========================================================================

fft_length  = input(['Specify FFT length (example: 1024): ']);
n_anal      = input('Enter analysis window size (power of 2) in samples to use (example: 512): ');
n_step      = input('Enter increment size in samples to center of next analysis window (example: 64): ');
[M,N] = size(data);
n_specdisplay = fix((M-n_anal)/n_step);
disp(['This choice will generate ',int2str(n_specdisplay),' displayed spectrogram lines.'])
gram = zeros(n_specdisplay,fft_length); % pre-assign 2-D size of gram display
disp('A Hamming window will be used to suppress the sidelobe artifacts.')
window = hamming(n_anal);
n = 1:n_anal;
for k=1:n_specdisplay
    gram(k,:)= (fft( window.*data(n),fft_length ))';
    n=n+n_step;
end

%-Only need positive freqs since real-valued data
gram_real = gram(:,1:fft_length/2);

titletext = ['Time-vs.-Frequency Analysis of Channel ',int2str(chan)];
plot_color_gram_STFT(gram_real,data,Fs,n_step,titletext)