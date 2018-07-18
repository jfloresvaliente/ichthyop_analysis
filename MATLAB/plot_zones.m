%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% TO FIND INCIDES OF A ZONE IN ROMS FILES
% aim1 = select a zone finding it's indices
% aim2 = plot that zone to check if we agree with zone selection
% aim3 = save indices (.txt) and save zone's figure (.tif)
% aim4 = create a directory to save indices and figures
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%% Create directory and outfile names
winds = 'clim';
% Directory where will be created new directories to indices and figures
out_dir = 'C:/Users/ASUS/Desktop/';
new_dir = 'coast_test';
mkdir([out_dir , new_dir]);
out_name = [out_dir, new_dir,'/', new_dir];

%% Needed variables: lon, lat, mask
roms_directory = ['H:/Ascat_', winds, '/'];
roms_file = 'newperush_avg.Y2010.M12.newperush.nc'; % anyone file
nc = ncload ([roms_directory,roms_file],'lon_rho','lat_rho','mask_rho','h');
lon_rho = lon_rho-360;

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

%% Find indices for lon and lat
XY = load([out_name '.txt']);
mask = ones([size(mask_rho,1) size(mask_rho,2)]);
% este loop permite discriminar entre tierra y mar asignando NaN a tierra
% luego, dichos valores no serán tomados en cuenta.
for i = 1:size(XY,1);
   if mask_rho(XY(i,1),XY(i,2)) == 1;
      mask(XY(i,1),XY(i,2)) = 2;
   else
      XY(i,1:2) = NaN;
   end
end

XY(any(isnan(XY), 2), :) = []; % Limpia las filas que contienen NaN

mask_rho = mask_rho.*mask;
mask_rho(mask_rho == 0) = NaN;
mask_rho(mask_rho == 1) = NaN;
mask_rho(mask_rho == 2) = 1;
%% Plot to confirm selecction
% figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
pcolor(lon_rho, lat_rho, mask_rho.*h);
m_usercoast('coastline_h.mat','patch',[0.6 0.6 0.6],'edgecolor','k');
caxis([0 60]);
shading 'flat'
xlabel('Longitude','FontSize', 14, 'FontWeight', 'bold')
ylabel('Latitude' ,'FontSize', 14, 'FontWeight', 'bold')
title('Bathymetric of release zones(m)', 'FontSize', 14, 'FontWeight', 'bold')

%% Add coastline to the plot (only if you set path Rooms_tools)
dir = '';
load ([dir, 'coastline_h.mat']); % loaded from Roms_tools
hold on;
lon = ncst(:,1);
lat = ncst(:,2);
plot(lon,lat,'black');

%% Set up domain of the plot (you can change this domain)
ylim([-06.5 -05.0]);
xlim([-82. -80.5]);

%% Save coordinates file (.txt) and figure (.tif)
% save([out_name,'.txt'],'XY','-ascii');
% img = getframe(gcf);
% imwrite(img.cdata, [out_name,'.tiff']);
% close all; clc

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%