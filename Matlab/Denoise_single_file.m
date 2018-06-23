% denoise the point clouds relating to the horizontal distance
clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_sections.mat');
% T = downsample(X,10);
% T(:,2) = T(:,2) - repmat(548000,length(T),1);
% T(:,3) = T(:,3) - repmat(5804000,length(T),1);
shift = [548000 5804000 0 0 0 0];

x= Trajectory_sec3(:,2);
y =Trajectory_sec3(:,3)-2;
X = [ones(size(x)) x];
b=regress(y,X)

    filename = 'D:\PP2\plane_estimation\pointsInPlane\model\tmp\3plane2.txt';
    pointcloud = importdata(filename);
    pointcloud = pointcloud  - repmat(shift,length(pointcloud),1);
    fprintf('Denoising file "%s"\n',filename);
    fprintf('number of point cloud before denoising:%d\n',length(pointcloud));
%     delete(filename);
      fileID = fopen('D:\PP2\plane_estimation\pointsInPlane\model\tmp\text.txt','wt');
        
    for j=1:length(pointcloud)
%          mindist = 100000;
%          idx = find(abs(Trajectory_sec2(:,2)-pointcloud(j,1))<2);
%          t = Trajectory_sec2(idx,:);
%          idx = find(abs(Trajectory_sec2(:,3)-pointcloud(j,2))<10);
%          t = Trajectory_sec2(idx,:);
%          for k=1:length(t)
%              dist = (Trajectory_sec2(k,2)-pointcloud(j,1))^2+(Trajectory_sec2(k,3)-pointcloud(j,2))^2;
%              if dist<mindist
%                 mindist = dist;
%              end
%          end
         mindist = abs(b(1)-pointcloud(j,2)+b(2)*pointcloud(j,1));
         if mindist<10
            fprintf(fileID,'%.6f %.6f %.6f %d %d %d\n',pointcloud(j,:)+shift);
         end

    end
 fclose(fileID);
%     fprintf('number of point cloud after denoising:%d\n',length(pointcloud));
%     pointcloud(:,1:2) = pointcloud(:,1:2) + repmat(shift(1:2),length(pointcloud),1);
%     savePointCloud('D:\PP2\plane_estimation\pointsInPlane\filtered\facade2_filtered.txt',pointcloud)
