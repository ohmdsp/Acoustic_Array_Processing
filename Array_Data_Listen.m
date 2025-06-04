function    [] = Array_Data_Listen(data,Fs)

% Filename:         Array_Data_listen.m
% Author:           D.R.Ohm   
% Software:         Matlab 7.01
% Rev.Date:         June 20, 2005
%
% Plays audio for acoustic array channel pairs.
%
% data      - array data in form X(data,channel)
% Fs        - sample frequency of collected array data
%
%==========================================================================
%==========================================================================
tfs = length(data);
disp(['Time duration of data record is ',num2str(tfs/Fs), ' seconds'])
choice_sound = input('Do you want to listen to sensor audio (1=YES,0=NO)?  ');
if choice_sound ==1
    run_select = 1;
    while run_select == 1
        disp('Select a channel pair to listen to with your headphones');
        channel_1 = input('First channel#:  ');
        channel_2 = input('Second channel#:  ');
        ch1_2 = [data(:,channel_1),data(:,channel_2)];
        soundsc(ch1_2,Fs )
        pause(tfs/Fs)
        run_select =input('Do you want to select another channel pair (1=YES,0=NO)? ');
    end
elseif choice_sound == 0 
end
