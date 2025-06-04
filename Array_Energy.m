function    [] = Array_Energy(data,Fs)

% Filename:         Array_Energy.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 20, 2005
%
% Creates Joint Plot of time-varying energy levels vs.time for all
% array channels.  User can select moving analysis window between 10 and
% 1000 samples and a step interval between %10 and %100 of the selected
% analysis window duration.
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
% tpk       - array of times for the energy peaks of each channel
%
%==========================================================================

[M,N] = size(data);
disp(['The number of sensors in the array is ', int2str(N)])
source = input('Enter array channel to process, or enter 10 to process all channles (example: 10): ');
interval = input('Enter window interval in samples (example: 200): ');
step = input('Enter moving window step size (overlap) in samples (example: 100): ');
NN = floor(M/(step)-1);
figure('Name','Energy Plot');
if source ~= 10
    data = data(:,source);
for k = 1:NN
        start = (k-1)*step+ 1;
        dataw = data(start:start + interval - 1);
        temp = fft(dataw);
        EE = temp'*temp;
        energy(k) = EE;
end
    nx = step/Fs.*(1:NN);
    plot(nx,energy)
    Plot_Title = input('Enter plot title (example: Array Channel 1): ');
    title(Plot_Title)
    xlabel('Time (sec)')
    ylabel('Energy')
    %xlim([0 50])

elseif source == 10
    data = data';
    energy_matrix = zeros(N,NN);
if source ==10
    for i = 1:N
        for k = 1:NN
            start = (k-1)*step + 1;
            data1 = data(i,start:start + interval - 1);
            temp = fft(data1);
            EE = temp*temp';
            energy(k) = EE;
        end
        energy_matrix(i,:) = energy;
        lm = max(max(energy_matrix));
    end
    nx = step/2000.*(1:NN);
    for i = 1:N
        subplot(4,2,i)
        plot(nx,energy_matrix(i,:))
        ylim([0 lm])
        xlabel('Time (sec)')
        ylabel(['Energy Ch = ',num2str(i)])
        %xlim([0 50])
        grid on
    end
end
else
    error('Input is not valid')
end
