function plot_rectangle(muscleCX,muscleCY,xmu,ymu);
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   [cx cy]=rect(muscleCX,muscleCY,xmu,ymu);
%rectangle('Position��, [x_start, y_start,width, h]); 
% �������£�
x_start=muscleCX-xmu;
y_start=muscleCY-ymu;
width=2*xmu;
h=2*ymu;
rectangle('Position',[x_start, y_start,width, h],'EdgeColor','r','LineWidth',2); 
end