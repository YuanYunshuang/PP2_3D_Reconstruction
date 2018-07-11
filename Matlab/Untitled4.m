% Delete noise from the road plane


clc
close all
clear all

pc1 = importdata('C:\Users\ophelia\Desktop\Segmentation_Results_V2\section1_road.txt');
pc2 = importdata('C:\Users\ophelia\Desktop\Segmentation_Results_V2\section2_road.txt');
pc3 = importdata('C:\Users\ophelia\Desktop\Segmentation_Results_V2\section3_road.txt');

load('Trajectory_sections.mat');
X1 = [ones(size(Trajectory_sec1(:,2))) Trajectory_sec1(:,2)];
a1 = regress(Trajectory_sec1(:,3),X1); 
norm_term1 = sqrt(a1(2)^2+1);
X2 = [ones(size(Trajectory_sec2(:,2))) Trajectory_sec2(:,2)];
a2 = regress(Trajectory_sec2(:,3),X2); 
norm_term2 = sqrt(a2(2)^2+1);
X3 = [ones(size(Trajectory_sec3(:,2))) Trajectory_sec3(:,2)];
a3 = regress(Trajectory_sec3(:,3),X3); 
norm_term3 = sqrt(a3(2)^2+1);

fn1='C:\Users\ophelia\Desktop\Segmentation_Results_V3\section1_road.txt';
if exist(fn1,'file')==2
    delete(fn1);
end
fid=fopen(fn1,'wt');
l=length(pc1);
for i=1:l
    mindist = (a1(1)-pc1(i,2)+a1(2)*pc1(i,1))/norm_term1;
    if mindist>-6.5 && mindist<8
        fprintf(fid,'%.6f %.6f %.6f %d %d %d\n',pc1(i,:));
    end
end
fclose(fid);

fn1='C:\Users\ophelia\Desktop\Segmentation_Results_V3\section2_road.txt';
if exist(fn1,'file')==2
    delete(fn1);
end
fid=fopen(fn1,'wt');
l=length(pc2);
for i=1:l
    mindist = (a2(1)-pc2(i,2)+a2(2)*pc2(i,1))/norm_term2;
    if mindist>-6.5 && mindist<8
        fprintf(fid,'%.6f %.6f %.6f %d %d %d\n',pc2(i,:));
    end
end
fclose(fid);

fn1='C:\Users\ophelia\Desktop\Segmentation_Results_V3\section3_road.txt';
if exist(fn1,'file')==2
    delete(fn1);
end
fid=fopen(fn1,'wt');
l=length(pc3);
for i=1:l
    mindist = (a3(1)-pc3(i,2)+a3(2)*pc3(i,1))/norm_term3;
    if mindist>-6.5 && mindist<8
        fprintf(fid,'%.6f %.6f %.6f %d %d %d\n',pc3(i,:));
    end
end
fclose(fid);      