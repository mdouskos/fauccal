% REPROJECTION
%   FAUCCAL supporting script. Called from
%   BUNDLE function for finding by back-projection 
%   remaining feature points that have been discarded  
%   during previous processes

clear impts

% im_n=M;
global imaa
global win_size

for i=1:M
    
    % Find maximum number of columns of the grid 
    % apearing in each image
    ct1=2;
    while impix{1,i}(ct1,3)~=1
        ct1=ct1+1;
    end
    mcls_a(i)=ct1-1;
end

% miss_pnts-> 1st column: number of point missing at least
%   in one image, 2nd column: numbers of images that this 
%   particular point is missing
% mp_im-> numbers of images that have missing points
% m_pim-> missing points for each image (image number=column number)
% m_pim_ind-> number of points missing in each image 
s=0;
mp_im=0;
mtr=1;
for i=1:size(miss_pnts,1)
    s=s+size(miss_pnts{i,2},2);
    for j=1:size(miss_pnts{i,2},2)    
        if isempty(mp_im(mp_im==miss_pnts{i,2}(1,j)))
            mp_im(mtr)=miss_pnts{i,2}(1,j);
            m_pim{miss_pnts{i,2}(1,j)}=miss_pnts{i,1};
            m_pim_ind(miss_pnts{i,2}(1,j))=1;
            mtr=mtr+1;
        else
            m_pim_ind(miss_pnts{i,2}(1,j))=m_pim_ind(miss_pnts{i,2}(1,j))+1;
            m_pim{miss_pnts{i,2}(1,j)}(m_pim_ind(miss_pnts{i,2}(1,j)))=miss_pnts{i,1};
        end
    end
end

win_size=round(width/40);

% Define array that holds the color code of each point
pt_col=cell(1,M);
for i=1:M
    pt_col{1,i}=ones(size(impix{i},1),1);
end

% Block of code that searches for all the missing points 
% inside the grid established in each image
swaa=1;
pt_col_t=pt_col;
for i=1:size(mp_im,2)

    im_n=mp_im(i); % set number of image to be searched for 
                   % missing points

    for j=1:size(m_pim{im_n},2)

        p_n=m_pim{im_n}(j); % set number point to be 
                            % searched for 
        
        % calculate no of column that points belongs to
        if rem(p_n,mcls_a(im_n))~=0
            cl=rem(p_n,mcls_a(im_n));
        else
            cl=mcls_a(im_n);
        end
        
        % calculate no of row that points belongs to
        % and it's correspoinding geodetic coordinates
        X=tilesize*(cl-1);
        row=((p_n-cl)/mcls_a(im_n))+1;
        Y=tilesize*(row-1);

        % call function that returns (and plots in green) 
        % the actual image corner given it's estimated 
        % image coordinates.
        [point_candidate]=nfpoints(X,Y,extriv(im_n,:),R(:,:,im_n),sk,intriv,iaffpx,iaffpy,xc{im_n},swaa);

        % if a point is found, assign it to grid edges
        % used for the bundle adjustment
        if ~isempty(point_candidate)
            impix{1,im_n}(p_n,:)=[im_n row cl p_n point_candidate(2,1) point_candidate(1,1)];
            pt_col_t{1,im_n}(p_n,1)=2;
        end
    end
end


