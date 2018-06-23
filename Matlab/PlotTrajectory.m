close all
%%
load('Trajectory_for_images.mat');
X = downsample(X,100);
trajectory = animatedline('lineWidth',2);
set(gca,'YLim',[5804420,5804560],'XLim',[548840,549050],'ZLim',[99,101]);
lx = length(X);

hold on
xlabel('North');
ylabel('East');
zlabel('Up');

for i = 1:lx
    addpoints(trajectory,X(i,2),X(i,3),X(i,4));
    head = scatter3(X(i,2),X(i,3),X(i,4),'filled','MarkerFaceColor','r',...
        'MarkerEdgeColor','r');
    drawnow
    F(i) = getframe(gcf);
    pause(0.001);
    delete(head);
end

video =VideoWriter('Trajectory.avi','MPEG-4');
video.FrameRate = 20;
open(video);
writeVideo(video,F);
close(video);