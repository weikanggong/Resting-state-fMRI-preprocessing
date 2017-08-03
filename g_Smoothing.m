function  [outfile,folder]=g_Smoothing(infile,FWHM)

disp('3D Spatial Smoothing with Gaussian Kernel...');
disp(['FWHM = ',num2str(FWHM),' mm...']);

outfile='Smoothed';
folder='4_Smoothed';
mkdir('./',folder);


command=['fslmaths ',infile,' -kernel gauss ',num2str(FWHM/2.3548),' -fmean ',outfile];
unix(command);
movefile([outfile,'.nii.gz'],folder);


disp('Done...');

end