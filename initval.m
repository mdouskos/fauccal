% INITVAL
%   FAUCCAL supporting script for the calculation
%   of initial values for the bundle adjustment


% Image coordinates for points (in pixels)
l=0;
mtr=1;
sz(1:size(impts,2))=0;
for i=1:size(impts,2)
    sz(i)=size(impts{i},1);
    j=1;
    while (j<=size(impts{i},1))
        if impts{i}(j,1)~=0
            impoint00(mtr,:)=impts{i}(j,:);
            mtr=mtr+1;
        end
        j=j+1;
    end
end
N=max(sz);
clear sz

% Camera constant c initial values (in pixels)\
c(1:M)=0;
if (~isempty(xv(isfinite(xv(:,2)))) && ~isempty(xv(isfinite(xv(:,1)))))
    for i=1:M
        if (isfinite(xv(i,2)) && isfinite(xv(i,1)))
            c(i)=sqrt(abs(-xv(i,1)*xv(i,2)-yv(i,1)*yv(i,2)));
        else
            c(i)=0;
        end
    end
else
    for i=1:M
        if (isfinite(xv(i,3)) && isfinite(xv(i,4)))
            c(i)=sqrt(abs(-xv(i,3)*xv(i,4)-yv(i,3)*yv(i,4)));
        else
            c(i)=0;
        end
    end
end
for i=1:M
    if c(i)==0
        c(i)=median(c(c~=0));
    end
end

% Choose best value for parameter c
if ~isempty(sigc(isfinite(sigc)))
    indc=find((sigc==min(sigc)),1);
    intriv=zeros(1,8);
    intriv(1,1)=c(indc);
    intriv(1,2)=1;
else
    intriv=zeros(1,8);
    intriv(1,1)=sum(c(1,:))/size(c,2);
    intriv(1,2)=1;
end

% Radial distortion initial values
if ip>=5
    knz=kiv(kiv~=0);
    if ~isempty(knz)
        if sw33==0
            kiv=reshape(knz,size(knz,1)/2,2);
        end
        intriv(5)=mean(kiv(:,1));
        intriv(6)=mean(kiv(:,2));
    end
end


