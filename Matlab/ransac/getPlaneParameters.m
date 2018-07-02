function [ n,d ,lamda] = getPlaneParameters( points )
% This function will calculate the parameters a,b,c,d which determine a
% plane from the points cloud
% input should be a n*3 matrix
% output is a normal vector contains a,b,c and the scala value d
% =======================================================================
[ave,points_red] = getReducedCoordinates(points);
% matrix S=A'A
S11=sum(points_red(:,1).^2);
S12=sum(points_red(:,1).*points_red(:,2));
S13=sum(points_red(:,1).*points_red(:,3));
S21=S12;
S22=sum(points_red(:,2).^2);
S23=sum(points_red(:,2).*points_red(:,3));
S31=S13;
S32=S23;
S33=sum(points_red(:,3).^2);
S=[S11 S12 S13;
   S21 S22 S23;
   S31 S32 S33];
%Normal vector n
[n,lamda] = eigs(S,1,'SM');
d=-n'*ave';

end

