
pc1 = importdata('D:\PP2\plane_estimation\pointsInPlane\filtered\section1.txt');
pc2 = importdata('D:\PP2\plane_estimation\pointsInPlane\filtered\section2.txt');
pc3 = importdata('D:\PP2\plane_estimation\pointsInPlane\filtered\section3.txt');
figure
subplot(1,3,1);
h1 = histogram(pc1(:,3));
title('Z coordinates of section1')
subplot(1,3,2);
h2 = histogram(pc2(:,3));
title('Z coordinates of section2')
subplot(1,3,3);
h3 = histogram(pc3(:,3));
title('Z coordinates of section3')
