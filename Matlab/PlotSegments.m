% denoise the point clouds relating to the horizontal distance
clc
clear all
close all
fclose('all');
% Read in the data
load('Trajectory_sections.mat');
shift = [548000 5804000 0 0 0 0];

figure 
axis equal
plot(T(:,2),T(:,3),'LineWidth',3);
hold on
%% Breaking the trajectory into segments,each segment has at most 15m
%======================================ONE==============================================
X = [ones(size(Trajectory_sec1(:,2))) Trajectory_sec1(:,2)];
a = regress(Trajectory_sec1(:,3),X); 
x1 = 844:0.5:1000;
y1 = a(1)+a(2)*x1;
L = [x1' y1'];
seg_start = L(1,:);

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
            x2 = seg_start(1)-1:1:seg_start(1)+1;
            y2 = B(count,1)+B(count,2)*x2;  
            plot(x2,y2);
        end
        count = count + 1;
    end
end

%======================================TWO==============================================
X = [ones(size(Trajectory_sec2(:,2))) Trajectory_sec2(:,2)];
a = regress(Trajectory_sec2(:,3),X); 
x1 = 1004:-0.25:993;
y1 = a(1)+a(2)*x1;
L = [x1' y1'];
seg_start = L(1,:);

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
            x2 = seg_start(1)-5:1:seg_start(1)+5;
            y2 = B(count,1)+B(count,2)*x2;  
            plot(x2,y2);
        end
        count = count + 1;
    end
end

%======================================THREE==============================================
X = [ones(size(Trajectory_sec3(:,2))) Trajectory_sec3(:,2)];
a = regress(Trajectory_sec3(:,3),X); 
x1 = 990:-0.25:938;
y1 = a(1)+a(2)*x1;
L = [x1' y1'];
seg_start = L(1,:);
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
