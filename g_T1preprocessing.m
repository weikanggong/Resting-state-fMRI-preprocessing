function g_T1preprocessing

disp('T1 preprocessing begin...')

cd('T1');
a=dir('*.nii.gz');
[~,index] = sortrows({a.date}.'); 
a = a(index);

if isempty(a)==1
    error('No T1 image file for this subject (nii.gz format)');
else
    %Reorient2std
    disp('Reorient2std and cropping...')
    f=a(1).name;
    f1=strrep(f,'.nii.gz','');
    command1=['fslreorient2std ',f1,' ',f1];
    unix(command1);
    %cropping
    command2=['robustfov -i ',f1,' -r cc_',f1];
    unix(command2);
    disp('Done...');
    %bet
    disp('Brain extraction...');
    command3=['bet cc_',f1,' bet_cc_',f1,' -m'];
    unix(command3);
    disp('Done...');
    
    %segmentation
    disp('Tissue segmentation...');
    command4=['fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -o bet_cc_',f1];
    unix(command4);
    disp('Done...');
    
    %flirt and fnirt
    disp('Linear registration...');
    inpf=['bet_cc_',f1];
    d1=which('g_T1preprocessing');
    d1=strrep(d1,'g_T1preprocessing.m','');
    reff=[d1,'MNI152_T1_2mm_brain'];
    command5=['flirt -in ',inpf,'.nii.gz -ref ',reff,' -omat linear_trans.mat'];
    unix(command5);
    disp('Done...');
    
    disp('Nonlinear registration...');
    command6=['fnirt --in=',inpf,' --ref=',reff,' --aff=linear_trans.mat --cout=str2std_nonlinear_trans --config=T1_2_MNI152_2mm'];
    unix(command6);
       
    command7=['applywarp -r ',reff,' -i ',inpf,' -o T1_2mmStdSpace -w str2std_nonlinear_trans'];
    unix(command7);
      
    command8=['applywarp -r ',reff,' -i ',inpf,'_pve_1 -o T1_2mmStdSpace_gm -w str2std_nonlinear_trans'];
    unix(command8);
    command9=['applywarp -r ',reff,' -i ',inpf,'_pve_2 -o T1_2mmStdSpace_wm -w str2std_nonlinear_trans'];
    unix(command9);
    command10=['applywarp -r ',reff,' -i ',inpf,'_pve_0 -o T1_2mmStdSpace_csf -w str2std_nonlinear_trans'];
    unix(command10);
       
    %command11=['invwarp --ref=',f,' --warp=str2std_nonlinear_trans --out=std2str_nonlinear_trans'];
    %unix(command11);

    
    aa=dir('*pve_0*');
    aa1=dir('*pve_2*');
    command9=['fslmaths ',aa(1).name,' -bin csf_mask'];
    unix(command9);
    command10=['fslmaths ',aa1(1).name,' -bin wm_mask'];
    unix(command10);

    disp('Done...');
    %T1_ref=inpf;
    %trans_matrix='str2std_nonlinear_trans';
    
    
end
    
cd ..
disp('T1 Preprocessing Done...') ;     
    
end