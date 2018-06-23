function [  ] = PlotKS( origin, base1, base2, base3, KSname )

x1 = [origin'; base1'];
x2 = [origin'; base2'];
x3 = [origin'; base3'];

plot3(x1(:,1), x1(:,2), x1(:,3), 'Color', 'r');
plot3(x2(:,1), x2(:,2), x2(:,3), 'Color', 'g');
plot3(x3(:,1), x3(:,2), x3(:,3), 'Color', 'b');
text(origin(1), origin(2), origin(3), KSname);
text(base1(1), base1(2), base1(3), 'x');
text(base2(1), base2(2), base2(3), 'y');
text(base3(1), base3(2), base3(3), 'z');

end

