function [x,y]=ellipse(xc,yc,a,b)
% 椭圆参数
%xc = 0; % 椭圆中心 x 坐标
%yc = 0; % 椭圆中心 y 坐标
%a = 2; % 长半轴长度
%b = 1; % 短半轴长度
theta = 0:0.01:2*pi; % 角度范围

% 计算椭圆上的点
x = xc + a * cos(theta);
y = yc + b * sin(theta);

axis equal; % 设置坐标轴比例相等，以保持椭圆形状准确显示
end