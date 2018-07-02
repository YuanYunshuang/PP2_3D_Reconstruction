

clc
clear all
close all
pointcloud = importdata('seg1_left.txt');
ptCloud = pointCloud(pointcloud(:,1:3));
r = typecast(pointcloud(:,4),'unit8');
g = typecast(pointcloud(:,5),'unit8');
b = typecast(pointcloud(:,6),'unit8');
ptCloud.Color = [r g b];
pcwrite(ptCloud,'seg1_left.ply');