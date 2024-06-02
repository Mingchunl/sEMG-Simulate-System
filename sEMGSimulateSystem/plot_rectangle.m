function plot_rectangle(muscleCX,muscleCY,xmu,ymu);
%UNTITLED 此处显示有关此函数的摘要
%   [cx cy]=rect(muscleCX,muscleCY,xmu,ymu);
%rectangle('Position’, [x_start, y_start,width, h]); 
% 程序如下：
x_start=muscleCX-xmu;
y_start=muscleCY-ymu;
width=2*xmu;
h=2*ymu;
rectangle('Position',[x_start, y_start,width, h],'EdgeColor','r','LineWidth',2); 
end