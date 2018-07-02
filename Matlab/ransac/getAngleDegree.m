function alpha = getAngleDegree( n1,n2 )
alpha=atan2d(norm(cross(n1,n2)),dot(n1,n2));
end