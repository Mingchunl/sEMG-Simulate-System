%生成静态128通道MUAP函数，电极排列方式16（沿z轴）*8（沿x)

function [muap ,cmu_xx, cmu_yy,rmu]=channel128_MUAP(nf,FD,cmu_x,cmu_y,dist_z,xmu,ymu,skinfat,mScheme,interE)
%function muap=TriMUAP_LAP_improve(100,0,6,10,7.5,15,1.5,2,2,5)
%output:
%muap :一个MU的AP(uv)
%sfap :一个MU所有fiber的SFAP(uv)
%input:
%   nf:  fiber的数量
%   FD:  MU的平均肌纤维直径
%cmu_x:  MU的中心x坐标
%cmu_y:  MU的中心y坐标,即深度,cmu_y>=skinfat+rmu(skinfat=4,limb)(skinfat=1.5,FDI)
%dist_z: 点电极与终板区的距离(mm)
%  xmu:  肌纤维x坐标范围(-xmu,xmu)
%  ymu:  肌纤维y坐标范围,即深度
%skinfat:肌肉的脂肪和皮肤层
%electrodeN: 电极个数
%interE: 电极间距离(一般为5mm)


%muap为模拟的MUAP波形
%参数定义：
%   rmu:     MU territory的半径
%   cmu(x,y):MU territory的中心位置,
%   r_muscle:肌肉半径,cmu的深度为r_muscle-rmu
%cmu_x=0;cmu_y=6;

%FD=55;  %肌纤维平均直径    (采用reference 2中参数)
IED=interE;  %电极间距离

rmu=sqrt((nf/20)/pi);

%%%%%%%%
%肌纤维的深度要超过skinfat
%skinfat=1.5;    %FDI肌肉的脂肪和皮肤层为1.5mm,
%xmu=15; %FDI肌肉的肌纤维x坐标范围（－10 10）
%ymu=15; %肌纤维y坐标,即深度为15mm

%skinfat=1+3;    %皮肤1mm和脂肪3mm(limb)
%计算MU的中心位置
%r_muscle=40+skinfat;
%t_muscle=50;%测试条件
%while(t_muscle>r_muscle)  
%    cmu_x=rand(1)*r_muscle;
%    cmu_y=0;
%    while(cmu_y<skinfat+rmu || cmu_y>r_muscle-rmu) %在肌肉
%        cmu_y=rand(1)*(r_muscle-rmu);
%    end
%    t_muscle=sqrt(cmu_x^2+(r_muscle-cmu_y)^2);
%end

%%%%%%%
%%endplate
endplate=mgd(nf,1,0,1); %endplate为高斯分布，均值为0，SD=1
%endplate=randn(nf,1); 
for i=1:nf
    if endplate(i)>0+3
        endplate(i)=3;  %由reference(2)知，endplate的范围应为
    end                 %0-3=<endplate=<0+3
    if endplate(i)<0-3
        endplate(i)=-3; 
    end
end
%%
%%fiber diameter
fiber_d=mgd(nf,1,FD,1); 

for i=1:nf
    if fiber_d(i)>FD+2
        fiber_d(i)=FD+2; 
    end                    
    if fiber_d(i)<FD-2
        fiber_d(i)=FD-2; 
    end
end
%%
vel=2.2+0.05*(fiber_d-25);%肌纤维速度与fiber diameter的关系

fiber=mgd(nf,1,0,1); %肌纤维长度变化，均值为0，SD=1

for j=1:nf
    if fiber(j)>0+2
        fiber(j)=2;  %由reference(2)知，肌纤维长度变化范围应为
    end                 %0-2=<endplate=<0+2
    if fiber(j)<0-2
        fiber(j)=-2; 
    end
end
len_fiber=130.+fiber;%肌纤维的基长为130mm
%--%肌纤维肌键的变化是(-5，5)均匀分布
fiberL=-5+10*rand(1,nf);    %help
fiberR=-5+10*rand(1,nf);

%hold on
if mScheme==1
        %对MU中心位置x坐标的调整
        if xmu-abs(cmu_x)<rmu
            if cmu_x<0
                cmu_x=cmu_x+(rmu-(xmu-abs(cmu_x))); 
            end
            if cmu_x>0
                cmu_x=cmu_x-(rmu-(xmu-abs(cmu_x)));  
            end
        end
        %对MU中心位置y坐标的调整
        if ymu+skinfat-cmu_y<rmu
            cmu_y=cmu_y-(rmu-(ymu+skinfat-cmu_y)); 
        end
        if cmu_y-skinfat<rmu    %FDI肌肉的脂肪和皮肤层为1.5mm,
            cmu_y=cmu_y+(rmu-(cmu_y-skinfat));   %肌纤维的深度要超过skinfat
        end
end
    
if mScheme==2
        mCX=0;
        mCY=skinfat+ymu/2;   %肌肉组织的中心点坐标
        if ymu/2-sqrt((cmu_x-mCX)^2+(cmu_y-mCY)^2)<rmu
           tlen=rmu-(ymu/2-sqrt((cmu_x-mCX)^2+(cmu_y-mCY)^2));
           del=asin(abs(cmu_x)/sqrt((cmu_x-mCX)^2+(cmu_y-mCY)^2));
           if cmu_x<0
              cmu_x=cmu_x+tlen*sin(del);
           end
           if cmu_x>0
              cmu_x=cmu_x-tlen*sin(del); 
           end
           
           if cmu_y<mCY
              cmu_y=cmu_y+tlen*cos(del); 
           end
           if cmu_y>mCY
              cmu_y=cmu_y-tlen*cos(del); 
           end            
        end
