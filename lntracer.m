function [pnlines gmt gaps lnen]=lntracer(bpnt,xc,ang1,ang2,ftm,pnlines_t,gmt,gaps,lnen,dirc)

% LNTRACER
%   FAUCCAL supporting function that is used to trace
%   the lines that correspond to grid's rows and
%   columns

ang1_l=ang1;
bpnt_bak=bpnt;
vals=[-1 1];
swtch=1;
sw2=0;
elen=0;
gaps=[];
if dirc>=3
    ss=2;
else
    ss=1;
end
while swtch==1
    csan=angnum(ang1_l,ang2);
    % Call of line seeking function
    [pnlines_t{lnen}]=seekline(bpnt,csan(1,2),csan(1,1),ftm(1),ftm(2),xc,ss);
    
    % If a line is returned seek the next line's base point an readjust
    % the segment length for the corresponding direction. If no lines are
    % returned try to find a next lines point as a base point
    if ~isempty(pnlines_t{lnen})
        dx=pnlines_t{lnen}(end,1)-pnlines_t{lnen}(1,1);
        dy=pnlines_t{lnen}(end,2)-pnlines_t{lnen}(1,2);
        if dx>=dy
            ang1_l=atan(dy/dx);
        else
            ang1_l=acot(dx/dy);
        end
        inind=round(size(pnlines_t{lnen},1)/2);
        bpnt(:)=pnlines_t{lnen}(inind,:); % return base point to the point
        % from where the seekline algorithn has started
        
        gnpnt(1)=csan(2,2)*ftm(3)+bpnt(1);
        gnpnt(2)=csan(2,1)*ftm(3)+bpnt(2);% New point's position estimation

        % Call of seekpnt algorithm to find if a point detected by
        % Harris exist near the position estimated
        [xcn2]=seekpnt(gnpnt,ftm(3),xc);
        % Same for the other side of the same direction
        gnpnt(1)=-csan(2,2)*ftm(3)+bpnt(1);
        gnpnt(2)=-csan(2,1)*ftm(3)+bpnt(2);
        [xcn2(:,2)]=seekpnt(gnpnt,ftm(3),xc);
        % Readjustment of segment length
        if length(xcn2(xcn2>0))>2
            segs=zeros(2,1);
            for i=1:2
                segs(i)=norm([xcn2(1,i)-bpnt(1);xcn2(2,i)-bpnt(2)]);
            end
            ftm(3)=(2*segs(1)+segs(2))/3;
        end
        if rem(dirc,2)==1
            xcn=xcn2(:,1);
        elseif rem(dirc,2)==0
            xcn=xcn2(:,2);
        end
        sw3=0;
    else
        elen=elen+1;
        % Estimate a point position of the next line and search for this
        % point
        inind=round(size(pnlines_t{lnen-1},1)/2);
        bpnt(:)=pnlines_t{lnen-1}(inind,:);
        gnpnt(1)=((-1)^(dirc+1))*2*csan(2,2)*ftm(3)+bpnt(1);
        gnpnt(2)=((-1)^(dirc+1))*2*csan(2,1)*ftm(3)+bpnt(2);
        [xcn2(:,2)]=seekpnt(gnpnt,ftm(3),xc);
        if rem(dirc,2)==1
            xcn=xcn2(:,1);
        elseif rem(dirc,2)==0
            xcn=xcn2(:,2);
        end
        sw3=1;
        lnen=lnen-1;
    end
    
    % If a point is found set this point as a base point and continue loop
    if length(xcn(xcn>0))>0 && elen<2
        if sw3==1 
            gaps_t(gmt)=lnen+1;
            gmt=gmt+1;
        end
        bpnt(:)=xcn(:,1);
        lnen=lnen+1;
    elseif elen>=2
        gmt=gmt-1;
        gaps_t(gmt)=0;
        lnen=lnen-1;
        swtch=0;
    else
        % If not try for 2 times to find if there are any other points
        % on the same direction and if not exit loop
        while (isempty(xcn(xcn>0)) && sw2<2)
            sw2=sw2+1;
            if lnen>1
                if size(pnlines_t{lnen},1)>2
                    bpnt(:)=pnlines_t{lnen}(inind+vals(sw2),:);
                    gnpnt(1)=((-1)^(dirc+1))*(1+sw3)*csan(2,2)*ftm(3)+bpnt(1);
                    gnpnt(2)=((-1)^(dirc+1))*(1+sw3)*csan(2,1)*ftm(3)+bpnt(2);
                    [xcn]=seekpnt(gnpnt,ftm(3),xc);
                end
            else
                bpnt=bpnt_bak;
                gnpnt(1)=((-1)^(dirc+1))*(1+sw3)*csan(2,2)*ftm(3)+bpnt(1);
                gnpnt(2)=((-1)^(dirc+1))*(1+sw3)*csan(2,1)*ftm(3)+bpnt(2);
                [xcn]=seekpnt(gnpnt,ftm(3),xc);
            end
            if (isempty(xcn(xcn>0)) && sw2==2 && sw3==0);
                sw2=0;
                sw3=1;
            end
        end
        if isempty(xcn(xcn>0))
            swtch=0;
        else
            if sw3==1
                gaps_t(gmt)=lnen+1;
                gmt=gmt+1;
            end
            bpnt(:)=xcn(:,1);
            lnen=lnen+1;
        end
    end
end
mtr1=1;
mtr2=1;
for i=1:size(pnlines_t,2)
    if ~isempty(pnlines_t{i})
        pnlines{mtr1}=pnlines_t{i};
        mtr1=mtr1+1;
    end
end
if ~isempty(gaps)
    for i=1:size(gaps_t,2)
        if gaps_t(i)~=0
            gaps(mtr2)=gaps_t(i);
            mtr2=mtr2+1;
        end
    end
end
lnen=size(pnlines,2);
clear sw3