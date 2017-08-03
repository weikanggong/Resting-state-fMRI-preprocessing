function [fwd,rms]=bramila_framewiseDisplacement(cfg)
% BRAMILA_FRAMEWISEDISPLACEMENT - Computes the framewise displacement
% metric as described in 
% Power et al. (2012) doi:10.1016/j.neuroimage.2011.10.018 and also 
% Power et al. (2014) doi:10.1016/j.neuroimage.2013.08.048
%   - Usage:
%   fwd = bramila_framewiseDisplacement(cfg)
%   - Input:
%   cfg is a struct with following parameters
%       cfg.motionparam = the 6 time series of motion parameters (time in 1st dimension)
%       cfg.prepro_suite = 'fsl-fs', 'spm' (default fsl-fs, fs = freesurfer)
%       cfg.radius = radius of sphere in mm to convert degrees to motion,
%       default = 50 as in Power et al 2014
%   - Output:
%       fwd = framewise displacement timeseries
%   - Notes:
%   Need to check that spm is indeed different, see end of Yan 2013 10.1016/j.neuroimage.2013.03.004 
%
%	Last edit: EG 2010-01-10
    
    fprintf('Computing framewise displacement...');
    temp_cfg=[];
    ts = load(cfg.motionparam);
    temp_cfg.vol=double(ts);
    temp_cfg.write=0;
    temp_cfg.detrend_type='linear-demean';
    ts=bramila_detrend(temp_cfg);   % demean and detrend as specified in Power et al 2014
    
    if(size(ts,2)~=6)
        error(['The motion time series must have 6 motion parameters in 6 columns; the size of the input given is ' num2str(size(ts))])
    end
    prepro_suite='fsl-fs'; % 1 is FSL, 2 is SPM
    if(isfield(cfg,'prepro_suite'))
        prepro_suite = cfg.prepro_suite;
    end
    
    radius=50; % default radius
    if(isfield(cfg,'radius'))
        radius = cfg.radius;
    end    
    
    if(strcmp(prepro_suite,'fsl-fs'))
        % convert radians into motion in mm
		% in FSL the first 3 columns are rotations, in spm its viceversa
        temp=ts(:,1:3);
        temp=radius*temp;
        ts(:,1:3)=temp;
    else % SPM way
        % convert degrees into motion in mm;
        temp=ts(:,4:6);
        %temp=(2*radius*pi/360)*temp; % UPDATE: it seems they are in radians afterall
        temp=radius*temp;
        ts(:,4:6)=temp;
    end
    
    dts=diff(ts);
    dts=[
        zeros(1,size(dts,2)); 
        dts
        ];  % first element is a zero, as per Power et al 2014
    fwd=sum(abs(dts),2);
    rms=sqrt(mean(ts.^2,1));    % root mean square for each column
    
    fprintf(' done\n');
    
 function vol = bramila_detrend(cfg)
% INPUT
%   cfg.infile = location where the subject NII file (4D)
%   cfg.vol = input can be a 4D volume, if this exists, then infile is not loaded but used as ID (optional)
%   cfg.write = 0 (default 0, set to 1 if you want to store the volume)
%   cfg.detrend_type = type of detrend, default is 'linear-nodemean', others are: 'linear-demean', 'spline', 'polynomial-(no)demean'
%   cfg.TR = TR (mandatory if detrend spline is used)
% OUTPUT
%   vol = a 4D volume detrended
if(isfield(cfg,'vol'))
	data=cfg.vol;
	% add check that it's a 4D vol
elseif(isfield(cfg,'infile'))
	nii=load_nii(cfg.infile);
	data=nii.img;
end
data=double(data);
type='linear-nodemean';
if(isfield(cfg,'detrend_type'))
    type=cfg.detrend_type;
end
% resize the data into a 2-dim matrix, time in first dimension
kk=size(data);
if(length(kk)==4)
    T=kk(4);
    tempdata=reshape(data,[],T);
    tempdata=tempdata';
    fprintf('Detrending data...');
else
    T=kk(1);
    tempdata=data;
end
m=mean(tempdata,1);
switch type
    case 'linear-demean'
        tempdata=detrend(tempdata);
    case 'linear-nodemean'
        tempdata=detrend(tempdata);
        for row=1:T
            tempdata(row,:)=tempdata(row,:)+m;
        end
    case 'spline'
        error('not implememented')
        % add here code
    case   'polynomial-demean'
        tempdata=detrend_extended(tempdata,2);  
    case   'polynomial-nodemean'
        tempdata=detrend_extended(tempdata,2);
        for row=1:T
            tempdata(row,:)=tempdata(row,:)+m;
        end 
	case 'Savitzky-Golay'
		% see http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3929490/
		if(T*cfg.TR>=240) 
			SGlen=round(240/cfg.TR); 
		else
			SGlen=T; % if we have less than 4 minutes, let's use all the data
		end
		disp(['Performing Savitzky-Golay detrending over ' num2str(SGlen) ' timepoints']);
		
		if(mod(SGlen,2)==0) SGlen=SGlen-1; end % it needs to be odd
		trend=sgolayfilt(tempdata,3,SGlen);
		for v=1:size(tempdata,2) % foreach voxel
			if(var(trend(:,v))==0) continue; end
			[aa bb res]=regress(tempdata(:,v),[trend(:,v)  ones(T,1)]);
			tempdata(:,v)=res;
		end
		for row=1:T
            tempdata(row,:)=tempdata(row,:)+m;
        end		  
