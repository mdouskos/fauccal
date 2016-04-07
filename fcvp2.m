function [fcv]=fcvp2(xv,yv,ina,inc,pntx,pnty)

% FCVP2
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for vanish
%   points estimation (without the use of vanish
%   line and without radial distortion estimation)

if ina~=0
    fcv(1)=ina;
    fcv(2)=-1;
    fcv(3)=xv-pntx;
    fcv(4)=pnty-yv+ina*(xv-pntx);
else
    fcv(1)=-1;
    fcv(2)=inc;
    fcv(3)=yv-pnty;
    fcv(4)=pntx-xv+inc*(yv-pnty);
end




