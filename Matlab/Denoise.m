% denoise the point clouds relating to the horizontal distance
clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_for_images.mat');
T = downsample(X,10);
T(:,2) = T(:,2) - repmat(548000,length(T),1);
T(:,3) = T(:,3) - repmat(5804000,length(T),1);
shift = [548000 5804000 0 0 0 0];
% Listing the point cloud file name
pcFileList = dir('D:\PP2\plane_estimation\pointcloud_filtered2');
pcFileList = pcFileList(3:end);

for i=1:length(pcFileList)
    filename = strcat('D:\PP2\plane_estimation\pointcloud_filtered2\',pcFileList(i).name);
    pointcloud = importdata(filename);
    pointcloud = pointcloud  - repmat(shift,length(pointcloud),1);
    fprintf('Denoising file "%s", -------------i=%d\n',filename,i);
    fprintf('number of point cloud before denoising:%d\n',length(pointcloud));
    delete(filename);
    j = 1;
    while(j<=length(pointcloud))
         mindist = 100000;
         idx = find(abs(T(:,2)-pointcloud(j,1))<15);
         t = T(idx,:);
         idx = find(abs(t(:,3)-pointcloud(j,2))<15);
         t = t(idx,:);
         for k=1:length(t)
             dist = (t(k,2)-pointcloud(j,1))^2+(t(k,3)-pointcloud(j,2))^2;
             if dist<mindist
                mindist = dist;
             end
         end
%          mindist = sqrt(mindist);
         if mindist>100
             pointcloud(j,:)=[];
             j = j-1;
         end
         j = j+1;
    end
    fprintf('number of point cloud after denoising:%d\n',length(pointcloud));
    pointcloud(:,1:2) = pointcloud(:,1:2) + repmat(shift(1:2),length(pointcloud),1);
    savePointCloud(filename,pointcloud)
end