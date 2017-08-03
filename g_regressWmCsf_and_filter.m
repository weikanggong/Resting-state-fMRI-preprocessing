
function [outfile1,outfile2,folder]=g_regressWmCsf_and_filter(infile,motion,bandpass,TR)


disp('Regressing out WM/CSF/Motion and temporal filtering...');

%Mapping the tissue probility map to individual FunImg space
d1=which('g_regressWmCsf_and_filter');
d1=strrep(d1,'g_regressWmCsf_and_filter.m','');

csf_mask=[d1,'avg152T1_csf_bin.nii.gz'];
wm_mask=[d1,'avg152T1_white_bin.nii.gz'];

command1=['applywarp --ref=',infile,' --in=',csf_mask,' --warp=std2Func.nii.gz --out=prob_csf --interp=nn'];
unix(command1);

command2=['applywarp --ref=',infile,' --in=',wm_mask,' --warp=std2Func.nii.gz --out=prob_wm --interp=nn'];
unix(command2);



%Mapping individual WM/CSF to individual FunImg space

command4='flirt -in ./T1/csf_mask -ref prob_csf -out individual_csf  -applyxfm -init ./Fun2strBBR/str2Func.mat -interp nearestneighbour';
unix(command4);

command5='flirt -in ./T1/wm_mask -ref prob_wm -out individual_wm  -applyxfm -init ./Fun2strBBR/str2Func.mat -interp nearestneighbour';
unix(command5);

%Find intersected regions between Prob map and individual map
command6='fslmaths individual_csf -mul prob_csf intersect_csf';
unix(command6);

command7='fslmaths individual_wm -mul prob_wm intersect_wm';
unix(command7);


%csf, wm, motion(6 parameters) average time series
command8=['3dmaskave -mask intersect_csf.nii.gz -quiet ',infile,'.nii.gz > csf.1D'];
unix(command8);

command9=['3dmaskave -mask intersect_wm.nii.gz -quiet ',infile,'.nii.gz > wm.1D'];
unix(command9);

%whole brain signal
command99=['3dmaskave -mask ./1_bet_FunImg/bet_FunImg_mask.nii.gz -quiet ',infile,'.nii.gz > global.1D'];
unix(command99);

%cat CSF/WM/motion parameters
motion_folder='./3_Motion_Corrected/';
if fix(motion)==6
    %6 parameter
    unix(['1dcat csf.1D wm.1D ',motion_folder,'Motion_Corrected.par > csf_wm_motion.1D']);
    unix(['1dcat csf.1D wm.1D global.1D ',motion_folder,'Motion_Corrected.par > csf_wm_motion_global.1D']);
    
elseif fix(motion)==12
    %12 parameter (6 motion + 6 derivative)
    load([motion_folder,'Motion_Corrected.par']);
    derivative=Motion_Corrected(2:end,:)-Motion_Corrected(1:(end-1),:);
    derivative1=cat(1,zeros(1,6),derivative);
    parameters=[Motion_Corrected,derivative1];
    save([motion_folder,'12_motion_parameters.1D'],'parameters','-ascii');
    unix(['1dcat csf.1D wm.1D ',motion_folder,'12_motion_parameters.1D > csf_wm_motion.1D']);
    unix(['1dcat csf.1D wm.1D global.1D ',motion_folder,'12_motion_parameters.1D > csf_wm_motion_global.1D']);
    
elseif fix(motion)==24
    %24 parameter (6 motion + 6 1timebefore + 12 square term)
    load([motion_folder,'Motion_Corrected.par']);
    onetimebefore=cat(1,zeros(1,6),Motion_Corrected(1:(end-1),:));
    parameters=[Motion_Corrected,onetimebefore,Motion_Corrected.^2,onetimebefore.^2];
    save([motion_folder,'Friston24_motion_parameters.1D'],'parameters','-ascii');
    unix(['1dcat csf.1D wm.1D ',motion_folder,'Friston24_motion_parameters.1D > csf_wm_motion.1D']);
    unix(['1dcat csf.1D wm.1D global.1D ',motion_folder,'Friston24_motion_parameters.1D > csf_wm_motion_global.1D']);
else
    error('No motion parameters regressed out! Please check your options!');
    
end



if TR~=0
    %regress them out and do temporal filtering
    command10=['3dTproject -ort csf_wm_motion.1D -prefix regressed_and_filtered.nii.gz -passband ',num2str(bandpass(1)),' ',num2str(bandpass(2)),' -input ',infile,'.nii.gz -dt ',TR];
    unix(command10);
    command10=['3dTproject -ort csf_wm_motion_global.1D -prefix regressed_and_filtered_NoGlobalSignal.nii.gz -passband ',num2str(bandpass(1)),' ',num2str(bandpass(2)),' -input ',infile,'.nii.gz -dt ',TR];
    unix(command10);
else
    command10=['3dTproject -ort csf_wm_motion.1D -prefix regressed_and_filtered.nii.gz -passband ',num2str(bandpass(1)),' ',num2str(bandpass(2)),' -input ',infile,'.nii.gz'];
    unix(command10);
    command10=['3dTproject -ort csf_wm_motion_global.1D -prefix regressed_and_filtered_NoGlobalSignal.nii.gz -passband ',num2str(bandpass(1)),' ',num2str(bandpass(2)),' -input ',infile,'.nii.gz'];
    unix(command10);
end


%move files to new folder
folder='6_Regressed_and_Filtered';
mkdir(folder);

bb=dir('*wm*');
for j=1:length(bb)
    movefile(bb(j).name,folder);
end

bb=dir('*csf*');
for j=1:length(bb)
    movefile(bb(j).name,folder);
end

outfile1='regressed_and_filtered.nii.gz';
movefile(outfile1,folder);

outfile2='regressed_and_filtered_NoGlobalSignal.nii.gz';
movefile(outfile2,folder);

disp('Done...')


end