function [] = Array_BTR(data,Fs)

% Filename:         Array_BTR.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         Sept.13, 2005; Mar.1,2021
%
% Computes and displays Log Bearing Time Grams and Normalized Log
% Bearing time grams for circular array. Note - assumes one sensor in middle
%
% Needed Filed:
%   plot_BTR_log_wholegram.m
%   plot_BTR_linear_normgram.m 
%
% To Do: trim gps file (time) if input data is trimmed before processing
%
%==========================================================================

Ns = input('Input number of sensors (example: 8): ');    % # of sensor channels
phi = 2*pi/(Ns-1);          % Angle spacing between sensors in radians

%-Get radial distance from center of array to sensor elements
r   = input('Input radius in meters of circular array (example: 1.85): ');
c   = 331;                  % Speed of sound in air      
interp_factor = 2;
Ts = 1/(Fs*interp_factor);

[M,N] = size(data);
chs_interp = zeros(interp_factor*M,N);
for k = 1:N
    chs_interp(:,k) = blockinterp(data(:,k),interp_factor);      % Interpolate data
end
[M,N] = size(chs_interp);   % size after interpolation
index = 1;
max_sdelay = 50;    % max expected delay in samples (must offset in plots too)
angle_step = pi/30;
offset = input('Enter offset (in degrees) for bearing plots: ');
offset_rad = offset*pi/180;
tic
for th = -offset_rad:angle_step:2*pi-offset_rad
    for i = 2:N
        n_delay =  round(1/Ts*(r/c * cos(th - (i-2)*phi)));     
        b_temp(:,i) = chs_interp(( max_sdelay+n_delay:end-max_sdelay+n_delay ),i);
    end
    b_temp(:,1) = chs_interp(( max_sdelay:end-max_sdelay ),1); % center mic sensor
    btr(:,index) = sum(b_temp(:,1:end)');
    index = index+1;
end
toc
btr = abs(btr);
[btr_n,btr_th] = size(btr);
seg_size = input('Enter # of samples in analysis interval duration (example: 2048): ');
overlap = input('Enter overlap (# samples) between analysis intervals (example: 512): ');

shift = seg_size - overlap;
num_segs = fix(( btr_n - seg_size )/shift) + 1;
tic
for theta = 1:btr_th
    range = 1:seg_size;
    for k=1:num_segs
        z = btr(range,theta);
        z_e = sum(z(:).^2);
        E_btr(k) = z_e/(seg_size*Ts);   
        range = range + shift;   
    end
    btr_f(theta,:) = E_btr;
end
btr_energy = btr_f;
toc

disp(' Plot Selection:  1--Log Whole Gram , 2--Line Normalized Linear Gram ');
source = input('Enter plot type selection: ');

if source==1
        plot_BTR_log_wholegram(btr_energy,Ts,angle_step,seg_size,overlap,offset)   
elseif source ==2
        plot_BTR_linear_normgram(btr_energy,Ts,angle_step,seg_size,overlap,offset)
end
      