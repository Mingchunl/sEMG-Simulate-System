
function [semg, emgIPI muap nAMU muaptcell cmu_x cmu_y rMU average_IPI] = isometricEMG(nMU,excitation,FrScheme,subTissue,xmu,ymu,channelscheme ,IED,fs,duration,RR)
%[semg_lap semg]=TriSEMG_LAP_improve(120,10,2,1,1.5,15);
%input:
%        nMU: MU的总体个数
% excitation: 收缩力的大小
%    mScheme: 肌肉组织的范围方案，mScheme=1为矩形，mScheme=2为圆形(通用)
%   FrScheme: Firing方案，FrScheme=1为reference(3)中FR1，FrScheme=2为reference(3)中FR2
%  subTissue: 皮下组织厚度(脂肪+皮肤)：FDI为1.5mm；limb为4mm
%    xmu,ymu: 肌肉组织的范围
%output:
%  semg: multi-channel sEMG signals, 两两相减便是双极性SEMG信号

%可根据需要调整的参数
% fs=2000;    % 采样率Hz
mScheme = 3;   %默认选择是椭圆肌肉
t=duration;       % 产生5s的数据
LocationElectrode=30;   %电极距终板区的位置
% IED=5;  %电极间距离5mm
% electrode=5;    %Laplace电极为5个点电极
%--------------

%%%
% nMU=120;
fiberTotal=28260;
%fiberTotal=40500;   %reference[4]
MFR=8;   %最小发放率为8Hz

%肌肉的范围
%mucy=15;    %肌纤维y坐标,即深度为15mm
mucy=ymu;
mucx=xmu;    %肌纤维x坐标范围(－mucx，mucx)
%under=1.5;  %皮下组织（脂肪＋皮肤＝1.5mm）
under=subTissue;
%-----------------------

%%fiber diameter
%所以MU的平均fiber diameter为高斯分布，均值为55，SD=10
MU_fd=mgd(nMU,1,55,100); 
for i=1:nMU
    if MU_fd(i)>55+3*10
        MU_fd(i)=55+3*10;  %由reference(2)知，fiber diameter的范围应为
    end                      %55-3*10=<endplate=<55+3*10
    if MU_fd(i)<55-3*10
        MU_fd(i)=55-3*10; 
    end
end

% recruitment thresold of MU
i=1:nMU;
  % RR为募集阈值范围，RR%MVC时，所有MU激活 a =ln(RR) 
a=log(RR)/nMU;
RTE=exp(a.*i);
%plot(RTE)
%----------------------

% fiber number of each MU
i=1:nMU;
RF=100;     %归一化力 100 fold
b=log(RF)/nMU;
Tforce=exp(b.*i);
forceTotal=sum(Tforce);
nfiber=(fiberTotal/forceTotal).*Tforce;
nfiber=fix(nfiber); %肌纤维数目为整数 
%plot(nfiber)
%-----------------------

% average firing rate of each MU
%firing方案1
if FrScheme==1
    %reference [3]中的FR1方案,即在100％MVC处发放率均为50Hz
    i=1:nMU;  %slope是斜率
    slope=(50-MFR)./(100.-RTE);  %MFR最小发放率
    force=1:100;    %force的变化情况
    FR=ones(nMU,100)*MFR;
    for i=1:nMU
        fx=find((force-RTE(i))>0);  %大于募集阈值时MU才激活
        FR(i,fx(1):end)=slope(i)*( force(fx(1:end)) -RTE(i) )+MFR;
    end
end
%firing方案2
if FrScheme==2
    %reference [3]中的FR2方案,即最小MU的最大发放率为20-25Hz,最大MU的最大发放率为～50Hz
    FRLM=22;    %最小MU的最大发放率设置为22Hz
    deltaFR=(50-FRLM)/nMU;            %MFR最小发放率
    slope=(50-MFR)/(100-RTE(end));    %RTE是募集阈值，RTE(end)=RR 募集范围
    FirstMforce=(FRLM-MFR)/slope+RTE(1);
    slopeB=(50-FRLM)/(100-FirstMforce);
    force =1:100;   %force的变化情况
    
    temp=ones(nMU,length(force))*MFR;
    for i=1:nMU
        fx=find((force-RTE(i))>0);  %大于募集阈值时MU才激活
        temp(i,fx(1):end)=slope*( force(fx(1:end)) -RTE(i) )+MFR;
    end
    for i=2:nMU
        for j=1:length(force)
            buff(j)=abs((temp(i,j)-FRLM)/(j-FirstMforce)-slopeB);
        end
        fMU=find(buff==min(buff));
        Mforce(i)=fMU;
    end
    Mforce(1)=FirstMforce;
    
    FR=ones(nMU,100)*MFR;
    for i=1:nMU
        fx=find((force-RTE(i))>0);  %大于募集阈值时MU才激活
        FR(i,fx(1):round(Mforce(i)))=slope*( force(fx(1):round(Mforce(i))) -RTE(i) )+MFR;
        FR(i,round(Mforce(i))+1:end)=slope*(round(Mforce(i))-RTE(i))+MFR;
    end
