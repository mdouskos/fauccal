function [fc]=fcte(x,y,intriv,extriv,R)

% FCTE
%   FAUCCAL supporting function that calculates
%   A matrix and dl vector factors for tie
%   points ground coordinates estimation

fc=zeros(2,4);
fc(1,1)=x*R(3,1,1)+intriv(1)*R(1,1,1);
fc(2,1)=y*R(3,1,1)+intriv(1)*R(2,1,1);
fc(1,2)=x*R(3,2,1)+intriv(1)*R(1,2,1);
fc(2,2)=y*R(3,2,1)+intriv(1)*R(2,2,1);
fc(1,3)=x*R(3,3,1)+intriv(1)*R(1,3,1);
fc(2,3)=y*R(3,3,1)+intriv(1)*R(2,3,1);
fc(1,4)=extriv(1,2)*fc(1,1)+extriv(1,3)*fc(1,2)+extriv(1,4)*fc(1,3);
fc(2,4)=extriv(1,2)*fc(2,1)+extriv(1,3)*fc(2,2)+extriv(1,4)*fc(2,3);