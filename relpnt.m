function [impix rws cls xc xy_err]=relpnt(dir_n,imname,M,ni,meth,sw10,xcnew,mess_xy,h_resize)

% RELPNT
%   FAUCCAL supporting function. 
%   Finds and sets in order points of a grid, 
%   based on Harris corner and edge detector.

global width
global height

clear ME
swresize=0;

% Read image
warning off
im=imread([dir_n imname]);
im_num=M;

% Check resolution of image and resize image if resolution grater than
% 960x720 in order to perform the Harris oparator in lower resolution
% images (Increses efficiency. Pre-requests Image Processing Toolbox,
% otherwise the full resolution image is used)
if h_resize==1 && (width>960 || height>720)
    try
        res_scale=width/640;
        im2=imresize(im,1/res_scale);
        swresize=1;
        clear im
        im=im2;
        clear im2
    catch      

    end
end

% Transform image to grayscale
s=whos('im');
if strcmp(s.class,'uint8')==1
    if size(im,3)~=1
        im=double(im);
        im2(:,:) = .2989*im(:,:,1) + .5870*im(:,:,2) + .1141*im(:,:,3);

        clear im
        im=uint8(im2);
        clear im2
    end
else
    ME = MException('Fauccal:INVFMT','This program works only with images of 8 bit color depth');
    throw(ME)
end

% Equlize image
mxval=max(max(im));
mnval=min(min(im));
if (mxval<255 && mnval>0)
    imeq=zeros(size(im));
    fctr=255/(mxval-mnval);
    imeq=round((im-mnval)*fctr);
    clear im fctr
    im=uint8(imeq);
else
    im=uint8(im);
end

% Image contrast
contrast=std(single(im(:)));
clear mxval mnval imeq

% Image size
ims(2)=size(im,1);
ims(1)=size(im,2);

if sw10==0;
    % Use Harris point detector on image

    sig=4;  % standard deviation of smoothing Gaussian. Typical values to use might be 1-3.
    thr=1100;   % threshold (optional). Try a value ~1000.
    rds=5;  % radius of region considered in non-maximal suppression (optional).
    % Typical values to use might be 1-3.
    wx=7;
    wy=7;
    wx2=-1;
    wy2=-1;

    [xc,xy_err]=sub_corners(im,sig,thr,rds,wx,wy,wx2,wy2);   % detect xc points with

else
     [xc,good,bad,xy_err,type]=cornerfinder(xcnew,im,3,3,-1,-1);
end


% This block applies the Harris operator localy for highly resolution
% images in order to achieve high efficiency 
if swresize==1

%     % Debug set 1 {Plot points on resized image}
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     figure(500+M)
%     imshow(im)
%     hold on
%     plot(xc(1,:),xc(2,:),'oy','markerfacecolor','y','markersize',5)
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    im3=imread([dir_n imname]);
    clear imname
        
    % Transform original image to grayscale
    if size(im3,3)~=1
        im3=double(im3);
        im2(:,:) = .2989*im3(:,:,1) + .5870*im3(:,:,2) + .1141*im3(:,:,3);

        clear im3
        im3=uint8(im2);
        clear im2
    end
    
     % Equlize image
    mxval=max(max(im3));
    mnval=min(min(im3));
    if (mxval<255 && mnval>0)
        imeq=zeros(size(im3));
        fctr=255/(mxval-mnval);
        imeq=round((im3-mnval)*fctr);
        clear im fctr
        im3=uint8(imeq);
    else
        im3=uint8(im3);
    end

    % Image contrast
    contrast=std(single(im3(:)));
    clear mxval mnval imeq

    % Image size
    ims(2)=size(im3,1);
    ims(1)=size(im3,2);
    
    xc3=zeros(size(xc,1),size(xc,2));
    xc3(:,:)=nan;
    w_x=floor(width/64);
    w_y=w_x;
    for i=1:size(xc,2)
        limx1=floor(xc(1,i)*res_scale)-w_x;
        limx2=floor(xc(1,i)*res_scale)+w_x;
        limy1=floor(xc(2,i)*res_scale)-w_y;
        limy2=floor(xc(2,i)*res_scale)+w_y;
        if limy1>0 && limy2<height && limx1>0 && limx2<width
            rs=limy1:limy2;
            cs=limx1:limx2;
        else
            continue
        end
        [xc2,xy_err]=sub_corners(im3(rs,cs),...
            sig,thr,rds,wx,wy,wx2,wy2);
        size_xc2=size(xc2,2);
        if size_xc2>0
            segs=zeros(1,size_xc2);
            for j=1:size_xc2 
                dx1=xc(1,i)*res_scale-(xc2(1,j)+cs(1)-1);
                dy1=xc(2,i)*res_scale-(xc2(2,j)+rs(1)-1);
                segs(j)=sqrt(dx1^2+dy1^2);
            end
            s_min=min(segs(:));
            if s_min<w_x/2
                s_ind=find(segs(:)==s_min);
                xc3(1,i)=xc2(1,s_ind)+(cs(1)-1);
                xc3(2,i)=xc2(2,s_ind)+(rs(1)-1);
            end
        end       
    end
    im=im3;
