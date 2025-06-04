function [xspect, xsp2] = Array_MUSIC_coh(data,fsamp)

% Filename:         Array_MUSIC_coh.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         September 21, 2005, Mar.1,2021
%
% Computes the beamformed signal for any given bearing direction
% from data collected from an array of acoustical sensors using the
% coherent wideband MUSIC beamformer. Developed using the paper: "Adaptive 
% Wideband Aeroacoustic Array Processing",Tien Pham, Army Research Labs. 
%
% Needed Files:
%   plot_MUSIC_log_wholegram.m
%
%==========================================================================

xx = data;
[nsamp,nchan] = size(xx);

nblock = 1024;%input(['Input the assumed stationary block length to use (example: 1024): ']);
lenblock = 90;%input(['Input the number of blocks to use - length/nblock. (example: 90): ']);
ncov = 128;%input(['Input the number of covariance estimates to compute for each stationary block (example: 128): ']);
nfreq = 4;%input(['Input the number of frequencey bins to use in the estimate (example: 4): ']);
ntgt = 1;%input(['Input the number of targets (example: 1) ']);

NPHI = 360;
phi = 2*pi*(0:(NPHI-1))'/NPHI; % Angle of arrival samples
cee   = 336;                % Speed of sound in air (m/s)
arrad = 1.2;%input(['Input radius in meters of circular array (example: 1.85): ']); 
tsamp = 1/fsamp;

%-Compute sensor locations
ccos = cos(2*pi*(0:nchan-2)/(nchan-1));
ssin = sin(2*pi*(0:nchan-2)/(nchan-1));
%northloc = arrad*[0 ccos(1:3) ccos(4:nchan-1)];
%eastloc = arrad*[0 ssin(1:3) ssin(4:nchan-1)];

eastloc = arrad*[0 ccos(1:nchan-1)];
northloc = arrad*[0 ssin(1:nchan-1)];

% Delay to each sensor for each angle of arrival
tdelay = (cos(phi)*eastloc+sin(phi)*northloc)/cee; 

% Locate strongest frequency components 
pwr = zeros(lenblock,1);
for ii = 1:nchan
  yy = reshape(xx(1:nblock*lenblock,ii),lenblock,nblock);
  fyy = fft(yy);
  pwr = pwr + sum(abs(fyy.^2)')';
end
[psort isort] = sort(pwr(2:lenblock/2));
idxfreq = 1+isort(lenblock/2-(1:nfreq))'; % indices of strong freq's

% Main loop to accumulate spectrum over all frequencies
zz = zeros(nchan,nblock);
xspect = zeros(NPHI,ncov);
xacc = zeros(NPHI,ncov);
for ifreq = idxfreq 
  omega = 2*pi*fsamp*(ifreq-1)/lenblock;
  asteer = exp(-j*omega*tdelay); % Conjugated steering vectors

  % Extract frequency component from each channel
  for ii = 1:nchan
    yy = reshape(xx(1:nblock*lenblock,ii),lenblock,nblock);
    fyy = fft(yy);
    zz(ii,:) = fyy(ifreq,:);
  end
  % Normalize channels to equal average power
  rmag = sqrt(sum(abs(zz.^2)')');
  zz = zz ./ repmat(rmag,1,nblock);

  for ii = 1:ncov
    % Compute short-time covariance matrix
    idx = (ii-1)*nblock/ncov + (1:nblock/ncov);
    aa = zz(:,idx);
    rr = aa*aa';

    %  Accumulate MUSIC spectrum for this freq to estimate
    [uu,lam] = eig(rr);
    bb = asteer*uu(:,1:nchan-ntgt);
    xspect(:,ii) = xspect(:,ii) + 1./(eps+sum(abs(bb.^2)')');
    xacc(:,ii) = xacc(:,ii) + sum(abs(bb.^2)')';
  end
end
xsp2 = 1./(eps+xacc);

Ts = tsamp;
plot_cohMUSIC_gram(xsp2,Ts,nblock,lenblock,ncov)