x(1:M,1:4)=0;
y(1:M,1:4)=0;
extriv(1:M,1:7)=0;
% Rotations initial values (rad)
for i=1:M
    lnn1=0;
    m=0;
    if (isfinite(xv(i,1)) && isfinite(xv(i,2)))
        extriv(i,1)=i;
        while size(lnn1,1)<2
            m=m+1;
            lnn1=impts{i}(impts{i}(:,2)==m,5);
            lnn2=impts{i}(impts{i}(:,2)==m,6);
            lnn3=impts{i}(impts{i}(:,2)==m,4);
        end
        if lnn1(end)>lnn1(1)
            extriv(i,7)=atan(-yv(i,1)/xv(i,1));
        else
            extriv(i,7)=atan(-yv(i,1)/xv(i,1))+pi;
        end
        extriv(i,6)=atan(c(i)/(yv(i,1)*sin(extriv(i,7))-xv(i,1)*cos(extriv(i,7))));
        extriv(i,5)=atan(c(i)/(cos(extriv(i,6))*(xv(i,2)*sin(extriv(i,7))+yv(i,2)*cos(extriv(i,7)))));
        x(i,1)=lnn1(1);
        y(i,1)=lnn2(1);
        x(i,2)=lnn1(end);
        y(i,2)=lnn2(end);
        x(i,3)=lnn3(1);
        y(i,3)=x(i,3);
        x(i,4)=lnn3(end);
        y(i,4)=x(i,4);
    elseif (isfinite(xv(i,1)) && ~isfinite(xv(i,2)))
        extriv(i,1)=i;
        while size(lnn1,1)<2
            m=m+1;
            lnn1=impts{i}(impts{i}(:,2)==m,5);
            lnn2=impts{i}(impts{i}(:,2)==m,6);
            lnn3=impts{i}(impts{i}(:,2)==m,4);
        end
        if lnn1(end)>lnn1(1)
            extriv(i,7)=atan(-yv(i,1)/xv(i,1));
        else
            extriv(i,7)=atan(-yv(i,1)/xv(i,1))+pi;
        end
        extriv(i,6)=atan(c(i)*sin(extriv(i,7))/yv(i,1));
        extriv(i,5)=0;
        x(i,1)=lnn1(1);
        y(i,1)=lnn2(1);
        x(i,2)=lnn1(end);
        y(i,2)=lnn2(end);
        x(i,3)=lnn3(1);
        y(i,3)=x(i,3);
        x(i,4)=lnn3(end);
        y(i,4)=x(i,4);
    elseif (~isfinite(xv(i,1)) && isfinite(xv(i,2)))
        extriv(i,1)=i;
        while size(lnn1,1)<2
            m=m+1;
            lnn1=impts{i}(impts{i}(:,2)==m,5);
            lnn2=impts{i}(impts{i}(:,2)==m,6);
            lnn3=impts{i}(impts{i}(:,2)==m,4);
        end
        if lnn1(end)>lnn1(1)
            extriv(i,7)=atan(xv(i,2)/yv(i,2));
        else
            extriv(i,7)=atan(xv(i,2)/yv(i,2))+pi;
        end
        extriv(i,5)=atan(c(i)*cos(extriv(i,7))/yv(i,2));
        extriv(i,6)=0;
        x(i,1)=lnn1(1);
        y(i,1)=lnn2(1);
        x(i,2)=lnn1(end);
        y(i,2)=lnn2(end);
        x(i,3)=lnn3(1);
        y(i,3)=x(i,3);
        x(i,4)=lnn3(end);
        y(i,4)=x(i,4);
    else
        extriv(i,1)=i;
        while size(lnn1,1)<2
            m=m+1;
            lnn1=impts{i}(impts{i}(:,2)==m,5);
            lnn2=impts{i}(impts{i}(:,2)==m,6);
            lnn3=impts{i}(impts{i}(:,2)==m,4);
        end
        if abs(lnn1(end)-lnn1(1))>=abs(lnn2(end)-lnn2(end))
            if lnn1(end)>lnn1(1)
                extriv(i,7)=atan((lnn2(end)-lnn2(1))/(lnn1(end)-lnn1(1)));
            else
                extriv(i,7)=atan((lnn2(end)-lnn2(1))/(lnn1(end)-lnn1(1)))+pi;
            end
        else
            if lnn1(end)>lnn1(1)
                extriv(i,7)=pi/2-atan((lnn2(end)-lnn2(1))\(lnn1(end)-lnn1(1)));
            else
                extriv(i,7)=pi/2-atan((lnn2(end)-lnn2(1))\(lnn1(end)-lnn1(1)))+pi;
            end
        end
        extriv(i,6)=0;
        extriv(i,5)=0;
        x(i,1)=lnn1(1);
        y(i,1)=lnn2(1);
        x(i,2)=lnn1(end);
        y(i,2)=lnn2(end);
        x(i,3)=lnn3(1);
        y(i,3)=x(i,3);
        x(i,4)=lnn3(end);
        y(i,4)=x(i,4);
    end
end
clear lnn1 lnn2 lnn3 

S=1;

