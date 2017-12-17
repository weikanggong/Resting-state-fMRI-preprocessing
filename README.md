# A Matlab-based software package for preprocessing the resting-state fMRI data


 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Copyright (C) 2017 Weikang Gong

The content in this package is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License.
**You are free to:**
Share — copy and redistribute the material in any medium or format.
Adapt — remix, transform, and build upon the material.
**Under the following terms:**
Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
NonCommercial — You may not use the material for commercial purposes.
ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
**Notices:**
You do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation.
No warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




**The software has been tested under Linux CentOS 7.2 and Ubuntu 16.04.**

**To use this software, one should have:**

 1. Matlab 2015b or higher;
 2. FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki);
 3. AFNI (https://afni.nimh.nih.gov/);
 4. All the .m files in this package and the BrainWavelet toolbox (http://www.brainwavelet.org/) are in the Matlab Path.
 5. The BrainWavelet toolbox should be compiled.
 
**The preprocessing steps include:**

 1. fMRI data brain extraction (bet in FSL).
 2. Slice timing correction (slicetimer in FSL).
 3. Motion correction (mcflirt in FSL).
 4. Smoothing (fslmath in FSL).
 5. Wavelet Despiking (BrainWavelet toolbox).
 6. Regress out WM/CSF/Motion parameters and temporal filtering (3dTproject in AFNI).
 7. FunImg register to T1, then normalize to 3mm Standard Space (BBR, flirt and fnirt in FSL).
 8. T1 data are also preprocessed duing these steps (bet,fast,flirt,fnirt).

**Arrange the data in a folder as (see 'example' folder as an example) :**

('data' is a folder, 'subject 1',..., 'subject n' are folders, 'T1' are folders)

(/subject_k_rest.nii.gz/ is the resting-state fMRI data of k-th subjects. The name of the data can be arbitrary.)

(/subject_k_t1.nii.gz/ is the T1 structure data of k-th subjects. The name of the data can be arbitrary.)

```
                                |---/subject_1_rest.nii.gz/
            |---'subject 1'-----|---'T1'---/subject_1_t1.nii.gz/
                                |---/subject_2_rest.nii.gz/
            |---'subject 2'-----|---'T1'---/subject_2_t1.nii.gz/
    'data'--                    |---....nii.gz
            |---...........-----|---'T1'---....nii.gz
                                |---/subject_n_rest.nii.gz/
            |---'subject n'-----|---'T1'---/subject_n_t1.nii.gz/

```
**Set the parameters in the 'Script_to_run.m' script, and type**
```
nohup matlab -nodisplay <Scipt_to_Run.m> report.log &
```
**in the terminal to begin the preprocessing. If something goes wrong, you can just delete or fix the 'bad' data and rerun the above command. The software will automatically continue to process the steps that have not been done.**

**Outputs of this software:**

1. The file 'FunImg_3mmStdSpace.nii.gz' and 'FunImg_3mmStdSpace_NoGlobalSignal.nii.gz' in the '7_FunImg_to_Std' folder is data one can use for further analysis. 'FunImg_3mmStdSpace.nii.gz' is the data in the 3mm standard space with global signal preserved. 'FunImg_3mmStdSpace_NoGlobalSignal.nii.gz' is the data in the 3mm standard space with global signal being regressed out.
  
2. The file 'meanFD_power.1D' in the '3_Motion_Corrected' folder is the mean Framewise displacement (FD) of this subject.

3. The file '**_normalization.tif' is a picture for checking the spatial normalization quality of fMRI data and T1 data. The first column shows the normalized fMRI data in standard space, and the second column shows the normalized T1 data in standard space, and the third column is the template used.

4. The file '**_6head_motion.tif' is a picture that shows the 6 ridge-body transformation parameters estimated in the motion correction step by mcflirt in FSL.
  
  
**If you have any questions, please email me at weikanggong@gmail.com**   
  



