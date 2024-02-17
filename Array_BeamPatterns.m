% Filename:         Array_Beampatterns.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         Sept.13, 2005, Mar.1,2021
%
% Creates beam patterns for circular array and displays a movie for all 
% bearing angles and for narrow band frequencys (20Hz, 325Hz, 650Hz)
%----------------------------------------------------------------------

deg2rad = 2*pi/360;
N = input(['Input the number of array sensors (ex. chs is 8 sensors): ']); % # of sensor channels
t = 25;                 % Center time
th  = 0:.01:2*pi; 
phi = 2*pi/(N-1);       % Angle spacing between sensors in radians
r   = input(['Input radius of circular array (meters) (ex. chs is 1.85): ']);% Radial distance from center of array to sensor elements
c   = 336;              % Speed of sound in air ( c = 331.5 + 0.6*T )
%f   = [20 325 650];     % Frequencies to use when computing beampatterns 
f   = [20 115 260];     % Frequencies to use when computing beampatterns 

b1 = exp(1i*2*pi*f(1)*t); 
b2 = exp(1i*2*pi*f(2)*t); 
b3 = exp(1i*2*pi*f(3)*t); 

%-Polar Plots 
choice = input('Enter bearing degree choice in degrees: ', 's');
bearing = str2double(choice);
theta_s = bearing*deg2rad;

%-Polar Plots 
legendText1=' 20 Hz ';
% legendText2='325 Hz ';
% legendText3='650 Hz ';
legendText2='115 Hz ';
legendText3='260 Hz ';

for i=2:N
    b1 = b1 + exp(1i*2*pi*f(1)*(t + r*cos(th-(i-2)*phi)/c - r*cos(theta_s-(i-2)*phi)/c) );
    b2 = b2 + exp(1i*2*pi*f(2)*(t + r*cos(th-(i-2)*phi)/c - r*cos(theta_s-(i-2)*phi)/c) );
    b3 = b3 + exp(1i*2*pi*f(3)*(t + r*cos(th-(i-2)*phi)/c - r*cos(theta_s-(i-2)*phi)/c) );    
end

figure('Name','Array Beampatterns');
polarplot(th,abs(b1),'-r');
hold on
polarplot(th,abs(b2),'-b');
polarplot(th,abs(b3),'-g');
legend(legendText1,legendText2,legendText3);
title(['Beam Pattern Plot for Bearing Degree = :  ', choice]);
hold off 



choice = input('Do you want to play movie (1=YES,0=NO)? ');
if choice ==1
%-Create Movie
disp('Playing Beam Pattern Movie for Full 360 degree Bearing Rotation')
h = figure('Name','Array Beampattern Movie');
clear theta_s;
for theta_s = 1:1:360
    clear b1;clear b2; clear b3;
    b1 = exp(1i*2*pi*f(1)*t); 
    b2 = exp(1i*2*pi*f(2)*t); 
    b3 = exp(1i*2*pi*f(3)*t); 
    for i=2:N
        b1 = b1 + exp(1i*2*pi*f(1)*(t + r*cos(th-(i-2)*phi)/c - r*cos(theta_s.*deg2rad-(i-2)*phi)/c) );
        b2 = b2 + exp(1i*2*pi*f(2)*(t + r*cos(th-(i-2)*phi)/c - r*cos(theta_s.*deg2rad-(i-2)*phi)/c) );
        b3 = b3 + exp(1i*2*pi*f(3)*(t + r*cos(th-(i-2)*phi)/c - r*cos(theta_s.*deg2rad-(i-2)*phi)/c) );
        
    end
    polarplot(th,abs(b1),'-r');
    hold on
    polarplot(th,abs(b2),'-b');
    polarplot(th,abs(b3),'-g');
    hold off
    legend(legendText1,legendText2,legendText3);
    title(['\theta =',num2str(theta_s)]);
    F = getframe;
end

elseif choice == 0
    else
     error('Window selection number is invalid.')
end