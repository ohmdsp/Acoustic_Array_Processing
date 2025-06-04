% Filename:         Array_TFA.m
% Author:           D.R.Ohm   
%
% Generates TFA gram using selectable method.
%
% Methods:
%   --STFT 
%   **Wigner Ville 
%   **WVF_sw (Wigner with Choi-Willimas smoothing)
%   **STAR (short-time autoregressive)')
%   **STFT_lp (covariance lin. pred. extrapolation)')
%   **STFT_ss (signal subspace SVD extrapolation)')
%
% Needed Files:
%   Array_TFR_STFT.m
%
%==========================================================================

disp('COMPUTE AND PLOT TIME-vs-FREQUENCY ANALYSIS OF ARRAY CHANNEL SIGNAL')
disp('Select a channel to process.');
chan = input('Input Channel #: ');
data_ch = data(:,chan);
data_ch = data_ch - mean(data_ch);


disp('TFR choice:      1 - STFT (Classical Short-Time Fourier Transform)')
%disp('TFR choice:     4 - WVF_sw (Wigner with Choi-Willimas smoothing)')
%disp('TFR choice:     3 - STAR (short-time autoregressive)')
%disp('TFR choice:     7 - STFT_lp (covariance lin. pred. extrapolation)')
%disp('TFR choice:     8 - STFT_ss (signal subspace SVD extrapolation)')
choice = input('Choose a TFR analysis method: ');


if choice == 1
    Array_TFR_STFT(data_ch,Fs,chan)
else
end
