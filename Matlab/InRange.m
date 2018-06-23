function [ inRange ] = InRange( range1, range2 )
% This function will test if range 2 is a subset of range1 or intersect
% with range1, if it is the case, the funtion will return 1, otherwise it
% return 0.
% Both inputs should formated with [xmin,xmax,ymin,ymax,zmin,zmax]
xbool = range2(1)>range1(2) || range1(1)>range2(2);
ybool = range2(3)>range1(4) || range1(3)>range2(4);
zbool = range2(5)>range1(6) || range1(5)>range2(6);
if ~xbool&&~ybool&&~zbool
    inRange = 1;
else 
    inRange = 0;
end

