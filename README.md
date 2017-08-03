# Resting-state-fMRI-preprocessing

A Matlab software package for preprocessing resting-state fMRI data. 

It has been tested under Linux CentOS 7.2 and Ubuntu 16.04.

To use this software, you should have: 
(1) Matlab 2015b or higher;
(2) FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki);
(3) AFNI (https://afni.nimh.nih.gov/);
(4) Make sure that all the .m files in this package and the BrainWavelet toolbox (http://www.brainwavelet.org/) are in your Matlab Path.

The preprocessing steps include:
 1. fMRI data brain extraction.
 2. Slice timing correction.
 3. Motion correction.
 4. Smoothing.
 5. Wavelet Despiking.
 6. Regress out WM/CSF/Motion parameters and temporal filtering.
 7. FunImg register to T1, then normalize to 3mm Standard Space.
 8. T1 data are also preprocessed duing these steps.

Arrange your data in a folder as the 'example' folder : 
('data' is a folder, 'subject 1',..., 'subject n' are folders, 'T1' are folders)

                                |---subject1_rest.nii.gz
            |---'subject 1'-----|---'T1'---subject1_t1.nii.gz
                                |---subject2_rest.nii.gz
            |---'subject 2'-----|---'T1'---subject2_t1.nii.gz
    'data'--|---...
            |---...
            |---'subject n'
            
Set the parameters in the 'Script_to_run.m' script, and type 

'nohup matlab -nodisplay <Scipt_to_Run.m> report.log &' in the terminal to run the preprocessing.
