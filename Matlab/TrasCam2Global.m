clc
clear all
close all
%%
x_base = [1 0 0]'; 
y_base = [0 1 0]'; 
z_base = [0 0 1]'; 
origin_base = [0 0 0]'; %global
load('Trajectory_for_images.mat');
X = downsample(X,100);
lx = length(X);
X(:,2:4) = X(:,2:4)-repmat(mean(X(:,2:4)),lx,1);



%% IKG mounting_camera.txt
alpha = 3.1493750236320928e+00;     % Rotation around vertical axis (yaw)
zeta = 1.5794758471340726e+00;      % rotation around horizontal axis (pitch)
kappa = 1.5742435495914964e+00;     % rotation around view axis (roll)
t_x = 4.6151672058497878e-01;
t_y = 5.9808916994333639e-01;
t_z = -1.2381792951442079e-01;



%%
origin_glob = [0 0 0]'; %global
R_BodyToGlobal = [[0 1 0];[1 0 0];[0 0 1]];

%% PLOTTING
KSs = animatedline('lineWidth',2);
hold on
axis equal
xlabel('North');
ylabel('East');
zlabel('Up');
view(4,10);
[ R,t, Rmm, Tmm ] = ParamGetter();
f = 1;
drawnow
F(f) = getframe(gcf); 
f = f+1;
pause(1);
for i = 1:length(X)
    [ R_rpy] = getR_rpy(X(i,5), X(i,6), X(i,7));

    % Transformation from camera to global
    o_cam = R_BodyToGlobal*R_rpy*(Rmm'*(R*origin_base+t)-Tmm)+X(i,2:4)';
    x_cam = R_BodyToGlobal*R_rpy*(Rmm'*(R*x_base+t)-Tmm)+X(i,2:4)';
    y_cam = R_BodyToGlobal*R_rpy*(Rmm'*(R*y_base+t)-Tmm)+X(i,2:4)';
    z_cam = R_BodyToGlobal*R_rpy*(Rmm'*(R*z_base+t)-Tmm)+X(i,2:4)';
    % plot camera system
    if i<10
        PlotKS(o_cam, x_cam, y_cam, z_cam, 'C');
        drawnow
        for k = 1:10
            F(f) = getframe(gcf); 
            f = f+1;
        end
        pause(1/i/i);
        if i==9
             view(0,90);
        end
%     else
%         addpoints(KSs,o_cam(1),o_cam(2),o_cam(3));
%         head = scatter3(o_cam(1),o_cam(2),o_cam(3),'filled','MarkerFaceColor','r',...
%         'MarkerEdgeColor','r');
%         drawnow
%         pause(0.0001);
    end
    % Tranformation from platform to gloabal
    o_p = R_BodyToGlobal*R_rpy*(Rmm'*origin_base-Tmm)+X(i,2:4)';
    x_p = R_BodyToGlobal*R_rpy*(Rmm'*x_base-Tmm)+X(i,2:4)'; 
    y_p = R_BodyToGlobal*R_rpy*(Rmm'*y_base-Tmm)+X(i,2:4)';
    z_p = R_BodyToGlobal*R_rpy*(Rmm'*z_base-Tmm)+X(i,2:4)';
    % plot plattform system
    if i<10
        PlotKS(o_p, x_p, y_p, z_p, 'P');
        drawnow
        for k = 1:10
            F(f) = getframe(gcf); 
            f = f+1;
        end
        pause(1/i/i);
%     else
%         addpoints(KSs,o_p(1),o_p(2),o_p(3));
%         head = scatter3(o_p(1),o_p(2),o_p(3),'filled','MarkerFaceColor','r',...
%         'MarkerEdgeColor','r');
%         drawnow
%         pause(0.0001);
    end   
    % Transformation from mms to global
    o_mm = R_BodyToGlobal*R_rpy*origin_base+X(i,2:4)';
    x_mm = R_BodyToGlobal*R_rpy*x_base+X(i,2:4)';
    y_mm = R_BodyToGlobal*R_rpy*y_base+X(i,2:4)';
    z_mm = R_BodyToGlobal*R_rpy*z_base+X(i,2:4)';
    % plotting MMS
    if i<10
        PlotKS(o_mm, x_mm, y_mm, z_mm, 'M');
        drawnow
        for k = 1:10
            F(f) = getframe(gcf); 
            f = f+1;
        end
        pause(1/i/i);
    else
        addpoints(KSs,o_mm(1),o_mm(2),o_mm(3));
        head = scatter3(o_mm(1),o_mm(2),o_mm(3),'filled','MarkerFaceColor','r',...
        'MarkerEdgeColor','r');
        drawnow
        F(f) = getframe(gcf); 
        f = f+1;
        pause(0.0001);
        delete(head);
    end
end

video =VideoWriter('KS_Trajectory','MPEG-4');
video.FrameRate = 20;
open(video);
writeVideo(video,F);
close(video);
