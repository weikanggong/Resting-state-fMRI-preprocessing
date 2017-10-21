%% Instruction
% To run this script, you should:
% (1) Use a Linux System;
% (2) Arrange your data in a folder correctly 
%         (See 'example' folder for data structure);
% (3) Install Matlab, FSL, AFNI, BrainWavelet(be compiled) software;
% (4) Make sure that this package and BrainWavelet toolbox are in your
%     Matlab Path;
%
% Set the patameters bellow in Settings Section, and then type the command:
%  nohup matlab -nodisplay <Scipt_to_Run.m> report.log &
% in the terminal.
% The preprocessing will run in the background. Informations are recorded
% in the 'report.log' file.

%% Preprocessing Steps
% 1. fMRI data brain extraction.
% 2. Slice timing correction.
% 3. Motion correction.
% 4. Smoothing.
% 5. Wavelet Despike.
% 6. Regress out WM/CSF/Motion parameters and temporal filtering.
% 7. FunImg register to T1, then normalize to 3mm Standard Space.
% 8. T1 data are also preprocessed duing these steps.

%% Settings
%Please set the following parameters for rest fMRI data preprocessing

% Data Directory (Be sure your data structure is correct!!)
workingDir='/home/gongweikang/Depression/xinan';


% whether do slicetiming
Is_slicetiming=1;

% Slice Timing TR (in second) (useful for filter)
TR=2;

% Slice order (1: bottom up, 2: top down, 3: interleaved+bottem up, 4: interleaved+top down, 'file.txt': specify slice direction)
slice_order=3;

% Spatial Gaussian Kernel Full-Width at Half Maximum (in mm)
FWHM=6;

% Motion parameter regression(options: 6, 12, Friston 24)
motion=12;

% bandpass ([low,high] in Hz)
bandpass=[0.01,0.1];


% The standard space to which each image is mapped.
resolution='3mm';

% Maximum Memory allowed for Wavelet Despiking (in GB)
memory=3;

% Number of processors 
n_core=19;

%Be sure that memory*n_core < maximum memory allowed!!



%% Main Function
options.Is_slicetiming=Is_slicetiming;
options.TR=TR;
options.slice_order=slice_order;
options.FWHM=FWHM;
options.motion=motion;
options.memory=memory;
options.n_core=n_core;
options.bandpass=bandpass;
options.resolution=resolution;
g_MainFunction(workingDir,options);




