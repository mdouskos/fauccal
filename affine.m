function [affpx,affpy]=affine(imc,ximr,yimr)

% AFFINE 
%   An affine transformation function for supporting 
%   FAUCCAL Toolbox

% Matrix A and dl vector
A=zeros(4,3);
for i=1:4
    A(i,1)=imc(i,1);
    A(i,2)=imc(i,2);
    A(i,3)=1;
end
dlx=ximr;
dly=yimr;

% affine parameters
N=A'*A;
Na=inv(N);
affpx=Na*(A'*dlx);
affpy=Na*(A'*dly);