% 1. add small amount of noise
% 2. different number of sample points
% 3. variations in uniformity

% define some colors
%jblue = [20/255 50/255 100/255];
%ngreen = [98 158 31]./255;

clear all; close all;

r = [[0.5;pi/10]+[.5 0; 0 3*pi/10]*rand(2,1),...
     [0.5;6*pi/10]+[.5 0; 0 3*pi/10]*rand(2,1),... 
     [0.5;11*pi/10]+[.5 0; 0 3*pi/10]*rand(2,1),... 
     [0.5;16*pi/10]+[.5 0; 0 3*pi/10]*rand(2,1)];

xyr = [r(1,:).*cos(r(2,:));
       r(1,:).*sin(r(2,:))];
   
theta = linspace(0, 2*pi, 1000);
coss = cos(theta);
sinn = sin(theta);
   
subplot(1,2,1)
%plot(xyr(1,:), xyr(2,:),0,0,'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
axis([-1 1 -1 1]);
plot(coss, sinn,'Color', 'k', 'LineWidth', 1);
hold on;
grid on;

p1 = xyr(:,1);
p2 = xyr(:,2);
p3 = xyr(:,3);
p4 = xyr(:,4);

n=20;   % number of control points used for Bezier curve generation
t = linspace(0,1,n);
%% constructing bezier between (0,0) and p1

v1 = [p1(2), -p1(1)];   % normal vector with the same length as p1
s1 = 2*rand(1,n)-ones(1,n);
samp1 = [t.*p1(1) + s1.*t.*(1-t).*v1(1);
         t.*p1(2) + s1.*t.*(1-t).*v1(2)];
bc1 = bezier_(samp1',70);

plot(bc1(:,1), bc1(:,2),'Color','g','LineWidth',1.5);
hold on;
plot(samp1(1,2:n-1), samp1(2,2:n-1),'LineStyle','none','Marker','.','MarkerSize',10,'Color','k');
hold on;


%% constructing bezier between (0,0) and p2

v2 = [p2(2), -p2(1)];   
s2 = 2*rand(1,n)-ones(1,n);
samp2 = [t.*p2(1) + s2.*t.*(1-t).*v2(1);
         t.*p2(2) + s2.*t.*(1-t).*v2(2)];
bc2 = bezier_(samp2',70);

plot(bc2(:,1), bc2(:,2),'Color','b','LineWidth',1.5);
hold on;

%% constructing bezier between (0,0) and p3

v3 = [p3(2), -p3(1)];   
s3 = 2*rand(1,n)-ones(1,n);
samp3 = [t.*p3(1) + s3.*t.*(1-t).*v3(1);
         t.*p3(2) + s3.*t.*(1-t).*v3(2)];
bc3 = bezier_(samp3',70);

plot(bc3(:,1), bc3(:,2),'Color','b','LineWidth',1.5);
hold on;

%% constructing bezier between (0,0) and p4

v4 = [p4(2), -p4(1)];   
s4 = 2*rand(1,n)-ones(1,n);
samp4 = [t.*p4(1) + s4.*t.*(1-t).*v4(1);
         t.*p4(2) + s4.*t.*(1-t).*v4(2)];
bc4 = bezier_(samp4',70);

plot(bc4(:,1), bc4(:,2),'Color','b','LineWidth',1.5);
hold on;

%% constructing bezier between p1 and p2

v5 = [p2(2)-p1(2), p1(1)-p2(1)];
s5 = 2*rand(1,n)-ones(1,n);
samp5 = [(1-t).*p1(1) + t.*p2(1) + s5.*t.*(1-t).*v5(1);
         (1-t).*p1(2) + t.*p2(2) + s5.*t.*(1-t).*v5(2)];
bc5 = bezier_(samp5',70);

plot(bc5(:,1), bc5(:,2),'Color','b','LineWidth',1.5);
hold on;

%% constructing bezier between p2 and p3

v6 = [p3(2)-p2(2), p2(1)-p3(1)];
s6 = 2*rand(1,n)-ones(1,n);
samp6 = [(1-t).*p2(1) + t.*p3(1) + s6.*t.*(1-t).*v6(1);
         (1-t).*p2(2) + t.*p3(2) + s6.*t.*(1-t).*v6(2)];
bc6 = bezier_(samp6',70);

plot(bc6(:,1), bc6(:,2),'Color','b','LineWidth',1.5);
hold on;

%% constructing bezier between p3 and p4

v7 = [p4(2)-p3(2), p3(1)-p4(1)];
s7 = 2*rand(1,n)-ones(1,n);
samp7 = [(1-t).*p3(1) + t.*p4(1) + s7.*t.*(1-t).*v7(1);
         (1-t).*p3(2) + t.*p4(2) + s7.*t.*(1-t).*v7(2)];
bc7 = bezier_(samp7',70);

plot(bc7(:,1), bc7(:,2),'Color','b','LineWidth',1.5);
hold on;

%% constructing bezier between p4 and p1

v8 = [p1(2)-p4(2), p4(1)-p1(1)];
s8 = 2*rand(1,n)-ones(1,n);
samp8 = [(1-t).*p4(1) + t.*p1(1) + s8.*t.*(1-t).*v8(1);
         (1-t).*p4(2) + t.*p1(2) + s8.*t.*(1-t).*v8(2)];
bc8 = bezier_(samp8',70);

plot(bc8(:,1), bc8(:,2),'Color','b','LineWidth',1.5);
hold on;

plot(xyr(1,:), xyr(2,:),0,0,'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');

xlabel('x');
ylabel('y');

set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);

%% mapping the 8 bezier curves onto the upper sphere
crack1 = [bc1(:,1),bc1(:,2),sqrt(1-bc1(:,1).^2-bc1(:,2).^2)];
crack2 = [bc2(:,1),bc2(:,2),sqrt(1-bc2(:,1).^2-bc2(:,2).^2)];
crack3 = [bc3(:,1),bc3(:,2),sqrt(1-bc3(:,1).^2-bc3(:,2).^2)];
crack4 = [bc4(:,1),bc4(:,2),sqrt(1-bc4(:,1).^2-bc4(:,2).^2)];
crack5 = [bc5(:,1),bc5(:,2),sqrt(1-bc5(:,1).^2-bc5(:,2).^2)];
crack6 = [bc6(:,1),bc6(:,2),sqrt(1-bc6(:,1).^2-bc6(:,2).^2)];
crack7 = [bc7(:,1),bc7(:,2),sqrt(1-bc7(:,1).^2-bc7(:,2).^2)];
crack8 = [bc8(:,1),bc8(:,2),sqrt(1-bc8(:,1).^2-bc8(:,2).^2)];


subplot(1,2,2)
plot3(crack1(:,1),crack1(:,2),crack1(:,3),'Color','g','LineWidth',1.5);
hold on;
plot3(crack2(:,1),crack2(:,2),crack2(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(crack3(:,1),crack3(:,2),crack3(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(crack4(:,1),crack4(:,2),crack4(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(crack5(:,1),crack5(:,2),crack5(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(crack6(:,1),crack6(:,2),crack6(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(crack7(:,1),crack7(:,2),crack7(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(crack8(:,1),crack8(:,2),crack8(:,3),'Color','b','LineWidth',1.5);
hold on;
plot3(xyr(1,:), xyr(2,:), sqrt(1-xyr(1,:).^2-xyr(2,:).^2),0,0,1,'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
hold on;
plot3(coss,sinn,zeros(1,1000),'k','LineWidth',1);
rotate3d on;
grid on;

xlabel('x');
ylabel('y');
zlabel('z');

set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);

%% constructing puzzle pieces

piece1 = [crack1(1:69,:); crack5(1:69,:); crack2(70:-1:2,:)];
piece1 = loadData(piece1);
figure;
subplot(1,4,1)
plot3(piece1(:,1), piece1(:,2), piece1(:,3),'LineWidth',1.5);
rotate3d on;
hold on;
plot3(piece1([1 70 139],1), piece1([1 70 139],2), piece1([1 70 139],3),'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
grid on;
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);

piece2 = [crack2(1:69,:); crack6(1:69,:); crack3(70:-1:2,:)];
piece2 = loadData(piece2);
subplot(1,4,2);
plot3(piece2(:,1), piece2(:,2), piece2(:,3),'LineWidth',1.5);
rotate3d on;
hold on;
plot3(piece2([1 70 139],1), piece2([1 70 139],2), piece2([1 70 139],3),'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
grid on;
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);

piece3 = [crack3(1:69,:); crack7(1:69,:); crack4(70:-1:2,:)];
piece3 = loadData(piece3);
subplot(1,4,3);
plot3(piece3(:,1), piece3(:,2), piece3(:,3),'LineWidth',1.5);
rotate3d on;
hold on;
plot3(piece3([1 70 139],1), piece3([1 70 139],2), piece3([1 70 139],3),'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
grid on;
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);

piece4 = [crack4(1:69,:); crack8(1:69,:); crack1(70:-1:2,:)];
piece4 = loadData(piece4);
subplot(1,4,4);
plot3(piece4(:,1), piece4(:,2), piece4(:,3),'LineWidth',1.5);
rotate3d on;
hold on;
plot3(piece4([1 70 139],1), piece4([1 70 139],2), piece4([1 70 139],3),'Marker','s','LineStyle','none','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
grid on;
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);

% figure;
% plot3(piece1(:,1), piece1(:,2), piece1(:,3),'b','LineWidth',1.5);
% hold on;
% plot3(piece2(:,1), piece2(:,2), piece2(:,3),'LineWidth',1.5);
% hold on;
% plot3(piece3(:,1), piece3(:,2), piece3(:,3),'LineWidth',1.5);
% hold on;
% plot3(piece4(:,1), piece4(:,2), piece4(:,3),'LineWidth',1.5);
% rotate3d on;
% grid on;

