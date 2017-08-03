function [outfile,folder]=g_WaveletDespike(infile,memory)

disp('Wavelet Despike ...');

outfile='Despiked';
folder='5_Despiked';
mkdir('./',folder);

WaveletDespike(infile,'Despiked','LimitRAM',memory,'verbose',0);

b=dir('Despiked_*');
for j=1:length(b)
    movefile(b(j).name,folder); 
end
disp('Done...');

outfile=[outfile,'_wds'];

end