% Xo, Yo, Zo initial values (meters)
R=zeros(3,3,M);
f=zeros(3,3,M);
for i=1:M
    cosw=cos(extriv(i,5));
    sinw=sin(extriv(i,5));
    cosf=cos(extriv(i,6));
    sinf=sin(extriv(i,6));
    cosk=cos(extriv(i,7));
    sink=sin(extriv(i,7));
    R(:,:,i)=[cosf*cosk, cosw*sink+sinw*sinf*cosk, sinw*sink-cosw*sinf*cosk;
        -cosf*sink, cosw*cosk-sinw*sinf*sink, sinw*cosk+cosw*sinf*sink;
        sinf, -sinw*cosf, cosw*cosf];
    f(:,:,i)=[-sinf*cosk,sinw*cosf*cosk,-cosw*cosf*cosk;
        sinf*sink,-sinw*cosf*sink,cosw*cosf*sink;
        cosf,sinw*sinf,-cosw*sinf];
    m_imp=max(impoint00(:,3));
    m=mod(x(i,4),m_imp);
    if mod(x(i,4),m_imp)==0
        S1=S*(x(i,4)/m_imp);
    else
        S1=S*(m/m_imp);
    end
    A1b=R(1,1,i)*x(i,2)+R(2,1,i)*y(i,2)-R(3,1,i)*intriv(1);
    PNb=R(1,3,i)*x(i,2)+R(2,3,i)*y(i,2)-R(3,3,i)*intriv(1);
    A1a=R(1,1,i)*impts{i}(1,5)+R(2,1,i)*impts{i}(1,6)-R(3,1,i)*intriv(1);
    A2a=R(1,2,i)*impts{i}(1,5)+R(2,2,i)*impts{i}(1,6)-R(3,2,i)*intriv(1);
    PNa=R(1,3,i)*impts{i}(1,5)+R(2,3,i)*impts{i}(1,6)-R(3,3,i)*intriv(1);
    extriv(i,4)=S1/(A1a/PNa-A1b/PNb);
    extriv(i,2)=extriv(i,4)*A1a/PNa;
    extriv(i,3)=extriv(i,4)*A2a/PNa;
end
clear S S1 A1a A1b A2a PNa PNb x y A1

for i=1:M
    if impts{i}(1,1)==0
        impts{i}(1,1:2)=0;
        impts{i}(1,4)=0;
    end
end

% Choose image with constant extrinsic 
% parameters (meters,rads)
imex=extriv(extriv(:,2)==min(extriv(:,2)),1);

% Choose image with constant Xo (meters)
imX=extriv(extriv(:,2)==max(extriv(:,2)),1);

if ground_t==0
    % Find points that appear in more than two images
    mtr=1;
    mtr2=1;
    ex_pnts=[];
    for i=1:N
        row(1:M)=0;
        for j=1:M
            if i<=size(impts{j},1)
                row(j)=impts{j}(i,4);
            end
        end
        statem=length(row(row~=0));
        if statem>=2
            if statem<M
                miss_pnts{mtr2,1}=i;
                miss_pnts{mtr2,2}=find(row==0);
                mtr2=mtr2+1;
            end
            pnt_ind(mtr,:)=[i,statem];
            mtr=mtr+1;
        end
    end


    % Calculation of inital values for check-points
    % coords initial values (meters)
    spaf=size(pnt_ind,1);
    par=sum(pnt_ind(:,2));
    agg_par=0;

    dl=zeros(2*par,1);
    A=zeros(2*par,3*spaf);

    mtr1=1;
    mtr2=1;
    mtr3=1;
    kr=size(impoint00,1);
    m_pn_i=max(pnt_ind(:,1));
    while (mtr1<=kr)
        t1=impoint00(mtr1,4);
        t2=pnt_ind(mtr2,1);
        if t1==t2
            in=impoint00(mtr1,1);
            fc=fcte(impoint00(mtr1,5),impoint00(mtr1,6),intriv,extriv(in,:),R(:,:,in));
            A(2*mtr3-1,3*(mtr2-1)+1:3*mtr2)=fc(1,1:3);
            A(2*mtr3,3*(mtr2-1)+1:3*mtr2)=fc(2,1:3);
            dl(2*mtr3-1,1)=fc(1,4);
            dl(2*mtr3,1)=fc(2,4);
            mtr1=mtr1+1;
            mtr2=mtr2+1;
            mtr3=mtr3+1;
        elseif t1<t2
            mtr1=mtr1+1;
        elseif t1>t2
            in=impoint00(mtr1,1);
            if t1>m_pn_i && in<M
                while impoint00(mtr1,4)>m_pn_i
                    mtr1=mtr1+1;
                end
                mtr2=1;
            elseif t1>m_pn_i && in==M
                break
            else
                mtr2=mtr2+1;
            end
        end
        try
            in;
        catch
            in=impoint00(mtr1,1);
        end
        if (t2==m_pn_i || t2==max(impts{in}(:,4)))
            mtr2=1;
        end
    end
    Nmat=A'*A;
    Na=inv(Nmat);
    n=A'*dl;
    X=Na*n;
    clear Nmat Na n A dl n fc

    pointiv(1:size(pnt_ind,1),1:4)=0;
    for i=1:size(pnt_ind,1)
        pointiv(i,1)=pnt_ind(i,1);
        pointiv(i,2:4)=X(3*(i-1)+1:3*(i-1)+3);
    end
    clear X
