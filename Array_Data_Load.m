% Filename:         Array_Data_Load.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 20, 2005; Sept. 19, 2021
%
% Loads acoustic array data for Analysis.
% Input acoustic array data will be put in the form X(data,channel) for
% processing. 
%
%==========================================================================
%==========================================================================

[filename,pathname] = uigetfile('Acoustic_Array_Toolbox/Array_Processing_Tools/array_data/*.mat','Select data to load')
pathplusfile = [pathname filename];
load([filename])
whos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Select Array Data File Name to Process %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = input(['Input Array Data File Name (example: chs): ']);
[M,N] = size(data);
if M < N          % Make array fit format X(data,channel)
    data = data';
else
end

[M,N] = size(data);
Fs = input('Input sample frequency used to collect data (example: 2000): ');

cut = input('Do you want to cut out section of data (1=Yes,0=No)? ');
if cut == 1
    disp(['Data length is ',int2str(M)]);
    ns = input(['Input start sample: ']);
    if isempty(ns)
        ns = 1
    end
    ne = input(['Input end sample: ']);
    if ne<ns 
        error('Must enter end sample greater than start sample')
    end
    if isempty(ne)
        ne = M
    end
    data = data(ns:ne,:);
elseif cut ==0
end

