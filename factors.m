function [fc]=factors(pointiv,intriv,extriv,R,f,ip,comsk,sk)

% FACTORS
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for bundle
%   solution by input values for Ground-based 
%   type of distortion

fc=zeros(2,16);

dXXo=pointiv(1,2)-extriv(1,2);
dYYo=pointiv(1,3)-extriv(1,3);
dZZo=pointiv(1,4)-extriv(1,4);
switch ip
    case {3,5,7}
        intriv(2)=1;
end
c=intriv(1);
a=intriv(2);
k1=intriv(5);
k2=intriv(6);
p1=intriv(7);
p2=intriv(8);

w=dXXo*R(3,1,1)+dYYo*R(3,2,1)+dZZo*R(3,3,1);
u=dXXo*R(1,1,1)+dYYo*R(1,2,1)+dZZo*R(1,3,1);
v=dXXo*R(2,1,1)+dYYo*R(2,2,1)+dZZo*R(2,3,1);
duwX=-(R(1,1,1)*w-R(3,1,1)*u)/w^2;
dvwX=-(R(2,1,1)*w-R(3,1,1)*v)/w^2;
duwY=-(R(1,2,1)*w-R(3,2,1)*u)/w^2;
dvwY=-(R(2,2,1)*w-R(3,2,1)*v)/w^2;
duwZ=-(R(1,3,1)*w-R(3,3,1)*u)/w^2;
dvwZ=-(R(2,3,1)*w-R(3,3,1)*v)/w^2;
duww=(w*(-R(1,3,1)*dYYo+R(1,2,1)*dZZo)-u*(-R(3,3,1)*dYYo+R(3,2,1)*dZZo))/w^2;
dvww=(w*(-R(2,3,1)*dYYo+R(2,2,1)*dZZo)-v*(-R(3,3,1)*dYYo+R(3,2,1)*dZZo))/w^2;
duwf=(w*(f(1,1,1)*dXXo+f(1,2,1)*dYYo+f(1,3,1)*dZZo)-u*(f(3,1,1)*dXXo+f(3,2,1)*dYYo+f(3,3,1)*dZZo))/w^2;
dvwf=(w*(f(2,1,1)*dXXo+f(2,2,1)*dYYo+f(2,3,1)*dZZo)-v*(f(3,1,1)*dXXo+f(3,2,1)*dYYo+f(3,3,1)*dZZo))/w^2;
duwk=(R(2,1,1)*dXXo+R(2,2,1)*dYYo+R(2,3,1)*dZZo)/w;
dvwk=-(R(1,1,1)*dXXo+R(1,2,1)*dYYo+R(1,3,1)*dZZo)/w;
fxt=-c*u/w;
fyt=-c*v/w;
r2=(fxt^2+fyt^2);
r4=r2^2;

dr2X=2*c^2*(u/w*duwX+v/w*dvwX);
fc(1,1)=-c*duwX-c*a*sk*dvwX+(k1*dr2X+k2*2*r2*dr2X)*fxt+(k1*r2+k2*r4)*(-c)*duwX+p1*(dr2X+4*fxt*(-c)*duwX)+2*p2*(-c)*duwX*fyt+2*p2*(-c)*dvwX*fxt;
fc(2,1)=-c*a*dvwX+(k1*dr2X+k2*2*r2*dr2X)*fyt+(k1*r2+k2*r4)*(-c)*dvwX+p2*(dr2X+4*fyt*(-c)*dvwX)+2*p1*(-c)*duwX*fyt+2*p2*(-c)*dvwX*fxt;

dr2Y=2*c^2*(u/w*duwY+v/w*dvwY);
fc(1,2)=-c*duwY-c*a*sk*dvwY+(k1*dr2Y+k2*2*r2*dr2Y)*fxt+(k1*r2+k2*r4)*(-c)*duwY+p1*(dr2Y+4*fxt*(-c)*duwY)+2*p2*(-c)*duwY*fyt+2*p2*(-c)*dvwY*fxt;
fc(2,2)=-c*a*dvwY+(k1*dr2Y+k2*2*r2*dr2Y)*fyt+(k1*r2+k2*r4)*(-c)*dvwY+p2*(dr2Y+4*fyt*(-c)*dvwY)+2*p1*(-c)*duwY*fyt+2*p2*(-c)*dvwY*fxt;

