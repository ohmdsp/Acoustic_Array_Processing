function [] = Array_CBF(data,Fs)

% Filename:         Array_CBF.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         Sept.13, 2005, Mar.1,2021
%
% Computes and displays Conventional Beamforming (CBF) Bearing - Frequency Grams 
% Generates narrowband bearing-frequency grams.

% Choose FFT lengths: 64 - 2048
% Choose center analysis time in seconds
%
% Needed Filed:
%   plot_cbf_log_wholegram.m
%
%==========================================================================
%==========================================================================

%Ns = input(['Input number of sensors (example: 8): ']);    % # of sensor channels
%-Get radial distance from center of array to sensor elements
r   = input(['Input radius in meters of circular array (example: 1.85): ']);
c   = 336;                      % Speed of sound in air
interp_factor = 1;
%Ts = 1/(Fs*interp_factor);

[M,N] = size(data);
chs_interp = zeros(M,N);
for k = 1:N
    chs_interp(:,k) = blockinterp(data(:,k),interp_factor);      %Interpolate data
end

psd = input('Choose FFT length (example: 512): ');
shift = 32;
num_shift = 16;
Tc = input('Choose center time in seconds for analysis (example: 25): ');
Nc = Tc*Fs;
range = Nc - psd/2:Nc + psd/2 - 1;

S = zeros(psd,N);
for bb = 1:num_shift
    S = S + fft(chs_interp(range,:),psd);
    range = range + shift;
end
S = S/num_shift;

angle_step = 1;
bb = zeros(360,psd/2);
for angle = 1:angle_step:360
    for k = 1:psd/2
        for i = 2:N
            delay = exp(-j*2*pi*k*(Fs/psd)*r/c*cos(2*pi*(angle/360 - (i-2)/(N-1))));
            bb(angle,k) = bb(angle,k) + S(k,i)*delay;
        end
        bb(angle,k) = bb(angle,k) + S(k,1);
        cbf(k,angle) = abs(bb(angle,k)).^2;
    end
end
        
seg_size = psd;
disp(' Plot Selection:  1--Log Whole Gram , 2--Line-Normalized Linear Gram ');
source = input('Enter number of data source choice (example: 2): ');
if source==1
        plot_CBF_log_wholegram(cbf,Fs,angle_step,seg_size)   
elseif source ==2
        plot_CBF_linear_normgram(cbf,Fs,angle_step,seg_size)
end
        

        