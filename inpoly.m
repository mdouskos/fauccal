function in=inpoly(x,y,xp,yp)

% INPOLY
%   FAUCCAL supporting function that tests if an
%   image point lies within a given window

if  (x>xp(1) && x<xp(2)) && (y>yp(1) && y<yp(3))
    in=1;
else
    in=0;
end