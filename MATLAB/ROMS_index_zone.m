%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% TO FIND INCIDES OF A SPECIFIC ZONE IN ROMS FILES
% aim1 = create a directory to save indices and figures
% aim2 = select a zone finding its indices
% aim3 = plot selected zone to check if we agree with zone selection
% aim4 = save indices (.txt) and save zone's figure (.tif)
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%% Coordinates to find indices in the form [minlon maxlon minlat maxlat]
limits = [-80.84 -80.7 -6.6 -6.43];

%% Create directory and outfile names
winds = 'daily';
% Directory where will be created new directories to indices and figures
out_dir = 'C:/Users/ASUS/Desktop/';
new_dir = 'coast_test';
mkdir([out_dir , new_dir]);
out_name = [out_dir, new_dir,'/', new_dir];

%% Needed variables: lon, lat, mask
roms_directory = ['H:/Ascat_', winds, '/'];
roms_file = 'newperush_avg.Y2010.M12.newperush.nc'; % anyone file
ncload ([roms_directory,roms_file],'lon_rho','lat_rho','mask_rho');
lon_rho = lon_rho-360;

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

%% Find indices for lon and lat
[row1,col1] = find(lon_rho>=limits(1) & lon_rho<=limits(2));
[row2,col2] = find(lat_rho>=limits(3) & lat_rho<=limits(4));
X = [row1 col1]; % lon indices
Y = [row2 col2]; % lat indices

%% Find match between lon&lat indices, then replace it with NaN in the mask
XY = intersect(X,Y,'rows');

mask = ones([size(mask_rho,1) size(mask_rho,2)]);
% este loop permite discriminar entre tierra y mar asignando NaN a tierra
% luego, dichos valores no serán tomados en cuenta.
for i = 1:size(XY,1);
   if mask_rho(XY(i,1),XY(i,2)) == 1;
      mask(XY(i,1),XY(i,2)) = NaN;
   else
      XY(i,1:2) = NaN;
   end
end

XY(any(isnan(XY), 2), :) = []; % Limpia las filas que contienen NaN
mask_rho = mask_rho.*mask;
%% Plot to confirm selecction
% figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
m_pcolor(lon_rho, lat_rho, mask_rho);
m_usercoast('coastline_h.mat','patch',[0.6 0.6 0.6],'edgecolor','k');
m_grid('box','fancy','xtick',5,'ytick',7,'tickdir','out','fontsize',7);
shading flat

%% Add coastline to the plot (only if you set path Rooms_tools)
dir = '';
load ([dir, 'coastline_h.mat']); % loaded from Roms_tools
hold on;
lon = ncst(:,1);
lat = ncst(:,2);
plot(lon,lat,'yellow');

%% Set up domain of the plot (you can change this domain)
ylim([-7  -5.15]);
xlim([-82 -80.15]);

%% Add limits of selection zone (like legend) to the plot
s = [num2str(limits(1)),' ',num2str(limits(2))];
p = [num2str(limits(3)),' ',num2str(limits(4))];
text(-80.78,-5.25,'Limits of zone','FontSize', 14, 'FontWeight', 'bold', 'color','red');
text(-80.78,-5.35,s,'FontSize', 14, 'FontWeight', 'bold', 'color','red');
text(-80.78,-5.45,p,'FontSize', 14, 'FontWeight', 'bold', 'color','red');

%% Save coordinates file (.txt) and figure (.tif)
save([out_name,'.txt'],'XY','-ascii');
img = getframe(gcf);
imwrite(img.cdata, [out_name,'.tiff']);
%close all; clc

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
