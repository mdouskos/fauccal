% VPSOL 
%   FAUCCAL supporting script that performs a 
%   least squares solution for estimating 
%   vanish points coordinates with simultaneous
%   estimation of radial distortion parameters

% Least squares solution with vanish line
sigc=inf;
SYN=0;
lenxv=length(xv(isfinite(xv)));
if (lenxv>2 && isfinite(xv(1)) && isfinite(xv(2)) && rs>3 && cs>3)
    xv2=xv;
    inlp2=inlp;
    ina2=ina;
    inc2=inc;
    yv2=yv;
    k2=kiv;
    spost=inf;
    term=0;
    if  ~isfinite(xv(3))
        obs=obsnh+obsnv+obsnd1; % Observation number
        un=5+lnh+lnv+lnd1;      % Unknown number
    elseif ~isfinite(xv(4))
        obs=obsnh+obsnv+obsnd2;
        un=5+lnh+lnv+lnd2;
    else
        obs=obsnh+obsnv+obsnd1+obsnd2;
        un=6+lnh+lnv+lnd1+lnd2;
    end
    A=zeros(obs,un);
    dl=zeros(obs,1);
    v=0;
    r=obs-un;
    
    % Least squares solution
    while term==0
        clear hia hic
        i=1;
        pon=1;
        mtr=1;
        lnum=1;
        % Fill A matrix and dl vector
        while pon~=0
            mtr2=0;
            if isfinite(xv2(i))
                for j=1:(lena(i)+lenc(i))
                    switch (i)
                        case 1
                            while length(horl(j+mtr2,(horl(j+mtr2,:)>0)))<3 
                                mtr2=mtr2+1;
                            end
                            for k=1:size(horl,2)
                                if horl(j+mtr2,k)~=0
                                    pntx=impoint00(impoint00(:,4)==horl(j+mtr2,k),5);
                                    pnty=impoint00(impoint00(:,4)==horl(j+mtr2,k),6);
                                    fcv=fcvprd(xv2(i),yv2(i),inlp2,k2,ina2(i,j+mtr2),inc2(i,j+mtr2),pntx,pnty);
                                    A(mtr,1)=fcv(1);
                                    if lenxv==4
                                        A(mtr,5:8)=fcv(2:5);
                                        A(mtr,8+lnum)=fcv(6);
                                    else
                                        A(mtr,4:7)=fcv(2:5);
                                        A(mtr,7+lnum)=fcv(6);
                                    end
                                    dl(mtr,1)=-fcv(7);
                                    mtr=mtr+1;
                                end
                            end
                            lnum=lnum+1;
                        case 2
                            while length(verl(j+mtr2,(verl(j+mtr2,:)>0)))<=2
                                mtr2=mtr2+1;
                            end
                            for k=1:size(verl,2)
                                if verl(j+mtr2,k)~=0
                                    pntx=impoint00(impoint00(:,4)==verl(j+mtr2,k),5);
                                    pnty=impoint00(impoint00(:,4)==verl(j+mtr2,k),6);
                                    fcv=fcvprd(xv2(i),yv2(i),inlp2,k2,ina2(i,j+mtr2),inc2(i,j+mtr2),pntx,pnty);
                                    A(mtr,2)=fcv(1);
                                    if lenxv==4
                                        A(mtr,5:8)=fcv(2:5);
                                        A(mtr,8+lnum)=fcv(6);
                                    else
                                        A(mtr,4:7)=fcv(2:5);
                                        A(mtr,7+lnum)=fcv(6);
                                    end
                                    dl(mtr,1)=-fcv(7);
                                    mtr=mtr+1;
                                end
                            end
                            lnum=lnum+1;
                        case 3
                            while length(diag2(j+mtr2,(diag2(j+mtr2,:)>0)))<=2
                                mtr2=mtr2+1;
                            end
                            for k=1:size(diag2,2)
                                if diag2(j+mtr2,k)~=0
                                    pntx=impoint00(impoint00(:,4)==diag2(j+mtr2,k),5);
                                    pnty=impoint00(impoint00(:,4)==diag2(j+mtr2,k),6);
                                    fcv=fcvprd(xv2(i),yv2(i),inlp2,k2,ina2(i,j+mtr2),inc2(i,j+mtr2),pntx,pnty);
                                    A(mtr,3)=fcv(1);
                                    if lenxv==4
                                        A(mtr,5:8)=fcv(2:5);
                                        A(mtr,8+lnum)=fcv(6);
                                    else
                                        A(mtr,4:7)=fcv(2:5);
                                        A(mtr,7+lnum)=fcv(6);
                                    end
                                    dl(mtr,1)=-fcv(7);
                                    mtr=mtr+1;
                                end
                            end
                            lnum=lnum+1;
                        case 4
                            while length(diag1(j+mtr2,(diag1(j+mtr2,:)>0)))<=2
                                mtr2=mtr2+1;
                            end
                            for k=1:size(diag1,2)
                                if diag1(j+mtr2,k)~=0
                                    pntx=impoint00(impoint00(:,4)==diag1(j+mtr2,k),5);
                                    pnty=impoint00(impoint00(:,4)==diag1(j+mtr2,k),6);
                                    fcv=fcvprd(xv2(i),yv2(i),inlp2,k2,ina2(i,j+mtr2),inc2(i,j+mtr2),pntx,pnty);
                                    if lenxv==4
                                        A(mtr,4)=fcv(1);
                                        A(mtr,5:8)=fcv(2:5);
                                        A(mtr,8+lnum)=fcv(6);
                                    else
                                        A(mtr,3)=fcv(1);
                                        A(mtr,4:7)=fcv(2:5);
                                        A(mtr,7+lnum)=fcv(6);
                                    end
                                    dl(mtr,1)=-fcv(7);
                                    mtr=mtr+1;
                                end
                            end
                            lnum=lnum+1;
                    end
                end
                i=i+1;
                if i==5
                    pon=0;
                end
            else
                i=i+1;
                if i==5
                    pon=0;
                end
            end
        end
        clear fcv lnum mtr pon pntx pnty

        Nmat=A'*A;
        n=A'*dl;
        Na=inv(Nmat);
        dx=Na*n;

        vn=A*dx-dl;
        so2postn=(vn'*vn)/r;
        spostn=sqrt(so2postn);

        if spostn>spost
            term=1;
            clear spostn so2postn vn
        else
            spost=spostn;
        end

        if term~=1
            v=vn;
            xv=xv2;
            kiv=k2;
            so2post=so2postn;
            inlp=inlp2;
            ina=ina2;
            inc=inc2;
            if lenxv==4
                if inlp(1)==1
                    xv2(1:4)=xv(1:4)+dx(1:4)';
                    inlp2(2)=inlp(2)+dx(5);
                    inlp2(3)=inlp(3)+dx(6);
                    k2(1:2)=kiv(1:2)+dx(7:8)';
                    yv2(1:4)=yv(1:4)+inlp(2)*xv2(1:4)+inlp(3);
                else
                    yv2(1:4)=yv(1:4)+dx(1:4)';
                    inlp2(2)=inlp(2)+dx(5);
                    inlp2(3)=inlp(3)+dx(6);
                    k2(1:2)=kiv(1:2)+dx(7:8)';
                    xv2(1:4)=xv(1:4)+inlp(2)*yv2(1:4)+inlp(3);
                end
            else
                if inlp(1)==1
                    if isfinite(xv(3))
                        xv2(1:3)=xv(1:3)+dx(1:3)';
                        inlp2(2)=inlp(2)+dx(4);
                        inlp2(3)=inlp(3)+dx(5);
                        k2(1:2)=kiv(1:2)+dx(6:7)';
                    else
                        xv2(1:2)=xv(1:2)+dx(1:2)';
                        xv2(4)=xv(4)+dx(3);
                        inlp2(2)=inlp(2)+dx(4);
                        inlp2(3)=inlp(3)+dx(5);
                        k2(1:2)=kiv(1:2)+dx(6:7)';
                    end
                else
                    if isfinite(xv(3))
                        yv2(1:3)=yv(1:3)+dx(1:3)';
                        inlp2(2)=inlp(2)+dx(4);
                        inlp2(3)=inlp(3)+dx(5);
                        k2(1:2)=kiv(1:2)+dx(6:7)';
                    else
                        yv2(1:2)=yv(1:2)+dx(1:2)';
                        yv2(4)=yv(4)+dx(3);
                        inlp2(2)=inlp(2)+dx(4);
                        inlp2(3)=inlp(3)+dx(5);
                        k2(1:2)=kiv(1:2)+dx(6:7)';
                    end
                end
            end
            for i=1:4
                if isfinite(xv(i))
                    hia=find(ina2(i,:)~=0 & isfinite(ina2(i,:)));
                    if isempty(hia)
                        hia=1:(lena(i)+lenc(i));
                    end
                    hic=find(inc2(i,:)~=0);
                    for j=1:(lena(i)+lenc(i))
                        if lenxv==4
                            if (j<=length(hia) && ina(i,hia(j))~=0)
                                ina2(i,hia(j))=ina(i,hia(j))+dx(8+j);
                            elseif (j<=length(hic) && inc(i,hic(j))~=0)
                                inc2(i,hic(j))=inc(i,hic(j))+dx(8+j);
                            end
                        else
                            if (j<=length(hia) && ina(i,j)~=0)
                                ina2(i,hia(j))=ina(i,hia(j))+dx(7+j);
                            elseif (j<=length(hic) && inc(i,j)~=0 )
                                inc2(i,hic(j))=inc(i,hic(j))+dx(7+j);
                            end
                        end
                    end
                end
            end
        end
    end
    if inlp(1)==1
        if lenxv==4
            yv(1:4)=inlp(2)*xv(1:4)+inlp(3);
        else
            if isfinite(xv(3))
                yv(1:3)=inlp(2)*xv(1:3)+inlp(3);
            else
                yv(1:2)=inlp(2)*xv(1:2)+inlp(3);
                yv(4)=inlp(2)*xv(4)+inlp(3);
            end
        end
    else
        if lenxv==4
            xv(1:4)=inlp(2)*yv(1:4)+inlp(3);
        else
            if isfinite(xv(3))
                xv(1:3)=inlp(2)*yv(1:3)+inlp(3);
            else
                xv(1:2)=inlp(2)*yv(1:2)+inlp(3);
                xv(4)=inlp(2)*yv(4)+inlp(3);
            end
        end
    end

    Vxprio=zeros(size(Na));
    Vxpost=Vxprio;

    Vxprio=Na;
    Vxpost=Vxprio*so2post;
    clear A Na Nmat dl dx n test so2postn spostn
    SYN=1;

    if lenxv==4
        Vxlp=[Vxpost(1:2,1:2),Vxpost(1:2,5:6);
            Vxpost(5:6,1:2),Vxpost(5:6,5:6)];
    elseif lenxv==3
        Vxlp=[Vxpost(1:2,1:2),Vxpost(1:2,4:5);
            Vxpost(4:5,1:2),Vxpost(4:5,4:5)];
    end
    c=sqrt(abs(-xv(1)*xv(2)-yv(1)*yv(2)));
    Jac1=[-(xv(2)/(2*c)),-(xv(1)/(2*c)),-(yv(2)/(2*c)),-(yv(1)/(2*c))];
    Jac2=[1 0 0 0;
        0 1 0 0;
        inlp(3) 0 xv(1) 1;
        0 inlp(3) xv(2) 1];
    sigc=sqrt(Jac1*Jac2*Vxlp*Jac2'*Jac1');
    clear Jac1 Jac2 Vxlp Vxpost Vxprio inlp inlp2 ...
        so2post spost term un v xv2 yv2
    clear c
end


% Least square solution without vanish line
for i=1:2
    if ( SYN==0 && isfinite(xv(i)))
        xv2=xv;
        ina2=ina;
        inc2=inc;
        yv2=yv;
        k2=kiv;
        spost=inf;
        term=0;
        v=0;
        krit=1;
        tst=1;
        while term==0
            clear hia hic
            mtr2=0;
            minobs=0;
            if i==1
                for p=1:size(horl,1)
                    if length(horl(p,(horl(p,:)>0)))<=2
                        minobs=minobs+(length(horl(p,(horl(p,:)>0)))*2);
                    end
                end
                A=zeros(obsnh-minobs,lnh+2);
                dl=zeros(obsnh-minobs,1);
                r=(obsnh-minobs)-(lnh+2);
            else
                for p=1:size(verl,1)
                    if length(verl(p,(verl(p,:)>0)))<=2
                        minobs=minobs+(length(verl(p,(verl(p,:)>0)))*2);
                    end
                end
                A=zeros(obsnv-minobs,lnv+4);
                dl=zeros(obsnv-minobs,1);
                r=(obsnv-minobs)-(lnv+4);
            end
            mtr=1;
            lnum=1;
            for j=1:(lena(i)+lenc(i))
                switch (i)
                    case 1
                        while length(horl(j+mtr2,(horl(j+mtr2,:)>0)))<=2
                            mtr2=mtr2+1;
                        end
                        for k=1:size(horl,2)
                            if horl(j,k)~=0
                                pntx=impoint00(impoint00(:,4)==horl(j+mtr2,k),5);
                                pnty=impoint00(impoint00(:,4)==horl(j+mtr2,k),6);
                                fcv=fcvp2rd(xv2(i),yv2(i),k2,ina2(i,j+mtr2),inc2(i,j+mtr2),pntx,pnty);
                                A(mtr,1:4)=fcv(1:4);
                                A(mtr,4+lnum)=fcv(5);
                                dl(mtr,1)=-fcv(6);
                                mtr=mtr+1;
                            end
                        end
                        lnum=lnum+1;
                    case 2
                        while length(verl(j+mtr2,(verl(j+mtr2,:)>0)))<=2
                            mtr2=mtr2+1;
                        end
                        for k=1:size(verl,2)
                            if verl(j+mtr2,k)~=0
                                pntx=impoint00(impoint00(:,4)==verl(j+mtr2,k),5);
                                pnty=impoint00(impoint00(:,4)==verl(j+mtr2,k),6);
                                fcv=fcvp2rd(xv2(i),yv2(i),k2,ina2(i,j+mtr2),inc2(i,j+mtr2),pntx,pnty);
                                A(mtr,1:4)=fcv(1:4);
                                A(mtr,4+lnum)=fcv(5);
                                dl(mtr,1)=-fcv(6);
                                mtr=mtr+1;
                            end
                        end
                        lnum=lnum+1;
                end
            end
            clear fcv lnum mtr pntx pnty

            Nmat=A'*A;
            n=A'*dl;
            Na=inv(Nmat);
            dx=Na*n;
            vn=A*dx-dl;
            so2postn=(vn'*vn)/r;
            spostn=sqrt(so2postn);

            if spostn>spost
                term=1;
                clear spostn so2postn vn
            else
                spost=spostn;
            end
            
            if term~=1
                v=vn;
                xv=xv2;
                yv=yv2;
                kiv=k2;
                so2post=so2postn;
                ina=ina2;
                inc=inc2;
                xv2(i)=xv(i)+dx(1);
                yv2(i)=yv(i)+dx(2);
                k2(1:2)=kiv(1:2)+dx(3:4)';
                hia=find(ina2(i,:)~=0 & isfinite(ina2(i,:)));
                if isempty(hia)
                    hia=1:lena(i)+lenc(i);
                end
                hic=find(inc2(i,:)~=0);
                for j=1:(lena(i)+lenc(i))
                    if (j<=length(hia) && ina(i,hia(j))~=0)
                        ina2(i,hia(j))=ina(i,hia(j))+dx(4+j);
                    elseif (j<=length(hia) && inc(i,j)~=0)
                        inc2(i,hic(j))=inc(i,hic(j))+dx(4+j);
                    end
                end
            end
        end
        Vxprio=zeros(size(Na));
        Vxpost(:,:,i)=Vxprio;

        Vxprio=Na;
        Vxpost(:,:,i)=Vxprio*so2post;
        clear A Na Nmat dl dx n test Vxprio r v so2post spost
    end
end

% If first grid point is missing estimate it's position
% from the intersection of the lines representing
% the first row and the first column
kr=[0 0];
if impoint00(1)==0
    for i=1:2
        if ina(i,1)~=0
            a(i)=ina(i,1);
            b(i)=inb(i,1);
            kr(i)=1;
        else
            c(i)=inc(i,1);
            d(i)=ind(i,1);
        end
    end
    if all(kr(:)~=0)
        impoint00(1,5)=(b(2)-b(1))/(a(1)-a(2));
        impoint00(1,6)=a(1)*impoint00(1,5)+b(1);
    elseif all(kr(:)==0)
        impoint00(1,6)=(d(2)-d(1))/(c(1)-c(2));
        impoint00(1,5)=c(1)*impoint00(1,6)+d(1);
    else
        in_a=find(a~=0);
        a=a(in_a);
        b=b(in_a);
        c=c(3-in_a);
        d=d(3-in_a);
        impoint00(1,5)=(b*c+d)/(1-a*c);
        impoint00(1,6)=a*impoint00(1,5)+b;
    end
    impoint00(1,2:4)=1;
end

clear horl diag1 diag2 verl ina2 ina inb inc inc2 ind ...
    lena lenc lenxv lnd1 lnd2 lnh lnv obs obsnd1 ...
    obsnd2 obsnh obsnv r cs rs term xv2 yv2
