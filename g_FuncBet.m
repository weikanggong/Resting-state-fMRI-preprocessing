function [outfile,folder]=g_FuncBet(infile)

disp('FunImg Brain extraction...')
folder='1_bet_FunImg';
mkdir(folder);

command=['fslroi ',infile,' FunImg_V0 0 1'];
unix(command);

command1='bet FunImg_V0 bet_FunImg_V0 -f 0.3';
unix(command1);

command2=['bet ',infile,' bet_FunImg -F'];
unix(command2);

command3='fslmaths bet_FunImg_V0 -bin bet_FunImg_mask';
unix(command3);

outfile='bet_FunImg';

movefile('FunImg_V0.nii.gz',folder);
movefile('bet_FunImg_V0.nii.gz',folder);
movefile('bet_FunImg_mask.nii.gz',folder);
movefile('bet_FunImg.nii.gz',folder);

disp('Done...')

end