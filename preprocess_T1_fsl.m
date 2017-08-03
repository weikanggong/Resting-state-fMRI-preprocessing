function preprocess_T1_fsl(dirs)

cd (dirs);
reff='/home/gongweikang/MATLAB/mycode/Rest_Preprocessing/MNI152_T1_2mm_brain.nii.gz';

a123=dir('*');
parpool(19);

parfor i=3:length(a123)
    if a123(i).isdir
         %Reorient2std
          cd(a123(i).name);
%         a1=dir('sub*.nii.gz');
%         disp('Reorient2std and cropping...')
%         f=a1(1).name;
%         f1=strrep(f,'.nii.gz','');
%         command1=['fslreorient2std ',f1,' ',f1];
%         unix(command1);
%         cropping
%         command2=['robustfov -i ',f1,' -r cc_',f1];
%         unix(command2);
%         disp('Done...');
%         bet
%         disp('Brain extraction...');
%         command3=['bet cc_',f1,' bet_cc_',f1,' -f 0.4 -m'];
%         unix(command3);
%         disp('Done...');
%         
%         segmentation
%         disp('Tissue segmentation...');
%         command4=['fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -o bet_cc_',f1];
%         unix(command4);
%         disp('Done...');
%         
%         flirt and fnirt
%         disp('Linear registration...');
%         inpf=['bet_cc_',f1];
%         
%         command5=['flirt -in ',inpf,'.nii.gz -ref ',reff,' -omat linear_trans.mat'];
%         unix(command5);
%         disp('Done...');
%         
%         disp('Nonlinear registration...');
%         command6=['fnirt --in=',inpf,' --ref=',reff,' --aff=linear_trans.mat --cout=str2std_nonlinear_trans --config=T1_2_MNI152_2mm'];
%         unix(command6);
%         
%         command7=['applywarp -r ',reff,' -i ',inpf,' -o T1_2mmStdSpace -w str2std_nonlinear_trans'];
%         unix(command7);
%         
%         command8=['applywarp -r ',reff,' -i ',inpf,'_pve_1 -o T1_2mmStdSpace_gm -w str2std_nonlinear_trans'];
%         unix(command8);
%         command9=['applywarp -r ',reff,' -i ',inpf,'_pve_2 -o T1_2mmStdSpace_wm -w str2std_nonlinear_trans'];
%         unix(command9);
%         command10=['applywarp -r ',reff,' -i ',inpf,'_pve_0 -o T1_2mmStdSpace_csf -w str2std_nonlinear_trans'];
%         unix(command10);
%         
%         
%         
%         plot
%         a=load_nii(reff);
%         img=a.img;
%         [x,y,z]=size(img);
%         dat1=squeeze(img(fix(x/2),:,:));
%         dat2=squeeze(img(:,fix(y/2),:));
%         dat3=squeeze(img(:,:,fix(z/2)));
%         
%         %T1 in std space
%         a1=load_nii('T1_2mmStdSpace.nii.gz');
%         img1=a1.img;
%         [x1,y1,z1]=size(img1);
%         dat4=squeeze(img1(fix(x1/2),:,:));
%         dat5=squeeze(img1(:,fix(y1/2),:));
%         dat6=squeeze(img1(:,:,fix(z1/2)));
%         
%         %GM in std space
%         a2=load_nii('T1_2mmStdSpace_gm.nii.gz');
%         img2=a2.img;
%         [x2,y2,z2]=size(img2);
%         dat7=squeeze(img2(fix(x2/2),:,:));
%         dat8=squeeze(img2(:,fix(y2/2),:));
%         dat9=squeeze(img2(:,:,fix(z2/2)));
%         
%         %fMRI normalization plot
%         subplot(3,3,1)
%         imagesc(rot90(dat1))
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         title('Standard space');
%         hline([30,60],'r-');
%         vline([36,73],'r-');
%         
%         subplot(3,3,4)
%         imagesc(rot90(dat2))
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         hline([30,60],'r-');
%         vline([30,60],'r-');
%         
%         subplot(3,3,7)
%         imagesc(rot90(dat3))
%         colormap(gray);
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         vline([30,60],'r-');
%         hline([36,73],'r-');
%         
%         subplot(3,3,2)
%         imagesc(rot90(dat4))
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         title('T1');
%         hline([30,60],'r-');
%         vline([36,73],'r-');
%         
%         subplot(3,3,5)
%         imagesc(rot90(dat5))
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         hline([30,60],'r-');
%         vline([30,60],'r-');
%         
%         subplot(3,3,8)
%         imagesc(rot90(dat6))
%         colormap(gray);
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         vline([30,60],'r-');
%         hline([36,73],'r-');
%         
%         subplot(3,3,3)
%         imagesc(rot90(dat7))
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         title('Gray matter');
%         hline([30,60],'r-');
%         vline([36,73],'r-');
%         
%         subplot(3,3,6)
%         imagesc(rot90(dat8))
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         hline([30,60],'r-');
%         vline([30,60],'r-');
%         
%         subplot(3,3,9)
%         imagesc(rot90(dat9))
%         colormap(gray);
%         set(gca,'YTickLabel',[]);
%         set(gca,'XTickLabel',[]);
%         vline([30,60],'r-');
%         hline([36,73],'r-');
%         
%         unix(['cp T1_2mmStdSpace_gm.nii.gz ','../',a123(i).name,'_gm.nii.gz']);
        unix(['cp T1_2mmStdSpace_csf.nii.gz ','../',a123(i).name,'_csf.nii.gz']);
        cd ..
    end
%     saveas(gcf, [a123(i).name,'.tif'], 'tif');
    
end


return




