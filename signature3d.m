
%
% signature3d.m
%
% A testbed for signature computation.
%

clear all; close all;

% Our starting curve
%t = 3.1:.01:3.9;  these were bounds for nonsingular curve
t = 0:0.1:2*pi;
lt = length(t);
%pts = [cos(t); sin(t).^2 + 1; t];
pts = [cos(t) + 0.4*cos(t)^2; 
    (1/2)*(cos(t) + 0.4*cos(t)^2) + sin(t) + (1/10)*sin(t)^2;
    cos(t)];
%pts = [.16*cos(3*t) + .3* cos(2*t)+cos(t) + .2*sin(t);
%     (.16*cos(3*t) + .16*cos(2*t)).*sin(t);sin(t)];
%pts = [t.*cos(t);sin(t).^2;t.^2];
%pts = [cos(t); sin(t).^2 + 2; t];

%pts2 = [cos(t)+.01*sin(t); sin(t).^2 + 2; t+.001*t.^2];

%lt;
%pts2;

% dimension1 = size(pts, 2);
% dimension2 = size(pts, 2);
% 
% first_centroid = [0; 0; 0];
% for i = 1:dimension1
%     first_centroid = first_centroid + pts(:, i);
% end
%     
% second_centroid = [0; 0; 0];
% for j = 1:dimension2
%     second_centroid = second_centroid + pts2(:, j); 
% end
% 
% first_centroid = first_centroid/dimension1;
% second_centroid = second_centroid/dimension2;
%     
% % calculate translation
% translation = second_centroid - first_centroid;
% 
% for i = 1:dimension1
%    pts(:, i) = pts(:, i) - first_centroid; 
% end
% 
% for i = 1:dimension2
%     pts2(:, i) = pts2(:, i) - second_centroid;
% end


% define a symbolic variable symt and compute *exactly* kappasym, tausym
% kappasym_s, tausym_s, the values of curvature, torsion, etc.


syms symt;

pts_t = double(subs(diff([cos(symt); sin(symt).^2 + 1; symt]),symt,t));
pts_tt = double(subs(diff([cos(symt); sin(symt).^2 + 1; symt],2),symt,t));
pts_ttt = double(subs(diff([cos(symt); sin(symt).^2 + 1; symt],3),symt,t));


% here we find the exact values of tau and kappa and call the tausym,
% kappasym
for i=1:lt
    kappasym(i) = norm(cross(pts_t(:,i), pts_tt(:,i)))/norm(pts_t(:,i))^3;
    tausym(i) = det([pts_t(:,i),pts_tt(:,i),pts_ttt(:,i)])/norm(cross(pts_t(:,i),pts_tt(:,i)))^2;
end

% Constructing a 3d rotation matrix.
% thetax,thetay,thetaz are randomly chosen angles of rotation (between
% 0 and 2*pi) around each axis.
%thetax = 2*pi*rand(1);
%thetay = 2*pi*rand(1);
%thetaz = 2*pi*rand(1);

% here we construct the rotation matrix
%rotx = [1 0 0; 0 cos(thetax) -sin(thetax); 0 sin(thetax) cos(thetax)];
%roty = [cos(thetay) 0 sin(thetay); 0 1 0; -sin(thetay) 0 cos(thetay)];
%rotz = [cos(thetaz) -sin(thetaz) 0;sin(thetaz) cos(thetaz) 0; 0 0 1];

% a random vector of translation, values chosen between -1 and 1
%tran = [2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt)];

% plot our original curve pts in blue and the transformed curve rotpts in red
%plot3(pts(1,:),pts(2,:),pts(3,:),'b');
%rotate3d on;
%hold on;

%rpts = rotx*roty*rotz*pts + tran;
%rpts2 = rotx*roty*rotz*pts2 + tran;

%plot3(rpts(1,:),rpts(2,:),rpts(3,:),'r');

[kappa, kappa_s, tau, tau_s] = compsig(pts);
%[rkappa, rkappa_s, rtau, rtau_s] = compsig(rpts);
%[rkappa2, rkappa_s2, rtau2, rtau_s2] = compsig(rpts2);
size(pts)
beg=1;
en=size(pts, 2);
pts
% plot(kappa(beg:en), tau(beg:en), 'r.');
% hold on;
% plot(kappasym(beg:en), tausym(beg:en), 'b.');
% xlabel('Curvature');
% ylabel('Torsion');
%plot(kappa(beg:en),kappa_s(beg:en),'r.')
%hold on;
%plot(kappa(beg:en),tau_s(beg:en),'b.')
%hold on;
%plot(kappa(beg:en),tau(beg:en),'g.')