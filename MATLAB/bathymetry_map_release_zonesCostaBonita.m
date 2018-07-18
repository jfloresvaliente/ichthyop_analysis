%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% PLOT BATHYMETRY MAP OF RELEASE ZONES
% aim1 = Make maps for release zones defined in Ichthyop
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%% Directory to sava map
out_dir = 'C:/Users/ASUS/Desktop/'; % Directorio de salida
out_name = [out_dir, 'bathymetry_map_release_zones_contour']; % Nombre de salida

%% Coordinates of the each release zones in the form of [minlon maxlon minlat maxlat]
% Each row represents a zone
zone_limits = [-81.3330 -80.7500 -5.916 -5.166;
               -80.8335 -80.7510 -6.500 -6.333];

%% Needed variables: lon, lat, mask
roms_file = 'D:/Ascat_daily/newperush_avg.Y2010.M12.newperush.nc';

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
ncload (roms_file,'lon_rho','lat_rho','mask_rho','h');
lon_rho = lon_rho-360;

%% Busqueda de los indices de cada zona
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

%% Se coloca 1 en los indices de xy, los demas permanecen en NaN
mask_rho = NaN([size(mask_rho,1) size(mask_rho,2)]);
for j = 1:size(xy,1);
    mask_rho(xy(j,1),xy(j,2)) = 1;
end

%% Limite de batimetría
h(h>60) = NaN;

%% Proyeccion de Mercator
domaxis = [-82 -80 -7 -5];

m_proj('mercator',...
    'lon',[domaxis(1) domaxis(2)],...
    'lat',[domaxis(3) domaxis(4)]);
set(0,'DefaultFigureRenderer','zbuffer')

m_pcolor(lon_rho, lat_rho, mask_rho.*h);
shading flat
m_usercoast('coastline_h','patch',[0.6 0.6 0.6],'edgecolor','k');
m_grid('box','fancy','fontsize',10);

hold on

v = [0,10,20,30,40,60,100,150,200];
[c2,h2] = m_contour(lon_rho,lat_rho,mask_rho.*h, v, 'Color','k','LineStyle','--');
v = [10,20,30,100,150,200];
clabel(c2,h2,v,'FontSize',10,'FontWeight','bold')
colorbar

message1 = sprintf('Sechura\nBay');
message2 = sprintf('Lobos\nde Tierra\nIsland');
m_text(-81.5,-5.50,message1,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
m_text(-81.3,-6.35,message2,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
% m_text(-81.3,-6.45,m,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
title('Bathymetric of release zones (m)','FontSize', 14,...
    'FontWeight', 'bold', 'color','black')

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%