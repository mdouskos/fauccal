function [xc,xy_err]=sub_corners(im,sigma,thresh,radius,wintx,winty,wx2,wy2)
% Arguments:   
%            im     - image to be processed.
%            sigma  - standard deviation of smoothing Gaussian. Typical
%                     values to use might be 1-3.
%            thresh - threshold. Try a value ~1000.
%            radius - radius of region considered in non-maximal
%                     suppression. Typical values to use might
%                     be 1-3.
%            Add a zero zone of size wx2,wy2 (Typical -1,-1)
%            wintx,winty=size of window around each point to search for sub-pixel corner (typical 5,5)


% Find Harris corners in image
[cim, r, c] = harris(im, sigma, thresh, radius);
% warning off all 

% Find sub-pixel corners close to the corners of Peter's Harris code (Jean-Yves Bouguet)
[xc,good,bad,xy_err,type] = cornerfinder([c(:) r(:)]',im,wintx,winty,wx2,wy2);
% Keep only good corners
xc=xc(:,find(good==1));
xy_err=xy_err(:,find(good==1));
% Plot both corners
% imshow(im), hold on,plot(xc(1,:),xc(2,:),'b+'), plot(c,r,'r+');  % Plots the sub-pixel corners in im

% warning on all 