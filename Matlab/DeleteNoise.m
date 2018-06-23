clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_for_images.mat');
T = downsample(X,20);
T(:,2) = T(:,2) - repmat(548000,length(T),1);
T(:,3) = T(:,3) - repmat(5804000,length(T),1);
% Listing the point cloud file name
pcFileList = dir('D:\PP2\VoxelGridFiltering\pointcloud_filtered-COPY2');
pcFileList = pcFileList(3:end);

for i=1:length(pcFileList)
% ex.     x          y          z
%     [845 860]   [380 395]   [75 90]
% named as "010101.txt".
     name = str2num(pcFileList(i,1).name(1:end-4));
     x = floor(name/10000)*15+830+7.5;
     y = floor(rem(name,10000)/100)*15+365+7.5;
     z = rem(name,100)*15+60+7.5;
     mindist = 100000;
     for j=1:length(T)
         dist = (T(j,2)-x)^2+(T(j,3)-y)^2;
         if dist<mindist
            mindist = dist;
         end
     end
     mindist = sqrt(mindist);
     if mindist>20 || pcFileList(i).bytes<1000000
         file = strcat('D:\PP2\VoxelGridFiltering\pointcloud_filtered-COPY2\',pcFileList(i,1).name);
         delete(file);
     end
end