function [varargout] = countConsensus(n,d,points,max_diff)
if nargout==1
    number=0;
    for i=1:length(points)
        temp=abs(points(i,:)*n+d);
        if temp<max_diff
            number=number+1;
        end
    end
    varargout{1}=number;
    return
else  new_points=[];
      outliers=[];
    for i=1:length(points)
        temp=abs(points(i,:)*n+d);
        if temp<max_diff
            new_points=[new_points;points(i,:)];
        else outliers=[outliers;points(i,:)];
        end
    end
    varargout{1}=new_points;
    varargout{2}=outliers;
    return
end
end