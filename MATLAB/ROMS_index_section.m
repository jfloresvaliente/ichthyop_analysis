%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% TO FIND INCIDES OF SPECIFIC LAT/TLON IN ROMS FILES
% aim1 = select a section finding it's indices
% aim2 = plot that section to check if we agree with selection
% aim3 = save indices (.txt) and save zone's figure (.tif)
% aim4 = create a directory to save indices and figures
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  

%% Indices of posible secction
row = 680;      %  (+up)  (-down)
col = 334;      %  (+ right) (- left)

%% Create directory and outfile names
winds = 'clim';
% Directory where will be created new directories to indices and figures
out_dir = '/home/marissela/ROMS/';
new_dir = 'section_bay';
mkdir([out_dir , new_dir]);
out_name = [out_dir, new_dir,'/', new_dir];

%% Needed variables: lon, lat, mask
roms_directory = ['/run/media/marissela/JORGE_NEW/Ascat_', winds, '/'];
roms_file = 'newperush_avg.Y2010.M12.newperush.nc'; % anyone file
nc = ncload ([roms_directory,roms_file],'lon_rho','lat_rho','mask_rho');
lon_rho = lon_rho-360;

% mask_rho(row,col:1:col+9)=NaN;    % uncomment to select a row
mask_rho(row:1:row+9,col)=NaN;      % uncomment to select a col

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

%% Plot to confirm selecction
% figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
pcolor(lon_rho, lat_rho, mask_rho);
% shading 'flat'

[row1,col1] = find(isnan(mask_rho));
XY = [row1 col1];

%% Add coastline to the plot (only if you set path Rooms_tools)
dir = '';
load ([dir, 'coastline_h.mat']); % loaded from Roms_tools
hold on;
lon = ncst(:,1);
lat = ncst(:,2);
plot(lon,lat,'yellow');

%% Set up domain of the plot (you can change this domain)
ylim([-06.65 -05.15]);
xlim([-81.80 -80.30]);

%% Add row and col selection (like legend) to the plot
s = ['ROW ' num2str(row)];
p = ['COL ' num2str(col)];
text(-80.78,-5.25,s,'FontSize', 14, 'FontWeight', 'bold', 'color','red');
text(-80.78,-5.35,p,'FontSize', 14, 'FontWeight', 'bold', 'color','red');

%% Save coordinates file (.txt) and figure (.tif)
save([out_name,'.txt'],'XY','-ascii');
img = getframe(gcf);
imwrite(img.cdata, [out_name,'.tiff']);
close all

% %%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
% %%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
