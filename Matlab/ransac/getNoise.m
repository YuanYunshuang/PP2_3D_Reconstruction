function [ sigma ] = getNoise( points,n,d )
vv=0;
for i=1:size(points,1)
v=points(i,:)*n+d;    
vv=vv+v^2;%residuals
end
sigma=sqrt(vv/(size(points,1)-3));
end