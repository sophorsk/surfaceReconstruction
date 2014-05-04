close all;

piece1 = csvread('puzzle6/piece1.dat');
piece2 = csvread('puzzle6/piece2.dat');
piece2r = piece2(207:-1:1, :);


map1to2 = applyProcrustes('puzzle6/p1to2.dat', 'puzzle6/p2to1r.dat');
c12on1 = map1to2('c1');
c12on2 = map1to2('c2');
rot12 = map1to2('rot');

centroid12on1=[ones(207,1)*c12on1(1), ones(207,1)*c12on1(2),ones(207,1)*c12on1(3)];
centroid12on2r=[ones(207,1)*c12on2(1), ones(207,1)*c12on2(2),ones(207,1)*c12on2(3)];

piece1tran = piece1 - centroid12on1;
piece2rtran = piece2r - centroid12on2r;
piece1tranr=piece1tran*rot12;

scatter3(piece2rtran(:,1),piece2rtran(:,2),piece2rtran(:,3));
rotate3d on;
hold on;
scatter3(piece1tranr(:,1),piece1tranr(:,2),piece1tranr(:,3));
hold on;
scatter3(piece1tranr(161:191,1),piece1tranr(161:191,2),piece1tranr(161:191,3),'*');
%scatter3(piece1tranr(139:207,1),piece1tranr(139:207,2),piece1tranr(139:207,3),'.r');
hold on;

%--------------------------------------------------------------------------
piece3 = csvread('puzzle6/piece3.dat');
p3to2 = piece3(44:1:69, :);
csvwrite('puzzle6/p3to2.dat', p3to2);
p2to3r = piece2(165:-1:140, :);
csvwrite('puzzle6/p2to3r.dat', p2to3r);

map3to2 = applyProcrustes('puzzle6/p3to2.dat', 'puzzle6/p2to3r.dat');
c32on3 = map3to2('c1');
c32on2 = map3to2('c2');
rot32 = map3to2('rot');

centroid32on3=[ones(207,1)*c32on3(1), ones(207,1)*c32on3(2),ones(207,1)*c32on3(3)];
centroid32on2r=[ones(207,1)*c32on2(1), ones(207,1)*c32on2(2),ones(207,1)*c32on2(3)];

piece3tran = piece3 - centroid32on3;
piece2rtran = piece2r - centroid32on2r;
piece3tranr=piece3tran*rot32 + centroid32on2r - centroid12on2r;

scatter3(piece3tranr(:,1),piece3tranr(:,2),piece3tranr(:,3)); %'Color',[0 .5 0],'Marker','o'
hold on;
scatter3(piece3tranr(44:69,1),piece3tranr(44:69,2),piece3tranr(44:69,3),'r*');
hold on;

%--------------------------------------------------------------------------
piece4 = csvread('puzzle6/piece4.dat');
piece4r = piece4(207:-1:1,:);
p4to3tr = piece4(60:-1:41,:);
csvwrite('puzzle6/p4to3tr.dat',p4to3tr);
p3trto4 = piece3tranr(148:167,:);
csvwrite('puzzle6/p3trto4.dat',p3trto4);

map4to3tr = applyProcrustes('puzzle6/p4to3tr.dat', 'puzzle6/p3trto4.dat');
c43on4 = map4to3tr('c1');
c43on3 = map4to3tr('c2');
rot43 = map4to3tr('rot');

centroid43on4=[ones(207,1)*c43on4(1), ones(207,1)*c43on4(2),ones(207,1)*c43on4(3)];
centroid43on3=[ones(207,1)*c43on3(1), ones(207,1)*c43on3(2),ones(207,1)*c43on3(3)];

piece4tran = piece4r - centroid43on4;
piece4tranr = piece4tran*rot43 + centroid43on3;

scatter3(piece4tranr(:,1),piece4tranr(:,2),piece4tranr(:,3));
hold on;
scatter3(piece4tranr(148:167,1), piece4tranr(148:167,2), piece4tranr(148:167,3),'r*');

xlabel('x');
ylabel('y');
zlabel('z');

set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);


