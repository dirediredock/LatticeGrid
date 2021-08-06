
close all; clear; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load MMM3

X=MMM3X;
Y=MMM3Y;
Z=MMM3Z;

X=unique(X);nx=length(X);
Y=unique(Y);ny=length(Y);
array=reshape(Z,ny,nx);
 
for d=1:1:21
    
    d
    
    depth=d-11;
    
    [M,c]=contour(X,Y,array,[depth,depth]);M=M';
    
    index=find(M(:,1)==depth);
    elev=ones(length(M),1).*depth;
    M=cat(2,M,elev);
    
    for i=1:length(index)
        q=index(i);
        M(q,:)=[NaN,NaN,NaN];
    end
    
    string=strcat('MMM3Contour',num2str(depth),'m.csv');
    writematrix(M,string);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /Volumes/Seagate/MapVizStudios/XYZ_DepthZeroJitter
load /Volumes/Seagate/MapVizStudios/ENC2020_Polygon

LLWLT=XYZ_DepthZeroJitter;
HHWLT=ENC2020_Polygon;

Line10=readmatrix('MMM3Contour-10m.csv');
Line01=readmatrix('MMM3Contour-1m.csv');
Line02=readmatrix('MMM3Contour-2m.csv');
Line03=readmatrix('MMM3Contour-3m.csv');
Line04=readmatrix('MMM3Contour-4m.csv');
Line05=readmatrix('MMM3Contour-5m.csv');
Line06=readmatrix('MMM3Contour-6m.csv');
Line07=readmatrix('MMM3Contour-7m.csv');
Line08=readmatrix('MMM3Contour-8m.csv');
Line09=readmatrix('MMM3Contour-9m.csv');
 
Line00=readmatrix('MMM3Contour0m.csv');
 
Depth10=readmatrix('MMM3Contour10m.csv');
Depth01=readmatrix('MMM3Contour1m.csv');
Depth02=readmatrix('MMM3Contour2m.csv');
Depth03=readmatrix('MMM3Contour3m.csv');
Depth04=readmatrix('MMM3Contour4m.csv');
Depth05=readmatrix('MMM3Contour5m.csv');
Depth06=readmatrix('MMM3Contour6m.csv');
Depth07=readmatrix('MMM3Contour7m.csv');
Depth08=readmatrix('MMM3Contour8m.csv');
Depth09=readmatrix('MMM3Contour9m.csv');

Lines=cat(1,Depth01,Depth02,Depth03,Depth04,Depth05,Depth06,Depth07, ...
  Depth08,Depth09,Depth10,Line00,Line01,Line02,Line03,Line04,Line05, ...
  Line06,Line07,Line08,Line09,Line10);

load MMM3; X=MMM3X;Y=MMM3Y;Z=MMM3Z;

index=find(Z>=0 & Z<=4);
 
figure('Position',[10,10,1420,780],'Resize','off','Color','k');hold on;

scatter3(X(index,1),Y(index,1),Z(index,1),0.1);

plot3(LLWLT(:,1),LLWLT(:,2),ones(length(LLWLT),1)*0,'r');
plot3(HHWLT(:,1),HHWLT(:,2),ones(length(HHWLT),1)*4,'r');

plot3(Line00(:,1),Line00(:,2),ones(length(Line00),1)*0,'w');
plot3(Depth04(:,1),Depth04(:,2),ones(length(Depth04),1)*4,'w');

plot3(Lines(:,1),Lines(:,2),(Lines(:,3)+11),'w');

xlim([-123.175,-122.975]);ylim([49.2625,49.3375]);
axis off;view(0,90);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








