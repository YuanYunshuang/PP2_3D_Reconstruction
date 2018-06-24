clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory.mat');
load('timestamps_camera.mat');
% Listing the point cloud file name
pcFileList = dir('G:\PP2\pointcloud');
pcFileList = pcFileList(3:end);

[ R,t, Rmm, Tmm ] = ParamGetter();
R_BodyToGlobal = [[0 1 0];[1 0 0];[0 0 -1]];
T = Trajectory(:,1);
lt = length(T);
pointer = 3;
%% Do transformation for each point cloud file

for i=1:length(pcFileList)
    tic
    filename = strcat('G:\PP2\pointcloud\',pcFileList(i).name);
    pointcloud = importdata(filename);
    pointcloud(:,1:2) = -pointcloud(:,1:2);
    tmp = pcFileList(i).name;
    timestamp = timestamps_camera(str2num(tmp(1:end-4))+1,2);
    diff1 = abs(timestamp-T(pointer-2));
    diff2 = abs(timestamp-T(pointer-1));
    for j=pointer:lt
        diff3 = abs(timestamp-T(j));
        if diff1>diff2 && diff2<diff3
            break;
        end
        diff1 = diff2;
        diff2 = diff3;
    end
    pointer = j;
    traj_t = Trajectory(pointer-1,:);
%     fprintf('%.6f | %.8f | %.8f | %.8f | %.8f | %.8f | %.8f |',traj_t);
    [ R_rpy] = getR_rpy(traj_t(5), traj_t(6), traj_t(7));
    l = length(pointcloud);
    pointcloud_glob = zeros(l,6);
    pointcloud_glob(:,4:6) = pointcloud(:,4:6);
  
    pointcloud_glob(:,1:3) = (R_BodyToGlobal*R_rpy*(Rmm'*(R*pointcloud(:,1:3)'...
        +repmat(t,1,l))-repmat(Tmm,1,l))+repmat(traj_t(2:4)',1,l))';
    savepath =strcat( 'G:\PP2\PP2data\data\IKGVAN\scenario_1\pointcloud_global\',pcFileList(i).name);
%      ptCloud = pointCloud(pointcloud_glob(:,1:3));
%      pcshow(ptCloud);
    savePointCloud(savepath,pointcloud_glob);
   
    fprintf('"%s" finished...i = %d\n',pcFileList(i).name,i);
    toc
end





