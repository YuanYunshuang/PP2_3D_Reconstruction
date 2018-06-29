clc 
clear all
close all
fclose all;
%###################
% Listing the point cloud file name
pcFileList = dir('G:\PP2\New\ELAS\pointcloudELAS_global');
pcFileList = pcFileList(3:end);
filename = 'G:\PP2\New\ELAS\XYZRange.txt';
if exist(filename,'file')==2
    delete(filename);
end
fileID = fopen(filename,'wt');% take care, if use 'w' instead of 'wt', fprintf('\n') would not work
fprintf(fileID,'%10s %19s %19s %19s %19s %19s %19s \n','Filename',...
    'Xmin |','Xmax |','Ymin |','Ymax |','Zmin |','Zmax |');    
X = [10e10,-10e10];
Y = [10e10,-10e10];
Z = [10e10,-10e10];
for i=1:length(pcFileList)
    filename = strcat('G:\PP2\New\ELAS\pointcloudELAS_global\',pcFileList(i).name);
    pointcloud = importdata(filename);
    
    x= [10e10,-10e10];
    y= [10e10,-10e10];
    z= [10e10,-10e10];
    
    for j=1:length(pointcloud)
        x(1)=min(pointcloud(j,1),x(1));
        x(2)=max(pointcloud(j,1),x(2));
        y(1)=min(pointcloud(j,2),y(1));
        y(2)=max(pointcloud(j,2),y(2));
        z(1)=min(pointcloud(j,3),z(1));
        z(2)=max(pointcloud(j,3),z(2));
%         fprintf('%10s %14.6f %14.6f %14.6f\n',...
%         pcFileList(i).name,pointcloud(j,1:3));
%         fprintf('%10s %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f \n',...
%         pcFileList(i).name,x(1),x(2),y(1),y(2),z(1),z(2));
    end
    

    fprintf(fileID,'%10s %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f \n',...
        pcFileList(i).name,x(1),x(2),y(1),y(2),z(1),z(2));
    X(1) = min(X(1),x(1));
    X(2) = max(X(2),x(2));
    Y(1) = min(Y(1),y(1));
    Y(2) = max(Y(2),y(2));
    Z(1) = min(Z(1),z(1));
    Z(2) = max(Z(2),z(2));
    
end
fprintf(fileID,'\n%10s %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f \n',...
    'Overall',X(1),X(2),Y(1),Y(2),Z(1),Z(2));
fclose(fileID);