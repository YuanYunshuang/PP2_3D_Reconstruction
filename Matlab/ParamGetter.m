function [ R,t, Rmm, Tmm ] = ParamGetter( )


%% IKG mounting_camera.txt
alpha = 3.1493750236320928e+00;     % Rotation around vertical axis (yaw)
zeta = 1.5794758471340726e+00;      % rotation around horizontal axis (pitch)
kappa = 1.5742435495914964e+00;     % rotation around view axis (roll)
t_x = 4.6151672058497878e-01;
t_y = 5.9808916994333639e-01;
t_z = -1.2381792951442079e-01;



%%
t = [t_x t_y t_z]';    %camera

R_alpha = [
    cos(alpha)  -sin(alpha) 0;
    sin(alpha)  cos(alpha)  0;
    0           0           1];

R_zeta = [
    cos(zeta)   0   sin(zeta);
    0           1   0;
    -sin(zeta)  0   cos(zeta)];

R_kappa = [
    1           0     0;
    0   cos(kappa) -sin(kappa)
    0   sin(kappa)  cos(kappa)];

R = R_kappa * R_zeta * R_alpha;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mounting_MMS.txt
Rmm= [  0.997171,0.042136,0.062248;
        0.042056,-0.999112,0.002589;
        0.062302,0.000036,-0.998057];

Tmm=1/1000*[-1917.004,143.546,105.603]'; %Faktor 1/1000 da in mm angegeben

end

