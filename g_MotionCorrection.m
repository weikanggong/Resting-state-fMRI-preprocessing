function [outfile,folder] =g_MotionCorrection(infile)


disp('Motion Correction...')

outfile='Motion_Corrected';
folder='3_Motion_Corrected';
mkdir('./',folder);
command=['mcflirt -in ',infile,' -out ',outfile,' -sinc_final -refvol 0 -mats -plots'];
unix(command);

command1=['fslmaths ',outfile,' -mas ./1_bet_FunImg/bet_FunImg_mask ',outfile];
unix(command1);

b=dir('Motion_Corrected.*');
for j=1:length(b)
    movefile(b(j).name,folder);
end
disp('Done...')

cd(folder);
ctg.motionparam='Motion_Corrected.par';
FD=bramila_framewiseDisplacement(ctg);
save('FD_power.1D','FD','-ascii')
mFD=mean(FD);
save('meanFD_power.1D','mFD','-ascii');
cd ..
end