% Block of code that searches for 3 additional rows/columns
% outside the established grid in each image
impixt=cell(1,M);
pt_col=cell(1,M);
swaa=2;
for im_n=1:M
    
    clear mrws mcls n_rows1 n_rows2 n_cols1 n_cols2
    clear ugr bgr lgc rgc ncls nrws
    
    mrws=max(impix{im_n}(:,2));
    mcls=max(impix{im_n}(:,3));

    n_rows1=cell(1,3);
    n_rows2=n_rows1;
    n_cols1=cell(1,3);
    n_cols2=n_cols1;
    bgr_pos=[];
    ugr_pos=[];
    lgc_pos=[];
    rgc_pos=[];
    % Calculate the ground coordinates of the points 
    % belonging to the three additional rows/colums 
    % outside the grid
    for i=1:4
        switch i
            case {1}
                mtr=1;
                for j=1:3
                    Y=-tilesize*j;
                    n_rows1{1,j}=zeros(2,mcls+6);
                    for k=-3:mcls+2
                        X=tilesize*k;
                        
                        % Search for each point
                        [point_candidate]=nfpoints(X,Y,extriv(im_n,:),R(:,:,im_n),sk,intriv,iaffpx,iaffpy,xc{im_n},swaa);
                        
                        % I f a point is found add it to row/column 
                        if ~isempty(point_candidate)
                            n_rows1{1,j}(:,k+4)=point_candidate(:,1);
                        end
                    end
                    
                    % Test if new rows/columns have sufficient number of
                    % points
                    if size(n_rows1{j}(1:2,n_rows1{j}(1,:)~=0&n_rows1{j}(2,:)~=0),2)>round(mcls/2)
                        bgr_pos(mtr)=j;
                        mtr=mtr+1;
                    end
                end
            % Same as above
            case{2}
                mtr=1;
                for j=1:3
                    Y=tilesize*(mrws+j-1);
                    n_rows2{1,j}=zeros(2,mcls+6);
                    for k=-3:mcls+2
                        X=tilesize*k;

                        [point_candidate]=nfpoints(X,Y,extriv(im_n,:),R(:,:,im_n),sk,intriv,iaffpx,iaffpy,xc{im_n},swaa);

                        if ~isempty(point_candidate)
                            n_rows2{1,j}(:,k+4)=point_candidate(:,1);
                        end
                    end

                    if size(n_rows2{j}(1:2,n_rows2{j}(1,:)~=0&n_rows2{j}(2,:)~=0),2)>round(mcls/2)
                        ugr_pos(mtr)=j;
                        mtr=mtr+1;
                    end
                end
            % Same as above
            case{3}
                mtr=1;
                for j=1:3
                    X=-tilesize*j;
                    n_cols1{1,j}=zeros(2,mrws);
                    for k=0:mrws-1
                        Y=tilesize*k;

                        [point_candidate]=nfpoints(X,Y,extriv(im_n,:),R(:,:,im_n),sk,intriv,iaffpx,iaffpy,xc{im_n},swaa);

                        if ~isempty(point_candidate)
                            n_cols1{1,j}(:,k+1)=point_candidate(:,1);
                        end
                    end

                    if size(n_cols1{j}(1:2,n_cols1{j}(1,:)~=0&n_cols1{j}(2,:)~=0),2)>round(mrws/2)
                        lgc_pos(mtr)=j;
                        mtr=mtr+1;
                    end
                end
            % Same as above
            case{4}
                mtr=1;
                for j=1:3
                    X=tilesize*(mcls+j-1);
                    n_cols2{1,j}=zeros(2,mrws);
                    for k=0:mrws-1
                        Y=tilesize*k;

                        [point_candidate]=nfpoints(X,Y,extriv(im_n,:),R(:,:,im_n),sk,intriv,iaffpx,iaffpy,xc{im_n},swaa);

                        if ~isempty(point_candidate)
                            n_cols2{1,j}(:,k+1)=point_candidate(:,1);
                        end
                    end
                    if size(n_cols2{j}(1:2,n_cols2{j}(1,:)~=0&n_cols2{j}(2,:)~=0),2)>round(mrws/2)
                        rgc_pos(mtr)=j;
                        mtr=mtr+1;
                    end
                end
        end
    end
    % Consider missing rows/columns (gaps)
    if ~isempty(bgr_pos)
        bgr=max(bgr_pos);
    else
        bgr=0;
    end
    if ~isempty(ugr_pos)
        ugr=max(ugr_pos);
    else
        ugr=0;
    end
    if ~isempty(lgc_pos)
        lgc=max(lgc_pos);
    else
        lgc=0;
    end
    if ~isempty(rgc_pos)
        rgc=max(rgc_pos);
    else
        rgc=0;
    end

    % New number of rows/columns
    ncls=mcls+lgc+rgc;
    nrws=mrws+bgr+ugr;
    
    % Add points belonging to new rows/columns to the bundle adjustment and
    % plot all this points (red color)
    impixt{im_n}=zeros(ncls*nrws,6);
    pt_col{im_n}=ones(ncls*nrws,1);
    for i=1:nrws
        for j=1:ncls
            n_ind=ncls*(i-1)+j;
            
            if i<=bgr
                if ~isempty(bgr_pos(1,bgr_pos(1,:)==bgr-i+1))
                    ind=(bgr_pos(1,:)==bgr-i+1);
                    if j<=lgc
                        if ~isempty(lgc_pos(1,lgc_pos(1,:)==lgc-j+1))
                            impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                                n_rows1{1,ind}(2,j-lgc+3) n_rows1{1,ind}(1,j-lgc+3)];
                            pt_col{1,im_n}(n_ind,1)=3;
                        else
                            impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                            pt_col{1,im_n}(n_ind,1)=1;
                        end
                    elseif j>mcls+lgc
                        if ~isempty(rgc_pos(1,rgc_pos(1,:)==j-mcls-lgc))
                            impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                                n_rows1{1,ind}(2,j-lgc+3) n_rows1{1,ind}(1,j-lgc+3)];
                            pt_col{1,im_n}(n_ind,1)=3;
                        else
                            impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                            pt_col{1,im_n}(n_ind,1)=1;
                        end
                    else
                        impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                            n_rows1{1,ind}(2,j-lgc+3) n_rows1{1,ind}(1,j-lgc+3)];
                        pt_col{1,im_n}(n_ind,1)=3;
                    end
                else
                    impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                    pt_col{1,im_n}(n_ind,1)=1;
                end
                
            elseif i>mrws+bgr
                if ~isempty(ugr_pos(1,ugr_pos(1,:)==i-mrws-bgr))
                    ind=(ugr_pos(1,:)==i-mrws-bgr);                         
                    if j<=lgc
                        if ~isempty(lgc_pos(1,lgc_pos(1,:)==lgc-j+1))
                            impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                                n_rows2{1,ind}(2,j-lgc+3) n_rows2{1,ind}(1,j-lgc+3)];
                            pt_col{1,im_n}(n_ind,1)=3;
                        else
                            impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                            pt_col{1,im_n}(n_ind,1)=1;
                        end
                    elseif j>mcls+lgc
                        if ~isempty(rgc_pos(1,rgc_pos(1,:)==j-mcls-lgc))
                            impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                                n_rows2{1,ind}(2,j-lgc+3) n_rows2{1,ind}(1,j-lgc+3)];
                            pt_col{1,im_n}(n_ind,1)=3;
                        else
                            impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                            pt_col{1,im_n}(n_ind,1)=1;
                        end
                    else
                        impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                            n_rows2{1,ind}(2,j-lgc+3) n_rows2{1,ind}(1,j-lgc+3)];
                         pt_col{1,im_n}(n_ind,1)=3;
                    end
                else
                    impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                    pt_col{1,im_n}(n_ind,1)=1;
                end                
            else
                if j<=lgc
                    if ~isempty(lgc_pos(1,lgc_pos(1,:)==lgc-j+1))
                        ind=(lgc_pos(1,:)==lgc-j+1);
                        impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                            n_cols1{1,ind}(2,i-bgr) n_cols1{1,ind}(1,i-bgr)];
                        pt_col{1,im_n}(n_ind,1)=3;
                    else
                        impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                        pt_col{1,im_n}(n_ind,1)=1;
                    end
                elseif j>mcls+lgc
                    if ~isempty(rgc_pos(1,rgc_pos(1,:)==j-mcls-lgc))
                        ind=(rgc_pos(1,:)==j-mcls-lgc);
                        impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                            n_cols2{1,ind}(2,i-bgr) n_cols2{1,ind}(1,i-bgr)];
                        pt_col{1,im_n}(n_ind,1)=3;
                    else
                        impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                        pt_col{1,im_n}(n_ind,1)=1;
                    end
                else
                    ind=mcls_a(im_n)*(i-bgr-1)+(j-lgc);
                    if ind<=size(impix{im_n},1)         
                        impixt{im_n}(n_ind,:)=[im_n i j n_ind...
                            impix{im_n}(ind,5) impix{im_n}(ind,6)];
                        if n_ind>size(pt_col{1,im_n},1)
                            pt_col{1,im_n}(n_ind,1)=1;
                        end
                        if pt_col_t{1,im_n}(ind,1)==2
                            pt_col{1,im_n}(n_ind,1)=2;
                        end
                    else
                        impixt{im_n}(n_ind,:)=[0 0 j 0 0 0];
                        pt_col{1,im_n}(n_ind,1)=1;
                    end
                end
            end
        end
    end
    for i=1:size(impixt{im_n},1)
        if impixt{im_n}(i,5)==0 && impixt{im_n}(i,6)==0
            j=impixt{im_n}(i,3);
            impixt{im_n}(i,:)=[0 0 j 0 0 0];
        end
    end
end

clear impix pt_col_t


clmns=zeros(M);
for i=1:M
    % New maximum number of columns
    clmns(i)=max(impixt{i}(:,3));
    % Concatenate pt_col to impix matrix
    impixt{i}=cat(2, impixt{i}, pt_col{i});
end

% Rearrange point numbers to corrspond to grids that all have 
% the same number of columns
impix=rearrange(impixt,rows,clmns,M);
clear impixt clmns mcls