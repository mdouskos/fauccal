function [fcv]=fcvp(xv,yv,inlp,ina,inc,pntx,pnty)

% FCVP
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for vanish
%   points estimation using vanish line 
%   (without radial distortion estimation)

switch inlp(1)
    case 1
    if inc~=0
        fcv(1)=inc*inlp(2)-1;
        fcv(2)=inc*xv;
        fcv(3)=inc;
        fcv(4)=inlp(2)*xv+inlp(3)-pnty;
        fcv(5)=pntx-xv-inc*pnty+inc*inlp(2)*xv+inc*inlp(3);
    else
        fcv(1)=ina-inlp(2);
        fcv(2)=-xv;
        fcv(3)=-1;
        fcv(4)=xv-pntx;
        fcv(5)=pnty-inlp(2)*xv-inlp(3)+ina*(xv-pntx);
    end
    case 2
    if inc~=0
        fcv(1)=inc-inlp(2);
        fcv(2)=-yv;
        fcv(3)=-1;
        fcv(4)=yv-pnty;
        fcv(5)=pntx-inlp(2)*yv-inlp(3)+inc*(yv-pnty);
    else
        fcv(1)=ina*inlp(2)-1;
        fcv(2)=ina*yv;
        fcv(3)=ina;
        fcv(4)=inlp(2)*yv+inlp(3)-pntx;
        fcv(5)=pnty-yv-ina*pntx+ina*inlp(2)*yv+ina*inlp(3);
    end
end


