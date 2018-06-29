% x->[ 548849.517163  549068.048645]----Delta_x = 218.5315
% y->[5804381.287557 5804599.942831]----Delta_y = 218.6553
% z->[     81.726773    128.859640 ]----Delta_z = 47.1329
% The subspace in the range would be splitted into many 15*15*15 boxes,
% x start with 548845, end with 549070, and centered to [845 1070]
% y start with 5804380, end with 5804605, and centered to [380 605]
% z start with 75, end with 135.
%--------------------------------------------------------------------------
% The new generated point cloud is splitted into many boxes, each box will
% be saved in a single txt file. The name of the file is formated with box
% index:
% ex.     x          y          z
%     [845 860]   [380 395]   [75 90]
% named as "010101.txt".
%###########################################################################
clc
close all
clear all
fclose('all');
% Listing the point cloud file name
pcFileList = dir('G:\PP2\New\ELAS\pointcloudELAS_global');
pcFileList = pcFileList(3:end);

% read the XYZRange
range = importdata('G:\PP2\New\ELAS\XYZRange.txt');
ranges = range.data(1:end-1,:);
shift = [548000 548000 5804000 5804000 0 0];
ranges = ranges-repmat(shift,length(ranges),1);
overall_range = range.data(end,:)-shift;

% Initializing bounding boxes
bx = zeros(15*15*4,7);
n = 1;
for i=1:15
    for j=1:15
        for k=1:4
            filename = i*10000+j*100+k;
            bx(n,1) = filename;
            bx(n,2:7) = [845+15*(i-1) 845+15*i 380+15*(j-1) 380+15*j 75+15*(k-1) 75+15*k];
            n=n+1;
        end
    end
end

% Filling the boxes
for i=1:length(bx)
    filename = strcat(num2str(bx(i,1)),'.txt');
    savepath =strcat( 'G:\PP2\New\ELAS\Cubes15m\',filename);
    if exist(savepath,'file')==2
        delete(savepath);
    end
    fileID = fopen(savepath,'wt');
    empty = 1;
    for j=1:length(ranges)
       if InRange(bx(i,2:end),ranges(j,:)) 
           name = strcat('G:\PP2\New\ELAS\pointcloudELAS_global\',pcFileList(j).name);
           pc = importdata(name);
           pc(:,1:3) = pc(:,1:3)-repmat(shift(1:2:6),length(pc),1);
           for k=1:length(pc)
             if  PointInBox(bx(i,2:7),pc(k,1:3))
                 fprintf(fileID,'%.6f %.6f %.6f %d %d %d\n',pc(k,:));
                 empty = 0;
             end
           end
       end
    end
    if empty==0
        fclose(fileID);
        empty = 1;
    else
        fclose(fileID);
        delete(savepath);
    end
    
end