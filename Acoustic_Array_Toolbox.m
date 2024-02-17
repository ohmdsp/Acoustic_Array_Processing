% Filename:         Acoustic_Array_Toolbox.m
% Author:           D.R.Ohm   
% Software:         Matlab R2020b
% Rev.Date:         Sept 21,2005; Mar.1,2021
%
% This script is used to call a library of scripts and functions for 
% processing and analysis of acoustic array signals. 
%
% Needed Files:
%   Array_Data_Load.m
%   Array_Data_Plot.m
%   Array_Data_Listen.m
%   Array_Energy.m
%   Array_Correlation.m
%   Array_Correlogram.m
%   Array_TFA.m
%   Array_Cepstrum.m
%   Array_BeamPatterns.m
%   Array_BTR.m
%   Array_CBF.m
%   Array_MVDR.m
%   Array_Music_coh.m  
%
%==========================================================================

clear all; close all; clc

disp('Choose array data file for processing (example: chs.mat) ');
Array_Data_Load;                

Array_Data_Plot(data,Fs);               

Array_Data_Listen(data,Fs);

choice = input('Do you want to low pass filter the data (1=YES,0=NO)? ');
if choice ==1
    data = Array_Data_LPFilter(data,Fs);
else 
end
 
choice = input(['Do you want to compute and display energy level vs. time (1=YES,0=NO): ']);
if choice ==1
    Array_Energy(data,Fs);      
else 
end

choice = input(['Do you want to compute and display correlation analysis results (1=YES,0=NO): ']);
if choice ==1
    Array_Correlation(data,Fs); 
else 
end

choice = input(['Do you want to compute and display correlogram (1=YES,0=NO): ']);
if choice ==1
    Array_Correlogram(data,Fs); 
else 
end

choice = input(['Do you want to compute and display time-frequency representations (1=YES,0=NO): ']);
if choice ==1
    Array_TFA;                 
end

choice = input(['Do you want to compute and display cepstrum analysis representation (1=YES,0=NO): ']);
if choice ==1
    Array_Cepstrum(data,Fs);                  
else 
end

choice = input(['Do you want to compute and display array beampatterns for the circular array geometry (1=YES,0=NO)? ']);
if choice ==1
    Array_BeamPatterns;
else 
end

choice = input(['Do you want to compute and display the bearing-time representation (BTR) (1=YES,0=NO): ']);
if choice ==1
    Array_BTR(data,Fs)
else
end

choice = input(['Do you want to compute and display a conventional beamformer representation (CBF) (1=YES,0=NO): ']);
if choice ==1
    Array_CBF(data,Fs)
else
end

choice = input(['Do you want to compute and display a Minimum Variance Distortionless Response (MVDR) beamformer (1=YES,0=NO): ']);
if choice ==1
    Array_MVDR(data,Fs)
else
end

choice = input(['Do you want to compute and display the coherent MUSIC beamformer(1=YES,0=NO): ']);
if choice ==1
    Array_MUSIC_coh(data,Fs);
else
end


