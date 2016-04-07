% BUNSOL
%   FAUCCAL supporting script 
%   performing a bundle adjustment

clear ind2 dl A
if ground_t==0;
    ind2=6*(M-1)-1;
else
    ind2=6*M;
end
dl=zeros(2*par+agg_par,1);
A=sparse(2*par+agg_par,ind2+3*spaf+ip+comsk);
r=2*par+agg_par-(ind2+3*spaf+ip+comsk);
point_kn=pointiv;

krit=1;
test1=1;
epan=0;
sw=0;
sker=1;
spost_old=0;
spost=0;

%while abs(spost-spost_old)>sigma_image*.0001 || epan<2
if ip > 3
    dxin(1:4)=1;
else
    dxin(1:3)=1;
    dxin(4) = 0;
end
while max(abs(dxin(1:4)))>basic_kr
    if epan~=0
        % R and f Matrixes
        for i=1:M
            cosw=cos(extriv(i,5));
            sinw=sin(extriv(i,5));
            cosf=cos(extriv(i,6));
            sinf=sin(extriv(i,6));
            cosk=cos(extriv(i,7));
            sink=sin(extriv(i,7));
            R(:,:,i)=[cosf*cosk, cosw*sink+sinw*sinf*cosk, sinw*sink-cosw*sinf*cosk;
                -cosf*sink, cosw*cosk-sinw*sinf*sink, sinw*cosk+cosw*sinf*sink;
                sinf, -sinw*cosf, cosw*cosf];
            f(:,:,i)=[-sinf*cosk,sinw*cosf*cosk,-cosw*cosf*cosk;
                sinf*sink,-sinw*cosf*sink,cosw*cosf*sink;
                cosf,sinw*sinf,-cosw*sinf];
        end
    end
    clear sinw sinf sink cosw cosf cosk

    mtr1=1;
    mtr2=1;
    mtr3=1;
    m_pn_i=max(pnt_ind(:,1));
    % fill A matrix and dl vector
    while mtr1<=kr
        t1=impoint00(mtr1,4);
        t2=pnt_ind(mtr2,1);
        if t1==t2
            in=impoint00(mtr1,1);
            if dd==1
                fc=factorsdd(pointiv(mtr2,:),intriv,extriv(in,:),R(:,:,in),f(:,:,in),impoint00(mtr1,5:6),ip,comsk,sk);
            else
                fc=factors(pointiv(mtr2,:),intriv,extriv(in,:),R(:,:,in),f(:,:,in),ip,comsk,sk);
            end
            if in<imex
                if in<imX
                    A(2*mtr3-1,6*(in-1)+1:6*in)=fc(1,1:6);
                    A(2*mtr3,6*(in-1)+1:6*in)=fc(2,1:6);
                elseif in==imX
                    A(2*mtr3-1,6*(in-1)+1:6*in-1)=fc(1,2:6);
                    A(2*mtr3,6*(in-1)+1:6*in-1)=fc(2,2:6);
                else
                    A(2*mtr3-1,6*(in-1):6*in-1)=fc(1,1:6);
                    A(2*mtr3,6*(in-1):6*in-1)=fc(2,1:6);
                end
            elseif in>imex
                if in<imX
                    A(2*mtr3-1,6*(in-2)+1:6*(in-1))=fc(1,1:6);
                    A(2*mtr3,6*(in-2)+1:6*(in-1))=fc(2,1:6);
                elseif in==imX
                    A(2*mtr3-1,6*(in-2)+1:6*(in-1)-1)=fc(1,2:6);
                    A(2*mtr3,6*(in-2)+1:6*(in-1)-1)=fc(2,2:6);
                else
                    A(2*mtr3-1,6*(in-2):6*(in-1)-1)=fc(1,1:6);
                    A(2*mtr3,6*(in-2):6*(in-1)-1)=fc(2,1:6);
                end
            end
            if ground_t==0 || spaf_uncert==1
                A(2*mtr3-1,ind2+3*(mtr2-1)+1:ind2+3*mtr2)=fc(1,7:9);
                A(2*mtr3,ind2+3*(mtr2-1)+1:ind2+3*mtr2)=fc(2,7:9);
            end
            switch ip
                case 3
                    A(2*mtr3-1,ind2+3*spaf+1:ind2+3*spaf+ip)=[fc(1,10) fc(1,12:13)];
                    A(2*mtr3,ind2+3*spaf+1:ind2+3*spaf+ip)=[fc(2,10) fc(2,12:13)];
                case 4
                    A(2*mtr3-1,ind2+3*spaf+1:ind2+3*spaf+ip)=fc(1,10:13);
                    A(2*mtr3,ind2+3*spaf+1:ind2+3*spaf+ip)=fc(2,10:13);
                case 5
                    A(2*mtr3-1,ind2+3*spaf+1:ind2+3*spaf+ip)=[fc(1,10) fc(1,12:15)];
                    A(2*mtr3,ind2+3*spaf+1:ind2+3*spaf+ip)=[fc(2,10) fc(2,12:15)];
                case 6
                    A(2*mtr3-1,ind2+3*spaf+1:ind2+3*spaf+ip)=fc(1,10:15);
                    A(2*mtr3,ind2+3*spaf+1:ind2+3*spaf+ip)=fc(2,10:15);
                case 7
                    A(2*mtr3-1,ind2+3*spaf+1:ind2+3*spaf+ip)=[fc(1,10) fc(1,12:17)];
                    A(2*mtr3,ind2+3*spaf+1:ind2+3*spaf+ip)=[fc(2,10) fc(2,12:17)];
                case 8
                    A(2*mtr3-1,ind2+3*spaf+1:ind2+3*spaf+ip)=fc(1,10:17);
                    A(2*mtr3,ind2+3*spaf+1:ind2+3*spaf+ip)=fc(2,10:17);
            end
            if comsk==1;
                A(2*mtr3-1,ind2+3*spaf+ip+1)=[fc(1,19)];
                A(2*mtr3,ind2+3*spaf+ip+1)=[fc(2,19)];
            end
            dl(2*mtr3-1,1)=impoint00(mtr1,5)-fc(1,18);
            dl(2*mtr3,1)=impoint00(mtr1,6)-fc(2,18);
            v_ind(2*mtr3-1,1:2)=[t1 impoint00(mtr1,1)];
            v_ind(2*mtr3,1:2)=v_ind(2*mtr3-1,1:2);
            mtr1=mtr1+1;
            mtr2=mtr2+1;
            mtr3=mtr3+1;
        elseif t1<t2
            mtr1=mtr1+1;
        elseif t1>t2
            in=impoint00(mtr1,1);
            if t1>m_pn_i & in<M
                while impoint00(mtr1,4)>m_pn_i
                    mtr1=mtr1+1;
                end
                mtr2=1;
            elseif t1>m_pn_i & in==M
                break
            else
                mtr2=mtr2+1;
            end
        end
        if (t2==m_pn_i | t2==max(impts{in}(:,4)))
            mtr2=1;
        end
    end
    
    if spaf_uncert==1
        for i=1:spaf
            A(2*par+3*i-2,ind2+3*i-2)=1;
            A(2*par+3*i-1,ind2+3*i-1)=1;
            A(2*par+3*i,ind2+3*i)=1;
            dl(2*par+3*i-2,1)=point_kn(i,2)-pointiv(i,2);
            dl(2*par+3*i-1,1)=point_kn(i,3)-pointiv(i,3);
            dl(2*par+3*i,1)=point_kn(i,4)-pointiv(i,4);
        end
    end
    
    % Minimal squares solution
    if spaf_uncert==1
        Nmat=A'*P*A;
        n=A'*P*dl;
    else
        Nmat=A'*A;
        n=A'*dl;
    end
    
    dx=Nmat\n;
    
    % Update unknown parameters values
    switch ip
        case {3,5,7}
            dxin(1:ip) = dx(ind2+3*spaf+1:ind2+3*spaf+ip)';
            intriv(1)=intriv(1)+dxin(1);
            intriv(3:ip+1)=intriv(3:ip+1)+dxin(2:ip);
        otherwise
            dxin(1:ip)= dx(ind2+3*spaf+1:ind2+3*spaf+ip)';
            intriv(1:ip)=intriv(1:ip)+dxin(1:ip);
    end
  
    if comsk==1
        sker=dx(end);
        sk=sk+sker;
    else
        sker=0;
    end

    for i=1:M
        if i<imex
            if i<imX
                extriv(i,2:7)=extriv(i,2:7)+dx(6*(i-1)+1:6*i)';
                dxe1(3*(i-1)+1:3*i)=dx(6*(i-1)+1:6*i-3);
                dxe2(3*(i-1)+1:3*i)=dx(6*i-2:6*i);
            elseif i==imX
                extriv(i,3:7)=extriv(i,3:7)+dx(6*(i-1)+1:6*i-1)';
                dxe1(3*(i-1)+1:3*i-1)=dx(6*(i-1)+1:6*i-4);
                dxe2(3*(i-1)+1:3*i)=dx(6*i-3:6*i-1);
            else
                extriv(i,2:7)=extriv(i,2:7)+dx(6*(i-1):6*i-1)';
                dxe1(3*(i-1):3*i-1)=dx(6*(i-1):6*i-4);
                dxe2(3*(i-1)+1:3*i)=dx(6*i-3:6*i-1);
            end
        elseif i>imex
            if i<imX
                extriv(i,2:7)=extriv(i,2:7)+dx(6*(i-2)+1:6*(i-1))';
                dxe1(3*(i-2)+1:3*(i-1))=dx(6*(i-2)+1:6*(i-1)-3);
                dxe2(3*(i-2)+1:3*(i-1))=dx(6*(i-1)-2:6*(i-1));
            elseif i==imX
                extriv(i,3:7)=extriv(i,3:7)+dx(6*(i-2)+1:6*(i-1)-1)';
                dxe1(3*(i-2)+1:3*(i-1)-1)=dx(6*(i-2)+1:6*(i-1)-4);
                dxe2(3*(i-2)+1:3*(i-1))=dx(6*(i-1)-3:6*(i-1)-1);
            else
                extriv(i,2:7)=extriv(i,2:7)+dx(6*(i-2):6*(i-1)-1)';
                dxe1(3*(i-2):3*(i-1)-1)=dx(6*(i-2):6*(i-1)-4);
                dxe2(3*(i-2)+1:3*(i-1))=dx(6*(i-1)-3:6*(i-1)-1);
            end
        end
    end

    if ground_t==0 || spaf_uncert==1
        for i=1:spaf
            pointiv(i,2:4)=pointiv(i,2:4)+dx(ind2+3*(i-1)+1:ind2+3*i)';
        end
        dxp=dx(ind2+1:ind2+3*spaf)';
    else
        dxp=0;
    end
  
    % Test critirion for loop termination
    switch ip
        case {3}
            test1=[abs(dxin(1:ip))>1e-3 abs(dxe1)>1e-4 abs(dxe2)>1e-6 abs(dxp)>1e-4];
        case {4}    
            test1=[abs(dxin(1))>1e-3 abs(intriv(1)*dxin(2))>1e-3 abs(dxin(3:ip))>1e-3 abs(dxe1)>1e-4 abs(dxe2)>1e-6 abs(dxp)>1e-4];
        case {5,7}
            test1=[abs(dxin(1:3))>1e-3 abs(dxin(4:ip))>1e-12  abs(dxe1)>1e-4 abs(dxe2)>1e-6 abs(dxp)>1e-4];
        otherwise
            test1=[abs(dxin(1))>1e-3 abs(intriv(1)*dxin(2))>1e-3 abs(dxin(3:4))>1e-3 abs(dxin(5:ip))>1e-12 abs(dxe1)>1e-4 abs(dxe2)>1e-6 abs(dxp)>1e-4];
    end
    
    krit=[dxin dxe1 dxe2 dxp];
  
    epan=epan+1;
    if epan>max_iter
        errordlg('Bundle adjustment can not converge','Error')
        res=0;
        return;
    end

