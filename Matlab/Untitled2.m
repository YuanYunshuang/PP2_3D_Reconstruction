

clc
clear all
close all
pointcloud = importdata('seg1_left.txt');
ptCloud = pointCloud(pointcloud(:,1:3));
c = uint8(pointcloud(:,4:6));
% g = uint8(pointcloud(:,5),'unit8');
% b = uint8(pointcloud(:,6),'unit8');
ptCloud.Color = c;
pcwrite(ptCloud,'seg1_left.ply');