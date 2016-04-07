% TILEBASED
%   FAUCCAL supporting script. Called from
%   RELPNT function for finding grid's
%   principal directions based on  
%   color alternation between chessboard's
%   tiles


wdpr=6; % Search window size e.g. for wdpr=6 then window=1/3 of image size
        % Search window's center is the midpnt
poly(1,:)=[midpnt(1)-round(ims(1)/wdpr),midpnt(1)-round(ims(1)/wdpr),...
    midpnt(1)+round(ims(1)/wdpr),midpnt(1)+round(ims(1)/wdpr)];
poly(2,:)=[midpnt(2)-round(ims(2)/wdpr),midpnt(2)+round(ims(2)/wdpr),...
    midpnt(2)+round(ims(2)/wdpr),midpnt(2)-round(ims(2)/wdpr)];
clear wdpr

% Find Harris points inside search window
mtr=0;
for i=1:size(xc,2)
    if inpolygon(xc(1,i),xc(2,i),poly(1,:),poly(2,:))
        mtr=mtr+1;
        xc2(:,mtr)=xc(:,i);
    end
end
clear mtr poly

% Sort above points according to distance from image center
dfmip=zeros(size(xc2,2),1);
for i=1:size(xc2,2)
    dfmip(i)=norm([midpnt(1)-xc2(1,i);midpnt(2)-xc2(2,i)]);
end
[dfmip,si]=sort(dfmip);
% clear dfmip

n1=0;
epan=1;
end_krit=0;
ang=[0 0];
seg=[0 0];
fline=cell(1,2);
ind=zeros(1,2);
mtr=1;
while (epan<=size(si,1)/2 && end_krit==0)
    
    % Select point nearest to image center (if n1 doesn't change. See below)
    n1=n1+1;
    idip=si(n1);
    cgpnt(1)=xc2(1,idip);
    cgpnt(2)=xc2(2,idip);

    % Sort above points according to distance from point nearest to center
    dfm=zeros(size(xc2,2),1);
    for i=1:size(xc2,2)
        dfm(i)=norm([cgpnt(1)-xc2(1,i);cgpnt(2)-xc2(2,i)]);
    end
    [dfm,siloc]=sort(dfm);
    tile_sz=median(dfm(1:6));
    dkr=tile_sz/4;
    in_dkr=floor(dkr)/2;
    
    % Check pixels' values on both sides of a tile's
    % segment. If there is great change of brightness then
    % this segment corresponds to a principal direction
    ang_met=1;
    for i=1:6
        segmid(i,1:2)=[(xc2(1,idip)+xc2(1,siloc(i+1)))/2,(xc2(2,idip)+xc2(2,siloc(i+1)))/2];
        ind(mtr)=i;
        fline{1,i}=[xc2(1,idip),xc2(1,siloc(i+1));
            xc2(2,idip),xc2(2,siloc(i+1))];
        
        dx=xc2(1,siloc(i+1))-xc2(1,idip);
        dy=xc2(2,siloc(i+1))-xc2(2,idip);
        r_b=segmid(i,1:2);
        if abs(dx)>=abs(dy)
            dir(1,i)=dy/dx;
            divor=sqrt(1+dir(1,i)^2);
            r_sup(1,:)=dkr*[dir(1,i)/divor,-divor];
            r_sup(2,:)=dkr*[-dir(1,i)/divor,divor];
            r_par(1,:)=r_b+r_sup(1,:);
            r_par(2,:)=r_b+r_sup(2,:);
            m=1;
            for j=-in_dkr:in_dkr
                coll(1,m)=im(round(r_par(1,2)+j*dir(1,i)/divor),round(r_par(1,1)+j*divor));
                coll(2,m)=im(round(r_par(2,2)-j*dir(1,i)/divor),round(r_par(2,1)-j*divor));
                m=m+1;
            end
        else
            dir(2,i)=dx/dy;
            divor=sqrt(1+dir(2,i)^2);
            r_sup(1,:)=dkr*[divor,-dir(2,i)/divor];
            r_sup(2,:)=dkr*[-divor,dir(2,i)/divor];
            r_par(1,:)=r_b+r_sup(1,:);
            r_par(2,:)=r_b+r_sup(2,:);
            m=1;
            for j=-in_dkr:in_dkr
                coll(1,m)=im(round(r_par(1,2)+j/divor),round(r_par(1,1)+j*dir(2,i)/divor));
                coll(2,m)=im(round(r_par(2,2)-j/divor),round(r_par(2,1)-j*dir(2,i)/divor));
                m=m+1;
            end
        end
        krit=abs(mean(coll(1,:))-mean(coll(2,:)));
        if krit>2*contrast
            mtr=mtr+1;
            if dir(1,i)~=0
                ang(ang_met)=atan(dir(1,i));
                seg(ang_met)=norm([dx,dy]);
                ang_met=ang_met+1;
            else
                ang(ang_met)=acot(dir(2,i));
                seg(ang_met)=norm([dx,dy]);
                ang_met=ang_met+1;
            end
            if ang(1)<0
                while ang(1)<0
                    ang(1)=ang(1)+2*pi;
                end
            elseif ang(1)>2*pi
                while ang(1)>2*pi
                    ang(1)=ang(1)-2*pi;
                end
            end
            if ang(2)<0
                while ang(2)<0
                    ang(2)=ang(2)+2*pi;
                end
            elseif ang(2)>2*pi
                while ang(2)>2*pi
                    ang(2)=ang(2)-2*pi;
                end
            end
            if (ang_met>2 && ((abs(ang(2)-ang(1))<pi/18 || abs(ang(2)-ang(1))>(35*pi)/18) || (abs(ang(2)-ang(1))<(19*pi)/18) && abs(ang(2)-ang(1))>(17*pi)/18))
                ang_met=ang_met-1;
                mtr=mtr-1;
            else
%                 plot(segmid(i,1),segmid(i,2),'+c')
            end
        end
        if ang_met>2
            end_krit=1;
            break
        end
    end
end
clear si n1
        


% Sets as direction X of Geodetic system as the direction of the above
% lines which tangant is less or equal to 1 according to the image
% coordinate system
if ((ang(1)>pi/4 && ang(1)<3*pi/4) ||...
        (ang(1)>5*pi/4 && ang(1)<7*pi/4))
    ang1=ang(2);
    ang2=ang(1);
    % Calculate segment lengths for each direction (see below)
    f(1)=seg(2);
    f(2)=f(1);
    f(3)=seg(1);
    f(4)=f(3);
    sw00=0;
else
    ang1=ang(1);
    ang2=ang(2);
    % Same as above
    f(1)=seg(1);
    f(2)=f(1);
    f(3)=seg(2);
    f(4)=f(3);
    sw00=1;
end

% % Debug set 2 {Plot established principle directions}
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(300+M)
% imshow(im)
% hold on
% plot(xc(1,:),xc(2,:),'yo')
% if sw00==0
% % Plot principal direction lines
% plot(fline{1,ind(2)}(1,:),fline{1,ind(2)}(2,:),'c','LineWidth',2)
% plot(fline{1,ind(1)}(1,:),fline{1,ind(1)}(2,:),'m','LineWidth',2)
% else
% % Same as above
% plot(fline{1,ind(1)}(1,:),fline{1,ind(1)}(2,:),'c','LineWidth',2)
% plot(fline{1,ind(2)}(1,:),fline{1,ind(2)}(2,:),'m','LineWidth',2)
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
clear tmpf fline fang anind bpnt xcn gnpnt
