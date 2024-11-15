% This script is part of the EMG analysis project and is used to test the extraction 
% of data from Delsys EMG systems. 
%
% Author: roberto.barumerli@univr.it

clearvars
close all

% Using data from pilot
pilot_data = load('data_delsys.mat');

flag_resample = 1; 
flag_plotting = 1; 

            % name, field, fs 
names = {'cinematica', 'acc', 100; ...
         'spinale', 'emg', 1000; ...
         'retto', 'emg', 1000};

dts = extract_delsys_data(pilot_data, names, flag_resample, flag_plotting)