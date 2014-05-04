close all; clear all;

% create the  mesh grid for theta on the r-theta plane 
theta = linspace(0, 2*pi, 1000);
coss = cos(theta);
sinn = sin(theta);

%% choosing several planar curves to partition the unit disk

% the first heart-shaped curve sitting upright
r1 = 1 - sinn;                  % r = 1- sin(theta)

% the second heart-shaped curve, with a 90 degree rotation of the first one around origin
r2 = 1 - sin(theta - pi/2);

% the thrid curve: an inscribed square
r3 = 1./(abs(coss)+abs(sinn));   % r = 1/(|cos(theta)|+|sin(theta)|)

% plot all these three curves together with the circular disk on the plane
figure;
plot(r1.*coss, r1.*sinn);
hold on;
plot(r2.*coss, r2.*sinn, 'r');
hold on;
plot(r3.*coss, r3.*sinn, 'g');
hold on;
plot(coss, sinn);

axis([-1 1 -1 1])


%% mapping planar curves onto the upper hemisphere

% I manually select the portion in which r1 doesn't exceed 1, i.e. the part
% of the heart that lies inside the unit disk. For this curve, it's from 0
% to pi
curve1 = [r1(1:500).*coss(1:500); r1(1:500).*sinn(1:500); sqrt(1-r1(1:500).^2)];
figure;
plot3(curve1(1,:), curve1(2,:), curve1(3,:));
rotate3d on;
hold on;

% Select out the portion inside the disk similarly; this time, from pi/2 to
% 3*pi/2
curve2 = [r2(251:750).*coss(251:750); r2(251:750).*sinn(251:750); sqrt(1-r2(251:750).^2)];
plot3(curve2(1,:), curve2(2,:), curve2(3,:),'r');
hold on;

curve3 = [r3.*coss; r3.*sinn; sqrt(1-r3.^2)];
plot3(curve3(1,:), curve3(2,:), curve3(3,:),'g');
hold on;


plot3(coss,sinn,zeros(1,1000));
hold on;
axis([-1 1 -1 1 0 1]);

%% create point clouds for each of these five spherical pieces

% note: some overlapping points may be recorded for multiple times
piece1 = [curve3(:,751:1000), curve1(:,1:250), curve2(:,251:500)];
figure;
plot3(piece1(1,:), piece1(2,:), piece1(3,:));
hold on;

% assembling the following pieces requires obtaining the intersection points
% of curve1 and curve2; I do so by manually checking
% curve2-curve1(:,500:-1:1), and the other intersection point is at
% curve2(:,125) or curve2(:, 126)
piece2 = [curve3(:,1:250), curve2(:,1:125), curve1(:,375:-1:1)];
figure;
plot3(piece2(1,:), piece2(2,:), piece2(3,:));
hold on;

piece3 = [curve3(:,251:500), curve1(:,500:-1:376), curve2(:,125:-1:1)];
figure;
plot3(piece3(1,:), piece3(2,:), piece3(3,:));
hold on;

piece4 = [curve3(:,501:750), curve2(:,500:-1:126), curve1(:,376:500)];
figure;
plot3(piece4(1,:), piece4(2,:), piece4(3,:));
hold on;

piece5 = [curve1(:,251:375), curve2(:,126:250)];
figure;
plot3(piece5(1,:), piece5(2,:), piece5(3,:));

figure(3)
k = 1:30;
[B,XY] = bucky;
gplot(B(k,k),XY(k,:),'-*')
axis square





