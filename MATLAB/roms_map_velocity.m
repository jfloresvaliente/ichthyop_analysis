%%%%%% Script to plot Z interpolated levels %%%%%%
close all; clear all; clc
% Plot maps for intensity of velocity
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

%% Get varibles
% Get lon & lat from another file
simu = 'clim';
directory = ['D:/Ascat_', simu, '/'];
% directory = ['D:/Ascat_', simu, '/'];
nc = ncload ([directory,'newperush_avg.Y2010.M12.newperush.nc'],...
    'mask_rho','lon_rho', 'lat_rho');
lon_rho = lon_rho-360;
mask_rho(mask_rho==0)=NaN;

% Get all the variables available in Zmean file.
nc = ncload ([directory,'newperush_SmeanZ_', simu, '.nc'],'u','v','Z');

%% Choose Z level
zlev = [3 5 7 9 11 12 13 16]; % 9 = at 40 m depth % used 3 , 5 ,7 , 9, 11, 12, 13, 16

for jj = 1:length(zlev); 

zlevel = zlev(jj); 
nv = 5; %% velocity vectors subsampling
var.range = [0 0.2];


%ha = tight_subplot(3,4,[.02 .015],[.1 .01],[.03 .01]); % plot parameters

for ii = 1:12;
%figure ;
FigHandle = figure('Position', [75, 75, 850, 850]);

%axes(ha(ii));
time = ii; %(1 = january ... 12 = december)

%% All the matrices must have the same size
ur = u(time,zlevel,:,:); ur = squeeze(ur); ur = u2rho_2d(ur);
vr = v(time,zlevel,:,:); vr = squeeze(vr); vr = v2rho_2d(vr);
mv = sqrt(ur.*ur+vr.*vr); % intensity velocity currents
%mv = (ur.*ur+vr.*vr)/2; % EKE calculation
mv = mv.*mask_rho;

%subplot(row,col,index.plot);
p_plot = pcolor(lon_rho,lat_rho,mv);
%p_plot = contourf(lon_rho,lat_rho,mv);
caxis(var.range);
shading flat
set(gca,'fontsize',7);
hold on;
quiver(lon_rho(1:nv:end,1:nv:end),lat_rho(1:nv:end,1:nv:end),...
       ur(1:nv:end,1:nv:end),vr(1:nv:end,1:nv:end),'k')
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
p = ['Depth' ' ' num2str(Z(zlevel)) 'm'];

text(-80.78,-5.25,s,'FontSize', 16, 'FontWeight', 'bold');
text(-80.78,-5.30,p,'FontSize', 16, 'FontWeight', 'bold');
text(-80.78,-5.35,'Intensity of currents (m/s)','FontSize', 16, 'FontWeight', 'bold');
%     if(ii == 12)
%         pos = get(gca, 'position');
%         cbr = colorbar('h');
%         set(gca, 'position', [pos(1) pos(2) pos(3) pos(4)]);
%         
%         
% %         ax = gca;
% %         axpos = ax.Position;
% %         c.Position(4) = 0.5*c.Position(4);
% %         ax.Position = axpos;
% %cb = colorbar('h'); 
% %set(cb,'position',[.15 .1 .1 .3])
%     end
% save figure
prof = abs(Z(zlevel)); prof = num2str(prof);
file.name = [directory 'intensity_currents_' simu '_' num2str(time) '_depth_' prof '.tif'];
img = getframe(gcf);
imwrite(img.cdata, file.name);
end
close all
end




% set(ha(1:8),'XTickLabel','');
% set(ha([2:4 6:8 10:12]),'YTickLabel','')
% scatter(lon, lat, 6*(ones(1, length(lon))), depth)
