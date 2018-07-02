clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_sections.mat');
shift = [548000 5804000 0 0 0 0];
%%%%%%%%%%%%%%%%%%[ Get regression parameter for section # ]%%%%%%%%%%%%%%%%%%%
X = [ones(size(Trajectory_sec3(:,2))) Trajectory_sec3(:,2)];
a = regress(Trajectory_sec3(:,3),X); 
norm_term = sqrt(a(2)^2+1);
% Listing the point cloud file name
pcFileList = dir('G:\PP2\New\ELAS\PCL_gefiltert\section3');
pcFileList = pcFileList(3:end);

for i=1:length(pcFileList)
    filename = strcat('G:\PP2\New\ELAS\PCL_gefiltert\section3\',pcFileList(i).name);
    pointcloud = importdata(filename);
%     pointcloud = pointcloud  - repmat(shift,length(pointcloud),1);
    fprintf('processing file "%s"\n',filename);
    name = pcFileList(i).name;
    name = name(1:end-4);
    fn = strcat('G:\PP2\New\ELAS\left_right_road\section3\',name);
    fn1 = strcat(fn,'_left.txt');
    fn2 = strcat(fn,'_right.txt');
    fn3 = strcat(fn,'_floor.txt');
    fn4 = strcat(fn,'_outliers.txt');
    if exist(fn1,'file')==2
        delete(fn1);
    end
    fopen(fn1,'wt');
    if exist(fn2,'file')==2
        delete(fn2);
    end
    fopen(fn2,'wt');
    if exist(fn3,'file')==2
        delete(fn3);
    end
    fopen(fn3,'wt');
    if exist(fn4,'file')==2
        delete(fn4);
    end
    fopen(fn4,'wt');

    fIDs = fopen('all');
        
    for j=1:length(pointcloud)

         mindist = (a(1)-pointcloud(j,2)+a(2)*pointcloud(j,1))/norm_term;
         if pointcloud(j,3)<98.2
             if pointcloud(j,3)<97
                pointcloud(j,3) = 97+rand;
             end      
            fprintf(fIDs(3),'%.6f %.6f %.6f %d %d %d\n',pointcloud(j,:));
         elseif mindist>8 && mindist<9
            fprintf(fIDs(1),'%.6f %.6f %.6f %d %d %d\n',pointcloud(j,:));
         elseif mindist<-4.5 && mindist>-6
            fprintf(fIDs(2),'%.6f %.6f %.6f %d %d %d\n',pointcloud(j,:));
         else
            fprintf(fIDs(4),'%.6f %.6f %.6f %d %d %d\n',pointcloud(j,:));
         end

    end
    fclose('all');
 end
