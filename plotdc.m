function plotdc(intriv,rm,M)

% PLOTDC
%   FAUCCAL supporting function that calculates
%   calibrated radial distortion curve's parameters 
%   and plots it

% Calculate parameters
k1=intriv(5);
k2=intriv(6);
d11=k1^2*rm^7/7;
d12=k2^2*rm^11/11;
d13=2*k1*k2*rm^9/9;
D1=d11+d12+d13;
d21=k1*rm^5/5;
d22=k2*rm^7/7;
D2=d21+d22;
D3=rm^3/3;

fact=(D2-D1)/(D1-2*D2+D3);
k0n=-fact;
k1n=(1+fact)*k1;
k2n=(1+fact)*k2;

str2=zeros(1,2,3);
str1=zeros(1,4,3);
ind=zeros(1,3);
k=[k0n k1n k2n];

% Plot curve and print corresponding parameters values
timk{1}=sprintf('%.3e',k(1));
timk{2}=sprintf('%.3e',k(2));
timk{3}=sprintf('%.3e',k(3));

rwid=[0:rm/500:rm];
for i=1:size(rwid,2)
    distcu(1,i)=k0n*rwid(i)+k1n*rwid(i)^3+k2n*rwid(i)^5;
end
hf=figure(M+1);
hold on
plot(rwid,distcu)
V=axis;
if k(1)>=0
    ht(1)=text(10,(V(4)-V(3))*3/10+V(3),['k_{0}\prime: ',timk{1}]);
    ht(2)=text(10,(V(4)-V(3))*2/10+V(3),['k_{1}\prime: ',timk{2}]);
    ht(3)=text(10,(V(4)-V(3))/10+V(3),['k_{2}\prime: ',timk{3}]);
else
    ht(1)=text(10,(V(4)-V(3))*3/10-V(4),['k_{0}\prime: ',timk{1}]);
    ht(2)=text(10,(V(4)-V(3))*2/10-V(4),['k_{1}\prime: ',timk{2}]);
    ht(3)=text(10,(V(4)-V(3))/10-V(4),['k_{2}\prime: ',timk{3}]);
end
for i=1:3
    ext(i,1:4)=get(ht(i),'Extent');
end
Xv=[ext(1,1) ext(1,1)+max(ext(:,3)) ext(1,1)+max(ext(:,3)) ext(1,1)];
Yv=[min(ext(:,2)) min(ext(:,2)) max(ext(:,2))+max(ext(:,4)) max(ext(:,2))+max(ext(:,4))];
patch(Xv,Yv,[1 1 .7]);
hdr=get(hf,'Children');
ch=get(hdr,'Children');
ptch=ch(1);
for i=1:4
    ch(i)=ch(i+1);
end
ch(5)=ptch;
set(hdr,'Children',ch);
title('Calibrated Radial Distortion Curve')
xlabel('r (pixel)')
ylabel('dr (pixel)')
af=0:10:V(2);
plot(af,zeros(size(af)),'k')
grid on
hold off
