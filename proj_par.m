function [a,a_p]=proj_par(intriv,extriv,sk,affpx,affpy)

% PROJ_PAR
%   FAUCCAL supporting function. 
%   Calculates projective parameters
%   given each image's interior and 
%   exterior orientation parameters.


cosw=cos(extriv(5));
sinw=sin(extriv(5));
cosf=cos(extriv(6));
sinf=sin(extriv(6));
cosk=cos(extriv(7));
sink=sin(extriv(7));
R(:,:)=[cosf*cosk, cosw*sink+sinw*sinf*cosk, sinw*sink-cosw*sinf*cosk;
    -cosf*sink, cosw*cosk-sinw*sinf*sink, sinw*cosk+cosw*sinf*sink;
    sinf, -sinw*cosf, cosw*cosf];

a=ones(3,3); 
a_p=a;

D=-(R(3,1)*extriv(2)+R(3,2)*extriv(3)+R(3,3)*extriv(4));
a(1,1)=(-intriv(1)*R(1,1)-intriv(1)*intriv(2)*sk*R(2,1)+intriv(3)*R(3,1))/D;
a(1,2)=(-intriv(1)*R(1,2)-intriv(1)*intriv(2)*sk*R(2,2)+intriv(3)*R(3,2))/D;
a(1,3)=-(a(1,1)*extriv(2)+a(1,2)*extriv(3)+(-intriv(1)*R(1,3)-intriv(1)*intriv(2)*sk*R(2,3)+intriv(3)*R(3,3))*extriv(4)/D);
a(2,1)=(-intriv(1)*intriv(2)*R(2,1)+intriv(4)*R(3,1))/D;
a(2,2)=(-intriv(1)*intriv(2)*R(2,2)+intriv(4)*R(3,2))/D;
a(2,3)=-(a(2,1)*extriv(2)+a(2,2)*extriv(3)+(-intriv(1)*intriv(2)*R(2,3)+intriv(4)*R(3,3))*extriv(4)/D);
a(3,1)=R(3,1)/D;
a(3,2)=R(3,2)/D;
    
if nargout==2
    D_p=affpx(1)*affpy(2)-affpy(1)*affpx(2);
    a_p(1,1)=a(1,1)*affpy(2)-a(2,1)*affpx(2)-a(3,1)*(affpx(3)*affpy(2)-affpy(3)*affpx(2));
    a_p(1,2)=a(1,2)*affpy(2)-a(2,2)*affpx(2)-a(3,2)*(affpx(3)*affpy(2)-affpy(3)*affpx(2));
    a_p(1,3)=a(1,3)*affpy(2)-a(2,3)*affpx(2)-(affpx(3)*affpy(2)-affpy(3)*affpx(2));
    a_p(2,1)=-a(1,1)*affpy(1)+a(2,1)*affpx(1)+a(3,1)*(affpx(3)*affpy(1)-affpy(3)*affpx(1));
    a_p(2,2)=-a(1,2)*affpy(1)+a(2,2)*affpx(1)+a(3,2)*(affpx(3)*affpy(1)-affpy(3)*affpx(1));
    a_p(2,3)=-a(1,3)*affpy(1)+a(2,3)*affpx(1)+(affpx(3)*affpy(1)-affpy(3)*affpx(1));
    a_p(3,1)=a(3,1);
    a_p(3,2)=a(3,2);
    a_p(1:8)=a_p(1:8)./D_p;
end





