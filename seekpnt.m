function [xcn]=seekpnt(gnpnt,f1,xc)

% SEEKPNT
%   FAUCCAL supporting function for tracing a point detected
%   by harris operator from an estimation of points position

mtr=0;
ws=10; % Search window initial size
wsl=1;
cntp=0;
xcl=[];

% Open a window around point's estimation position and keep
% points within this window
npoly=[gnpnt(1)-f1/wsl,gnpnt(1)+f1/wsl,gnpnt(1)+f1/wsl,gnpnt(1)-f1/wsl;
    gnpnt(2)-f1/wsl gnpnt(2)-f1/wsl  gnpnt(2)+f1/wsl gnpnt(2)+f1/wsl];
for i=1:size(xc,2)
    if inpoly(xc(1,i),xc(2,i),npoly(1,:),npoly(2,:))
        mtr=mtr+1;
        xcl(:,mtr)=xc(:,i);
    end
end
clear mtr

% Loop that tries to find point
mtr=0;
while mtr~=1
    npoly=[gnpnt(1)-f1/ws,gnpnt(1)+f1/ws,gnpnt(1)+f1/ws,gnpnt(1)-f1/ws;
        gnpnt(2)-f1/ws gnpnt(2)-f1/ws  gnpnt(2)+f1/ws gnpnt(2)+f1/ws];

    mtr=0;
    if ~isempty(xcl)
        for i=1:size(xcl,2)
            if inpoly(xcl(1,i),xcl(2,i),npoly(1,:),npoly(2,:))
                mtr=mtr+1;
                xcn(:,mtr)=xcl(:,i);
            end
        end
    else
        clear xcn
        mtr=1;
        xcn(1:2,1)=0;
        break
    end
    
    % Readjust searching window's parameters 
    if (mtr>1 && ws<10 && cntp<5) 
        if (max(xcn(1,:))-min(xcn(1,:))>2 &&...
                max(xcn(1,:))-min(xcn(2,:))>2)
            ws=ws+0.5;
            cntp=cntp+1;
        else
            xcnn(:,1)=xcn(:,1);
            clear xcn
            xcn(:,1)=xcnn(:,1);
            clear xcnn
            mtr=1;
        end
    elseif (mtr==0 && ws>2)
        ws=ws-0.5;
    end
    if ((mtr~=1 && (ws==2 || ws==10)) || cntp==5)
        clear xcn
        mtr=1;
        xcn(1:2,1)=0;
    end
end