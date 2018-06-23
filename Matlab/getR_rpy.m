function [ R_rpy ] = getR_rpy( roll, pitch, yaw )

%die Winkel erhalten wir aus der trajectory_MMS.txt
%hier stehen erstmal Beispielwinkel
roll = roll*pi/180;
pitch = pitch*pi/180;
yaw = yaw* pi/180;
R_yaw = [
    cos(yaw)  -sin(yaw) 0;
    sin(yaw)  cos(yaw)  0;
    0           0           1];

R_pitch = [
    cos(pitch)   0   sin(pitch);
    0           1   0;
    -sin(pitch)  0   cos(pitch)];

R_roll = [
    1           0     0;
    0   cos(roll) -sin(roll)
    0   sin(roll)  cos(roll)];

R_rpy=R_yaw*R_pitch*R_roll;

end