end

if FrScheme==3
    
    %PFR=50-12*RTE./RTE(end);%每个MU的最大发放率
    PFR(1)=35;
    PFR(2:nMU)=35-12*RTE(2:end)/RTE(end);%每个MU的最大发放率
    slope=(PFR(end)-MFR)/(100-RTE(end));  %斜率
         
    force =1:100;   %force的变化情况
    
    FR=ones(nMU,length(force))*MFR;
    for i=1:nMU
        fx=find((force-RTE(i))>0);  %大于募集阈值时MU才激活
        FR(i,fx(1):end)=slope*( force(fx(1:end)) -RTE(i) )+MFR;
        pp=find(FR(i,:)>=PFR(i));
        FR(i,pp(1):end)=PFR(i);        
    end    
end

clear temp;
%========
%temp=0
%for i=1:120    %检测是否有小于MFR的值，所有FR的值应大于MFR
%    temp=temp+length(find(FR(i,:)<8));
%end
%=========
% figure
% set(gcf, 'color', 'white')
% xlabel('excitation(max %)')
% ylabel('Firing rate')
% 
% hold on
% for i=1:120
% plot(FR(i,:),LineWidth=2)
% end
% xlabel('excitation(max %)')
% ylabel('Firing rate')

%------------------
i=1;
while excitation-RTE(i)>0
       i=i+1;
       if i==nMU
           i=i+1;
           break
       end
end
disp('number of active MU')
nAMU=i-1   % number of active MU
if nAMU<=1
    nAMU=1;
else nAMU=i-1;
end
%-----------------------
% uniform distribution of MU center
%肌肉组织方案一
if mScheme==1
    %肌肉组织为矩形形状
    MUx=-mucx+(2*mucx)*rand(1,nMU);
    MUy=under+mucy*rand(1,nMU);
%-----------
end
%肌肉组织方案二
if mScheme==2
    %%肌肉组织为圆柱形状,直接为肌肉组织的深度
    Dmuscle=mucy;   %直径
    mucx=Dmuscle/2; 
    MUx= -Dmuscle/2+ Dmuscle* rand(1,nMU);
    MUy=under+ Dmuscle* rand(1,nMU);
    %MU中心位置需规范在肌肉组织圆形范围内
    muscleCX=0;
    muscleCY=under+Dmuscle/2;   %肌肉组织的中心点坐标
    for i=1:nMU
        if sqrt((MUx(i)-muscleCX)^2+(MUy(i)-muscleCY)^2) >Dmuscle/2
            delta=asin(abs(MUx(i)/sqrt((MUx(i)-muscleCX)^2+(MUy(i)-muscleCY)^2)));
            if MUx(i)<0
               MUx(i)=MUx(i)+(sqrt((MUx(i)-muscleCX)^2+(MUy(i)-muscleCY)^2) -Dmuscle/2)*sin(delta);
            end
            if MUx(i)>0
               MUx(i)=MUx(i)-(sqrt((MUx(i)-muscleCX)^2+(MUy(i)-muscleCY)^2) -Dmuscle/2)*sin(delta);
            end
            if MUy(i)<under+Dmuscle/2
               MUy(i)=MUy(i)+(sqrt((MUx(i)-muscleCX)^2+(MUy(i)-muscleCY)^2) -Dmuscle/2)*cos(delta);
            end
            if MUy(i)>under+Dmuscle/2
               MUy(i)=MUy(i)-(sqrt((MUx(i)-muscleCX)^2+(MUy(i)-muscleCY)^2) -Dmuscle/2)*cos(delta);
            end
        end
    end
end




