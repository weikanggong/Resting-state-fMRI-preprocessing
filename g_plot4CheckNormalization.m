function g_plot4CheckNormalization

%%smoothed fMRI map to 2mm std space
d1=which('g_plot4CheckNormalization');
d1=strrep(d1,'g_plot4CheckNormalization.m','');
reff1=[d1,'MNI152_T1_2mm_brain'];

unix('fslroi ./4_Smoothed/Smoothed ./4_Smoothed/Smoothed_v0 0 1');

command=['applywarp --ref=',reff1,' --in=./4_Smoothed/Smoothed_v0 --warp=./7_FunImg_to_Std/Func2std --rel --out=img4plot --interp=sinc'];
unix(command);

a=load_nii('img4plot.nii.gz');
img=a.img;
[x,y,z]=size(img);
dat1=squeeze(img(fix(x/2),:,:));
dat2=squeeze(img(:,fix(y/2),:));
dat3=squeeze(img(:,:,fix(z/2)));

%%T1 in std space
a1=load_nii('./T1/T1_2mmStdSpace.nii.gz');
img1=a1.img;
[x1,y1,z1]=size(img1);
dat4=squeeze(img1(fix(x1/2),:,:));
dat5=squeeze(img1(:,fix(y1/2),:));
dat6=squeeze(img1(:,:,fix(z1/2)));

%%GM in std space
a2=load_nii([reff1,'.nii.gz']);
img2=a2.img;
[x2,y2,z2]=size(img2);
dat7=squeeze(img2(fix(x2/2),:,:));
dat8=squeeze(img2(:,fix(y2/2),:));
dat9=squeeze(img2(:,:,fix(z2/2)));

f=pwd;
k=strfind(f,'/');
f1=f((k(end)+1):end);


%%fMRI normalization plot
subplot(3,3,1)
imagesc(rot90(dat1))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
title('fMRI');
hline([30,60],'r-');
vline([36,73],'r-');

subplot(3,3,4)
imagesc(rot90(dat2))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
hline([30,60],'r-');
vline([30,60],'r-');

subplot(3,3,7)
imagesc(rot90(dat3))
colormap(gray);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
vline([30,60],'r-');
hline([36,73],'r-');

subplot(3,3,2)
imagesc(rot90(dat4))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
title('T1');
hline([30,60],'r-');
vline([36,73],'r-');

subplot(3,3,5)
imagesc(rot90(dat5))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
hline([30,60],'r-');
vline([30,60],'r-');

subplot(3,3,8)
imagesc(rot90(dat6))
colormap(gray);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
vline([30,60],'r-');
hline([36,73],'r-');

subplot(3,3,3)
imagesc(rot90(dat7))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
title('Std Space');
hline([30,60],'r-');
vline([36,73],'r-');

subplot(3,3,6)
imagesc(rot90(dat8))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
hline([30,60],'r-');
vline([30,60],'r-');

subplot(3,3,9)
imagesc(rot90(dat9))
colormap(gray);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
vline([30,60],'r-');
hline([36,73],'r-');



saveas(gcf, [f1,'_normalization.tif'], 'tif') 

unix('rm img4plot.nii.gz');


%%Head motion plot
load('./3_Motion_Corrected/Motion_Corrected.par');

subplot(2,1,1)
plot(Motion_Corrected(:,1:3),'LineWidth',1.5);
legend('x','y','z');
title('MCFLIRT estimated rotations (radians)');
xlim([1,size(Motion_Corrected,1)]);
xlabel('Time');
h=refline(0,0);
set(h,'LineStyle','-.','Color','black');

subplot(2,1,2)
plot(Motion_Corrected(:,4:6),'LineWidth',1.5);
legend('x','y','z');
title('MCFLIRT estimated translations (mm)');
xlim([1,size(Motion_Corrected,1)]);
xlabel('Time');
h1=refline(0,0);
set(h1,'LineStyle','-.','Color','black');

saveas(gcf, [f1,'_6head_motion.tif'], 'tif');

return


function hhh=hline(y,in1,in2)
% function h=hline(y, linetype, label)
% 
% Draws a horizontal line on the current axes at the location specified by 'y'.  Optional arguments are
% 'linetype' (default is 'r:') and 'label', which applies a text label to the graph near the line.  The
% label appears in the same color as the line.
%
% The line is held on the current axes, and after plotting the line, the function returns the axes to
% its prior hold state.
%
% The HandleVisibility property of the line object is set to "off", so not only does it not appear on
% legends, but it is not findable by using findobj.  Specifying an output argument causes the function to
% return a handle to the line, so it can be manipulated or deleted.  Also, the HandleVisibility can be 
% overridden by setting the root's ShowHiddenHandles property to on.
%
% h = hline(42,'g','The Answer')
%
% returns a handle to a green horizontal line on the current axes at y=42, and creates a text object on
% the current axes, close to the line, which reads "The Answer".
%
% hline also supports vector inputs to draw multiple lines at once.  For example,
%
% hline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
%
% draws three lines with the appropriate labels and colors.
% 
% By Brandon Kuczenski for Kensington Labs.
% brandon_kuczenski@kensingtonlabs.com
% 8 November 2001

if length(y)>1  % vector input
    for I=1:length(y)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=hline(y(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(gca);
    hold on

    x=get(gca,'xlim');
    h=plot(x,[y y],linetype);
    if ~isempty(label)
        yy=get(gca,'ylim');
        yrange=yy(2)-yy(1);
        yunit=(y-yy(1))/yrange;
        if yunit<0.2
            text(x(1)+0.02*(x(2)-x(1)),y+0.02*yrange,label,'color',get(h,'color'))
        else
            text(x(1)+0.02*(x(2)-x(1)),y-0.02*yrange,label,'color',get(h,'color'))
        end
    end

    if g==0
    hold off
    end
    set(h,'tag','hline','handlevisibility','off') % this last part is so that it doesn't show up on legends
end % else

if nargout
    hhh=h;
end
return
function hhh=vline(x,in1,in2)
% function h=vline(x, linetype, label)
% 
% Draws a vertical line on the current axes at the location specified by 'x'.  Optional arguments are
% 'linetype' (default is 'r:') and 'label', which applies a text label to the graph near the line.  The
% label appears in the same color as the line.
%
% The line is held on the current axes, and after plotting the line, the function returns the axes to
% its prior hold state.
%
% The HandleVisibility property of the line object is set to "off", so not only does it not appear on
% legends, but it is not findable by using findobj.  Specifying an output argument causes the function to
% return a handle to the line, so it can be manipulated or deleted.  Also, the HandleVisibility can be 
% overridden by setting the root's ShowHiddenHandles property to on.
%
% h = vline(42,'g','The Answer')
%
% returns a handle to a green vertical line on the current axes at x=42, and creates a text object on
% the current axes, close to the line, which reads "The Answer".
%
% vline also supports vector inputs to draw multiple lines at once.  For example,
%
% vline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
%
% draws three lines with the appropriate labels and colors.
% 
% By Brandon Kuczenski for Kensington Labs.
% brandon_kuczenski@kensingtonlabs.com
% 8 November 2001

if length(x)>1  % vector input
    for I=1:length(x)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=vline(x(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(gca);
    hold on

    y=get(gca,'ylim');
    h=plot([x x],y,linetype);
    if length(label)
        xx=get(gca,'xlim');
        xrange=xx(2)-xx(1);
        xunit=(x-xx(1))/xrange;
        if xunit<0.8
            text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        else
            text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        end
    end     

    if g==0
    hold off
    end
    set(h,'tag','vline','handlevisibility','off')
end % else

if nargout
    hhh=h;
end
return
