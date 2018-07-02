function [ave,points_red] = getReducedCoordinates(points)
    ave = sum(points)/size(points,1);
    points_red = points - repmat(ave,length(points),1);
end

