%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% PLOT MAPS IN Z LEVELS
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%% ncfile directory and ncfile name
ncDir  = 'H:/Ascat_daily/';
outDir = 'F:/ichthyop_output_analysis/RUN2/roms_maps/daily/';
ncFile = 'newperush_Mmean.nc';

%% ROMS parameters
vtransform   = 1; 
N            = 42;            % number of sigma levels
Zlev         = -10:-10:-40;  % zlevels to get interpolations
nv           = 4; %% velocity vectors subsampling
scale_factor = 1.2; % para el tamaño de las flechas
barColor     = [-0.0001 0.0001];

% Load ncfile
ncload ([ncDir ncFile], 'lon_rho','lat_rho','u','v','w','h','mask_rho');
zr = zlevs(h,0*h,6.5,0,10,N,'r',vtransform); % 3D variable with bathymetry
mask_rho(mask_rho == 0) = NaN;
lon_rho = lon_rho - 360;

%% Proyeccion de Mercator
domaxis = [-82 -80 -7 -5];
m_proj('mercator',...
    'lon',[domaxis(1) domaxis(2)],...
    'lat',[domaxis(3) domaxis(4)]);
set(0,'DefaultFigureRenderer','zbuffer')
%% Bucle de calculo de variables en Z
for month = 1:12; % Bucle para calcular en los 12 meses
    
    varU = squeeze(u(month,:,:,:)); varU = u2rho_3d(varU);
    varV = squeeze(v(month,:,:,:)); varV = v2rho_3d(varV);
    varW = squeeze(w(month,:,:,:));
    
    for iz = 1:length(Zlev); % Bucle para interpolar en los niveles Z
        varnU(iz,:,:) = sigmatoz(varU,zr,Zlev(iz));
        varnV(iz,:,:) = sigmatoz(varV,zr,Zlev(iz));
        varnW(iz,:,:) = sigmatoz(varW,zr,Zlev(iz));
    end;
    
    for j = 1:length(Zlev); % Bucle para plotear cada mes y cada nivel Z
        a   = squeeze(varnU(j,:,:)) .* mask_rho;
        b   = squeeze(varnV(j,:,:)) .* mask_rho;
        mv1 = squeeze(varnW(j,:,:)); % Velocidad Vertical en 2D
        
%         FigHandle = figure('Position', [75, 75, 850, 850]);
        figure
        m_pcolor(lon_rho, lat_rho, mv1);
        shading flat
%         set(gca,'Fontsize',14,'Fontweight','bold')
        
        m_usercoast('coastline_h','patch',[0.6 0.6 0.6],'edgecolor','k');
        m_grid('box','fancy','fontsize',10);
%         set(gca,'Fontsize',20,'XColor','k','YColor','r')
        colorbar
        caxis(barColor);
%         set(gca,'Fontsize',14)
                
        hold on
        x = lon_rho(1:nv:end,1:nv:end);
        y = lat_rho(1:nv:end,1:nv:end);
        a2 = a(1:nv:end,1:nv:end);
        b2 = b(1:nv:end,1:nv:end);
%         m_quiver(x, y, a2*scale_factor, b2*scale_factor, 'k','AutoScale','off')
           
        if month < 10
           titulo = ['Month ', num2str(0),num2str(month), ' Depth ' ,num2str(abs(Zlev(j))), ' m']; 
        else
           titulo = ['Month ',num2str(month), ' Depth ' ,num2str(abs(Zlev(j))), ' m']; 
        end
        xlabel(titulo,'Fontweight','bold');
        
        if Zlev(j) > -10
           prof = abs(Zlev(j)); prof = [num2str(0),num2str(prof)];
        else
           prof = abs(Zlev(j)); prof = num2str(prof);
        end
        fig_name = [outDir 'WCurrents' num2str(month) '_depth_' prof '.tif'];
        img = getframe(gcf);
        imwrite(img.cdata, fig_name);
    end
    close all
end
