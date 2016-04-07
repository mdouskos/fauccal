function [xv,yv,impoint00, pntn, sigc, kiv]=...
    vpts(impix,xc,xyerr,affpx,affpy,rmax)

% VPTS 
%   FAUCCAL supporting function that calculates 
%   the vanish points of a grid

rs=max(impix(:,2));
cs=max(impix(:,3));

ind=[];
% Transform (i,j) coordinates to image coordinates (x,y)
impoint00=zeros(size(impix,1),8);
for i=1:size(impix,1)
    impoint00(i,1:4)=impix(i,1:4);
    impoint00(i,5)=impix(i,5)*affpx(1)+impix(i,6)*affpx(2)+affpx(3);
    impoint00(i,6)=impix(i,5)*affpy(1)+impix(i,6)*affpy(2)+affpy(3);
end
clear impix

% Indexes of points that belong to horizontal lines
horl=zeros(rs,cs);
verl=horl';
for i=1:rs
    for j=1:cs
        for k=1:size(impoint00,1)
            if (impoint00(k,2)==i & impoint00(k,3)==j)
                horl(i,j)=impoint00(k,4);
            end
        end
    end
end
clear j k

% Indexes of points that belong to vertical lines
verl=horl';
mat=horl(rs:-1:1,:);

% Indexes of points that  belong to the diagonals
diag1=zeros(rs+cs-5,min(rs,cs));
diag2=diag1;

if rs<=cs
    rs1=rs;
    cs1=cs;
    mat1=mat;
else
    rs1=cs;
    cs1=rs;
    mat1=mat';
end

e=1;
if (rs1>3 & cs1>3)
    for ct=1:(rs1+cs1-5)
        if ct<rs1-2
            for i=1:ct+2
                diag1(ct,i)=mat1(rs1-(ct+2)+i,i);
            end
        elseif (ct>=rs1-2 & ct<(rs1-2+abs(rs1-cs1)+1))
            for i=1:rs1
                diag1(ct,i)=mat1(i,ct-(rs1-2)+i);
            end
        else
            for i=1:rs1-e
                diag1(ct,i)=mat1(i,ct-(rs1-2)+i);
            end
            e=e+1;
        end
    end
end

e=1;
if (rs1>3 & cs1>3)
    for ct=1:(rs1+cs1-5)
        if ct<rs1-2
            for i=1:ct+2
                diag2(ct,i)=mat1(ct+3-i,i);
            end
        elseif (ct>=rs1-2 & ct<(rs1-2+abs(rs1-cs1)+1))
            for i=1:rs1
                diag2(ct,i)=mat1(rs1+1-i,ct-(rs1-2)+i);
            end
        else
            for i=1:rs1-e
                diag2(ct,i)=mat1(rs1+1-i,ct-(rs1-2)+i);
            end
            e=e+1;
        end
    end
end

if rs>cs
    diag1=diag1(end:-1:1,:);
    diag2=diag2(:,end:-1:1);
end
pntn=length(mat(mat~=0));
clear mat mat1 ct cs1 rs1 e

