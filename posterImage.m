clear all; close all;

t = 0:.01:4;
lt = length(t);
pts = [cos(t); sin(t).^2 + 2; t];

pts2 = [cos(t)+.01*sin(t); sin(t).^2 + 2; t+.001*t.^2];

% Constructing a 3d rotation matrix.
% thetax,thetay,thetaz are randomly chosen angles of rotation (between
% 0 and 2*pi) around each axis.
thetax = 2*pi*rand(1);
thetay = 2*pi*rand(1);
thetaz = 2*pi*rand(1);

% here we construct the rotation matrix
rotx = [1 0 0; 0 cos(thetax) -sin(thetax); 0 sin(thetax) cos(thetax)];
roty = [cos(thetay) 0 sin(thetay); 0 1 0; -sin(thetay) 0 cos(thetay)];
rotz = [cos(thetaz) -sin(thetaz) 0;sin(thetaz) cos(thetaz) 0; 0 0 1];

% a random vector of translation, values chosen between -1 and 1
tran = [2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt)];

% plot our original curve pts in blue and the transformed curve rotpts in red
%plot3(pts(1,:),pts(2,:),pts(3,:),'b');
%rotate3d on;
%hold on;
rpts = rotx*roty*rotz*pts + tran;
rpts2 = rotx*roty*rotz*pts2 + tran;
%plot3(rpts(1,:),rpts(2,:),rpts(3,:),'r');

[kappa, kappa_s, tau, tau_s] = compsig(pts);
[rkappa, rkappa_s, rtau, rtau_s] = compsig(rpts);
[rkappa2, rkappa_s2, rtau2, rtau_s2] = compsig(rpts2);

% generate a kappa_s vs tau_s plot for curve pts to illustrate bivertex arc
% decomposition
figure;
subplot(1,2,1)
plot3(pts(1,:),pts(2,:),pts(3,:));
subplot(1,2,2)
plot(kappa_s, tau_s, 'r.-', [-5, 5], [0, 0], 'k-', [0, 0], [-8, 8], 'k-');
