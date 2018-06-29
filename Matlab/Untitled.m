clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_sections.mat');
% load('Trajectory_for_images.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x= Trajectory_sec1(:,2);
y =Trajectory_sec1(:,3);
X = [ones(size(x)) x];
b = regress(y,X);
figure 
axis equal
% xlim =([990,1005]);
x1 = 845:1:1005;
% x2 = 920:1:930;
y1 = b(1)+b(2)*x1;
m = x1(12);
n = y1(12);
% m = x1(floor(length(x1)/2));
% n = y1(floor(length(x1)/2));
% c1 = n+m/b(2);
% c2 = -1/b(2);
[ c1,c2 ] = getVerticalLine( b(2),[m n] );
x2 = m-1:1:m+1;
y2 = c1 + c2*x2;
% plot(Trajectory_sec1(:,2),Trajectory_sec1(:,3));
plot(T(:,2),T(:,3));
hold on
% plot(x1,y1)
hold on
plot(x2,y2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x= Trajectory_sec2(:,2);
y =Trajectory_sec2(:,3);
X = [ones(size(x)) x];
b = regress(y,X);
% xlim =([990,1005]);
x1 = 995:1:1000;
x2 = 980:1:1010;
y1 = b(1)+b(2)*x1;
m = x1(floor(length(x1)/2));
n = y1(floor(length(x1)/2));
% c1 = n+m/b(2);
% c2 = -1/b(2);
[ c1,c2 ] = getVerticalLine( b(2),[m n] );
y2 = c1 + c2*x2;
% plot(x1,y1)
hold on
plot(x2,y2)
plot(Trajectory_sec2(:,2),Trajectory_sec2(:,3));
% for i = 1:length(Trajectory_sec2)
% d = abs(b(1)-Trajectory_sec2(i,3)+b(2)*Trajectory_sec2(i,2));
% fprintf('%.6f\n',d);
% end