else
    xc3=xc;
    clear imname xc
end

clear sig thr rds wx wy wx2 wy2 xc im3

xcn(1,:)=xc3(1,~isnan(xc3(1,:)));
xcn(2,:)=xc3(2,~isnan(xc3(2,:)));
clear xc3
xc=xcn;
clear xcn

% Ignore perimetric points
inv=ni;
 
offset=0;

% Uncomment following block in order to solve DLR dataset 
%%%%%%%%%%%%%%%%%%%%%%
% inv=2;
% if M==6 || M==7 || M==9
%     offset=-30;
%     if M==9
%         inv=3;
%     end
% else
%     offset=30;
% end
%%%%%%%%%%%%%%%%%%%%%%

% Uncomment following block in order to solve Bouguet's dataset 
%%%%%%%%%%%%%%%%%%%%%%
% inv=2;
%%%%%%%%%%%%%%%%%%%%%%

% Calculate central point's coordinates
midpnt=[median(xc(1,:))+offset  median(xc(2,:))+offset];

% Evaluate scripts for finding principal directions
% according to user's choice
if meth==1
    % Debug set 2 {Plot established principle directions} 
    % is in tilebased.m file
    tilebased %% default method
else
    pntbased %% this method can not longer be selected by the program's GUI
end

% Central point is set as the base point from wich the point seeking 
% algorithm begins
bpnt(1:2)=cgpnt(1,:);

vals=[-1 1];
gmtr=1;
gmtc=1;
gapsr=[];
gapsc=[];

% Cos and sin of principal directions
csan=angnum(ang1,ang2);

% constructed lines variable
lnen=1;
pnlines{lnen}(1,:)=cgpnt(:);
ftm(1)=f(1);
ftm(2)=f(2);
ftm(3)=f(3);

sw2=0;
for i=1:2
    % Call function for tracing lines
    [pnlines gmtr gapsr lnen]=lntracer(bpnt,xc,ang1,ang2,...
        ftm,pnlines,gmtr,gapsr,lnen,i);

    % Alike proceedure to find first line's point on the opposite side of the
    % above direction
    ftm(3)=f(4);
    bpnt(:)=cgpnt(:);
    gnpnt(1)=-csan(2,2)*ftm(3)+bpnt(1);
    gnpnt(2)=-csan(2,1)*ftm(3)+bpnt(2);
    [xcn]=seekpnt(gnpnt,ftm(3),xc);


    if (i==1 && ~isempty(xcn(xcn>0)))
        % If a point on the opposite side is found continue
        % to other lines
        bpnt(:)=xcn(:,1);
        lnen=lnen+1;
        pnlines{lnen}(1,:)=bpnt(:);
    elseif isempty(xcn(xcn>0))
        % If not try for 2 times to find if there are any other points
        % on the same direction and if not exit loop
        tmp_ind=find(pnlines{1}(:,1)==cgpnt(1));
        if (tmp_ind>1 && tmp_ind<size(pnlines{1},1))
            while (isempty(xcn(xcn>0)) && sw2<3)
                sw2=sw2+1;
                gnpnt(1)=-csan(2,2)*ftm(3)+pnlines{1}(tmp_ind+(-1)^sw2,1);
                gnpnt(2)=-csan(2,1)*ftm(3)+pnlines{1}(tmp_ind+(-1)^sw2,2);
                [xcn]=seekpnt(gnpnt,ftm(3),xc);
            end
        end
        if isempty(xcn(xcn>0))
            break
        else
            bpnt(:)=xcn(:,1);
            lnen=lnen+1;
            pnlines{lnen}(1,:)=bpnt(:);
        end
    end