else
    % Find points that appear in more than one images
    mtr=1;
    mtr2=1;
    ex_pnts=[];
    for i=1:N
        row(1:M)=0;
        for j=1:M
            if i<=size(impts{j},1)
                row(j)=impts{j}(i,4);
            end
        end
        statem=length(row(row~=0));
        if statem>=1
            if statem<M
                miss_pnts{mtr2,1}=i;
                miss_pnts{mtr2,2}=find(row==0);
                mtr2=mtr2+1;
            end
            pnt_ind(mtr,:)=[i,statem];
            mtr=mtr+1;
        end
    end
    
    
    par=sum(pnt_ind(:,2));
    if spaf_uncert==0
        spaf=0;
        agg_par=0;
    else
        spaf=size(pnt_ind,1);
        agg_par=3*spaf;
        P = sparse(2*par+agg_par,2*par+agg_par,2*par+agg_par);
        for i=1:2*par
            P(i,i)=1./(sigma_image^2);
        end
        for i=1:agg_par
            P(i+2*par,i+2*par)=1./(sigma_ground^2);
        end
    end
 
    kr=size(impoint00,1);
    
    tilesize=1/(max(impoint00(:,2))-1);
    cpX=zeros(size(pnt_ind,1),2);
    cpX(:,1)=1:size(pnt_ind,1); cpY=cpX; cpZ=cpX;
    for i=1:size(pnt_ind,1)
        cpX(i,2)=(impoint00(find(pnt_ind(i,1)==impoint00(:,4),1),3)-1)*tilesize;
        cpY(i,2)=(impoint00(find(pnt_ind(i,1)==impoint00(:,4),1),2)-1)*tilesize;
        
        % Uncomment following block in order to solve Zhang dataset 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        %     ip_ind=find(pnt_ind(i,1)==impoint00(:,4),1);
        %     if mod(impoint00(ip_ind,3),2)==1
        %         cpX(i,2)=floor((impoint00(ip_ind,3))/2)*tilesize;
        %     else
        % %         cpX(i,2)=(floor((impoint00(ip_ind,3))/2)*tilesize)-7/121;
        %         cpX(i,2)=(floor((impoint00(ip_ind,3))/2)*tilesize)-25/423;
        %     end
        %     if mod(impoint00(ip_ind,2),2)==1
        %         cpY(i,2)=floor((impoint00(ip_ind,2))/2)*tilesize;
        %     else
        % %         cpY(i,2)=(floor((impoint00(ip_ind,2))/2)*tilesize)-7/121;
        %         cpY(i,2)=(floor((impoint00(ip_ind,2))/2)*tilesize)-25/423;
        %     end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    cpZ(:,2)=0;
    imex=M+1;
    imX=M+1;
    pointiv(1:size(pnt_ind,1),1:4)=0;
    for i=1:size(pnt_ind,1)
        pointiv(i,1)=pnt_ind(i,1);
        pointiv(i,2:4)=[cpX(i,2),cpY(i,2),cpZ(i,2)];
    end
    clear cpX cpY cpZ
end

