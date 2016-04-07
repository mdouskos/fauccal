function [pnlines]=seekline(bpnt,cang1,sang1,fa1,fa2,xc,ss)

% SEEKLINE
%   FAUCCAL supporting function for tracing a line

% Estimate next line's point position
gnpnt(1)=cang1*fa1+bpnt(1);
gnpnt(2)=sang1*fa1+bpnt(2);
cbr1=0;
pnen=2;
pnlines=bpnt;
efan=nan;
sfan=nan;
while cbr1<3
    clear xcn2
    % Call line for tracing point
    [xcn]=seekpnt(gnpnt,fa1,xc);

    [xcn2]=xcn;
    
    % Seek point on opposite direction for later
    % segment length recalculation
    gnpnt(1)=-cang1*fa2+bpnt(1);
    gnpnt(2)=-sang1*fa2+bpnt(2);
    [xcn2(:,2)]=seekpnt(gnpnt,fa2,xc);
    if length(xcn2(xcn2>0))>2
        segs=zeros(2,1);
        for i=1:2
            segs(i)=norm([xcn2(1,i)-bpnt(1);xcn2(2,i)-bpnt(2)]);
        end
        fa1_t=(2*segs(1)+segs(2))/3;
        if (~(fa1_t/fa1>1.5) && ~(fa1_t/fa1<0.68))
            fa1=fa1_t;
        end           
    end
    xcn=xcn2(:,1);
    
    % Calculate angle difference between two sequent
    % segments
    if ss==1
        efn=(xcn(2,1)-bpnt(2))/(xcn(1,1)-bpnt(1));
        ang_dif=abs(abs(atan(efn))-abs(atan(efan)));
    else
        sfn=(xcn(2,1)-bpnt(2))\(xcn(1,1)-bpnt(1));
        ang_dif=abs(abs(acot(sfn))-abs(acot(sfan)));
    end

    % Test if above segments are collinear
    if (length(xcn(xcn>0))>0 && ((ss==1 && (ang_dif<0.03 || isnan(efan)))...
            || (ss==2 && (ang_dif<0.03 || isnan(sfan)))))
        if ss==1
            efan=efn;
        else
            sfan=sfn;
        end
        pnlines(pnen,:)=[xcn(1,1) xcn(2,1)];
        % Make new point a base point and estimate next line's
        % point position
        bpnt(:)=xcn(:,1);
        gnpnt(1)=cang1*fa1+bpnt(1);
        gnpnt(2)=sang1*fa1+bpnt(2);
        cbr1=0;
        pnen=pnen+1;
    else
        cbr1=cbr1+1;
        gnpnt(1)=cang1*(1+cbr1)*fa1+bpnt(1);
        gnpnt(2)=sang1*(1+cbr1)*fa1+bpnt(2);        
    end
end

efan=nan;
sfan=nan;
cbr1=0;
fa1=fa2;
if ~isempty(pnlines)
    bpnt(:)=pnlines(1,:);
end
gnpnt(1)=-cang1*fa2+bpnt(1);
gnpnt(2)=-sang1*fa2+bpnt(2);

% Same proceedure as above for the other half line
while cbr1<3
    clear xcn2
    [xcn]=seekpnt(gnpnt,fa2,xc);
    
    [xcn2]=xcn;
    gnpnt(1)=cang1*fa1+bpnt(1);
    gnpnt(2)=sang1*fa1+bpnt(2);
    [xcn2(:,2)]=seekpnt(gnpnt,fa1,xc);
    if length(xcn2(xcn2>0))>2
        for i=1:2
            segs(i)=norm([xcn2(1,i)-bpnt(1);xcn2(2,i)-bpnt(2)]);
        end
        fa2_t=(2*segs(1)+segs(2))/3;
        if (~(fa2_t/fa2>1.5) && ~(fa2_t/fa2<0.68))
            fa2=fa2_t;
        end           
        
    end
    xcn=xcn2(:,1);
    if ss==1
        efn=(xcn(2,1)-bpnt(2))/(xcn(1,1)-bpnt(1));
        ang_dif=abs(abs(atan(efn))-abs(atan(efan)));
    else
        sfn=(xcn(2,1)-bpnt(2))\(xcn(1,1)-bpnt(1));
        ang_dif=abs(abs(acot(sfn))-abs(acot(sfan)));
    end

   
    if (length(xcn(xcn>0))>0 && ((ss==1 && (ang_dif<0.03 || isnan(efan)))...
            || (ss==2 && (ang_dif<0.03 || isnan(sfan)))))
        if ss==1
            efan=efn;
        else
            sfan=sfn;
        end
        pnlines(pnen,:)=[xcn(1,1) xcn(2,1)];
        bpnt(:)=xcn(:,1);
        gnpnt(1)=-cang1*fa2+bpnt(1);
        gnpnt(2)=-sang1*fa2+bpnt(2);
        cbr1=0;
        pnen=pnen+1;
    else
        cbr1=cbr1+1;
        gnpnt(1)=-cang1*(1+cbr1)*fa2+bpnt(1);
        gnpnt(2)=-sang1*(1+cbr1)*fa2+bpnt(2);        
    end
end

if size(pnlines,1)<4
    pnlines=[];
end

% Sort line's points in ascending(descending) order
if ~isempty(pnlines)
    [srt,srtind]=sort(pnlines(:,ss));
    for k=1:size(pnlines(:,ss))
        pnlntmp(k,:)=[pnlines(srtind(k),1) pnlines(srtind(k),2)];
    end
    pnlines(:,:)=pnlntmp;
end