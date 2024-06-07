%求（cmu_x,cmu_y)对应角在椭圆径向距离
function r=radius(cmu_x, cmu_y, xc, yc,a,b) %(x,y)与椭圆中心（xc,yc)距离
theta = atan2(cmu_y - yc, cmu_x - xc);%此处是弧度制
t = atan(a*tan(theta)/b);
r = sqrt(a^2*(cos(t))^2 + b^2*(sin(t))^2);
end