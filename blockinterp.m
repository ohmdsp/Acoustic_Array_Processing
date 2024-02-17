function x_interp=blockinterp(x,M)

% INTERPOLATION BY FFT function
% create an interpolated signal

% x    -- real-valued input signal
% M    -- sample rate factor valid values are:
%         1 (same sample rate), 2/4/8/power-of-2 (interpolated sample
%         rate over original sample rate)
% x_interp    -- output interpolated signal of length=M*length(x)

[Nr,Nc]=size(x);
if Nr==1
    N=Nc;
else
    N=Nr;
end
NN=2;
while NN < N
    NN=NN*2;
end
if N==NN
    X=fft(x,N);
elseif Nr==1
    X=fft([x,zeros(1,NN-N)],NN);
else
    X=fft([x;zeros(NN-N,1)],NN);
end
if  M == 1
    x_interp = x;
else
    x_temp=real(M*ifft([X(1:NN/2);X(NN/2+1)/2;zeros(NN*(M-1)-1,1);X(NN/2+1)/2;X(NN/2+2:NN)],M*NN));
    x_interp=x_temp(1:M*length(x));
end