% Calculate line equation parameters for all lines depending on lines
% direction
ina=zeros(4,size(diag1,1));
inb=ina;
inc=ina;
ind=ina;
sizeh=0;
sizev=0;
obsnh=0;
obsnv=0;
obsnd1=0;
obsnd2=0;
lnh=0;
lnv=0;
lnd1=0;
lnd2=0;
for i=1:4
    switch(i)
        case 1
            for j=1:rs
                ln=horl(j,horl(j,:)>0);
                if (~isempty(ln) && length(ln)>=3 )
                    obsnh=obsnh+length(ln);
                    lnh=lnh+1;
                    x1=impoint00(impoint00(:,4)==ln(1),5);
                    y1=impoint00(impoint00(:,4)==ln(1),6);
                    x2=impoint00(impoint00(:,4)==ln(end),5);
                    y2=impoint00(impoint00(:,4)==ln(end),6);
                    if (abs(x2-x1)>=abs(y2-y1))
                        ina(i,j)=(y2-y1)/(x2-x1);
                        inb(i,j)=y1-x1*ina(i,j);
                    else
                        inc(i,j)=(x2-x1)/(y2-y1);
                        ind(i,j)=x1-y1*inc(i,j);
                    end
                    sizehn=sqrt((x2-x1)^2+(y2-y1)^2);
                    if (sizehn>sizeh)
                        sizeh=sizehn;
                    end
                else
                    ina(i,j)=NaN;
                    inb(i,j)=NaN;
                end
            end
        case 2
            for j=1:cs
                ln=verl(j,verl(j,:)>0);
                if (~isempty(ln) && length(ln)>=3 )
                    obsnv=obsnv+length(ln);
                    lnv=lnv+1;
                    x1=impoint00(impoint00(:,4)==ln(1),5);
                    y1=impoint00(impoint00(:,4)==ln(1),6);
                    x2=impoint00(impoint00(:,4)==ln(end),5);
                    y2=impoint00(impoint00(:,4)==ln(end),6);
                    if (abs(x2-x1)>=abs(y2-y1))
                        ina(i,j)=(y2-y1)/(x2-x1);
                        inb(i,j)=y1-x1*ina(i,j);
                    else
                        inc(i,j)=(x2-x1)/(y2-y1);
                        ind(i,j)=x1-y1*inc(i,j);
                    end
                    sizevn=sqrt((x2-x1)^2+(y2-y1)^2);
                    if (sizevn>sizev)
                        sizev=sizevn;
                    end
                else
                    ina(i,j)=NaN;
                    inb(i,j)=NaN;
                end
            end
        case 3
            for j=1:rs+cs-5
                ln=diag2(j,diag2(j,:)>0);
                if (~isempty(ln) && length(ln)>=3 )
                    obsnd2=obsnd2+length(ln);
                    lnd2=lnd2+1;
                    x1=impoint00(impoint00(:,4)==ln(1),5);
                    y1=impoint00(impoint00(:,4)==ln(1),6);
                    x2=impoint00(impoint00(:,4)==ln(end),5);
                    y2=impoint00(impoint00(:,4)==ln(end),6);
                    if (abs(x2-x1)>=abs(y2-y1))
                        ina(i,j)=(y2-y1)/(x2-x1);
                        inb(i,j)=y1-x1*ina(i,j);
                    else
                        inc(i,j)=(x2-x1)/(y2-y1);
                        ind(i,j)=x1-y1*inc(i,j);
                    end
                else
                    ina(i,j)=NaN;
                    inb(i,j)=NaN;
                end
            end
        case 4
            for j=1:rs+cs-5
                ln=diag1(j,diag1(j,:)>0);
                if (~isempty(ln) && length(ln)>=3 )
                    obsnd1=obsnd1+length(ln);
                    lnd1=lnd1+1;
                    x1=impoint00(impoint00(:,4)==ln(1),5);
                    y1=impoint00(impoint00(:,4)==ln(1),6);
                    x2=impoint00(impoint00(:,4)==ln(end),5);
                    y2=impoint00(impoint00(:,4)==ln(end),6);
                    if (abs(x2-x1)>=abs(y2-y1))
                        ina(i,j)=(y2-y1)/(x2-x1);
                        inb(i,j)=y1-x1*ina(i,j);
                    else
                        inc(i,j)=(x2-x1)/(y2-y1);
                        ind(i,j)=x1-y1*inc(i,j);
                    end
                else
                    ina(i,j)=NaN;
                    inb(i,j)=NaN;
                end
            end
    end
end
clear x1 y1 x2 y2 ln sizehn sizevn

