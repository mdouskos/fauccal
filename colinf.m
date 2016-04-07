function [x,y]=colinf(intriv,sk,extriv,pointiv)

% COLINF
%   FAUCCAL supporting function that implements
%   the collinearity function

dXXo=pointiv(1,2)-extriv(1,2);
dYYo=pointiv(1,3)-extriv(1,3);
dZZo=pointiv(1,4)-extriv(1,4);

u=dXXo*R(1,1,1)+dYYo*R(1,2,1)+dZZo*R(1,3,1);
v=dXXo*R(2,1,1)+dYYo*R(2,2,1)+dZZo*R(2,3,1);
w=dXXo*R(3,1,1)+dYYo*R(3,2,1)+dZZo*R(3,3,1);

r=sqrt(fx^2+fy^2)/100;
dr=intriv(5)*r^3+intriv(6)*r^5;
dx=fx*dr/r;
dy=fy*dr/r;

x=intriv(3)-fx-sk*v/w+dx+dx2;
y=intriv(4)-fy+dy+dy2;