end
% resize the data back
if(length(kk)==4)
    tempdata=tempdata';
    vol=reshape(tempdata,kk);
    fprintf(' done\n');
else
    vol=tempdata;
end
if cfg.write==1 || nargout<1
    cfg.outfile=bramila_savevolume(cfg,vol,'EPI volume after detrending','mask_detrend.nii');
end
function [X,T]=detrend_extended(t,X,p)
% DETREND removes the trend from data, NaN's are considered as missing values
% 
% DETREND is fully compatible to previous Matlab and Octave DETREND with the following features added:
% - handles NaN's by assuming that these are missing values
% - handles unequally spaced data
% - second output parameter gives the trend of the data
% - compatible to Matlab and Octave 
%
% [...]=detrend([t,] X [,p])
%	removes trend for unequally spaced data
%	t represents the time points
%	X(i) is the value at time t(i)
%	p must be a scalar
%
% [...]=detrend(X,0)
%	removes the mean
%
% [...]=detrend(X,p)
%	removes polynomial of order p (default p=1)
%
% [...]=detrend(X,1) - default
%	removes linear trend 
%
% [X,T]=detrend(...) 
%
% X is the detrended data
% T is the removed trend
% 
% see also: SUMSKIPNAN 
% This library is free software; you can redistribute it and/or
% modify it under the terms of the GNU Library General Public
% License as published by the Free Software Foundation; either
% Version 2 of the License, or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Library General Public License for more details.
%
% You should have received a copy of the GNU Library General Public
% License along with this library; if not, write to the
% Free Software Foundation, Inc., 59 Temple Place - Suite 330,
% Boston, MA  02111-1307, USA.
% Copyright (C) 1995, 1996  Kurt Hornik <Kurt.Hornik@ci.tuwien.ac.at>
% Copyright (C) 2001 by Alois Schloegl <a.schloegl@ieee.org>	
% last revision 13 Apr 2001, Ver 2.74
if (nargin == 1)
    	p = 1;
       	X = t;
	t = [];
elseif (nargin == 2)
        if all(size(X)==1), 
                p = X;
                X = t;
                t = [];
        else
                p = 1;
    	end;            
elseif (nargin == 3)
        
elseif (nargin > 3)
    	fprintf (1,'usage: detrend (x [, p])\n');
end;
% check data, must be in culomn order
[m, n] = size (X);
if (m == 1)
        X = X';
        r=n;
else
        r=m;
end
% check time scale
if isempty(t),
	t = (1:r).'; % make time scale 
elseif ~all(size(t)==size(X)) 
        t = t(:);
end;
% check dimension of t and X
if ~all(size(X,1)==size(t,1))
        fprintf (2,'detrend: size(t,1) must same as size(x,1) \n');
end;
% check the order of the polynomial 
if (~(all(size(p)==1) & (p == round (p)) & (p >= 0)))
	fprintf (2,'detrend:  p must be a nonnegative integer\n');
end
if (nargout>1)  , % needs more memory
        T = zeros(size(X))+nan; 
        %T=repmat(nan,size(X)); % not supported by Octave 2.0.16
        
        
        if (size(t,2)>1),	% for multiple time scales
                for k=1:size(X,2),
	                idx=find(~isnan(X(:,k)));
                        b = (t(idx,k) * ones (1, p + 1)) .^ (ones (length(idx),1) * (0 : p));
		        T(idx,k) = b * (b \ X(idx,k));
		end;
        	        
        else			% if only one time scale is used
		b = (t * ones (1, p + 1)) .^ (ones (length(t),1) * (0 : p));
                for k=1:size(X,2),
	                idx=find(~isnan(X(:,k)));
		        T(idx,k) = b(idx,:) * (b(idx,:) \ X(idx,k));
	        	%X(idx,k) = X(idx,k) - T(idx,k); % 1st alternative implementation
                        %X(:,k) = X(:,k) - T(:,k); % 2nd alternative 
                end;
	end;
        X = X-T;  % 3nd alternative 
        
        if (m == 1)
	        X = X';
	        T = T';
	end
else % needs less memory
        if (size(t,2)>1),	% for multiple time scales
                for k = 1:size(X,2),
	                idx = find(~isnan(X(:,k)));
                        b = (t(idx,k) * ones (1, p + 1)) .^ (ones (length(idx),1) * (0 : p));
		        X(idx,k) = X(idx,k) -  b * (b \ X(idx,k));
		end;
        else			% if only one time scale is used
		b = (t * ones (1, p + 1)) .^ (ones (length(t),1) * (0 : p));
		for k = 1:size(X,2),
		        idx = find(~isnan(X(:,k)));
	        	X(idx,k) = X(idx,k) - b(idx,:) * (b(idx,:) \ X(idx,k));
		end;
	end;
        if (m == 1)
	        X = X';
	end
end;   
    
    
    
    
    
    