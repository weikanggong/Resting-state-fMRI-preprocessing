function g_MainFunction(workingDir,options)

cd(workingDir);
sublist=dir();
ind=[sublist(:).isdir];
sublist=sublist(ind);
sublist=sublist(3:end);
n_sub=size(sublist,1);


disp(['Number of subjects: ',num2str(n_sub),'.']);

parpool(options.n_core);

parfor i=1:n_sub
    cd(sublist(i).name);
    unix('rm Func2std.nii.gz');
    unix('rm std2Func.nii.gz');
    a=dir('*.nii.gz');
    [~,index] = sortrows({a.date}.'); 
    a = a(index);
    if isempty(a)==1
        error('No image file for this subject (Must be .nii.gz format!)');
    else
        
        %bet fmri
        f1=dir('./1_bet_FunImg/bet_FunImg.nii.gz');
        if length(f1)==1
            disp('FunImg has been brain-extracted, omit this step...');
            folder='1_bet_FunImg';
            outfile='bet_FunImg';
        else
            infile=a(1).name;
            [outfile,folder]=g_FuncBet(infile);
        end
        
        %slice timing
        f2=dir('./2_Slice_Timing_Corrected/Slice_Timing_Corrected.nii.gz');
        if length(f2)==1
            disp('FunImg has been slice-timing corrected, omit this step...');
            folder='2_Slice_Timing_Corrected';
            outfile='Slice_Timing_Corrected';
        else
            infile=['./',folder,'/',outfile];
            [outfile,folder]=g_slicetiming(infile,options.TR,options.slice_order);
        end
        
        
        %motion correction
        f3=dir('./3_Motion_Corrected/Motion_Corrected.nii.gz');
        if length(f3)==1
            disp('FunImg has been motion corrected, omit this step...');
            folder='3_Motion_Corrected';
            outfile='Motion_Corrected';
        else
            infile=['./',folder,'/',outfile];
            [outfile,folder] =g_MotionCorrection(infile);
        end
        
        
        %smoothing
        f4=dir('./4_Smoothed/Smoothed.nii.gz');
        if length(f4)==1
            disp('FunImg has been smoothed, omit this step...');
            folder='4_Smoothed';
            outfile='Smoothed';
        else
            infile=['./',folder,'/',outfile];
            [outfile,folder]=g_Smoothing(infile,options.FWHM);
        end
        
        
        %wavelet despike
        f5=dir('./5_Despiked/Despiked_wds.nii.gz');
        if length(f5)==1
            disp('FunImg has been despiked, omit this step...');
            folder='5_Despiked';
            outfile='Despiked_wds';
        else
            infile=['./',folder,'/',outfile,'.nii.gz'];
            [outfile,folder]=g_WaveletDespike(infile,options.memory);
        end
        
        
        %T1 bet,segment,flirt,fnirt
        f6=dir('./T1/T1_2mmStdSpace.nii.gz');
        if length(f6)==1
            disp('T1Img has been preprocessed, omit this step...');
        else
            g_T1preprocessing;
        end
        
        
        %func2str BBR
        f7=dir('./Fun2strBBR/Func2str.nii.gz');
        f77=dir('./7_FunImg_to_Std/Fun2strBBR/Func2str.nii.gz');
        if length(f7)==1 || length(f77)==1
            disp('FunImg has been registered to T1, omit this step...');
        else
            g_func2strBBR
        end
        
        
        %func2std pre
        f9=dir('./7_FunImg_to_Std/Func2std.nii.gz');
        if length(f9)==1
            disp('FunImg mapping has been preprocessed, omit this step...');
        else
            g_Func2std_preprocessing
        end
        
        %regress out wm,csf signal and temporal filtering
        f8=dir('./6_Regressed_and_Filtered/regressed_and_filtered.nii.gz');
        if length(f8)==1
            disp('FunImg has been regressed and filtered, omit this step...');
            folder='6_Regressed_and_Filtered';
            outfile1='regressed_and_filtered';
            outfile2='regressed_and_filtered';
        else
            infile=['./',folder,'/',outfile];
            [outfile1,outfile2,folder]=g_regressWmCsf_and_filter(infile,options.motion,options.bandpass,options.TR);
        end
        
        %fun2str2std
        f9=dir('./7_FunImg_to_Std/FunImg_4mmStdSpace.nii.gz');
        if length(f9)==1
            disp('FunImg has been normalized, omit this step...');
            unix('rm Func2std.nii.gz');
            unix('rm std2Func.nii.gz');
        else
            infile1=['./',folder,'/',outfile1];
            infile2=['./',folder,'/',outfile2];
            g_Func2std_mapping(infile1,infile2)
        end
        
        %plot picture
        f10=dir('*6head_motion*');
        if length(f10)==1
            disp('Pictures have been plotted, omit this step...');
        else
            g_plot4CheckNormalization;
        end
    end
    
    disp(['Preprocessing finished for subject ',sublist(i).name]);
    cd ..
    
end

disp('All the preprocessing steps finished!');



end