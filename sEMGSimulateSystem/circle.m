function [cx cy] = circle(x,y,r)
%���ɼ���MU�ֲ���Բ
%   �˴���ʾ��ϸ˵��
% �������£�
t=0:pi/100:2*pi;
cy=r*sin(t)+y;
cx=r*cos(t)+x;
end