% Calculate vanish points coordinates initial values
for i=1:4
    lena(i)=length(ina(i,(ina(i,:)~=0 & isfinite(ina(i,:)))));
    lenc(i)=length(inc(i,(inc(i,:)~=0 & isfinite(inc(i,:)))));
    if (lena(i)~=0 && lenc(i)~=0)
        inda=find(abs(ina(i,:))==min(abs(ina(i,ina(i,:)~=0))));
        a=ina(i,inda);
        b=inb(i,inda);
        indc=find(abs(inc(i,:))==min(abs(inc(i,inc(i,:)~=0))));
        c=inc(i,indc);
        d=ind(i,indc);
        if a~=(1/c)
            xv(i)=(b*c+d)/(1-a*c);
            yv(i)=a*xv(i)+b;
        else
            xv(i)=inf;
            yv(i)=inf;
        end
    elseif lenc(i)~=0
        inc1=inc(i,(inc(i,:)~=0 & isfinite(inc(i,:))));
        par1=[inc1(1) inc1(end)];
        ind1=ind(i,(ind(i,:)~=0 & isfinite(ind(i,:))));
        par2=[ind1(1) ind1(end)];
        if par1(2)~=par1(1)
            yv(i)=(par2(2)-par2(1))/(par1(1)-par1(2));
            xv(i)=par1(1)*yv(i)+par2(1);
        else
            xv(i)=inf;
            yv(i)=inf;
        end
    elseif lena(i)~=0
        ina1=ina(i,(ina(i,:)~=0 & isfinite(ina(i,:))));
        par1=[ina1(1) ina1(end)];
        inb1=inb(i,(inb(i,:)~=0 & isfinite(inb(i,:))));
        par2=[inb1(1) inb1(end)];
        if par1(1)~=par1(2)
            xv(i)=(par2(2)-par2(1))/(par1(1)-par1(2));
            yv(i)=par1(1)*xv(i)+par2(1);
        else
            xv(i)=inf;
            yv(i)=inf;
        end
    end
end
clear ina1 inb1 inc1 ind1 par1 par2 a b c d

for i=1:4
    if (isfinite(xv(i)) & sqrt(xv(i)^2+yv(i)^2)>40*max(sizeh,sizev))
        xv(i)=inf;
        yv(i)=inf;
    end
end

% Vanish line equation parameters (initial values)
if  (isfinite(xv(1)) && isfinite(xv(2)) && abs(xv(2)-xv(1))>=abs(yv(2)-yv(1)))
    inlp(1)=1;
    inlp(2)=(yv(2)-yv(1))/(xv(2)-xv(1));
    inlp(3)=yv(1)-inlp(2)*xv(1);
elseif (isfinite(xv(1)) && isfinite(xv(2)) && abs(xv(2)-xv(1))<abs(yv(2)-yv(1)))
    inlp(1)=2;
    inlp(2)=(yv(2)-yv(1))\(xv(2)-xv(1));
    inlp(3)=xv(1)-inlp(2)*yv(1);
end
kiv=[0 0];

% Solve adjustment for finding vanish points
if min(sizeh,sizev)>1.2*rmax
    vpsolrd
else
    vpsol
end

% Calculate standard deviation of c parameter if
% vanish line is not used in above adjustment
if (SYN==0 && isfinite(xv(1)) && isfinite(xv(2)))
    Vxlp=[Vxpost(1,1,1) 0 Vxpost(1,2,1) 0;
        0 Vxpost(1,1,2) 0 Vxpost(1,2,2);
        Vxpost(2,1,1) 0 Vxpost(2,2,1) 0;
        0 Vxpost(2,1,2) 0 Vxpost(2,2,2)];
    c=sqrt(abs(-xv(1)*xv(2)-yv(1)*yv(2)));
    Jac1=[-(xv(2)/(2*c)),-(xv(1)/(2*c)),-(yv(2)/(2*c)),-(yv(1)/(2*c))];
    sigc=sqrt(Jac1*Vxlp*Jac1');
    clear c
end

clear SYN Vxlp Vxpost i j k