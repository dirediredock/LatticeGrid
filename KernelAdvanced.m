
clear; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=1001;
tmp=zeros(N);tmp(1:10:end,1:10:end)=1;
[x,y]=find(tmp);
x=x(:)'; y=y(:)';
N2=sqrt(sum(tmp(:)));
i=ceil(N2^2/2);

p=[x(i);y(i)]; % Reference point locations
Mosaic=[x;y]; % 2D data point locations
noise=normrnd(0,3,[1,length(Mosaic)]);
Mosaic=Mosaic+noise*2; % Add noise (because real-world data is noisy)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

slices=360/k;
r1=400; % Closer search bound
r2=200; % Further search bound
margin=slices/2;

figure('Position',[60,60,800,800],'Resize','off','Color','k');hold on;
axis tight;axis off;
scatter(Mosaic(2,:),Mosaic(1,:),0.1,'c'); % Background lattice
scatter(p(2),p(1),100,'w','filled');

Kernel=zeros(k,3);

i=0;

for dirAngle=0:slices:slices*k-slices
    
    i=i+1;
    
    [ind2,nn]=angleDirection(p,Mosaic,r1,r2,dirAngle,margin);
    
    x=p(2); y=p(1);
    [theta,r]=cart2pol(Mosaic(2,nn)-x,Mosaic(1,nn)-y);
    u=r*cos(theta);
    v=r*sin(theta);
    
    scatter(Mosaic(2,ind2),Mosaic(1,ind2),2); % Highlight mosaic slices
    scatter(Mosaic(2,nn),Mosaic(1,nn),50,'r','filled'); 
    
    Kernel(i,1)=Mosaic(2,nn);
    Kernel(i,2)=Mosaic(1,nn); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if k<=2
    
else % Draws kernel triangles for k>=3
    
    Xa=[];
    Ya=[];
    Za=[];
    Xb=[];
    Yb=[];
    Zb=[];
    
    count=0;

    for i=1:length(Kernel)
        A=Kernel(i,:);
        for q=1:length(Kernel)
            if q>=i
            else
                count=count+1;
                B=Kernel(q,:);
                Xa(count)=A(1,1);
                Ya(count)=A(1,2);
                Za(count)=A(1,3);
                Xb(count)=B(1,1);
                Yb(count)=B(1,2);
                Zb(count)=B(1,3);
                plot3([A(1,1);B(1,1)],[A(1,2);B(1,2)],[A(1,3);B(1,3)],'r');
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ind,indMin]=angleDirection(p,Mosaic,r1,r2,dirAngle,margin)

    % Code below from Abdullah H. Ozcan (2016) 'directionaldist', 
    % which in turn requires 'nearestneighbour' by Richard Brown (2016):
    % [https://www.mathworks.com/matlabcentral/fileexchange/
    % 54723-extract-points-in-a-defined-direction-and-distance]
    % [https://www.mathworks.com/matlabcentral/fileexchange/
    % 12574-nearestneighbour-m]

    idx1 = nearestneighbour(p,Mosaic,'r',r1);
    idx2 = nearestneighbour(p,Mosaic,'r',r2);

    idx=setdiff(idx1,idx2);
    
    [THETA,~]=cart2pol(p(1)-Mosaic(1,idx),p(2)-Mosaic(2,idx));
    th=ceil(THETA/pi*180);
    th=mod(th+180,360);
    ind1=find(abs(dirAngle-th)<margin);
    ind2=find(abs(dirAngle-th)>(360-margin));
    ind=union(ind1,ind2);
    ind=idx(ind);
    
    [~,indMin]=min((p(1)-Mosaic(1,ind)).^2+(p(2)-Mosaic(2,ind)).^2);
    indMin=ind(indMin);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