end



if mScheme==3 %椭圆  调整MU中心坐标
        mCX=0; %肌肉中心坐标
        mCY=0;
        ellipse_y =skinfat+ymu/2;   %肌肉组织的中心点坐标
        a = xmu;
        b= ymu/2;
        r = radius(cmu_x,cmu_y,0,0,a,b);%边界距离
        d = distance(cmu_x,cmu_y,0,0); %MU实际距离
        if r-d <rmu
           tlen=abs(d+rmu-r); %相差的距离
           del=asin(abs(cmu_x)/sqrt((cmu_x-mCX)^2+(cmu_y-mCY)^2));
         if cmu_x<0
              cmu_x=cmu_x+tlen*sin(del);
           end
           if cmu_x>0
              cmu_x=cmu_x-tlen*sin(del); 
           end
           
           if cmu_y<mCY
              cmu_y=cmu_y+tlen*cos(del); 
           end
           if cmu_y>mCY
              cmu_y=cmu_y-tlen*cos(del); 
           end              
        end
        cmu_y = cmu_y+ellipse_y;
end


    
%%%用于记录MU在muscle tissue 中分布情况
[cx cy]=circle(cmu_x,cmu_y,rmu);
hold on
HH=plot(cx,cy,'r');
set(HH,'LineWidth',2);
if mScheme ==2

    [cx cy]=circle(0,skinfat+ymu/2,ymu/2);%肌肉组织区域范围
    hold on
    HH=plot(cx,cy,'m');
    set(HH,'LineWidth',2);
elseif  mScheme==1
    plot_rectangle(0,skinfat+ymu/2,xmu,ymu/2);
else
    plot_ellipse(0,skinfat+ymu/2,xmu,ymu/2);
end
cmu_xx=cmu_x;
cmu_yy=cmu_y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%计算MU territory中所有fiber的SFAP
for i=1:nf
    %fiber的x坐标位置
    tx=rand(1);
    if tx>=0.5
        cmu_xp(i)=cmu_x+rand(1)*rmu;
    else
        cmu_xp(i)=cmu_x-rand(1)*rmu;
    end

    %fiber的y坐标位置
    ty=rand(1);             
    if ty>=0.5
       cmu_yp(i)=cmu_y+rand(1)*rmu;
    else
       cmu_yp(i)=cmu_y-rand(1)*rmu;
    end
    
    %sfap=SFAP_tri(cmu_xp(i),cmu_yp(i),dist_z+endplate(i),0.303,vel(i));
    %sfap=SFAP_tri_improve(cmu_xp(i),cmu_yp(i),dist_z+endplate(i),0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
    %len(i)=length(sfap);
end

%------第1到第16个电极
for j=1:16
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)-4*IED,cmu_yp(i),dist_z+endplate(i)+(j-1)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)-4*IED,cmu_yp(i),dist_z+endplate(i)+(j-1)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap


%------第17到第32个电极
for j=17:32
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)-3*IED,cmu_yp(i),dist_z+endplate(i)+(j-17)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)-3*IED,cmu_yp(i),dist_z+endplate(i)+(j-17)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap

%------第33到第48个电极
for j=33:48
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)-2*IED,cmu_yp(i),dist_z+endplate(i)+(j-33)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)-2*IED,cmu_yp(i),dist_z+endplate(i)+(j-33)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap

%------第49到第64个电极
for j=49:64
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)-IED,cmu_yp(i),dist_z+endplate(i)+(j-49)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)-IED,cmu_yp(i),dist_z+endplate(i)+(j-49)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap

%------第65到第80个电极
for j=65:80
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i),cmu_yp(i),dist_z+endplate(i)+(j-65)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i),cmu_yp(i),dist_z+endplate(i)+(j-65)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap


%------第81到第96个电极
for j=81:96
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)+IED,cmu_yp(i),dist_z+endplate(i)+(j-81)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)+IED,cmu_yp(i),dist_z+endplate(i)+(j-81)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap

%------第97到第112个电极
for j=97:112
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)+2*IED,cmu_yp(i),dist_z+endplate(i)+(j-97)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)+2*IED,cmu_yp(i),dist_z+endplate(i)+(j-97)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap


%------第113到第128个电极
for j=113:128
    for i=1:nf
        sfap=SFAP_tri_improve(cmu_xp(i)+3*IED,cmu_yp(i),dist_z+endplate(i)+(j-113)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        len(i)=length(sfap);
    end
    sfap=zeros(nf,max(len));
    for i=1:nf
        clear temp;
        temp=SFAP_tri_improve(cmu_xp(i)+3*IED,cmu_yp(i),dist_z+endplate(i)+(j-113)*IED,0.303,vel(i),len_fiber(i),fiberL(i),fiberR(i));
        sfap(i,1:length(temp))=temp;
    end
    %一个MU的MUAP
    muap(j,:)=sum(sfap);
end
clear sfap




%% 
hold on
plot(cmu_xp,cmu_yp,'*')
