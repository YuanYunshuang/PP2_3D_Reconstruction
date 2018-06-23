clc
clear all
close all

load('Trajectory.mat');

%%
e_x_glob = [1 0 0]'; % front
e_y_glob = [0 1 0]'; % left
e_z_glob = [0 0 1]'; % up
origin_glob = [0 0 0]';

time200 = 1497279241.196106;
time270 = 1497279243.996085;
tmp = Trajectory(:,1);
index200 = find(abs(tmp-time200)<10e-4);
index270 = find(abs(tmp-time270)<10e-4);

traj_tranf200 = Trajectory(index200,:);
traj_tranf270 = Trajectory(index270,:);

[ R,t, Rmm, Tmm ] = ParamGetter();
[ R_rpy200] = getR_rpy(traj_tranf200(5), traj_tranf200(6), traj_tranf200(7));
[ R_rpy270] = getR_rpy(traj_tranf270(5), traj_tranf270(6), traj_tranf270(7));
p200 = importdata('000200.txt');
p270 = importdata('000270.txt');
p200(:,1:2) = -p200(:,1:2);
p270(:,1:2) = -p270(:,1:2);

R_BodyToGlobal = [[0 1 0];[1 0 0];[0 0 -1]];
l200 = length(p200);
l270 = length(p270);
p200_glob = zeros(l200,3);
p270_glob = zeros(l270,3);
for i = 1:length(p200)    
p200_glob(i,:) = R_BodyToGlobal*R_rpy200*(Rmm'*(R*p200(i,1:3)'+t)-Tmm)+traj_tranf200(2:4)';
end
for i = 1:length(p270)    
p270_glob(i,:) = R_BodyToGlobal*R_rpy270*(Rmm'*(R*p270(i,1:3)'+t)-Tmm)+traj_tranf270(2:4)';
end

figure(1)
pointcloud = [p200_glob;p270_glob];
ptCloud = pointCloud(pointcloud);
pcshow(ptCloud);
pcwrite(ptCloud,'pt_test.ply');



