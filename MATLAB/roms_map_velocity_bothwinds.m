%%%%%% Script to plot Z interpolated levels %%%%%%
close all; clear all; clc
% Plot maps for intensity of velocity
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

%% Get varibles from clim winds
% Get lon & lat from another file
simu = 'clim';
% directory = ['/run/media/marissela/JORGE_NEW/Ascat_', simu, '/'];
directory = ['D:/Ascat_', simu, '/'];
nc = ncload ([directory,'newperush_avg.Y2010.M12.newperush.nc'],...
    'mask_rho','lon_rho', 'lat_rho');
lon_rho = lon_rho-360;
mask_rho(mask_rho==0)=NaN;

% Get all the variables available in Zmean file.
nc = ncload ([directory,'newperush_SmeanZ_', simu, '.nc'],'u','v','Z');

u1 = u;
v1 = v;
Z1 = Z;

%% Get varibles from daily winds
% Get lon & lat from another file
simu = 'daily';
% directory = ['/run/media/marissela/JORGE_NEW/Ascat_', simu, '/'];
directory = ['D:/Ascat_', simu, '/'];
% nc = ncload ([directory,'newperush_avg.Y2010.M12.newperush.nc'],...
%     'mask_rho','lon_rho', 'lat_rho');
% lon_rho = lon_rho-360;
% mask_rho(mask_rho==0)=NaN;

% Get all the variables available in Zmean file.
nc = ncload ([directory,'newperush_SmeanZ_', simu, '.nc'],'u','v','Z');

u2 = u;
v2 = v;
Z2 = Z;

clear('u','v','Z','nc')

%% Choose Z level
zlev = [3 5 7 9 11 12 13 16]; % 9 = at 40 m depth % used 3 , 5 ,7 , 9, 11, 12, 13, 16

%% Loop for plot both regimen winds


for jj = 1:length(zlev); % loop for multiple depths

zlevel = zlev(jj); 
nv = 5; %% velocity vectors subsampling
var.range = [0 0.2];


%ha = tight_subplot(3,4,[.02 .015],[.1 .01],[.03 .01]); % plot parameters

for ii = 1:12; % loop for months

time = ii; %(1 = january ... 12 = december)

%% All the matrices must have the same size
ur1 = u1(time,zlevel,:,:); ur1 = squeeze(ur1); ur1 = u2rho_2d(ur1);
vr1 = v1(time,zlevel,:,:); vr1 = squeeze(vr1); vr1 = v2rho_2d(vr1);
mv1 = sqrt(ur1.*ur1+vr1.*vr1); % intensity velocity currents
%mv1 = (ur1.*ur1+vr1.*vr1)/2; % EKE calculation
mv1 = mv1.*mask_rho;

%% All the matrices must have the same size
ur2 = u2(time,zlevel,:,:); ur2 = squeeze(ur2); ur2 = u2rho_2d(ur2);
vr2 = v2(time,zlevel,:,:); vr2 = squeeze(vr2); vr2 = v2rho_2d(vr2);
mv2 = sqrt(ur2.*ur2+vr2.*vr2); % intensity velocity currents
%mv2 = (ur2.*ur2+vr2.*vr2)/2; % EKE calculation
mv2 = mv2.*mask_rho;

%% plot figures
% figure ;

% FigHandle = figure('Position', [75, 75, 1250, 850]);
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
%axes(ha(ii));

p_plot = pcolor(lon_rho,lat_rho,mv1);
%p_plot = contourf(lon_rho,lat_rho,mv);
caxis(var.range);
shading flat
set(gca,'fontsize',7);
hold on;
quiver(lon_rho(1:nv:end,1:nv:end),lat_rho(1:nv:end,1:nv:end),...
       ur1(1:nv:end,1:nv:end),vr1(1:nv:end,1:nv:end),'k')
grid on
set(gca,'Layer','top')

%% Put coastline
%dir = 'F:\Matlab_packages\Roms_tools\Run\';
%dir = '/home/marissela/Documents/Roms_tools/Run/';
dir = '';
load ([dir, 'coastline_h.mat']);
hold on
lon = ncst(:,1);
lat = ncst(:,2);
plot(lon,lat,'k')

%% Set up domain of the plot
ylim([-07.0 -05.15]);
xlim([-82.0 -80.15]);
%ylim([-06.0 -05.0]);
%xlim([-81.5 -80.75]);

pos = get(gca, 'position');
cbr = colorbar('h');
set(gca, 'position', [pos(1) pos(2) pos(3) pos(4)]);

s = ['Month' ' ' num2str(time)];
p = ['Depth' ' ' num2str(Z1(zlevel)) 'm'];

text(-80.78,-5.25,s,'FontSize', 8, 'FontWeight', 'bold');
text(-80.78,-5.30,p,'FontSize', 8, 'FontWeight', 'bold');
text(-80.78,-5.35,'Intensity of currents (m/s)','FontSize', 8, 'FontWeight', 'bold');
text(-80.78,-5.40,'Montly Winds','FontSize', 8, 'FontWeight', 'bold');



subplot(1,2,2)
%axes(ha(ii));
time = ii; %(1 = january ... 12 = december)

%subplot(row,col,index.plot);
p_plot = pcolor(lon_rho,lat_rho,mv2);
%p_plot = contourf(lon_rho,lat_rho,mv);
caxis(var.range);
shading flat
set(gca,'fontsize',7);
hold on;
quiver(lon_rho(1:nv:end,1:nv:end),lat_rho(1:nv:end,1:nv:end),...
       ur2(1:nv:end,1:nv:end),vr2(1:nv:end,1:nv:end),'k')
grid on
set(gca,'Layer','top')

%% Put coastline
%dir = 'F:\Matlab_packages\Roms_tools\Run\';
%dir = '/home/marissela/Documents/Roms_tools/Run/';
dir = '';
load ([dir, 'coastline_h.mat']);
hold on
lon = ncst(:,1);
lat = ncst(:,2);
plot(lon,lat,'k')

%% Set up domain of the plot
ylim([-07.0 -05.15]);
xlim([-82.0 -80.15]);
%ylim([-06.0 -05.0]);
%xlim([-81.5 -80.75]);

pos = get(gca, 'position');
cbr = colorbar('h');
set(gca, 'position', [pos(1) pos(2) pos(3) pos(4)]);

s = ['Month' ' ' num2str(time)];
p = ['Depth' ' ' num2str(Z2(zlevel)) 'm'];

text(-80.78,-5.25,s,'FontSize', 8, 'FontWeight', 'bold');
text(-80.78,-5.30,p,'FontSize', 8, 'FontWeight', 'bold');
text(-80.78,-5.35,'Intensity of currents (m/s)','FontSize', 8, 'FontWeight', 'bold');
text(-80.78,-5.40,'Daily Winds','FontSize', 8, 'FontWeight', 'bold');



% save figure
prof = abs(Z1(zlevel)); prof = num2str(prof);
% file.name = [directory 'intensity_currents_' num2str(time) '_depth_' prof '.tif'];
file.name = ['F:/roms_plots/' 'intensity_currents_' num2str(time) '_depth_' prof '.tif'];
img = getframe(gcf);
imwrite(img.cdata, file.name);
end
close all
end


