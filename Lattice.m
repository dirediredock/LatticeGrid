
close all; clear; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creating the point cloud.

load MosaicMarkThree;1

X=MosaicMarkThreeX;
Y=MosaicMarkThreeY;
Z=MosaicMarkThreeZ;

xyzPoints=cat(2,X,Y,zeros(length(Z),1));2
ptCloud=pointCloud(xyzPoints);3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creating the lattice

Xmin=-123.3;
Xmax=-122.8;
Ymin=49.226;
Ymax=49.500;

step=29999;
Xi=(Xmin:1/step:Xmax)';
Yi=(Ymin:0.5479999999/step:Ymax)';

string=length(Yi);
newOne=ones(string,1);

totalVector=string^2;

newX=zeros(totalVector,1);
newY=zeros(totalVector,1);

temp=zeros(string.*2,1);

for i=1:string
    
    b=mod(i,100);
    if b==0
        i
    end
    
    newX(i*string-string+1:i*string,1)=newOne.*Xi(i,1);
    newY(i*string-string+1:i*string,1)=Yi;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creating `newZ`, where the `K` variable determines smoothness

newZ=zeros(totalVector,1);

for i=1:1:totalVector
    
    b=mod(i,1000000);
    if b==0
        i/totalVector*100
    end
    
    point=[newX(i,:),newY(i,:),0];
    
    K=10; % 10-simplex version
    
    [indices,dists]=findNearestNeighbors(ptCloud,point,K);
    
    pickZ=Z(indices);
    pointZ=nanmean(pickZ);
    newZ(i,1)=pointZ;
    
end

MMM3X=newX;
MMM3Y=newY;
MMM3Z=newZ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