end
lnenr=lnen;
if mess_xy==1  
    if mod(im_num,2)==0
        pnlines2_t=pnlines;
        clear pnlines
    end
end  
bpnt(1:2)=cgpnt(1,:);
lnen=1;
sw2=0;
pnlines2{lnen}(1,:)=cgpnt(:);
ftm(1)=f(3);
ftm(2)=f(4);
ftm(3)=f(1);

% Change cos and sin to correspond to the second direction
csan=angnum(ang2,ang1);

for i=3:4
    % Same proceedure as above
    [pnlines2 gmtc gapsc lnen]=lntracer(bpnt,xc,ang2,ang1,...
        ftm,pnlines2,gmtc,gapsc,lnen,i);

    ftm(3)=f(2);
    bpnt(:)=cgpnt(:);
    gnpnt(1)=-csan(2,2)*ftm(3)+bpnt(1);
    gnpnt(2)=-csan(2,1)*ftm(3)+bpnt(2);
    [xcn]=seekpnt(gnpnt,ftm(3),xc);

    if (i==3 && ~isempty(xcn(xcn>0)))
        bpnt(:)=xcn(:,1);
        lnen=lnen+1;
        pnlines2{lnen}(1,:)=bpnt(:);
    elseif isempty(xcn(xcn>0))
        tmp_ind=find(pnlines2{1}(:,1)==cgpnt(1));
        if (tmp_ind>1 && tmp_ind<size(pnlines2{1},1))
            while (isempty(xcn(xcn>0)) && sw2<3)
                sw2=sw2+1;
                gnpnt(1)=-csan(2,2)*ftm(3)+pnlines2{1}(tmp_ind+(-1)^sw2,1);
                gnpnt(2)=-csan(2,1)*ftm(3)+pnlines2{1}(tmp_ind+(-1)^sw2,2);
                [xcn]=seekpnt(gnpnt,ftm(3),xc);
            end
        end
        if isempty(xcn(xcn>0))
            break
        else
            bpnt(:)=xcn(:,1);
            lnen=lnen+1;
            pnlines2{lnen}(1,:)=bpnt(:);
        end
    end
end
lnenc=lnen;
clear cgpnt lnen

if mess_xy==1
    if mod(im_num,2)==0
        pnlines=pnlines2;
        clear pnlines2
        pnlines2=pnlines2_t;
        clear pnlines2_t
    end
end

% For lines with more than 2 points calculates the point where each line
% intersects the Y axis

if mess_xy==1
    if mod(im_num,2)==1
        fab=zeros(1,size(pnlines,2));
        for i=1:lnenr
            pl_i=round(size(pnlines{i},1)/2);
            pl(1:2,1:2)=[pnlines{i}(pl_i,1:2);pnlines{i}(pl_i+1,1:2)];
            al=(pl(2,2)-pl(1,2))/(pl(2,1)-pl(1,1));
            bl=pl(1,2)-al*pl(1,1);
            fab(i)=al*midpnt(1)+bl;
        end
    else
        fad=zeros(1,size(pnlines2,2));
        for i=1:lnenr
            pl_i=round(size(pnlines2{i},1)/2);
            pl(1:2,1:2)=[pnlines2{i}(pl_i,1:2);pnlines2{i}(pl_i+1,1:2)];
            al=(pl(2,2)-pl(1,2))/(pl(2,1)-pl(1,1));
            bl=pl(1,2)-al*pl(1,1);
            fad(i)=al*midpnt(1)+bl;
        end
    end