%肌肉组织方案二
if mScheme==3
    %%肌肉组织为椭圆形状,直接为肌肉组织的深度
    MUx=-mucx+(2*mucx)*rand(1,nMU);  %MU中心位置
    MUy=-mucy/2+mucy*rand(1,nMU);%-7.5+(0,1)*15
    %MU中心位置需规范在肌肉组织圆形范围内
    muscleCX=0;
    muscleCY= 0; %肌肉组织的中心点坐标
    ellipse_y = under+mucy/2; 
    a= mucx;
    b=mucy/2;
    for i=1:nMU
        d(i) =distance(MUx(i),MUy(i),0,0);%求MU到椭圆中心距离
        r(i)= radius(MUx(i),MUy(i),0,0,a,b);% 求MU对应theta在椭圆中的径长
        if d(i) >r(i)
            delta=atan2(MUx(i) ,MUy(i));
            MUx(i) = r(i)*cos(delta);
            MUy(i) = r(i)*sin(delta);
        end 
    end
end

if channelscheme==1
     electrode =64;
else 
    electrode =128;
end
dist_z=LocationElectrode;
buff=zeros(electrode,1);
clear temp;
figure
%画电极
ex= [-20,-15, -10, -5, 0, 5, 10, 15];
ey = zeros(1,8);
plot(ex, ey, 'o', 'MarkerFaceColor', 'blue', 'MarkerSize', 6)

for i=1:nAMU
    if channelscheme==1
      
    %temp=TriMUAP_LAP_improve(nfiber(i),MU_fd(i),MUx(i),MUy(i),dist_z,mucx,mucy,under,mScheme,IED);
    [temp ,cmu_xx, cmu_yy,rmu] =channel64_MUAP(nfiber(i),MU_fd(i),MUx(i),MUy(i),dist_z,mucx,mucy,under,mScheme,IED);
    cmu_x(i,1)=cmu_xx;
    cmu_y(i,1)=cmu_yy;
    rMU(i,1) =rmu;
    else  channelscheme==2;
    [temp ,cmu_xx, cmu_yy,rmu] =channel128_MUAP(nfiber(i),MU_fd(i),MUx(i),MUy(i),dist_z,mucx,mucy,under,mScheme,IED);
    cmu_x(i,1)=cmu_xx;
    cmu_y(i,1)=cmu_yy;
    rMU(i,1) =rmu;
    end
        %len(i)=length(temp);
    len(i)=size(temp,2);  %返回temp列数，即临时muap的长度
    buff=[buff temp];
    clear temp
end
len=[1 len];
muap=zeros(electrode,nAMU,max(len));
for i=1:nAMU
    for j=1:electrode
        muap(j,i,1:len(i+1))=buff(j,  sum(len(1:i))+1 : sum(len(1:i))+len(i+1)    ); 
    end
end



clear len buff

% Guassian distribution of IPI


buff=0;
for i=1:nAMU
    mIPI=round(fs/(FR(i,excitation)));    
    nMUAP=round(t*fs/mIPI);     
    startMUAP=round(rand(1)*mIPI);
    nIPI=mgd(nMUAP,1,0,(0.1*mIPI)^2)';
    for j=1:nMUAP
        if nIPI(j)>0.1*mIPI
            nIPI(j)=0.1*mIPI;
        end
        if nIPI(j)<-0.1*mIPI
            nIPI(j)=-0.1*mIPI;
        end
    end
    nIPI=mIPI+nIPI;
    %=============
    IPI=startMUAP;
    for j=1:nMUAP
        IPI=[IPI startMUAP+ sum(nIPI(1:j))];
    end
    kt=find(IPI<t*fs);  %限定IPI在所给采样时间以内
    temp=IPI(1:kt(end));    
    clear IPI
    IPI=temp;
    %================   
    len(i)=length(IPI);
    buff=[buff IPI];
    clear IPI temp
end

len=[1 len];
muIPI=zeros(nAMU,max(len));
for i=1:nAMU
    muIPI(i,1:len(i+1))=buff(sum(len(1:i))+1:sum(len(1:i))+len(i+1)); 
end
muIPI=round(muIPI);   %各个mu的发放序列
clear len buff

for i=1:nAMU
    if muIPI(i,1)==0
       muIPI(i,1)=muIPI(i,1)+1; %第一个MUAP发放位置不能是0
    end 
end
%----------------
%----------------
emgIPI=zeros(nAMU,t*fs);
for e=1:electrode


    for i=1:nAMU


        for j=1:size(muIPI,2)
            if muIPI(i,j)>0
                emgIPI(i,muIPI(i,j))=1; 
            end
        end
        muapbuff(1,:)=muap(e,i,:);
        temp=conv(muapbuff,emgIPI(i,:));  %muapt
        singleEMG(i,:)=temp(1:t*fs);
        muaptcell(e,i,:)=temp;
        clear temp;


    end
    semg(e,:)=sum(singleEMG); %累加所有激活MU的muapt
    clear singleEMG

    average_IPI = FR(1:nAMU,excitation)';

end








