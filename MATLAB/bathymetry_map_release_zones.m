%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% PLOT BATHYMETRY MAP OF RELEASE ZONES
% aim1 = Make maps for release zones defined in Ichthyop
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace
%% Coordinates of the release zones [minlon maxlon minlat maxlat]
% Each row represents a zone
zone_limits = [-81.3330 -80.7500 -5.916 -5.166;
               -80.8335 -80.7510 -6.500 -6.333];
%% Directory to sava map
out_dir = 'C:/Users/ASUS/Desktop/';
out_name = [out_dir, 'bathymetry_map_release_zones_contour'];
%% Needed variables: lon, lat, mask
roms_directory = 'D:/Ascat_daily/';
roms_file = 'newperush_avg.Y2010.M12.newperush.nc'; % anyone file

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
ncload ([roms_directory,roms_file],'lon_rho','lat_rho','mask_rho','h');
lon_rho = lon_rho-360;

xy = [];
for i =  1:size(zone_limits,1);
   limits = zone_limits(i,:);   
   %% Find indices for lon and lat
   [row1,col1] = find(lon_rho>=limits(1) & lon_rho<=limits(2));
   [row2,col2] = find(lat_rho>=limits(3) & lat_rho<=limits(4));
   X = [row1 col1]; % lon indices
   Y = [row2 col2]; % lat indices
   %% Find match between lon&lat indices, then replace it with NaN in the mask
   XY = intersect(X,Y,'rows');   
   %% Loop to discriminate between land and sea by assigning NaN to land
   % then, such values will not be taken into account.
   mask = ones([size(mask_rho,1) size(mask_rho,2)]);
   for j = 1:size(XY,1);
       if mask_rho(XY(j,1),XY(j,2)) == 1;
           mask(XY(j,1),XY(j,2)) = NaN;
       else XY(j,1:2) = NaN;
       end
   end
   %% Cleans rows containing NaN, and get only index in sea
   XY(any(isnan(XY), 2), :) = [];
   xy = vertcat(xy,XY);
%    mask_rho = mask_rho.*mask;
end

mask_rho = NaN([size(mask_rho,1) size(mask_rho,2)]);
for j = 1:size(xy,1);
    mask_rho(xy(j,1),xy(j,2)) = 1;
end

h(h>60) = NaN;
%% Plot to confirm selecction
% figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
pcolor(lon_rho, lat_rho, mask_rho.*h);
shading flat
%% Add coastline to the plot (only if you set path Rooms_tools)
dir = '';
load ([dir, 'coastline_h.mat']); % loaded from Roms_tools
hold on;
lon = ncst(:,1);
lat = ncst(:,2);
plot(lon,lat,'black');


ncload ([roms_directory,roms_file],'mask_rho','h');
mask_rho(mask_rho == 0) = NaN;

hold on
v = [0,10,20,30,40,60,100,150,200];
[c2,h2] = contour(lon_rho,lat_rho,mask_rho.*h, v, 'Color','k','LineStyle','--');
% v = [10,20,30,100,150,200];
clabel(c2,h2,v,'FontSize',10,'FontWeight','bold')



%% Set up domain of the plot (you can change this domain)
ylim([-7  -5]);
xlim([-82 -80]);
caxis([0 60]);

% %% Proyeccion de Mercator
% domaxis = [xlim ylim];
% m_proj('mercator',...
%     'lon',[domaxis(1) domaxis(2)],...
%     'lat',[domaxis(3) domaxis(4)]);
% set(0,'DefaultFigureRenderer','zbuffer')
% m_usercoast('coastline_h','patch',[0.6 0.6 0.6],'edgecolor','k');
%         m_grid('box','fancy','fontsize',10);
% 
set(gca, 'YAxisLocation', 'right');
set(gca, 'TickDir', 'out');
% set(gca,'ytick',[]);
% xticks([-82 -81.5 -81 -80.5 -80]);
% xticklabels({'82W','81.30`','81W','80.30`','80W'})
cbr = colorbar('h');    % add color-bar
set(gca,'fontsize',12)
%% Add limits of selection zone (like legend) to the plot
s = 'Sechura Bay';
p = 'Lobos de Tierra';
m = 'Island';
% text(-80.78,-5.25,'Limits of zone','FontSize', 14, 'FontWeight', 'bold', 'color','red');
% text(-81.5,-5.50,s,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
% text(-81.3,-6.35,p,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
% text(-81.3,-6.45,m,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
title('Bathymetric of release zones (m)','FontSize', 14, 'FontWeight', 'bold', 'color','black')


%% Save coordinates file (.txt) and figure (.tif)
save([out_name,'.txt'],'XY','-ascii');
img = getframe(gcf);
imwrite(img.cdata, [out_name,'.tiff']);
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
