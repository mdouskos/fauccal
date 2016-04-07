function [fcv]=fcvprd(xv,yv,inlp,k,ina,inc,pntx,pnty)

% FCVPRD
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for vanish
%   points estimation using vanish line 
%   and with radial distortion estimation

r2=(pntx^2+pnty^2);
frd=1-k(1)*r2-k(2)*r2^2;
switch inlp(1)
    case 1
    if inc~=0
        fcv(1)=inc*inlp(2)-1;
        fcv(2)=inc*xv;
        fcv(3)=inc;
        fcv(4)=(pnty*inc-pntx)*r2;
        fcv(5)=(pnty*inc-pntx)*r2^2;
        fcv(6)=inlp(2)*xv+inlp(3)-pnty*frd;
        fcv(7)=pntx*frd-xv-inc*(pnty*frd-inlp(2)*xv-inlp(3));
    else
        fcv(1)=ina-inlp(2);
        fcv(2)=-xv;
        fcv(3)=-1;
        fcv(4)=(pntx*ina-pnty)*r2;
        fcv(5)=(pntx*ina-pnty)*r2^2;
        fcv(6)=xv-pntx*frd;
        fcv(7)=pnty*frd-inlp(2)*xv-inlp(3)-ina*(pntx*frd-xv);
    end
    case 2
    if inc~=0
        fcv(1)=inc-inlp(2);
        fcv(2)=-yv;
        fcv(3)=-1;
        fcv(4)=(pnty*inc-pntx)*r2;
        fcv(5)=(pnty*inc-pntx)*r2^2;
        fcv(6)=yv-pnty*frd;
        fcv(7)=pntx*frd-inlp(2)*yv-inlp(3)-inc*(pnty*frd-yv);
    else
        fcv(1)=ina*inlp(2)-1;
        fcv(2)=ina*yv;
        fcv(3)=ina;
        fcv(4)=(pntx*ina-pnty)*r2;
        fcv(5)=(pntx*ina-pnty)*r2^2;
        fcv(6)=inlp(2)*yv+inlp(3)-pntx*frd;
        fcv(7)=pnty*frd-yv-ina*(pntx*frd-inlp(2)*yv-inlp(3));
    end
end


