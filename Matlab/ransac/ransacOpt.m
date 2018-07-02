function [ n,d,new_points,outliers ] = ransacOpt( points,z,w,max_diff,min_dist,max_dist)
b=w*0.5;
k=ceil(log10(1-z)/log10(1-b))
consensus=zeros(k,5);
tree = KDTreeSearcher(points);
for i=1:k
    points3=zeros(3,3);
    index1 = randi(length(points));
    points3(1,:)=points(index1,:);
    x1=points(index1,1);
    y1=points(index1,2);
    z1=points(index1,3);
    p=1;
    n=0;
    idx = rangesearch(tree, points3(1,:), max_dist);
    idx = idx{1};
%--------------------------------------------------------------------------
    for j=2:3
        while(1)
           index= randi(length(idx));
           x=points(idx(index),1);
           y=points(idx(index),2);
           z=points(idx(index),3);
           dist=sqrt((x1-x)^2+(y1-y)^2+(z1-z)^2);
           if (dist>min_dist) 
               points3(j,:)=points(idx(index),:);
               p=p+1;
               break;
           end
           if n>1000
               break;
           end
           n=n+1;
        end
    end 
%--------------------------------------------------------------------------
    if p==3
        [ n,d]=getPlaneParametersFrom3Points(points3);
        consensus(i,2:5)=[n' d];
        consensus(i,1)=countConsensus(n,d,points,max_diff);
    end
%--------------------------------------------------------------------------
end
[M,I]=max(consensus(:,1));
bestFit=consensus(I,:);
n=bestFit(2:4)';
d=bestFit(5);
[ new_points, outliers ] = countConsensus( n,d,points,max_diff);
end