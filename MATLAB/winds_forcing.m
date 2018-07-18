
%% Monthly winds
dirpath = 'C:/Users/ASUS/Desktop/roms_files/';
ncload ('H:/Ascat_clim/newperush_avg.Y2012.M6.newperush.nc',...
    'lon_rho','lat_rho','mask_rho');
lon_rho = lon_rho-360;
mask_rho(mask_rho==0)=NaN;

ncload([dirpath, 'input/newperush_frc_ascatclim_2008_2012.nc'],...
    'sustr','svstr');
nv = 7; %% velocity vectors subsampling
var_range = [0,0.06];
winds = 'clim';

for month = 1:12
    % All the matrices must have the same size
    sus = squeeze(sustr(month,:,:)); sus = u2rho_2d(sus);
    svs = squeeze(svstr(month,:,:)); svs = v2rho_2d(svs);
    mv  = sqrt(sus.^2+svs.^2).*mask_rho; % intensity velocity winds
    
    pcolor(lon_rho,lat_rho,mv);
    caxis(var_range);
    shading flat
    cbr = colorbar('h');
    set(gca,'fontsize',7);
    hold on;
    quiver(lon_rho(1:nv:end,1:nv:end),lat_rho(1:nv:end,1:nv:end),...
        sus(1:nv:end,1:nv:end),svs(1:nv:end,1:nv:end),'k')
    grid on
    set(gca,'Layer','top')
    
    dir = '';
    load ([dir, 'coastline_h.mat']);
    hold on
    lon = ncst(:,1);
    lat = ncst(:,2);
    plot(lon,lat,'k')
    %% Set up domain of the plot
    ylim([-07.0 -05.15]);
    xlim([-82.0 -80.15]);
    
    file_name = [dirpath winds '_winds_' num2str(month) '.tif'];
    img = getframe(gcf);
    imwrite(img.cdata, file_name);
    close all

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get climatology from daily forcing

% for year = 2008:2008
%     ncload([dirpath, 'newperush_frc_ascat' winds '_', num2str(year), '.nc'],...
%         'sustr','svstr');
%     sustr = u2rho_3d(sustr);
%     svstr = v2rho_3d(svstr);
% 
%     for month =  1:30:360;
%     end
% end
