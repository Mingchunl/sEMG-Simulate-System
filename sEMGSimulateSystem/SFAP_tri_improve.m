function sfap=SFAP_tri_improve(dist_x,dist_y,dist_z,kab,vel,len_fiber,fiberL,fiberR)
%function sfap=SFAP_tri_improve(0,5,10,0.303,4,100,-20,0)
%input:
%   dist_x,dist_y,dist_z 为点电极的坐标（严格按照参考文献的坐标）
%   kab: kab=a/b,且0=<kab<1, b=7(default)
%   vel: 肌纤维的传导速度（与肌纤维直径有关）
%   len_fiber:肌纤维的半长（基长len_fiber=100mm）
%   fiberL:肌纤维左边长度变化，（基长为100mm）
%   fiberR:肌纤维右边长度变化，（基长为100mm）
%output:
%   sfap:单纤维动作电位


pre=0.5;  %precision产生电位的分辨率，越小分辨率越高，但数据越长
        %单独研究动作电位时，应该设置高分辨率pre＝0.01；
        %研究肌电信号时，应该设置低分辨率pre＝1(采样率为1kHz)，以满足计算；
        %pre=0.5时，对应的采样率为2kHz

%clear
%kab=0.303;  %输入比值 kab=a/b
%vel=4;      %输入参数 单位m/s
%dist_x=0;dist_y=5;dist_z=10;

delta_r=0.063;
delta_z=0.33;
delta=delta_z/delta_r;
%len_fiber=100;%肌纤维半长
len_fiberL=len_fiber+fiberL;
len_fiberR=len_fiber+fiberR;


b=7;        %spacing
a=kab*b;
I2=388;
I3=kab*I2;
I1=I2-I3;

%step1
%1 电极子的产生过程
%%generation
%I1传输
t=0:pre:a/vel-pre;
ra1=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*t).^2);%向右
ra2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z).^2);
ra3=ra2;
rb1=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*t).^2);%向左
rb2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z).^2);
rb3=rb2;
sfap=(-I1./ra1+I2./ra2-I3./ra3-I3./rb3+I2./rb2-I1./rb1)/(2*pi*delta_r);

%I2传输
t=a/vel:pre:b/vel-pre;
ra1=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*t).^2);
ra2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*t+a).^2);
ra3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z).^2); %向右

rb1=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*t).^2);
rb2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*t-a).^2);
rb3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z).^2); %向左

temp=(-I1./ra1+I2./ra2-I3./ra3-I3./rb3+I2./rb2-I1./rb1)./(2*pi*delta_r);
sfap=[sfap,[temp]];
clear temp

clear ra1 ra2 ra3 rb1 rb2 rb3
%step2
%2 整个电极子的传输过程
%由于肌纤维左右长度的不同，下面分别考虑左右电极子的传输过程
%右边极子的传输和消失过程
%开始产生I3
%%transmission
tR=b/vel:pre:len_fiberR/vel-pre;
r1=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*tR).^2);
r2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*tR+a).^2);
r3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*tR+b).^2);
%右边电极子的消失过程,
%%extinction
%I1在肌键(肌纤维末端)处恒定，I2和I3向肌键移动
tR1=len_fiberR/vel:pre:(len_fiberR+a)/vel-pre;
ra1=zeros(1,length(tR1));
ra1(1:end)=sqrt((dist_x^2+dist_y^2)*delta+(len_fiberR-dist_z).^2);
ra2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*tR1+a).^2);
ra3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*tR1+b).^2); %向右
%I1和I2在肌键(肌纤维末端)处恒定，I3向肌键移动
%tR2=(len_fiberR+a)/vel:pre:(len_fiberR+b-a)/vel;
tR2=(len_fiberR+a)/vel:pre:(len_fiberR+b)/vel;
raa1=zeros(1,length(tR2));
raa1(1:end)=sqrt((dist_x^2+dist_y^2)*delta+(len_fiberR-dist_z).^2);
raa2=raa1;
raa3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z-vel.*tR2+b).^2);%向右

%对右边极子的组合
Re1=[r1 ra1 raa1];  %I1
Re2=[r2 ra2 raa2];  %I2
Re3=[r3 ra3 raa3];  %I3

%左边极子的传输和消失过程
%%transmission
tL=b/vel:pre:len_fiberL/vel-pre;
r4=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*tL-b).^2);
r5=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*tL-a).^2);
r6=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*tL).^2);
%%extinction
%I1在肌键(肌纤维末端)处恒定，I2和I3向肌键移动
tL1=len_fiberL/vel:pre:(len_fiberL+a)/vel-pre;
rb1=zeros(1,length(tL1));
rb1(1:end)=sqrt((dist_x^2+dist_y^2)*delta+(len_fiberL+dist_z).^2);
rb2=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*tL1-a).^2);
rb3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*tL1-b).^2); %向左
%I1和I2在肌键(肌纤维末端)处恒定，I3向肌键移动
%tL2=(len_fiberL+a)/vel:pre:(len_fiberL+b-a)/vel;
tL2=(len_fiberL+a)/vel:pre:(len_fiberL+b)/vel;
rbb1=zeros(1,length(tL2));
rbb1(1:end)=sqrt((dist_x^2+dist_y^2)*delta+(len_fiberL+dist_z).^2);
rbb2=rbb1;
rbb3=sqrt((dist_x^2+dist_y^2)*delta+(dist_z+vel.*tL2-b).^2); %向左

%对左边极子的组合
Le1=[r6 rb1 rbb1];  %I1
Le2=[r5 rb2 rbb2];  %I2
Le3=[r4 rb3 rbb3];  %I3

%step3
%根据肌纤维左右长度的不同，计算产生的动作电位
fiber_right=length(Re3);
fiber_left=length(Le3);

if fiber_right<=fiber_left
    temp=(-I1./Re1+I2./Re2-I3./Re3-I3./Le3(1:fiber_right)+I2./Le2(1:fiber_right)-I1./Le1(1:fiber_right))./(2*pi*delta_r);
    sfap=[sfap,[temp]];
    clear temp
    temp=(-I3./Le3(fiber_right+1:end)+I2./Le2(fiber_right+1:end)-I1./Le1(fiber_right+1:end))./(2*pi*delta_r);
    sfap=[sfap,[temp]];
    clear temp
else
    temp=(-I1./Re1(1:fiber_left)+I2./Re2(1:fiber_left)-I3./Re3(1:fiber_left)-I3./Le3+I2./Le2-I1./Le1)./(2*pi*delta_r);
    sfap=[sfap,[temp]];
    clear temp
    temp=(-I1./Re1(fiber_left+1:end)+I2./Re2(fiber_left+1:end)-I3./Re3(fiber_left+1:end))./(2*pi*delta_r);
    sfap=[sfap,[temp]];
    clear temp
end
temp=sfap;
sfap=zeros(1,length(temp)+1);
sfap(1:length(temp))=temp;
