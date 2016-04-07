function bundle(hands)

% BUNDLE
%   FAUCCAL Toolbox main function.
%   Calls functions that relate
%   points, find vanish points, 
%   calculate initial values and 
%   perform the bundle solution.
%   It also calls the functions 
%   that print the results

ip=hands.ipsec+hands.ipbas;
comsk=hands.ipsk;
ground_t=hands.ground;
mess_xy=hands.mess;
sw22=hands.bproj;
spaf_uncert=hands.uncert;
sigma_image=hands.s_im;
sigma_ground=hands.s_gr;
dd=hands.dd;
meth=hands.meth;
basic_kr=hands.basic_kr;
max_iter=hands.max_iter;
h_resize=hands.resize;
clear hands

global width
global height
global ex_pnt

if ground_t==0 || spaf_uncert==0
    sigma_image=1;
    sigma_ground=1;
end

warning off

% Image Input 
swch=1;

[imname,dir,filter]=uigetfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.tiff;*.png','All Image File Formats';...
        '*.bmp','BMP-Windows Bitmap';...
        '*.gif','GIF-CompuServe Bitmap';...
        '*.jpg;*.jpeg','JPG-JPEG Bitmaps';...
        '*.tif;*.tiff','TIF-TIFF Bitmap'},...
        'Select Images','multiselect','on');

    
if filter~=0
    im_inf=imfinfo([dir imname{1}]);
    %             mkdir(dir,'tifs');
    %             mkdir(dir,'figs');
    width=im_inf.Width;
    height=im_inf.Height;
    
    %Number of images
    M=size(imname,2);
    
    if M<2
         errordlg('Please select at least 2 images','Error')
         return
    end
    
    for i=1:M
        im_inf=imfinfo([dir imname{i}]);
        if im_inf.Width~=width || im_inf.Height~=height
            errordlg('Images must have the same dimensions','Error')
            return
        end
    end
else
    errordlg('Please select at least 2 images','Error')
    return
end

warning on

clear imnew i

% Maximum Distance from Image Center for
% Radial Distortion Curve Calibration
rmax=.85*sqrt((width/2)^2+(height/2)^2);

% Data for affine transformation
ims=[height width];
imc=[1,1;1,ims(2);ims(1),1;ims(1),ims(2)];
negs=(ims-1)/2;
ximr=[-negs(2);negs(2);-negs(2);negs(2)];
yimr=[negs(1);negs(1);-negs(1);-negs(1)];

% Affine transformation
[affpx,affpy]=affine(imc,ximr,yimr);
[iaffpy,iaffpx]=affine([ximr,yimr],imc(:,1),imc(:,2));
clear ximr yimr imc ims negs

sw10=0;
for xcind=1:M
    xcnew{xcind}=[];
end

ni=ones(1,M);
impixt=cell(1,M);
rows=zeros(1,M);
clmns=zeros(1,M);
xc=cell(1,M);
xyerr=cell(1,M);
% Call of function that finds points and their 
% correspondences
h = waitbar(0,'Establishing image points correspondences, please wait...');
for i=1:M
    try
    [impixt{i} rows(i) clmns(i) xc{i} xyerr{i}]=...
        relpnt(dir,imname{i},i,ni(i),meth,sw10,xcnew{i},mess_xy,h_resize);

        waitbar(i/M,h,['Establishing image points correspondences, please wait...'...
            sprintf('\nProcessing Image %i of %i',i,M)]);
    catch ME
        errordlg('An error has occured please try again','Error')
        if h~=0 && ishandle(h)
            close(h)
        end
        fprintf('Error while processing image: %s, try removing it\n',imname{i})
        rethrow(ME)
    end
end
if h~=0 && ishandle(h)
    close(h)
end


% Rearrange point numbers to corrspond to grids that all have 
% the same number of columns
impix=rearrange(impixt,rows,clmns,M);

ep=0;

