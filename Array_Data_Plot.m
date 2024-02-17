function    [] = Array_Data_Plot(data,Fs)

% Filename:         Array_Data_Plot.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 20, 2005
%
% Plots multi-channel acoustic array data for visualization.
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
%
%==========================================================================

[M,N] = size(data);   % array data dimensions
lm = max(max(data));
choice_plot = input('Do you want to plot array channel data (1=YES,0=NO)?  ');
if choice_plot ==1
    figure('Name','Array Data');
    subplot(N,1,1)
    t_axis = [1:M]*1/Fs;
    plot(t_axis,data(:,1))
    ylim([-lm lm]);
    xlim([t_axis(1) t_axis(end)]) 
    ylabel(['CH',int2str(1)])
    title('Acoustic Array Signals')
    for n = 2:N
        subplot(N,1,n)
        t_axis = [1:M]*1/Fs;
        plot(t_axis,data(:,n))
        %y_max = max(data(:,n));
        ylim([-lm lm]);
        xlim([t_axis(1) t_axis(end)]);
        ylabel(['CH',int2str(n)])
    end
elseif choice_plot == 0 
end