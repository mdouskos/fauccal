function ccmat=corcoef(Vm)

% CORCOEF
%   FAUCCAL supporting function that calculates
%   the correlation coefficients of the calculated
%   interior orientation parameters

msz=size(Vm,1);
ccmat=zeros(msz,msz);
for i=1:msz
    for j=1:msz
        if j>i
            ccmat(i,j)=Vm(i,j)/(sqrt(Vm(i,i)*Vm(j,j)));
            ccmat(j,i)=ccmat(i,j);
        elseif j==i
            ccmat(i,j)=1;
        end
    end
end
