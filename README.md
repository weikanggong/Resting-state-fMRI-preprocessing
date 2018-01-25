# A Matlab-based software package for preprocessing the resting-state fMRI data


 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Copyright (C) 2017 Weikang Gong

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
  


**LICENSE**

This software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this software. If not, see http://www.gnu.org/licenses/.



**CONDITIONS OF USE**

The Software is distributed "AS IS" under the GNU General Public License (GPL, Version 3) license solely for non-commercial use. On accepting these conditions, the licensee understand that no condition is made or to be implied, nor is any warranty given or to be implied, as to the accuracy of the Software, or that it will be suitable for any particular purpose or for use under any specific conditions. Furthermore, the software authors disclaim all responsibility for the use which is made of the Software. It further disclaims any liability for the outcomes arising from using the Software.

No part of the Software may be reproduced, modified, transmitted or transferred in any form or by any means, electronic or mechanical, without the express permission of the author. The permission of the author is not required if the said reproduction, modification, transmission or transference is done without financial return, the conditions of this License are imposed upon the receiver of the product, and all original and amended source code is included in any transmitted product. You may be held legally responsible for any copyright infringement that is caused or encouraged by your failure to abide by these terms and conditions.

You are not permitted under this License to use this Software commercially. Use for which any financial return is received shall be defined as commercial use, and includes (1) integration of all or part of the source code or the Software into a product for sale or license by or on behalf of Licensee to third parties or (2) use of the Software or any derivative of it for research with the final aim of developing software products for sale or license to a third party or (3) use of the Software or any derivative of it for research with the final aim of developing non-software products for sale or license to a third party, or (4) use of the Software to provide any service to an external organisation for which payment is received. If you are interested in using the Software commercially, please contact Unitectra (http://www.unitectra.ch/en).




