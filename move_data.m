
a=dir('00*');
for i=1:184
    cd(a(i).name);
    aa=dir('*normalization.tif');
    copyfile(aa(1).name,'..')
    f='./7_FunImg_to_Std/FunImg_4mmStdSpace.nii.gz';
    copyfile(f,['../',a(i).name,'_4mm.nii.gz']);
    cd ..
    i
end
