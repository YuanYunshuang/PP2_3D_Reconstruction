function [ n,d] = getPlaneParametersFrom3Points( points )
n=cross(points(2,:)-points(1,:),points(3,:)-points(1,:));
n=(n/norm(n))';
d=-points(3,:)*n;
end