function [ n,d,new_points,outliers ] = ransac( points,z,w,max_diff)
b=w^3;
k=ceil(log10(1-z)/log10(1-b))
consensus=zeros(k,5);
for i=1:k
    points3=zeros(3,3);
    index3 = randi(length(points),3,1);
    for j=1:3
        points3(j,:)=points(index3(j),:);
    end
    [ n,d]=getPlaneParametersFrom3Points(points3);
    consensus(i,2:5)=[n' d];
    consensus(i,1)=countConsensus(n,d,points,max_diff);
end
[M,I]=max(consensus(:,1));
bestFit=consensus(I,:);
n=bestFit(2:4)';
d=bestFit(5);
[ new_points, outliers ] = countConsensus( n,d,points,max_diff);
end