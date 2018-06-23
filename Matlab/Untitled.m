x= Trajectory_sec2(:,2);
y =Trajectory_sec2(:,3);
X = [ones(size(x)) x];
b=regress(y,X)

figure 
x1 = 990:1:1005;
x2 = b(1)+b(2)*x1;
plot(x1,x2)
hold on
plot(Trajectory_sec2(:,2),Trajectory_sec2(:,3));
for i = 1:length(Trajectory_sec2)
d = abs(b(1)-Trajectory_sec2(i,3)+b(2)*Trajectory_sec2(i,2));
fprintf('%.6f\n',d);
end