%8*8
clear
clc
nMU = 70;
excitation =10; % 
mScheme = 1;
FrScheme = 3; 
subTissue = 4;
xmu = 15 ;%椭圆a
ymu =8; %椭圆b
RR=70;
IED=5;
fs =2000;
duration= 5 ;
channelscheme=1; %1 为64通道 ，2 为128
[semg emgIPI muap nAMU muapt cmu_x cmu_y rMU average_IPI] = isometricEMG(nMU,excitation,FrScheme,subTissue,xmu,ymu,channelscheme ,IED,fs,duration,RR);


%% 
figure
MUAPs = muap(:, 15,:);

MUAPs= squeeze(MUAPs);



for i =1:64
        subplot(8,8,i)
        plot(MUAPs(i,:))
        
end




    




        
