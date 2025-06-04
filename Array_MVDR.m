function [] = Array_MVDR(data,Fs)

% Filename:         Array_MVDR.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         Sept.13, 2005, Mar.1,2021
%
% Computes and displays minimum variance distortionless response (MVDR)
% beamformer bearing-frequency grams  
% 
% Needed Filed:
%   plot_MVDR_log_wholegram.m
%
%----------------------------------------------------------------------

N = input('Input number of sensors (example: 8): ');    % # of sensor channels
%phi = 2*pi/(N-1);               % Angle spacing between sensors in radians
%-Get radial distance from center of array to sensor elements
r   = input(['Input radius in meters of circular array (example: 1.85): ']);
c   = 336;                  % Speed of sound in air
%f   = input(['Input center frequency for beamformer (Hz) (ex. 335): ']);       
interp_factor = 1;
%Ts = 1/(Fs*interp_factor);  % Sample period 

for chan = 1:N
chs_interp(:,chan) = blockinterp(data(:,chan),interp_factor);   % Interpolate data
end

psd = 512;
delta = round(psd/2);
ni = 4;
ns = 32;
Tc = input('Choose center time in seconds for analysis (example: 25): ');
Nc = Tc*Fs;                                 % Center Time
n_range = [Nc - 50: ni: Nc + 50 + ns];

[m_row, n_col] = size(data);
pp = 1; 

pp = 1; 
X_bar = zeros(psd,N,50);
for nc = n_range   
    for ii = [1:n_col]
        X_bar(:,ii,pp) = fft(data([nc-delta : nc+delta-1],ii)) ;   % narrowband signals    
    end 
    pp = pp+1;
end
frames = length(n_range);

for  Kf = 1:psd/2

    for pp = 1:frames
        X_2bar(pp,:) = X_bar(Kf,:,pp);                           % X_2bar(nc,nf)
    end 

    angle = 1:360; 
    num_angle = length(angle);
    e = [];
    e(1,:) = ones(1,num_angle);
    for kk = 2:n_col
          phi = -2*pi*Kf*(Fs/psd)*r/c*cos(2*pi*(angle/360-(kk-2)/7));
          e(kk,:) = exp(j*phi);
    end
    [e_row, e_col]= size(e);  
    
    %Rspat = inv(X_2bar'*X_2bar);
    
    for ii= 1:e_col 
         R_MVDR(Kf,ii) = real(1/( e(:,ii)'*inv(X_2bar'*X_2bar)*e(:,ii) ));    %
         %R_MVDR(Kf,ii) = real(1/( e(:,ii)'*Rspat*e(:,ii) ));
    end 

end 
mvdr = R_MVDR;           
seg_size = psd;
plot_MVDR_log_wholegram(mvdr,Fs,1,seg_size) 
