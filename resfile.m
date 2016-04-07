function resfile(ip,imnames,pointiv,extriv,...
    intriv,intrer,psf,sxy,epan,t,spost,ccm,ssyn,ground_t,spaf_uncert,comsk,sk,intrer_cy,sigma_image,sigma_ground)

% RESFILE
%   FAUCCAL supporting function that exports results 
%   in a file

if rem(ip,2)==1
    inpst=['c ';'xo';'yo';'k1';'k2';'p1';'p2'];
else
    inpst=['cx';'ar';'xo';'yo';'k1';'k2';'p1';'p2'];
end
if comsk==1
    inpst(end+1,:)='sk';
end
    

[fnsave dir]=uiputfile(...
       {'*.txt;', 'Text File'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Save Results as');
if fnsave==0
    warning('Fauccal:Results:Cancel','Cancel pressed results file saved as results.txt');
    fnsave='results.txt';
    dir=cat(2,cd,'\');
end

if isempty(regexp(fnsave,'.txt', 'once' ))
    fnsave=cat(2,fnsave,'.txt');
end
f=fopen([dir fnsave],'w');
slsh=repmat('/',1,59);
fprintf(f,'%s\n',slsh);
fprintf(f,'//Automaticaly generated results file produced by FAUCCAL//\n');
fprintf(f,'//Created by Valsamis Douskos                            //\n');
t_prod=datestr(now);
blks=repmat(' ',1,25);
fprintf(f,'//Produced: %s',t_prod);
fprintf(f,'%s//\n',blks);
fprintf(f,'%s\n',slsh);
fprintf(f,'\n%%Images%%\n');
fprintf(f,'{');
for i=1:size(imnames,2)
    fprintf(f,'%i: %s',[i,imnames{i}]);
    if i<size(imnames,2)     
        fprintf(f,'  ');
    end
end
fprintf(f,'}');

fprintf(f,'\n\n%%Adjustment Parameters%%\n');
if ground_t==1
    if spaf_uncert==1
        fprintf(f,'Control Points with a priori variance\n');
        fprintf(f,'A Priori Sigma For Image Coordinates %f\n',sigma_image);
        fprintf(f,'A Priori Sigma For Ground Coordinates %f\n',sigma_ground);
        fprintf(f,'A Priori Sigma=%i\n',1);
    else
        fprintf(f,'Fixed Control Points\n');
    end   
end
fprintf(f,'Number of Observations: %i\n',ssyn(1));
fprintf(f,'Unknowns: %i\n',ssyn(2));
fprintf(f,'Degree of Freedom: %i\n',ssyn(3));
fprintf(f,'Number of Images: %i\n',size(imnames,2));
fprintf(f,'Tie Points: %i\n',size(psf,1));
fprintf(f,'Parameters defined: ');
for i=1:ip+comsk
    fprintf(f,'%s ',inpst(i,:));
end

fprintf(f,'\n\n');
fprintf(f,'%s\n',repmat('~',1,11));
fprintf(f,'~ Results ~\n');
fprintf(f,'%s\n',repmat('~',1,11));

if spaf_uncert==1
    fprintf(f,'\n#A Posteriori Standard Error Sigma#\n');
else
    fprintf(f,'\n#A Posteriori Standard Error Sigma (pixels)#\n');
end
fprintf(f,'Sigma=%.3g\n',spost);
fprintf(f,'\n#Number Of Iterations#\n');
fprintf(f,'%i\n',epan);
fprintf(f,'\n#Time elapsed (secs)#\n');
fprintf(f,'%.4g\n',t);

fprintf(f,'\n#Central Projection Parameters (pixels)#\n');
switch ip
    case {3,5,7}
        fprintf(f,'c=%.3f',intriv(1));
        fprintf(f,' %c ',char(177));
        fprintf(f,'%.3f\n',intrer(1));
    otherwise
        fprintf(f,'cx=%.3f',intriv(1));
        fprintf(f,' %c ',char(177));
        fprintf(f,'%.3f\n',intrer(1));
        fprintf(f,'ar=%.6f',intriv(2));
        fprintf(f,' %c ',char(177));
        fprintf(f,'%.6f\n',intrer(2));
        fprintf(f,'(cy=%.3f',intriv(2)*intriv(1));
        fprintf(f,' %c ',char(177));
        fprintf(f,'%.3f)\n',intrer_cy);
end
fprintf(f,'xo=%.3f',intriv(3));
fprintf(f,' %c ',char(177));
fprintf(f,'%.3f\n',intrer(3));
fprintf(f,'yo=%.3f',intriv(4));
fprintf(f,' %c ',char(177));
fprintf(f,'%.3f\n',intrer(4));
if comsk==1
    fprintf(f,'sk=%.6f',sk);
    fprintf(f,' %c ',char(177));
    fprintf(f,'%.6f\n',intrer(ip+mod(ip,2)+comsk));
end
switch ip
    case {5,6,7,8}
        fprintf(f,'\n#Radial Distortion Parameters#\n');
        fprintf(f,'k1=%.3e',intriv(5));
        fprintf(f,' %c ',char(177));
        fprintf(f,'%.2e\n',intrer(5));
        fprintf(f,'k2=%.3e',intriv(6));
        fprintf(f,' %c ',char(177));
        fprintf(f,'%.2e\n',intrer(6));
        if (ip==7 || ip==8)
            fprintf(f,'\n#Decentering Distortion Parameters#\n');
            fprintf(f,'p1=%.3e',intriv(7));
            fprintf(f,' %c ',char(177));
            fprintf(f,'%.2e\n',intrer(7));
            fprintf(f,'p2=%.3e',intriv(8));
            fprintf(f,' %c ',char(177));
            fprintf(f,'%.2e\n',intrer(8));
        end
end

fprintf(f,'\n#Correlation Coefficients#\n');
fprintf(f,'      ');
for i=2:ip
    fprintf(f,'  %s  \t',inpst(i,:));
end
if comsk==1
    fprintf(f,'  %s  \t',inpst(end,:));
end
fprintf(f,'\n');

for i=1:ip-1+comsk
    fprintf(f,'%s\t',inpst(i,:));
    if i>1
        str=repmat('      \t',1,i-1);
        fprintf(f,str);
    end
    for j=2:ip+comsk
        if j>i
            if ccm(i,j)>0
                fprintf(f,'+');
            end
            fprintf(f,'%.3f\t',ccm(i,j));
        end
    end
    fprintf(f,'\n');
end

rcc=200/pi();
fprintf(f,'\n#Extrinsic Parameters#\n');
fprintf(f,'(Assuming that the pattern is 1 ground unit long)\n');
fprintf(f,' I/N\t\tXo(m)\t\tYo(m)\t\tZo(m)\t\tw(grad)\tf(grad)\tk(grad)\n');
for i=1:size(extriv,1)
    fprintf(f,'%4i\t%11.3f\t%11.3f\t%11.3f\t',extriv(i,1:4));
    fprintf(f,'%11.4f\t%11.4f\t%11.4f\n',extriv(i,5:7)*rcc);
end



fprintf(f,'\n#Residuals (pixels)#\n');
mtr1=1;
fprintf(f,'\n\t-----Image: %s-----\n',imnames{mtr1});
fprintf(f,' P/N\t\tvx\t\tvy\t\tsxy\n');
for i=1:size(sxy,1)
    if (i>1 && sxy(i,1)-sxy(i-1,1)>0)
        mtr1=mtr1+1;
        fprintf(f,'\n\t-----Image: %s-----\n',imnames{mtr1});
        fprintf(f,' P/N\t\tvx\t\tvy\t\tsxy\n');
    end
    fprintf(f,'%4i\t%9.3f\t%9.3f\t%10.3f',sxy(i,2:5));
    if i<size(sxy,1)
        fprintf(f,'\n');
    end
end

if ground_t==0 || spaf_uncert==1
    fprintf(f,'\n\n#Tie Points Coordinates & Errors (m)#\n');
    fprintf(f,'(Assuming that the pattern is 1 ground unit long)\n');
    fprintf(f,' P/N\t\tX\t\tY\t\tZ\t\tSx\t\tSy\t\tSz\n');
    for i=1:size(psf,1)
        fprintf(f,'%4i\t%9.3f\t%9.3f\t%9.3f\t%11.3e\t%11.3e\t%11.3e',[pointiv(i,1:4) psf(i,2:4)]);
        if i<size(psf,1)
            fprintf(f,'\n');
        end
    end
end
fclose(f);