% PNTBASED
%   FAUCCAL supporting script. Called from
%   RELPNT function for finding grid's
%   principal directions based on the 
%   assumption that the biggest side of
%   a given tile is always a diagonal

fline=[];   % Lines constructed from detected points
n1=1;      
ftk=.17;    % Factor that determins angle difference threshold
wdfc=3.5;   % Factor that determins search window size
lenfc=2;    % Factor that determins line segment thresholds
fctln=3;    % Factor that determins minimum point number in line
mt1a=0; 
mt1b=0;
mt2a=0;
mt2b=0;
mt3=1;
sbs=0;
while size(fline,2)~=4 
    clear fang seglen
    seglen=[];
    mt1a=mt1a+1;
    mt1b=mt1b+1;
    
    wdpr=6; % Search window size e.g. for wdpr=6 then window=1/3 of image size
    % Search window's center is the image center
    poly(1,:)=[midpnt(1)-round(ims(1)/wdpr),midpnt(1)-round(ims(1)/wdpr),...
        midpnt(1)+round(ims(1)/wdpr),midpnt(1)+round(ims(1)/wdpr)];
    poly(2,:)=[midpnt(2)-round(ims(2)/wdpr),midpnt(2)+round(ims(2)/wdpr),...
        midpnt(2)+round(ims(2)/wdpr),midpnt(2)-round(ims(2)/wdpr)];
    
    % Find Harris points inside search window
    mtr=0;
    for i=1:size(xc,2)
        if inpolygon(xc(1,i),xc(2,i),poly(1,:),poly(2,:))
            mtr=mtr+1;
            xc2(:,mtr)=xc(:,i);
        end
    end
    
    % Sort above points according to distance from image center
    dfmip=zeros(size(xc2,2),1);
    for i=1:size(xc2,2)
        dfmip(i)=norm([midpnt(1)-xc2(1,i);midpnt(2)-xc2(2,i)]);
    end
    
    [dfmip,si]=sort(dfmip);
    
    % Select point nearest to image center (if n1 doesn't change. See below)
    idip=si(n1);
    pnt1(1)=xc2(1,idip);
    pnt1(2)=xc2(2,idip);
    cgpnt(1)=pnt1(1);
    cgpnt(2)=pnt1(2);
    clear si
    
    % Sort above points according to distance from point nearest to center
    dfm=zeros(size(xc2,2),1);
    for i=1:size(xc2,2)
        dfm(i)=norm([pnt1(1)-xc2(1,i);pnt1(2)-xc2(2,i)]);
    end

    [dfm]=sort(dfm);

    if ~isempty(dfm)
        if size(dfm,1)>7
            f1=median(dfm(2:7)); % Estimation of chess tile side length
        else
            f1=median(dfm(1:end));
        end
    else
        break
    end
    
    % New search window based on tile side ('segment') length
    wdpr=ims(1)/(f1*wdfc);
    poly(1,:)=[midpnt(1)-round(ims(1)/wdpr),midpnt(1)-round(ims(1)/wdpr),...
        midpnt(1)+round(ims(1)/wdpr),midpnt(1)+round(ims(1)/wdpr)];
    poly(2,:)=[midpnt(2)-round(ims(2)/wdpr),midpnt(2)+round(ims(2)/wdpr),...
        midpnt(2)+round(ims(2)/wdpr),midpnt(2)-round(ims(2)/wdpr)];
    clear xc2 dfm si
    
    % Find Harris points inside new window and sort according to 
    % distance from point nearest to center
    mtr=0;
    for i=1:size(xc,2)
        if inpolygon(xc(1,i),xc(2,i),poly(1,:),poly(2,:))
            mtr=mtr+1;
            xc2(:,mtr)=xc(:,i);
        end
    end

    for i=1:size(xc2,2)
        dfm(i)=norm([pnt1(1)-xc2(1,i);pnt1(2)-xc2(2,i)]);
    end
    [dfm,si]=sort(dfm);

    % Test all points in order if belong to an existing line or define
    % a new, based on angle factor specified in the begining of the loop and
    % then procesed by the conditions described below
    mtr=0;
    ang=[];
    for i=1:size(xc2,2)-1
        if (abs(xc2(2,si(i+1))-pnt1(2))<=abs(xc2(1,si(i+1))-pnt1(1)) && abs(xc2(2,si(i+1))-pnt1(2))>eps)
            para=(xc2(2,si(i+1))-pnt1(2))/(xc2(1,si(i+1))-pnt1(1));
            if isempty(ang)
                mtr=mtr+1;
                ang(mtr)=atan(para);
                line{mtr}=xc2(:,si(i+1));
            else
                apa=atan(para);
                S=norm([xc2(2,si(i+1))-pnt1(2);xc2(1,si(i+1))-pnt1(1)]);
                tk=atan(ftk*f1/S);
                krt1=abs(apa-ang(:))<tk;
                krt2=(abs(apa-ang(:))<pi+tk & abs(apa-ang(:))>pi-tk);
                if (isempty(krt1(krt1>0)) && isempty(krt2(krt2>0)))
                    mtr=mtr+1;
                    ang(mtr)=apa;
                    line{mtr}=xc2(:,si(i+1));
                else
                    if isempty(krt2(krt2>0))
                        anind=find(krt1>0,1);
                    elseif isempty(krt1(krt1>0))
                        anind=find(krt2>0,1);
                    else
                        anind=min(find(krt1>0,1),find(krt2>0));
                    end
                    in2=size(line{anind}(:,:),2)+1;
                    line{anind}(:,in2)=xc2(:,si(i+1));
                end
            end
        % elseif used for lines which have direction tangent greater than 1
        elseif (abs(xc2(2,si(i+1))-pnt1(2))>abs(xc2(1,si(i+1))-pnt1(1)) && abs(xc2(1,si(i+1))-pnt1(1))>eps)
            parc=(xc2(2,si(i+1))-pnt1(2))\(xc2(1,si(i+1))-pnt1(1));
            if isempty(ang)
                mtr=mtr+1;
                ang(mtr)=acot(parc);
                line{mtr}=xc2(:,si(i+1));
            else
                apc=acot(parc);
                S=norm([xc2(2,si(i+1))-pnt1(2);xc2(1,si(i+1))-pnt1(1)]);
                tk=atan(ftk*f1/S);
                krt1=abs(apc-ang(:))<tk;
                krt2=(abs(apc-ang(:))<pi+tk & abs(apc-ang(:))>pi-tk);
                if (isempty(krt1(krt1>0)) && isempty(krt2(krt2>0)))
                    mtr=mtr+1;
                    ang(mtr)=apc;
                    line{mtr}=xc2(:,si(i+1));
                else
                    if isempty(krt2(krt2>0))
                        anind=find(krt1>0,1);
                    elseif isempty(krt1(krt1>0))
                        anind=find(krt2>0,1);
                    else
                        anind=min(find(krt1>0,1),find(krt2>0));
                    end
                    in2=size(line{anind}(:,:),2)+1;
                    line{anind}(:,in2)=xc2(:,si(i+1));
                end
            end
        end
    end
    clear S tk apa apc in2 krt1 krt2 para parc
    
    % Keep only lines which have sufficient points and 
    % segment length inside the threshold as specified
    % by the relative factors.
    % In addition keeps only the first segments on each side of the
    % above lines.
    mtr2=0;
    for i=1:size(line,2)
         tmplen=norm([line{1,i}(1,1)-pnt1(1);line{1,i}(2,1)-pnt1(2)]);
        if (size(line{1,i},2)>fctln && tmplen<lenfc*f1)
            mtr2=mtr2+1;
            fline{mtr2}=[line{1,i}(:,1) pnt1(:) line{1,i}(:,2)];
            if ang(i)>pi
                fang(mtr2)=ang(i)-pi;
            elseif ang(i)<0
                fang(mtr2)=ang(i)+pi;
            else
                fang(mtr2)=ang(i);
            end
            seglen(mtr2)=tmplen;
        end
    end
    clear ang line tmplen
    
    % Find segment with maximum length which corresponds to one diagonal
    % of chess patern tile
    if ~isempty(seglen)
        inm=find(seglen==max(seglen),1);
    elseif (isempty(seglen) && mt3<=5 && n1<size(dfmip,2))
        % if zero lines detected change initial point and set all factors
        % to initial values
        fline=[];
        n1=n1+1;
        ftk=.17; 
        wdfc=3.5; 
        lenfc=2;    
        fctln=3;   
        mt3=mt3+1;
        continue
    else
        % if for 5 times zero lines are detected then go to sobel based
        % search
        sbs=1;
        break
    end
    
    % Decide the termination of the loop or change of factors
    % based on the number of lines finaly accepted
    if size(fline,2)<4
        if size(fline,2)<2  % if only 2 line change base point or 
            if n1<size(dfmip,2) % if no other point then go to sobel based 
                % search
                
                n1=n1+1;
            else
                % As previous break
                sbs=1;
                break
            end
        else    % if lines less than 4 and more than one
            if (mt1a>5 && n1<size(dfmip,2)) 
                % every 5 iterations
                n1=n1+1;    % change base point
                wdfc=3.5;   % use initial factors
                ftk=.17;
                mt1a=0;
                mt1b=mt1b+1;
            elseif (mt1b>75)
                % after 5*75 iterations exit
                % As previous break
                sbs=1;
                break
            else
                % use larger window but simultaneously make angle threshold
                % narrower
                if  (wdfc*f1<ims(1) && ftk>0)
                    wdfc=wdfc+.05;
                    ftk=ftk-0.005;
                else
                    % As previous break
                    sbs=1;
                    break
                end
            end
        end
    elseif size(fline,2)>4  
        % if more lines than 4
        if (mt2a>7 && n1<size(dfmip,2) && mt2b<=4)
            % every 7 iterations 
            n1=n1+1;    % change base point
            fctln=3;    % use initial factors
            lenfc=2;
            ftk=.17;
            mt2a=0;
            mt2b=mt2b+1;
        elseif (mt2b>35)
            % after 7*35 iterations exit
            % As previous break
            sbs=1;
            break
        else
            if (ftk>0 && lenfc>1 && fctln<10)
                fctln=fctln+floor(mt2a/7);  % increase minimum points in line threshold                
                lenfc=lenfc-.03;    % decrease segment length threshold
                ftk=ftk-.005;       % use narrower angle threshold
            else
                % As previous break
                sbs=1;
                break
            end
        end
        clear fline fang2
        fline=[];
    end
end
clear mt1a mt1b mt2a mt2b mtr mtr2 dfmip epan
clear fctln ftk lenfc wdfc ims poly seglen wdpr dfm

if isempty(fline)
    errordlg('No lines detected','Error')
    return
elseif size(fline,2)<4
    errordlg('Not enough lines detected','Error')
    return
end

fin=0;
mtr=1;
if sbs==0
    % Accepted initial point
    idip=si(n1);
    pnt1(1)=xc2(1,idip);
    pnt1(2)=xc2(2,idip);

    % Sort lines in accending order based on angle to the X axis
    % (left-handed coordinate system!)
    [fang2,si2]=sort(fang);
    ind(3)=find(si2==inm);

    % Find lines which define principal directions as the
    % next and previous lines (in order of ascending angle
    % to axis X) from the diagonal
    if ind(3)==size(fang,2)
        ind(1)=si2(ind(3)-1);
        ind(2)=si2(1);
    elseif ind(3)==1
        ind(1)=si2(size(fang,2));
        ind(2)=si2(ind(3)+1);
    else
        ind(1)=si2(ind(3)-1);
        ind(2)=si2(ind(3)+1);
    end
end

% % Shows longest segment in magenta and other in yellow
% for i=1:size(fline,2)
%     if i==ind(3)
%         plot(fline{1,i}(1,:),fline{1,i}(2,:),'m')
%     else
%         plot(fline{1,i}(1,:),fline{1,i}(2,:),'y')
%     end
% end

% % Shows two principal directions
% for i=1:size(fline,2)
%     if i==ind(1)
%         plot(fline{1,i}(1,:),fline{1,i}(2,:),'m')
%     elseif i==ind(2)
%         plot(fline{1,i}(1,:),fline{1,i}(2,:),'g')
%     end
% end
% clear fang2 inm si2 xc2

% Sets as direction X of Geodetic system as the direction of the above
% lines which tangant is less or equal to 1 according to the image
% coordinate system
if ((fang(ind(1))>pi/4 && fang(ind(1))<3*pi/4) ||...
        (fang(ind(1))>5*pi/4 && fang(ind(1))<7*pi/4))
    ang1=fang(ind(2));
    ang2=fang(ind(1));
    dif1=fline{1,ind(2)}(:,1)-fline{1,ind(2)}(:,2);
    dif2=fline{1,ind(1)}(:,1)-fline{1,ind(1)}(:,2);
    % Calculate segment lengths for each direction (see below) 
    if dif1(1)>=0
         f(1)=norm(dif1);
         f(2)=norm(fline{1,ind(2)}(:,2)-fline{1,ind(2)}(:,3));
    else
         f(2)=norm(dif1);
         f(1)=norm(fline{1,ind(2)}(:,2)-fline{1,ind(2)}(:,3));
    end
    if dif2(1)>=0
         f(3)=norm(dif2);
         f(4)=norm(fline{1,ind(1)}(:,2)-fline{1,ind(1)}(:,3));
    else
         f(4)=norm(dif2);
         f(3)=norm(fline{1,ind(1)}(:,2)-fline{1,ind(1)}(:,3));
    end
%     % Plot principal direction lines    
%     plot(fline{1,ind(2)}(1,:),fline{1,ind(2)}(2,:),'c')
%     plot(fline{1,ind(1)}(1,:),fline{1,ind(1)}(2,:),'m')
else
    ang1=fang(ind(1));
    ang2=fang(ind(2));
    dif1=fline{1,ind(1)}(:,1)-fline{1,ind(1)}(:,2);
    dif2=fline{1,ind(2)}(:,1)-fline{1,ind(2)}(:,2);
    % Same as above
    if dif1(1)>=0
         f(1)=norm(dif1);
         f(2)=norm(fline{1,ind(1)}(:,2)-fline{1,ind(1)}(:,3));
    else
         f(2)=norm(dif1);
         f(1)=norm(fline{1,ind(1)}(:,2)-fline{1,ind(1)}(:,3));
    end
    if dif2(1)>=0
         f(3)=norm(dif2);
         f(4)=norm(fline{1,ind(2)}(:,2)-fline{1,ind(2)}(:,3));
    else
         f(4)=norm(dif2);
         f(3)=norm(fline{1,ind(2)}(:,2)-fline{1,ind(2)}(:,3));
    end
%     % Same as above
%     plot(fline{1,ind(1)}(1,:),fline{1,ind(1)}(2,:),'c')
%     plot(fline{1,ind(2)}(1,:),fline{1,ind(2)}(2,:),'m')
end

% Sets the segments lengths for each side on the principal directions
% for the central point
if (ang1>pi/2 && ang1<3*pi/2)
    tmpf=f(2);
    f(2)=f(1);
    f(1)=tmpf;
end
if (ang2>0 && ang2<pi)
    tmpf=f(4);
    f(4)=f(3);
    f(3)=tmpf;
end
clear tmpf fline fang anind
