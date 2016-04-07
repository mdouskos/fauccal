function impix=rearrange(impixt,rows,clmns,M)

% REARRANGE
%   FAUCCAL function that rearranges point numbers in order to
%   corrspond to grids that all have the same number of columns

% Maximun number of columns
mcls=max(clmns(:));

% Rearrange point numbers to corrspond to grids that all have 
% the same number of columns
impix=cell(1,M);   
cgm=0;
for i=1:M
    c_s=size(impixt{i},2);
    impix{i}=zeros(rows(i)*mcls,c_s);
    gs=mcls-clmns(i);
    for j=1:size(impixt{i},1)
        if (impixt{i}(j,3)==clmns(i) && clmns(i)<mcls)
            impix{i}(j+cgm,:)=impixt{i}(j,:);
            if impix{i}(j+cgm,4)~=0
                impix{i}(j+cgm,4)=impix{i}(j+cgm,4)+cgm;
            end
            cgm=cgm+gs; 
            impix{i}(j+cgm:j+cgm+gs-1,:)=zeros(gs,c_s);
        else
            impix{i}(j+cgm,:)=impixt{i}(j,:);
            if impix{i}(j+cgm,4)~=0
                impix{i}(j+cgm,4)=impix{i}(j+cgm,4)+cgm;
            end
        end
    end
    cgm=0;
end
