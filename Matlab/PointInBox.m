function [ in ] = PointInBox( box,point )
% This function tests if a point lies in a bounding box
    xbool = point(1)>box(1)&&point(1)<box(2);
    ybool = point(2)>box(3)&&point(2)<box(4);
    zbool = point(3)>box(5)&&point(3)<box(6);
    if xbool && ybool && zbool
        in = 1;
    else
        in = 0;
    end
end

