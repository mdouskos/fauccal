function [fcv]=fcvp2rd(xv,yv,k,ina,inc,pntx,pnty)

% FCVP2RD
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for vanish
%   points estimation with radial distortion 
%   estimation (without the use of vanish line) 

r2=(pntx^2+pnty^2);
frd=1-k(1)*r2-k(2)*r2^2;
if ina~=0
    fcv(1)=ina;
    fcv(2)=-1;
    fcv(3)=(pntx*ina-pnty)*r2;
    fcv(4)=(pntx*ina-pnty)*r2^2;
    fcv(5)=xv-pntx*frd;
    fcv(6)=pnty*frd-yv+ina*(xv-pntx*frd);
else
    fcv(1)=-1;
    fcv(2)=inc;
    fcv(3)=(pnty*inc-pntx)*r2;
    fcv(4)=(pnty*inc-pntx)*r2^2;
    fcv(5)=xv-pnty*frd;
    fcv(6)=pntx*frd-xv+inc*(yv-pnty*frd);
end




