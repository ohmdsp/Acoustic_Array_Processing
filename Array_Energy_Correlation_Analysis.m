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
%==========================================================================

clear all;close all;
load chs.mat
[MM NN] = size(chs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Energy Levels of Each Channel %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
disp(' Data source choices:  1--Ch1 , 2--Ch2 , 3--Ch3, 4--Ch4, 5--Ch5, 6--Ch6, 7--Ch7, 8--Ch8, 10--All Channels');
source = input('Enter number of data source choice: ');
interval = input('Enter window interval in samples (10-1000): ');
step = input('Enter moving window step size in samples (1 - interval): ');
N = MM/(step)-1;
if source == 1
    data = chs(:,1);
elseif source == 2
    data = chs(:,2);
elseif source == 3
    data = chs(:,3);
elseif source == 4
    data = chs(:,4);
elseif source == 5
    data = chs(:,5);
elseif source == 6
    data = chs(:,6);
elseif source == 7
    data = chs(:,7);
elseif source == 8
    data = chs(:,8);
elseif source == 10
    data = [chs(:,1)';chs(:,2)';chs(:,3)';chs(:,4)';chs(:,5)';chs(:,6)';chs(:,7)';chs(:,8)'];
end

if source == 1,2,3,4,5,6,7,8;
    for k = 1:N
        start = (k-1)*step+ 1;
        dataw = data(start:start + interval - 1);
        M = fft(dataw);
        EE = M'*M;
        energy(k) = EE;
    end
    nx = step/2000.*(1:N);
    plot(nx,energy)
    Plot_Title = input('Enter plot title (example: Array Channel 1): ');
    Title(Plot_Title)
    xlabel('Time (sec)')
    ylabel('Energy')
    xlim([0 50])
end
energy_matrix = zeros(8,N);
if source ==10
    for i = 1:8
        for k = 1:N
            start = (k-1)*step + 1;
            data1 = data(i,start:start + interval - 1);
            M = fft(data1);
            EE = M*M';
            energy(k) = EE;
        end
        energy_matrix(i,:) = energy;
    end
    nx = step/2000.*(1:N);
    for i = 1:8
        subplot(4,2,i)
        plot(nx,energy_matrix(i,:))
        xlabel('Time (sec)')
        ylabel(['Energy Ch = ',num2str(i)])
        xlim([0 50])
        grid on
    end
end

%--ACS Estimates 
disp('Would you like to compute and plot correlation analysis?');
choice = input('1 -- YES, 0 -- NO ');
if choice == 1
figure(2)
max_lag = input('Enter maximum lags to use for autocorrelation: ');
bias = input('Enter bias choice(biased, unbiased): ');
acs_matrix = zeros(8,2*max_lag+1);
for i = 1:8
    x = data(i,:)';
    r = correlation_sequence(max_lag,bias,x)'; 
    acs_matrix(i,:) = r;
end
ax = -max_lag:max_lag;
for i = 1:8
    subplot(4,2,i)
    plot(ax,real(acs_matrix(i,:)));
    xlabel('Lags')
    ylabel(['ACS Amp Ch = ',num2str(i)]) 
end

%--CCS Estimates
figure(3)
ccs_matrix = zeros(8,2*max_lag+1);
for i = 1:8
    x = data(5,:)';
    y = data(i,:)';
    r = correlation_sequence(max_lag,bias,x,y)'; 
    ccs_matrix(i,:) = r;
end
ax = -max_lag:max_lag;
for i = 1:8
    subplot(4,2,i)
    plot(ax,real(ccs_matrix(i,:)));
    %title(['Channel 1',num2str(i)])
    xlabel('Lags')
    ylabel(['CCS Amp Ch = ',num2str(i)])
    ylim([-.3 .3])
end

else
end