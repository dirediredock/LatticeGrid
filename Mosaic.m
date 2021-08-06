
close all; clear; clc

Xmin=-123.3; Xmax=-122.8; % Horizontal model bounds
Ymin=49.226; Ymax=49.500; % Vertical model bounds
LatticeX=[Xmin;Xmax;Xmax;Xmin;Xmin];
LatticeY=[Ymin;Ymin;Ymax;Ymax;Ymin];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LLWLT: Lower Low Water Large Tide 
% HHWLT: Higher High Water Large Tide 

%{
    [LLWLT] CHS Burrard Inlet bathymetry
    Edits: Above-datum data in this set is "broken" from a bad export by
           CHS, fixed in v2.0 of CHS bathymetry. Underwater is still great!
%}

ModelA=readmatrix('combine_5m_extract_WGS84_c.txt');
ModelAx=ModelA(:,2);ModelAy=ModelA(:,1);ModelAz=ModelA(:,3);

ModelAx(ModelAx<Xmin)=NaN;ModelAx(ModelAx>Xmax)=NaN;
ModelAy(ModelAy<Ymin)=NaN;ModelAy(ModelAy>Ymax)=NaN;
ModelAz(ModelAz>0)=NaN; % Removes above-water

%{
    [HHWLT] City of Vancouver LIDAR Ground
    Edits: Plus 4 meters due to high tide datum, as revealed by HHWLT
           above-water from CHS bathymetry 2.0
%}

load LidarWGS_GroundX; load LidarWGS_GroundY; load LidarWGS_GroundZ

ModelBx=LidarWGS_GroundX(1:20:end,1); 
ModelBy=LidarWGS_GroundY(1:20:end,1); 
ModelBz=LidarWGS_GroundZ(1:20:end,1);

ModelBz=ModelBz+4; % Hacky 4-meter datum fix

ModelBx(ModelBx<Xmin)=NaN;ModelBx(ModelBx>Xmax)=NaN;
ModelBy(ModelBy<Ymin)=NaN;ModelBy(ModelBy>Ymax)=NaN;
ModelBz(ModelBz<=0)=NaN;  % Remove underwater

%{
    [LLWLT] CHS Burrard Inlet bathymetry 2.0 Underwater
    Edits: This is coarser but complimentary bathymetry. Intertidal
           components must be isolated.
%}

load WaterLowCHS
ModelCx=WaterLowX;ModelCy=WaterLowY;ModelCz=WaterLowZ;

ModelCz=ModelCz*-1; % Elevation fix

ModelCx(ModelCx<Xmin)=NaN;ModelCx(ModelCx>Xmax)=NaN;
ModelCy(ModelCy<Ymin)=NaN;ModelCy(ModelCy>Ymax)=NaN;

NodelCz=ModelCz;
NodelCz(NodelCz<=0)=NaN; % Keep including Maplewood Flats
NodelCz(NodelCz>=8)=NaN; 
ModelCz(ModelCz>0)=NaN; % Remove above-water

%{
    [HHWLT] CHS Above-water LIDAR Intertidal
    Edits: This is LIDAR high-resolution with intertidal components isolated.
          Above-water is above high tide, so data here is mostly useless.
    Note: Ground LIDAR has HHWLT datum because it matches this dataset, which
          is the one with the known datum.
%}

load WaterHighCHS
ModelDx=WaterHighX;
ModelDy=WaterHighY;
ModelDz=WaterHighZ;

ModelDz=(ModelDz*-1)+4; % Elevation and Datum fix
ModelDz(ModelDz>4)=NaN; % Keep only intertidal

ModelDx(ModelDx<Xmin)=NaN;ModelDx(ModelDx>Xmax)=NaN;
ModelDy(ModelDy<Ymin)=NaN;ModelDy(ModelDy>Ymax)=NaN;

%{
    [LLWLT] Outer Harbour from SalishSeaCast
    Edits: Making room for CHS batymetry
%}

load SalishSeaCastExtract; SeaCast=SalishSeaCastExtract;
ModelEx=SeaCast(:,1);ModelEy=SeaCast(:,2);ModelEz=SeaCast(:,3);

indexRemoveX=find(ModelEx>=-123.26);
indexRemoveY=find(ModelEy<=49.342 & ModelEy>=49.265);
indexRemove=cat(1,indexRemoveX,indexRemoveY);
[ii,~,kk]=unique(indexRemove);
freq=accumarray(kk,1);
freq(freq==1)=NaN;
indexRemove=cat(2,ii,freq);
indexRemove(any(isnan(indexRemove),2),:)=[];
ModelEx(indexRemove,1)=NaN;
ModelEy(indexRemove,1)=NaN;

ModelEx(ModelEx<Xmin)=NaN;ModelEx(ModelEx>Xmax)=NaN;
ModelEy(ModelEy<Ymin)=NaN;ModelEy(ModelEy>Ymax)=NaN;

ModelEz(ModelEz>0)=NaN; % Remove above-water

%{
    [LLWLT] Federal Elevation Model
    Edits: Downtown removed, replaced by City of Vancouver LIDAR data
%}

Federal=readmatrix('AltimetryVancouver.txt');
ModelFx=Federal(:,1);ModelFy=Federal(:,2);ModelFz=Federal(:,3);

