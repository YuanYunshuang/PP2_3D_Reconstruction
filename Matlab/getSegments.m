% denoise the point clouds relating to the horizontal distance
clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_sections.mat');
shift = [548000 5804000 0 0 0 0];
%%%%%%%%%%%%%%%%%%[ Get parameter for section 1 ]%%%%%%%%%%%%%%%%%%%
X = [ones(size(Trajectory_sec3(:,2))) Trajectory_sec3(:,2)];
a = regress(Trajectory_sec3(:,3),X); 
norm_term = sqrt(a(2)^2+1);
% Listing the point cloud file name
pcFileList = dir('G:\PP2\New\SPSS\pointcloudSPSS_global_3sections\section3');
pcFileList = pcFileList(3:end);

%% Breaking the trajectory into segments,each segment has at most 15m
figure 
axis equal
x1 = 990:-0.25:938;
y1 = a(1)+a(2)*x1;
L = [x1' y1'];
seg_start = L(1,:);
plot(T(:,2),T(:,3),'LineWidth',3);
hold on
% get cut lines
n = floor(norm(L(1,:) - L(end,:))/15)*2;
B = zeros(n,5); % matrix for storing parameters of the lines
count = 1;
l = length(x1);
for i=2:l
    if norm(L(i,:)-seg_start)>7.5
        seg_start = L(i,:);
        B(count,3:4) =  seg_start;
        [b1,b2] = getVerticalLine(a(2),seg_start);
        B(count,1:2) = [b1 b2];
        B(count,5) = sqrt(B(count,2)^2+1);
        if rem(count,2)==0
            x2 = seg_start(1)-1.5:1:seg_start(1)+1.5;
            y2 = B(count,1)+B(count,2)*x2;  
            plot(x2,y2);
        end
        count = count + 1;
    end
end
B = B(2:2:end,:);


%% Put the point cloud into different segments
n = size(B,1);
% fIDs = zeros(1,n);
for i=1:n
    filename = strcat('G:\PP2\New\SPSS\pointcloudSPSS_global_segments\section3\seg',num2str(i));
    filename = strcat(filename,'.txt');
    if exist(filename,'file')==2
        delete(filename);
    end
    fopen(filename,'wt');
end
fIDs = fopen('all');
%====================================================================================================================
for i=1:length(pcFileList)
    pointcloud = importdata(strcat('G:\PP2\New\SPSS\pointcloudSPSS_global_3sections\section3\',pcFileList(i).name));
    l = length(pointcloud);
    pointcloud = pointcloud - repmat(shift,l,1);
    
    for j = 1:l
%         tmp = abs(a(1)-pointcloud(j,2)+a(2)*pointcloud(j,1))/norm_term;
%         if tmp>40
%             continue
%         end
        min2line = 1;
        dist_min = abs(B(1,1)-pointcloud(j,2)+B(1,2)*pointcloud(j,1))/B(1,3);
        for k = 2:n
            dist = abs(B(k,1)-pointcloud(j,2)+B(k,2)*pointcloud(j,1))/B(k,3);
            if dist_min>dist
                dist_min = dist;
                min2line = k;
            end
        end

        fprintf(fIDs(min2line),'%.6f %.6f %.6f %d %d %d\n',pointcloud(j,:));
    end
%     fclose('all');
end

fclose('all');
