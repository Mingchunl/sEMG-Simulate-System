function [cx cy] = circle(x,y,r)
%生成肌肉MU分布的圆
%   此处显示详细说明
% 程序如下：
t=0:pi/100:2*pi;
cy=r*sin(t)+y;
cx=r*cos(t)+x;
end

