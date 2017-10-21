function [outfile,folder]=g_slicetiming(infile,Is_slicetiming,TR,slice_order)



%slice timing
disp('Slice timing correction...');

if Is_slicetiming==0
    disp(['TR is ',num2str(TR),'...']);   
    outfile='Slice_Timing_Corrected';
    folder='2_Slice_Timing_Corrected';
    mkdir('./',folder);
    
    copyfile([infile,'.nii.gz'],['./',folder,'/',outfile,'.nii.gz']);

    disp('Done...');
else
    
    TR=num2str(TR);
    
    
    disp(['TR is ',num2str(TR),'...']);
    
    outfile='Slice_Timing_Corrected';
    folder='2_Slice_Timing_Corrected';
    mkdir('./',folder);
    
    if slice_order==1
        disp('Slice order is bottom-up..')
        command=['slicetimer -i ',infile,' -o ',outfile,' -r ',TR];
        unix(command);
    elseif slice_order==2
        disp('Slice order is top-down..')
        command=['slicetimer -i ',infile,' -o ',outfile,' --down -r ',TR];
        unix(command);
    elseif slice_order==3
        disp('Slice order is interleaved and bottom up..')
        command=['slicetimer -i ',infile,' -o ',outfile,' --odd -r ',TR];
        unix(command);
    elseif slice_order==4
        disp('Slice order is interleaved and top down..')
        command=['slicetimer -i ',infile,' -o ',outfile,' --odd --down -r ',TR];
        unix(command);
    else
        disp('Slice order is specified elsewhere..')
        command=['slicetimer -i ',infile,' -o ',outfile,' -r ',TR,' --ocustom=',slice_order];
        unix(command);
    end
    
    movefile([outfile,'.nii.gz'],folder);
    
    
    disp('Done...');
    
end

end