
pc = importdata('D:\PP2\plane_estimation\pointsInPlane\filtered\section2_original.txt');
for i=1:length(pc)
    if pc(i,3)<97
        pc(i,3) = 97+rand;
    end
end

savePointCloud('D:\PP2\plane_estimation\pointsInPlane\filtered\section2.txt',pc);