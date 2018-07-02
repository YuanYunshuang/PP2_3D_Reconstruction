clc
clear
tic
% Load the Tango point cloud (left)
points1 = LoadPly('schneiderberg15cm_1.ply'); % One plane at street schneiderberg
points1=points1';
disp(['First scene: ',num2str(size(points1,1)),' x ', num2str(size(points1,2))])

%% =========================================================
% Load the Riegl point cloud (right)
points2 = LoadPly('schneiderberg15cm_2.ply'); % Two planes at street schneiderberg
points2=points2';
disp(['Second scene: ',num2str(size(points2,1)),' x ', num2str(size(points2,2))])
disp('')
%% =========================================================

% Scene 1
% Use your own values!
z = 0.95; % Probability to find the plane
w = 0.5; % Probability that a point belongs to a plane
max_diff = 0.2; % Max. difference of a point to plane
min_dist=1;
max_dist=1.5;
%% =========================================================
% [n_S1,d_S1,new_points_S1,outliers_S1] = ransac(points1,z,w,max_diff);
[n_S1,d_S1,new_points_S1,outliers_S1] = ransacOpt(points1,z,w,max_diff,min_dist,max_dist);
[n_S1_new,d_S1_new,lambda] = PCA(new_points_S1) % Get plane parameters without outliers
%% =========================================================

% % Scene 2
z = 0.95; % Probability to find the plane
w_plane1 = 0.35; % Probability that a point belongs plane1
w_plane2 = 0.6; % Probability that a point belongs plane2 after removing plane 1
max_diff = 0.2; % Max. difference of a point to plane

%% =========================================================
% [n1_S2,d1_S2,plane1,outliers1] = ransac(points2,z,w_plane1,max_diff);
[n1_S2,d1_S2,plane1,outliers1] = ransacOpt(points2,z,w_plane1,max_diff,min_dist,max_dist);
[n1_S2,d1_S2,lambda] = PCA(plane1) % Get plane parameters without outliers

% [n2_S2,d2_S2,plane2,outliers_S2] = ransac(outliers1,z,w_plane2,max_diff);
[n2_S2,d2_S2,plane2,outliers_S2] = ransacOpt(outliers1,z,w_plane2,max_diff,min_dist,max_dist);
[n2_S2,d2_S2,lambda] = PCA(plane2) % Get plane parameters without outliers

% Agnle between planes
alpha = getAngleDegree(n1_S2,n2_S2)
%% =========================================================
x1=-20:5:0;
x1=x1';
z1=0:5:20;
z1=z1';
[X1,Z1]=meshgrid(x1,z1);
Y11=-(1/n_S1(2))*(n_S1(1)*X1+n_S1(3)*Z1+d_S1);
Y12=-(1/n2_S2(2))*(n2_S2(1)*X1+n2_S2(3)*Z1+d2_S2);

y2=(-5:5:20)';
[Y2,Z2]=meshgrid(y2,y2);
X2=-(1/n1_S2(1))*(n1_S2(2)*Y2+n1_S2(3)*Z2+d1_S2);

figure
scatter3(outliers_S1(:,1),outliers_S1(:,2),outliers_S1(:,3),'.r');
hold on
scatter3(new_points_S1(:,1),new_points_S1(:,2),new_points_S1(:,3),'.g');
view(-24,24);
title('Scene 1 with one plane');
xlabel('X-Achse') 
ylabel('Y-Achse')
zlabel('Z-Achse')
legend('outliers','plane');
surface(X1,Y11,Z1,repmat(50,length(Y11)));

figure
hold on
scatter3(plane1(:,1),plane1(:,2),plane1(:,3),'.g');
scatter3(plane2(:,1),plane2(:,2),plane2(:,3),'.b');
scatter3(outliers_S2(:,1),outliers_S2(:,2),outliers_S2(:,3),'.r');
surface(X1,Y12,Z1,repmat(50,length(Y12)));
surface(X2,Y2,Z2,repmat(50,length(Y2)));
view(-24,24);
title('Scene 2 with two planes')
xlabel('X-Achse') 
ylabel('Y-Achse')
zlabel('Z-Achse')
legend('plane1','plane2','outliers');

toc


