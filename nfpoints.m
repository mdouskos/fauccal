function [point_candidate]=nfpoints(X,Y,extriv,R,sk,intriv,iaffpx,iaffpy,xc,swaa)

% NFPOINTS
%   FAUCCAL supporting function. 
%   Returns an actual image corner given
%   it's estimated image coordinates.

global height 
global width
global win_size

dXXo=X-extriv(1,2);
dYYo=Y-extriv(1,3);
dZZo=0-extriv(1,4);
w=dXXo*R(3,1,1)+dYYo*R(3,2,1)+dZZo*R(3,3,1);
u=dXXo*R(1,1,1)+dYYo*R(1,2,1)+dZZo*R(1,3,1);
v=dXXo*R(2,1,1)+dYYo*R(2,2,1)+dZZo*R(2,3,1);
fx=-intriv(1)*u/w-intriv(1)*intriv(2)*sk*v/w;
fy=-intriv(1)*intriv(2)*v/w;
fxt=-intriv(1)*u/w;
fyt=-intriv(1)*v/w;

r=sqrt(fxt^2+fyt^2);
dr=intriv(5)*r^3+intriv(6)*r^5;
dx=fxt*dr/r;
dy=fyt*dr/r;
dx2=intriv(7)*((r)^2+2*fxt^2)+intriv(8)*(2*fxt*fyt);
dy2=intriv(8)*((r)^2+2*fyt^2)+intriv(7)*(2*fxt*fyt);

x_t=intriv(3)+fx+dx+dx2;
y_t=intriv(4)+fy+dy+dy2;

x_im=x_t*iaffpx(1)+y_t*iaffpx(2)+iaffpx(3);
y_im=x_t*iaffpy(1)+y_t*iaffpy(2)+iaffpy(3);

if inpolygon(x_im,y_im,[1,width,width,1],[1,1,height,height])

    dists=zeros(1,size(xc,2));
    for l=1:size(xc,2)
        dists(1,l)=norm([xc(1,l)-x_im,xc(2,l)-y_im]);
    end
    point_candidate=xc(:,(min(dists(1,:))==dists(1,:)&dists(1,:)<win_size*.1));
else
    point_candidate=[];
end