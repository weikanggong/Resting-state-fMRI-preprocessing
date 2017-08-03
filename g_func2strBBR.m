function g_func2strBBR

disp('FunImg to Standard Space using Boundary-based Registration...')

a1=dir('./T1/cc_*.nii.gz');
T1_ref=strrep(a1(1).name,'.nii.gz','');

epi='./1_bet_FunImg/bet_FunImg_V0.nii.gz';

rawt1=['./T1/',T1_ref];
bett1=['./T1/bet_',T1_ref];
wmseg=['./T1/bet_',T1_ref,'_pve_2'];
outfile='Func2str';

command=['epi_reg --epi=',epi,' --t1=',rawt1,' --t1brain=',bett1,' --wmseg=',wmseg,'  --out=',outfile];

unix(command);

folder='Fun2strBBR';
mkdir(folder);

b=dir('Func2str*');
for i=1:length(b)
    movefile(b(i).name,folder);
end

command1='convert_xfm -omat ./Fun2strBBR/str2Func.mat -inverse ./Fun2strBBR/Func2str.mat';
unix(command1);


disp('Done...')


end