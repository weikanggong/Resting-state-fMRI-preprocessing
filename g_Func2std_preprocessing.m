function g_Func2std_preprocessing


    %to std
    disp('FunImg to standard space preprocessing...');
    
    d1=which('g_Func2std_preprocessing');
    d1=strrep(d1,'g_Func2std_preprocessing.m','');
    
    reff=[d1,'MNI152_T1_2mm_brain'];
    
    command2=['convertwarp --ref=',reff,' --warp1=./T1/str2std_nonlinear_trans --premat=./Fun2strBBR/Func2str.mat --out=Func2std --relout'];
    unix(command2);
    
    command3='invwarp --ref=./1_bet_FunImg/bet_FunImg_V0 --warp=Func2std --out=std2Func';
    unix(command3);
    

    disp('Done...');
  
    
    
    
end