indexRemoveX=find(ModelFx<=-123.0214);
indexRemoveY=find(ModelFy<=49.2954);
indexRemove=cat(1,indexRemoveX,indexRemoveY);
[ii,~,kk]=unique(indexRemove);
freq=accumarray(kk,1);
freq(freq==1)=NaN;
indexRemove=cat(2,ii,freq);
indexRemove(any(isnan(indexRemove),2),:)=[];
ModelFx(indexRemove,1)=NaN;
ModelFy(indexRemove,1)=NaN;

indexRemoveX=find(ModelFx<=-123.1348);
indexRemoveY=find(ModelFy<=49.3147);
indexRemove=cat(1,indexRemoveX,indexRemoveY);
[ii,~,kk]=unique(indexRemove);
freq=accumarray(kk,1);
freq(freq==1)=NaN;
indexRemove=cat(2,ii,freq);
indexRemove(any(isnan(indexRemove),2),:)=[];
ModelFx(indexRemove,1)=NaN;
ModelFy(indexRemove,1)=NaN;

indexRemoveX=find(ModelFx<=-123.1125);
indexRemoveY=find(ModelFy<=49.307);
indexRemove=cat(1,indexRemoveX,indexRemoveY);
[ii,~,kk]=unique(indexRemove);
freq=accumarray(kk,1);
freq(freq==1)=NaN;
indexRemove=cat(2,ii,freq);
indexRemove(any(isnan(indexRemove),2),:)=[];
ModelFx(indexRemove,1)=NaN;
ModelFy(indexRemove,1)=NaN;

ModelFx(ModelFx<Xmin)=NaN;ModelFx(ModelFx>Xmax)=NaN;
ModelFy(ModelFy<Ymin)=NaN;ModelFy(ModelFy>Ymax)=NaN;

ModelFz(ModelFz<=0)=NaN; % Remove underwater

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Point cloud cleanup

ModelA=cat(2,ModelAx,ModelAy,ModelAz);
ModelA(any(isnan(ModelA),2),:)=[];
ModelB=cat(2,ModelBx,ModelBy,ModelBz);
ModelB(any(isnan(ModelB),2),:)=[];
ModelC=cat(2,ModelCx,ModelCy,ModelCz);
ModelC(any(isnan(ModelC),2),:)=[];
ModelD=cat(2,ModelDx,ModelDy,ModelDz);
ModelD(any(isnan(ModelD),2),:)=[];
ModelE=cat(2,ModelEx,ModelEy,ModelEz);
ModelE(any(isnan(ModelE),2),:)=[];
ModelF=cat(2,ModelFx,ModelFy,ModelFz);
ModelF(any(isnan(ModelF),2),:)=[];
ModelG=cat(2,ModelCx,ModelCy,NodelCz);
ModelG(any(isnan(ModelG),2),:)=[];

load ENC2020_polygon; A=ENC2020_Polygon;
A(28647:28722,:)=[];A(29198:29290,:)=[]; % Removing redundant islands

% Removing excess Federal Elevation model based on ENC2020

IndexENC=inpoly2(ModelF(:,1:2),A(:,1:2));
IndexENC=find(IndexENC==1);
ModelF(IndexENC,:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% VISUALIZATIONS

figure('Position',[10,10,1420,780],'Resize','off','Color','k');hold on;
axis off;axis tight;view(0,90);

scatter3(ModelA(:,1),ModelA(:,2),ModelA(:,3),0.2,'filled');drawnow;
scatter3(ModelB(:,1),ModelB(:,2),ModelB(:,3),0.2,'filled');drawnow;
scatter3(ModelC(:,1),ModelC(:,2),ModelC(:,3),0.2,'filled');drawnow;
scatter3(ModelG(:,1),ModelG(:,2),ModelG(:,3),0.2,'filled');drawnow;
scatter3(ModelD(:,1),ModelD(:,2),ModelD(:,3),0.2,'filled');drawnow;
scatter3(ModelE(:,1),ModelE(:,2),ModelE(:,3),0.2,'filled');drawnow;
scatter3(ModelF(:,1),ModelF(:,2),ModelF(:,3),0.2,'filled');drawnow;

plot3(A(:,1),A(:,2),ones(length(A),1)*4,'-w','LineWidth',0.05);

plot3(LatticeX,LatticeY,[2000;2000;2000;2000;2000],'-w');
plot3(LatticeX,LatticeY,[-500;-500;-500;-500;-500],'-w');
plot3([Xmin;Xmin],[Ymax;Ymax],[-500,2000],'-w');
plot3([Xmax;Xmax],[Ymax;Ymax],[-500,2000],'-w');
plot3([Xmin;Xmin],[Ymin;Ymin],[-500,2000],'-w');
plot3([Xmax;Xmax],[Ymin;Ymin],[-500,2000],'-w');

MosaicMarkThreeX=cat(1,ModelA(:,1),ModelB(:,1),ModelC(:,1),ModelD(:,1), ...
    ModelE(:,1),ModelF(:,1),ModelG(:,1));
MosaicMarkThreeY=cat(1,ModelA(:,2),ModelB(:,2),ModelC(:,2),ModelD(:,2), ...
    ModelE(:,2),ModelF(:,2),ModelG(:,2));
MosaicMarkThreeZ=cat(1,ModelA(:,3),ModelB(:,3),ModelC(:,3),ModelD(:,3), ...
    ModelE(:,3),ModelF(:,3),ModelG(:,3));

figure('Position',[10,10,1420,780],'Resize','off','Color','k');hold on;
axis off;axis tight;view(0,90);
scatter3(MosaicMarkThreeX,MosaicMarkThreeY,MosaicMarkThreeZ,0.2,'filled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%