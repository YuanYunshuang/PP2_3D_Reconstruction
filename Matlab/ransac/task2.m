clc 
clear
% format double
pic=imread('depthImage_8Bit.PNG');
pic= double(pic);
cx=260.1922;
cy=209.5835;
f= 365.5953;

[r,c]=size(pic);
pixels= r*c;
picVec=reshape(pic,pixels,1);
picVec(picVec==0)=[];
m=length(picVec);% number of no 0 pixels 
Coordinates=zeros(m,3);
n=1;

for i=1:r % y of the image
    for j=1:c % x of the image  
      if pic(i,j)~=0
      Coordinates(n,1)= ((j-cx)*pic(i,j))/f;   % x of object
      Coordinates(n,2)= pic(i,j);  %y
      Coordinates(n,3)= ((-(i-cy)*pic(i,j)))/f;  %z
      n=n+1;
      end
    end
end

ptCloud = pointCloud(Coordinates);
ptCloudOut = pcdenoise(ptCloud,'Threshold',1);
pcwrite(ptCloudOut,'Coordinates','PLYFormat','binary');

figure
pcshow(ptCloudOut);
title('Result of the point coordinates');
xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