dr2Z=2*c^2*(u/w*duwZ+v/w*dvwZ);
fc(1,3)=-c*duwZ-c*a*sk*dvwZ+(k1*dr2Z+k2*2*r2*dr2Z)*fxt+(k1*r2+k2*r4)*(-c)*duwZ+p1*(dr2Z+4*fxt*(-c)*duwZ)+2*p2*(-c)*duwZ*fyt+2*p2*(-c)*dvwZ*fxt;
fc(2,3)=-c*a*dvwZ+(k1*dr2Z+k2*2*r2*dr2Z)*fyt+(k1*r2+k2*r4)*(-c)*dvwZ+p2*(dr2Z+4*fyt*(-c)*dvwZ)+2*p1*(-c)*duwZ*fyt+2*p2*(-c)*dvwZ*fxt;

dr2w=2*c^2*(u/w*duww+v/w*dvww);
fc(1,4)=-c*duww-c*a*sk*dvww+(k1*dr2w+k2*2*r2*dr2w)*fxt+(k1*r2+k2*r4)*(-c)*duww+p1*(dr2w+4*fxt*(-c)*duww)+2*p2*(-c)*duww*fyt+2*p2*(-c)*dvww*fxt;
fc(2,4)=-c*a*dvww+(k1*dr2w+k2*2*r2*dr2w)*fyt+(k1*r2+k2*r4)*(-c)*dvww+p2*(dr2w+4*fyt*(-c)*dvww)+2*p1*(-c)*duww*fyt+2*p2*(-c)*dvww*fxt;

dr2f=2*c^2*(u/w*duwf+v/w*dvwf);
fc(1,5)=-c*duwf-c*a*sk*dvwf+(k1*dr2f+k2*2*r2*dr2f)*fxt+(k1*r2+k2*r4)*(-c)*duwf+p1*(dr2f+4*fxt*(-c)*duwf)+2*p2*(-c)*duwf*fyt+2*p2*(-c)*dvwf*fxt;
fc(2,5)=-c*a*dvwf+(k1*dr2f+k2*2*r2*dr2f)*fyt+(k1*r2+k2*r4)*(-c)*dvwf+p2*(dr2f+4*fyt*(-c)*dvwf)+2*p1*(-c)*duwf*fyt+2*p2*(-c)*dvwf*fxt;

dr2k=2*c^2*(u/w*duwk+v/w*dvwk);
fc(1,6)=-c*duwk-c*a*sk*dvwk+(k1*dr2k+k2*2*r2*dr2k)*fxt+(k1*r2+k2*r4)*(-c)*duwk+p1*(dr2k+4*fxt*(-c)*duwk)+2*p2*(-c)*duwk*fyt+2*p2*(-c)*dvwk*fxt;
fc(2,6)=-c*a*dvwk+(k1*dr2k+k2*2*r2*dr2k)*fyt+(k1*r2+k2*r4)*(-c)*dvwk+p2*(dr2k+4*fyt*(-c)*dvwk)+2*p1*(-c)*duwk*fyt+2*p2*(-c)*dvwk*fxt;

fc(1,7)=-fc(1,1);
fc(2,7)=-fc(2,1);
fc(1,8)=-fc(1,2);
fc(2,8)=-fc(2,2);
fc(1,9)=-fc(1,3);
fc(2,9)=-fc(2,3);

dr2c=2*r2/c;
fc(1,10)=-u/w-a*sk*v/w+(k1*dr2c+k2*2*r2*dr2c)*fxt+(k1*r2+k2*r4)*(-u/w)+p1*(dr2c+4*fxt*(-u/w))+2*p2*(-u/w)*fyt+2*p2*(-v/w)*fxt;
fc(2,10)=-a*v/w+(k1*dr2c+k2*2*r2*dr2c)*fyt+(k1*r2+k2*r4)*(-v/w)+p2*(dr2c+4*fyt*(-v/w))+2*p1*(-u/w)*fyt+2*p2*(-v/w)*fxt;

fc(1,11)=-c*sk*v/w; 
fc(2,11)=-c*v/w;

fc(1,12)=1;
fc(2,12)=0;
fc(1,13)=0;
fc(2,13)=1;

fc(1,14)=fxt*r2;
fc(2,14)=fyt*r2;
fc(1,15)=fxt*r4;
fc(2,15)=fyt*r4;

     
fc(1,16)=(r2+2*fxt^2);
fc(2,16)=(2*fxt*fyt);
fc(1,17)=fc(2,16);
fc(2,17)=(r2+2*fyt^2);

if comsk==1
    fc(1,19)=-c*a*v/w; %%
    fc(2,19)=0;
else
    sk=0;
end

fc(1,18)=intriv(3)-c*u/w-c*a*sk*v/w+(k1*r2+k2*r4)*fxt+p1*(r2+2*fxt^2)+2*p2*fxt*fyt;
fc(2,18)=intriv(4)-c*a*v/w+(k1*r2+k2*r4)*fyt+p2*(r2+2*fyt^2)+2*p1*fxt*fyt;