else
    fab=zeros(1,size(pnlines,2));
    for i=1:lnenr
        pl_i=round(size(pnlines{i},1)/2);
        pl(1:2,1:2)=[pnlines{i}(pl_i,1:2);pnlines{i}(pl_i+1,1:2)];
        al=(pl(2,2)-pl(1,2))/(pl(2,1)-pl(1,1));
        bl=pl(1,2)-al*pl(1,1);
        fab(i)=al*midpnt(1)+bl;
    end
end

% For lines with more than 2 points calculates the point where each line
% of the other direction intersects the X axis
if mess_xy==1
    if mod(im_num,2)==1
        fad=zeros(1,size(pnlines2,2));
        for i=1:lnenc
            pl_i=round(size(pnlines2{i},1)/2);
            pl(1:2,1:2)=[pnlines2{i}(pl_i,1:2);pnlines2{i}(pl_i+1,1:2)];
            cl=(pl(2,2)-pl(1,2))\(pl(2,1)-pl(1,1));
            dl=pl(1,1)-cl*pl(1,2);
            fad(i)=cl*midpnt(2)+dl;
        end
    else
        fab=zeros(1,size(pnlines,2));
        for i=1:lnenc
            pl_i=round(size(pnlines{i},1)/2);
            pl(1:2,1:2)=[pnlines{i}(pl_i,1:2);pnlines{i}(pl_i+1,1:2)];
            cl=(pl(2,2)-pl(1,2))\(pl(2,1)-pl(1,1));
            dl=pl(1,1)-cl*pl(1,2);
            fab(i)=cl*midpnt(2)+dl;
        end
    end
else
    fad=zeros(1,size(pnlines2,2));
    for i=1:lnenc
        pl_i=round(size(pnlines2{i},1)/2);
        pl(1:2,1:2)=[pnlines2{i}(pl_i,1:2);pnlines2{i}(pl_i+1,1:2)];
        cl=(pl(2,2)-pl(1,2))\(pl(2,1)-pl(1,1));
        dl=pl(1,1)-cl*pl(1,2);
        fad(i)=cl*midpnt(2)+dl;
    end
end


% Sort lines according to the coords of the point of intersection
if mess_xy==1
    if mod(im_num,2)==1
        [fab,sib]=sort(fab,'descend');
        [fad,sid]=sort(fad);
    else
        [fab,sib]=sort(fab);
        [fad,sid]=sort(fad);
    end
else
    [fab,sib]=sort(fab,'descend');
    [fad,sid]=sort(fad);
end

% Set points' correspoinding row, column and number
mtrg=0;
rgm=0;
rws=size(pnlines,2)+size(gapsr,1)+2*(1-inv);
cls=size(pnlines2,2)+size(gapsc,1)+2*(1-inv);

for i=inv:size(fab,2)+1-inv
    cgm=0;
    for j=inv:size(fad,2)+1-inv
        kr=0;
        for k=1:size(pnlines{sib(i)},1)
            for l=1:size(pnlines2{sid(j)},1)
                if ~isempty(find(pnlines{sib(i)}(k,1)==...
                        pnlines2{sid(j)}(l,1),1))
                    kr=1;
                    break
                end
            end
            if kr==1
                break
            end
        end
        mtrg=mtrg+1;
        
        if kr==1
            t_1=i+1-inv+rgm;
            t_2=j+1-inv+cgm;
            impix(mtrg,1:6)=[M t_1 t_2 mtrg...
                pnlines{sib(i)}(k,2) pnlines{sib(i)}(k,1)];
        else
            impix(mtrg,1:6)=[0 0 j+1-inv+cgm 0 0 0];
        end
        if (j+1<size(pnlines2,2) && sid(j+1)<sid(j))
            if ~isempty(find(sid(j)==gapsc(:),1))
                mtrg=mtrg+1;
                impix(mtrg,1:6)=zeros(1,6);     
                cgm=cgm+1;
            end
        elseif (j+1<size(pnlines2,2) && sid(j+1)>sid(j))
            if ~isempty(find(sid(j+1)==gapsc(:),1))
                mtrg=mtrg+1;
                impix(mtrg,1:6)=zeros(1,6);
                cgm=cgm+1;
            end
        end
    end
    if (i+1<size(pnlines,2) && sib(i+1)<sib(i))
        if ~isempty(find(sib(i)==gapsr(:),1))
            mtrg=mtrg+1;
            impix(mtrg:mtrg+cls-1,1:6)=zeros(cls,6);
            mtrg=mtrg+cls-1;
            rgm=rgm+1;
        end
    elseif (i+1<size(pnlines,2) && sib(i+1)>sib(i))
        if ~isempty(find(sib(i+1)==gapsr(:),1))
            mtrg=mtrg+1;
            impix(mtrg:mtrg+cls-1,1:6)=zeros(cls,6);
            mtrg=mtrg+cls-1;
            rgm=rgm+1;
        end
    end