sw33=0;
sw44=0;
sw55=0;
warning off
while swch==1
    tic
    if sw33==0
        % Vanish Points Calculation
        for i=1:M
            [xv(i,:) yv(i,:) impts{i} pntn(i) sigc(i) kiv(i,:)]=...
                vpts(impix{i},xc{i},xyerr{i},affpx,affpy,rmax);
        end
    end
    
    kr_rep=1;
    while kr_rep==1
        for i=1:M
            if (isnan(impts{i}(1,5)) || isnan(impts{i}(1,6)))
                kr_rep=1;
                
                impixt{i}=[];
                impix{i}=[];
                xc{i}=[];
                xyerr{i}=[];
                impts{i}=[];
                kiv(i,:)=0;             

                im_str=sprintf('%i',i);
                h = waitbar(0,['Few points on perimiter at image ',im_str,...
                    sprintf('\nReprocessing Image, please wait...')]);

                try
                impixt{i}=[];
                ni(i)=ni(i)+1;
                [impixt{i} rows(i) clmns(i) xc{i} xyerr{i}]=...
                    relpnt(dir,imname{i},i,ni(i),meth,sw10,xcnew{i},mess_xy);
                
                warning off
                
                waitbar(1,h,['Few points on perimiter at image ',im_str,...
                     sprintf('\nReprocessing Image, please wait...')]);
                    catch ME
                        close(h)
                        return
                    end
                try
                    close(h)
                end              
            else 
                kr_rep=0;
            end
            
            if kr_rep==1
                % Rearrange point numbers to corrspond to grids that all have
                % the same number of columns
                impix=rearrange(impixt,rows,clmns,M);

                for i=1:M
                    [xv(i,:) yv(i,:) impts{i} pntn(i) sigc(i) kiv(i,:)]=...
                        vpts(impix{i},xc{i},xyerr{i},affpx,affpy,rmax);
                end
            end
        end
    end
    
    clear impixt clmns 
    
    if ep>0
        clear pnt_ind pointiv N cosf cosk cosw ...
            indc kr m_pn_i par sinf sink sinw spaf t1 t2...
            c pntn R f impoint00 v_ind sxy v miss_pnts intriv extriv imX imex
    end
    
    % Calculation of initial values
    initval % script that calculates initial values (see initval.m)
    intrivs=intriv; extrivs=extriv; pointivs=pointiv;
    Rs=R;fs=f;ch=1;
    sk=0;
    
    sxy=zeros(par,5);
    
    % Bundle adjustment solution
    bunsol % script that performs the bundle adjustment (see bunsol.m) 
    
    % checks which points have residuals greater than
    % the limit of 3*sigma and resolve without them
    % if asked by user
    if sw22==0 && res==1 
        % Define array that holds the color code of each point and
        % concatenate this array to impix matrix
        if sw44==0
            pt_col=cell(1,M);
            for i=1:M
                pt_col{1,i}=ones(size(impix{i},1),1);
            end
            for i=1:M
                impix{i}=cat(2, impix{i}, pt_col{i});
            end
        end
        % Concatenate sxy to impix matrix
        if sw55==0
            sw55=1;
            for i=1:M
                clear a s_s
                a=sxy(sxy(:,1)==i,:);
                for j=1:size(impix{i},1)
                    if impix{i}(j,4)~=0
                        ind=find(a(:,2)==impix{i}(j,4),1);
                        s_s(j,1:2)=[a(ind,3) a(ind,4)];
                    else
                        s_s(j,1:2)=0;
                    end
                end
                impix{i}=cat(2,impix{i},s_s);
            end
        end
        struct.dir=dir;
        struct.imname=imname;
        struct.impix=impix;
        try
            h_p=plot_center('plot_c',struct);
        end
        sw33=1;
        ex_pnt=[];
        f_pnts=(sxy(find(sxy(:,5)>2.96*spost*sigma_image),:));
        if ~isempty(f_pnts)
            exclude('myinit',exclude,f_pnts);
            waitfor(exclude)
        end
        if ~isempty(ex_pnt)
            try
                close(h_p)
            end
            for i=1:size(ex_pnt,1)
                if ex_pnt(i,2)==1
                    impix{ex_pnt(i,1)}(ex_pnt(i,2),1)=0;
                    impix{ex_pnt(i,1)}(ex_pnt(i,2),2:4)=[1 1 1];
                    impts{ex_pnt(i,1)}(ex_pnt(i,2),1)=0;
                    impts{ex_pnt(i,1)}(ex_pnt(i,2),2:4)=[1 1 1];
                else
                    impix{ex_pnt(i,1)}(ex_pnt(i,2),1:4)=0;
                    impts{ex_pnt(i,1)}(ex_pnt(i,2),1:4)=0;
                end
            end
        else
            swch=0;
        end
    else
        swch=0;
    end
    ep=ep+1;
    
    if sw22==1 && res==1
        sw22=0;
        if ground_t==1
            swch=1;
            reprojection % script for back-projection of the missing points (see reprojection.m)                      
            sw44=1;
        else
            mtr=1;
            for i=1:size(pointiv,1)-1
                if pointiv(i+1,2)>pointiv(i,2)
                    aa(mtr)=pointiv(i+1,2)-pointiv(i,2);
                    mtr=mtr+1;
                end
            end
            tilesize=mean(aa); % recalculate tilesize
        end
    end
end
warning on

% Print of the final results
if res==1
    intrer_cy=full(sqrt((intriv(2)^2*Vm(1,1))+...
        (intriv(1)^2*Vm(2,2))+...
        2*intriv(2)*intriv(1)*Vm(1,2)));
    cbdata{1}=intriv;
    cbdata{2}=intrer;
    cbdata{3}=ip;
    cbdata{4}=spost;
    cbdata{5}=[intriv(2)*intriv(1), intrer_cy];
    cbdata{6}=[sk,intrer(ip+mod(ip,2)+comsk),comsk];
    cbdata{7}=ground_t;

    Results('mycb',Results,cbdata)
    
    % Export of results file
    resfile(ip,imname,pointiv,extriv,...
        intriv,intrer,psf,sxy,epan,t,spost,ccmat,st_syn,ground_t,spaf_uncert,comsk,sk,intrer_cy,sigma_image,sigma_ground);
    
    % Radial Distortion Curve Calibration and Plot
    if (ip>=5)
        figure(M+1)
        set(M+1,'Name','Calibrated Radial Distortion Curve');
        plotdc(intriv,rmax,M);
%         saveas(gcf, [cd '\curve'], 'tiffn')
%         saveas(gcf, [cd '\curve'], 'fig')
    end
end