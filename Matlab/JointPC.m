clc
close all
clear all
fclose('all');
% Listing the point cloud file name
pcFileList = dir('E:\PraxisProjekt2\data\IKGVAN\scenario_1\pointcloud_global');
pcFileList = pcFileList(3:end);

% Read in the trajectry
load('Trajectory_sections.mat');

% T(:,2) = T(:,2) - repmat(548000,length(T),1);
% T(:,3) = T(:,3) - repmat(5804000,length(T),1);

% Listing the point cloud file name
pcFileList = dir('D:\PP2\plane_estimation\pointcloud_filtered2');
pcFileList = pcFileList(3:end);
% mkdir D:\PP2\plane_estimation\pointcloud_filtered2\section1;
% mkdir D:\PP2\plane_estimation\pointcloud_filtered2\section2;
% mkdir D:\PP2\plane_estimation\pointcloud_filtered2\section3;

for i=1:length(pcFileList)
% ex.     x          y          z
%     [845 860]   [380 395]   [75 90]
% named as "010101.txt".
     name = str2num(pcFileList(i,1).name(1:end-4));
     x = floor(name/10000)*15+830+7.5;
     y = floor(rem(name,10000)/100)*15+365+7.5;
     z = rem(name,100)*15+60+7.5;
     mindist = 100000;
     locateTo = 0;
     for j=1:length(Trajectory_sec1)
         dist = (Trajectory_sec1(j,2)-x)^2+(Trajectory_sec1(j,3)-y)^2;
         if dist<mindist
            mindist = dist;
            locateTo = 1;
         end
     end
     
     for j=1:length(Trajectory_sec2)
         dist = (Trajectory_sec2(j,2)-x)^2+(Trajectory_sec2(j,3)-y)^2;
         if dist<mindist
            mindist = dist;
            locateTo = 2;
         end
     end
     
     for j=1:length(Trajectory_sec3)
         dist = (Trajectory_sec3(j,2)-x)^2+(Trajectory_sec3(j,3)-y)^2;
         if dist<mindist
            mindist = dist;
            locateTo = 3;
         end
     end
     
     cd('D:\PP2\plane_estimation\pointcloud_filtered2');
     switch locateTo
         case 1
            movefile(pcFileList(i,1).name,'section1');
         case 2
            movefile(pcFileList(i,1).name,'section2');
         case 3
            movefile(pcFileList(i,1).name,'section2');
     end

end