end     

% % Debug set 3 {Points on original image, Established Lines, Points used in
% % first solution}
% 
% % Plot all points
% figure(100+M)
% imshow(im),hold on
% % plot(xc(1,:),xc(2,:),'yo')
% plot(xc(1,:),xc(2,:),'oy','markerfacecolor','y','markersize',7)
% % saveas(gcf, [dir_n 'tifs\' sprintf('figure%i',100+M)], 'tiffn')
% % saveas(gcf, [dir_n 'figs\' sprintf('figure%i',100+M)], 'fig')
% % close(100+M)
% 
% % Plot full lines
% figure(1000+M)
% imshow(im),hold on
% % plot(xc(1,:),xc(2,:),'yo')
% for i=inv:size(fab,2)+1-inv
%     if ~isempty(pnlines{sib(i)})
%         plot(pnlines{sib(i)}(:,1),pnlines{sib(i)}(:,2),'r','LineWidth',2)
%     end
% end
% for i=inv:size(fad,2)+1-inv
%     if ~isempty(pnlines2{sid(i)})
%         plot(pnlines2{sid(i)}(:,1),pnlines2{sid(i)}(:,2),'r','LineWidth',2)
%     end
% end
% % plot(xc(1,:),xc(2,:),'oy','markerfacecolor','y','markersize',7)
% % saveas(gcf, [dir_n 'tifs\' sprintf('figure%i',1000+M)], 'tiffn')
% % saveas(gcf, [dir_n 'figs\' sprintf('figure%i',1000+M)], 'fig')
% % close(1000+M)
% 
% % Plot grid points
% figure(10000+M)
% imshow(im),hold on
% r_ind=ones(1,max(impix(:,2)));
% c_ind=ones(1,max(impix(:,3)));
% for i=1:size(impix,1)
%     if impix(i,5)~=0 || impix(i,6)~=0
%         xc_rows{impix(i,2)}(r_ind(impix(i,2)),1:2)=[impix(i,5);impix(i,6)];
%         r_ind(impix(i,2))=r_ind(impix(i,2))+1;
%         xc_cols{impix(i,3)}(c_ind(impix(i,3)),1:2)=[impix(i,5);impix(i,6)];
%         c_ind(impix(i,3))=c_ind(impix(i,3))+1;
%     end
% end
% for i=1:size(xc_rows,2)
% %     plot(xc_rows{i}(:,2),xc_rows{i}(:,1),'oy')
%     plot(xc_rows{i}(:,2),xc_rows{i}(:,1),'r','LineWidth',2)
%     plot(xc_rows{i}(:,2),xc_rows{i}(:,1),'oy','markerfacecolor','y','markersize',7)
% end
% for i=1:size(xc_cols,2)
% %     plot(xc_cols{i}(:,2),xc_cols{i}(:,1),'oy')
%     plot(xc_cols{i}(:,2),xc_cols{i}(:,1),'r','LineWidth',2)
%     plot(xc_cols{i}(:,2),xc_cols{i}(:,1),'oy','markerfacecolor','y','markersize',7)    
% end
% % saveas(gcf, [dir_n 'tifs\' sprintf('figure%i',10000+M)], 'tiffn')
% % saveas(gcf, [dir_n 'figs\' sprintf('figure%i',10000+M)], 'fig')    
% % close(10000+M)

warning on
clear inind lnen segs sw2 vals xcn xcn2 bpnt gnpnt sw3
clear csan(1,1) csan(2,1) csan(1,2) csan(2,2) cgpnt
clear f f1 ftm(1) ftm(2) ftm(3) i im_num