clc
close all
clear all

pc = importdata('D:\PP2\plane_estimation\pointsInPlane\filtered\section2.txt');
road = 'D:\PP2\plane_estimation\pointsInPlane\filtered\section2_road.txt';
facades = 'D:\PP2\plane_estimation\pointsInPlane\filtered\section2_facades.txt';
if exist(road,'file')==2
    delete(road);
end
if exist(facades,'file')==2
    delete(facades);
end
roadID = fopen(road,'wt');
facadesID = fopen(facades,'wt');
   
for i=1:length(pc)
    if pc(i,3)>98
        fprintf(facadesID,'%.6f %.6f %.6f %d %d %d\n',pc(i,:));
    else
        fprintf(roadID,'%.6f %.6f %.6f %d %d %d\n',pc(i,:));
    end
end

fclose(roadID);
fclose(facadesID);
           