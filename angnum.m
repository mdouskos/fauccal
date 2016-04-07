function an_n=angnum(ang1,ang2)

% ANGNUM
%   FAUCCAL supporting function that calculates and
%   returns the sin and cos of the input directions

an_n=zeros(2,2);
an_n(1,1)=sin(ang1);
an_n(1,2)=cos(ang1);
an_n(2,1)=sin(ang2);
an_n(2,2)=cos(ang2);