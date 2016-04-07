function [fc]=factorsdd(pointiv,intriv,extriv,R,f,pcds,ip,comsk,sk)

% FACTORSDD
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for bundle
%   solution by input values for Image-based 
%   type of distortion


fc=zeros(2,16);
dx=0;
dx2=0;
dy=0;
dy2=0;
tdx_xo=0;
tdx_yo=0;
tdy_yo=0;
tdx2_xo=0;
tdx2_yo=0;
tdy2_yo=0;
pc=0;
fxt=pcds(1)-intriv(3); %fxt=x'-xo
fyt=pcds(2)-intriv(4); %fxt=x'-xo
dXXo=pointiv(1,2)-extriv(1,2);
dYYo=pointiv(1,3)-extriv(1,3);
dZZo=pointiv(1,4)-extriv(1,4);
switch ip
    case {3,5,7}
        intriv(2)=1;
end
cx=intriv(1);
cy=intriv(1)*intriv(2);
w=dXXo*R(3,1,1)+dYYo*R(3,2,1)+dZZo*R(3,3,1);
u=dXXo*R(1,1,1)+dYYo*R(1,2,1)+dZZo*R(1,3,1);
v=dXXo*R(2,1,1)+dYYo*R(2,2,1)+dZZo*R(2,3,1);
fc(1,1)=cx*(R(1,1,1)*w-R(3,1,1)*u)/w^2;
fc(2,1)=cy*(R(2,1,1)*w-R(3,1,1)*v)/w^2;
fc(1,2)=cx*(R(1,2,1)*w-R(3,2,1)*u)/w^2;
fc(2,2)=cy*(R(2,2,1)*w-R(3,2,1)*v)/w^2;
fc(1,3)=cx*(R(1,3,1)*w-R(3,3,1)*u)/w^2;
fc(2,3)=cy*(R(2,3,1)*w-R(3,3,1)*v)/w^2;
fc(1,4)=-cx*(w*(-R(1,3,1)*dYYo+R(1,2,1)*dZZo)-u*(-R(3,3,1)*dYYo+R(3,2,1)*dZZo))/w^2;
fc(2,4)=-cy*(w*(-R(2,3,1)*dYYo+R(2,2,1)*dZZo)-v*(-R(3,3,1)*dYYo+R(3,2,1)*dZZo))/w^2;                
fc(1,5)=-cx*(w*(f(1,1,1)*dXXo+f(1,2,1)*dYYo+f(1,3,1)*dZZo)-u*(f(3,1,1)*dXXo+f(3,2,1)*dYYo+f(3,3,1)*dZZo))/w^2;
fc(2,5)=-cy*(w*(f(2,1,1)*dXXo+f(2,2,1)*dYYo+f(2,3,1)*dZZo)-v*(f(3,1,1)*dXXo+f(3,2,1)*dYYo+f(3,3,1)*dZZo))/w^2;
fc(1,6)=-cx*(R(2,1,1)*dXXo+R(2,2,1)*dYYo+R(2,3,1)*dZZo)/w;
fc(2,6)=cy*(R(1,1,1)*dXXo+R(1,2,1)*dYYo+R(1,3,1)*dZZo)/w;
fc(1,7)=-fc(1,1);
fc(2,7)=-fc(2,1);
fc(1,8)=-fc(1,2);
fc(2,8)=-fc(2,2);
fc(1,9)=-fc(1,3);
fc(2,9)=-fc(2,3);
fc(1,10)=-u/w-intriv(2)*sk*v/w;
switch ip
    case 3
        fc(2,10)=-intrin(2)*v/w;
        fx=intriv(1)*fc(1,10); %fx=x-xo
        fy=intriv(1)*fc(2,10); %fy=y-yo
    case 4
        fc(2,10)=-intriv(2)*v/w;
        fc(1,11)=-intriv(1)*sk*v/w;
        fc(2,11)=-intriv(1)*v/w;
        fx=intriv(1)*fc(1,10); %fx=x-xo
        fy=intriv(2)*fc(2,11); %fy=y-yo
    otherwise
        switch ip
            case {5,7}      
            fc(2,10)=-intriv(2)*v/w;
            fx=intriv(1)*fc(1,10); %fx=x-xo
            fy=intriv(1)*fc(2,10); %fy=y-yo
            otherwise
            fc(2,10)=-intriv(2)*v/w;
            fc(1,11)=-intriv(1)*sk*v/w;
            fc(2,11)=-intriv(1)*v/w;
            fx=intriv(1)*fc(1,10); %fx=x-xo
            fy=intriv(2)*fc(2,11); %fy=y-yo   
        end
        r=sqrt(fxt^2+fyt^2)/100;
        dr=intriv(5)*r^3+intriv(6)*r^5;
        k1=intriv(5)/100^2;
        k2=intriv(6)/100^4;
        dx=fxt*dr/r;
        dy=fyt*dr/r;
        fc(1,14)=fxt*r^2;
        fc(2,14)=fyt*r^2;
        fc(1,15)=fxt*r^4;
        fc(2,15)=fyt*r^4;
        tdx_xo=-(3*k1*fxt^2+k1*fyt^2+5*k2*fxt^4+6*k2*fxt^2*fyt^2+k2*fyt^4);
        tdx_yo=-(2*k1*fxt*fyt+4*k2*fxt^3*fyt+4*k2*fxt*fyt^3);
        tdy_yo=-(3*k1*fyt^2+k1*fxt^2+5*k2*fyt^4+6*k2*fxt^2*fyt^2+k2*fxt^4);
        switch ip
            case {7,8}
            p1=intriv(7)/100;
            p2=intriv(8)/100;
            fc(1,16)=((r*100)^2+2*fxt^2)/100;
            fc(2,16)=(2*fxt*fyt)/100;
            fc(1,17)=fc(2,16);
            fc(2,17)=((r*100)^2+2*fyt^2)/100;
            tdx2_xo=-(6*p1*fxt+2*p2*fyt);
            tdx2_yo=-(2*p1*fyt+2*p2*fxt);
            tdy2_yo=-(6*p2*fyt+2*p1*fxt);
            dx2=intriv(7)*fc(1,16)+intriv(8)*fc(2,16);
            dy2=intriv(8)*fc(2,17)+intriv(7)*fc(2,16);  
        end
end
if comsk==1
    fc(1,19)=-intriv(1)*intriv(2)*v/w;
    fc(2,19)=0;
else
    sk=0;
end
fc(1,12)=1;
fc(2,12)=0;
fc(1,13)=0;
fc(2,13)=1;
fc(1,18)=intriv(3)+fx+dx+dx2;
fc(2,18)=intriv(4)+fy+dy+dy2;