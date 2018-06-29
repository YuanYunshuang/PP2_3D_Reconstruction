function [ b1,b2 ] = getVerticalLine( a2,point )
m = point(1);
n = point(2);
b1 = n+m/a2;
b2 = -1/a2;
end