v=A*dx-dl;
spost_old=spost;
    % A posteriori sigma
    if spaf_uncert==1
        so2post=(v'*P*v)/r;
    else
        so2post=(v'*v)/r;
    end
    spost=sqrt(so2post);
    fprintf('Iteration: %d sigma: %f \n',epan,spost);
end



Na=inv(Nmat);
switch ip
    case {3,5,7}
        intriv(2)=1;
end
if dd==1
    intriv(5)=intriv(5)/100^2;
    intriv(6)=intriv(6)/100^4;
    intriv(7:8)=intriv(7:8)/100;
end
clear Nmat n krit test1 dxe1 dxe2 dxin dxp f fc

% Calculate residuals and other statistical values
if ~isnan(intriv(1))
    st_syn=[2*par+agg_par,ind2+3*spaf+ip+comsk,r];
    
    % A priori V matrix
    Vxprio=Na;
    v=A*dx-dl;
    for i=1:par
        sxy(i,1:5)=[v_ind(2*i-1,2),v_ind(2*i-1,1),v(2*i-1,1),v(2*i,1),...
            norm([v(2*i-1),v(2*i)])];
    end
    
    % A posteriori sigma
    if spaf_uncert==1
        so2post=(v'*P*v)/r;
    else
        so2post=(v'*v)/r;
    end
    spost=sqrt(so2post);
    
    % A posteriori V matrix
    Vxpost=Vxprio*so2post;

    psf=zeros(size(pointiv,1),4);
    if ground_t==0 || spaf_uncert==1
        for i=1:size(pointiv,1)
            psf(i,1)=pointiv(i,1);
            psf(i,2)=sqrt(Vxpost(ind2+3*(i-1)+1,ind2+3*(i-1)+1));
            psf(i,3)=sqrt(Vxpost(ind2+3*(i-1)+2,ind2+3*(i-1)+2));
            psf(i,4)=sqrt(Vxpost(ind2+3*(i-1)+3,ind2+3*(i-1)+3));
        end
    end

    intrer=zeros(1,9);
    switch ip
        case {3,5,7}
            intrer(1)=sqrt(Vxpost(ind2+3*spaf+1,ind2+3*spaf+1));
            intrer(2)=intrer(1);
            for i=2:ip+comsk
                intrer(i+1)=sqrt(Vxpost(ind2+3*spaf+i,ind2+3*spaf+i));
            end
        otherwise
            for i=1:ip+comsk
                intrer(i)=sqrt(Vxpost(ind2+3*spaf+i,ind2+3*spaf+i));
            end
    end
    if dd==1
        intrer(5)=intrer(5)/100^2;
        intrer(6)=intrer(6)/100^4;
        intrer(7:8)=intrer(7:8)/100;
    end
    
    
    clear dx A dl Na ans i j l

    Vm=Vxpost(end-ip+1-comsk:end,end-ip+1-comsk:end);
    Vei=[Vxpost(1:ind2,1:ind2) Vxpost(1:ind2,end-ip+1:end)
         Vxpost(end-ip+1:end,1:ind2) Vxpost(end-ip+1:end,end-ip+1:end)];
    
    % Correlation Coefficients
    ccmat=corcoef(Vm);
    ccmatei=corcoef(Vei);
    
    clear ind2
    
    epan;
    t=toc;
    fprintf('Time Elapsed: %f \n',toc);
    res=1;
    
elseif (ch==2 && isnan(intriv(1)))
    warning('Second adjustment did not converge, returned to first solution.');
    intriv=inbk;extriv=exbk;epan=epanb;t=tb;ip=ip+1;
    res=1;
else
    errordlg('Bundle adjustment did not converge','Error')
    res=0;
end