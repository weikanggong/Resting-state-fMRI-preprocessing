
function g_Func2std_mapping(infile1,infile2)

disp('Mapping FunImg to Standard Space...')


d1=which('g_Func2std_mapping');
d1=strrep(d1,'g_Func2std_mapping.m','');
reff1=[d1,'MNI152_T1_3mm_brain'];
folder='7_FunImg_to_Std';
mkdir(folder);
unix(['mv Func2std.nii.gz ',folder]);
unix(['mv std2Func.nii.gz ',folder]);
unix(['mv Fun2strBBR ',folder]);

command=['applywarp --ref=',reff1,' --in=',infile1,' --warp=./7_FunImg_to_Std/Func2std --rel --out=FunImg_3mmStdSpace --interp=sinc'];
unix(command);

command=['applywarp --ref=',reff1,' --in=',infile2,' --warp=./7_FunImg_to_Std/Func2std --rel --out=FunImg_3mmStdSpace_NoGlobalSignal --interp=sinc'];
unix(command);



movefile('FunImg_3mmStdSpace.nii.gz',folder);
movefile('FunImg_3mmStdSpace_NoGlobalSignal.nii.gz',folder);

disp('Finished!');



end
