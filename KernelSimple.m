
close all; clear; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simplex=10;

poly=nsidedpoly(simplex);
Z=rescale(rand([simplex,1]),-1,1);
X=poly.Vertices(:,1);
Y=poly.Vertices(:,2);
kernel=cat(2,X,Y,Z);

Xa=[];Ya=[];Za=[];
Xb=[];Yb=[];Zb=[];

figure('Position',[650,10,780,780],'Resize','off','Color','k');hold on;
set(gca,'CameraViewAngleMode','manual');axis off;axis equal;
scatter3(kernel(:,1),kernel(:,2),kernel(:,3),0.01,'w','filled');
scatter3(0,0,0,500,'w','filled');

count=0;colors=(plasma(length(kernel)));

for i=1:length(kernel)
    A=kernel(i,:);
    for q=1:length(kernel)
        if q>=i
        else
            count=count+1;
            B=kernel(q,:);
            Xa(count)=A(1,1);Ya(count)=A(1,2);Za(count)=A(1,3);
            Xb(count)=B(1,1);Yb(count)=B(1,2);Zb(count)=B(1,3);
            plot3([A(1,1);B(1,1)],[A(1,2);B(1,2)],[A(1,3);B(1,3)],'-', ...
            'Color',colors(i,:),'LineWidth',1);
            drawnow;pause(0.05);
        end
    end
end

colors=flipud(plasma(count));

figure('Position',[0,10,750,780],'Resize','off','Color','k');hold on;
set(gca,'CameraViewAngleMode','manual');axis off;axis equal;
scatter3(kernel(:,1),kernel(:,2),kernel(:,3),0.01,'w','filled');
scatter3(0,0,0,500,'w','filled');

for i=1:count
    plot3([Xa(i);Xb(i)],[Ya(i);Yb(i)],[Za(i);Zb(i)],'-', ...
    'Color',colors(i,:),'LineWidth',1);
    drawnow;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




