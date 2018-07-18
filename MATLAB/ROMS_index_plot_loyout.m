%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%%
% Directory where will be created new directories to indices and figures
out_dir  = 'C:/Users/ASUS/Desktop/contour_plots/';
new_dir  = 'up_zone2';
out_name = [out_dir, new_dir,'/', new_dir];
winds    = {'clim','daily'}; % Type of simulation
year_in  = 2009;
year_on  = 2011;
month_in = 1;
month_on = 12;
var      = 'v';
zlevels  = 100;
XY = load ([out_name, '.txt']);
zlim1 = [-0.05 0.17];
zlim2 = [0 0.005];
zlim3 = [ -5.7259e-04 1.0180e-04];

out_dir = 'C:/Users/ASUS/Desktop/contour_plots/';

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
% num_plot = 0;

for ii = winds;
%     figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
    figure
    num_plot = 0;
    % change next line if ROMS files are stored in other directory
%     fig_name = [out_dir new_dir '/' var '_layout.tif'];
%     ncload (['H:/Ascat_' char(ii) '/' 'newperush_Mmean.nc'], var, 'h'); % ROMS file name
%     var_mean = eval(var);
    
    load([out_dir new_dir '/' var '_' char(ii) '_mean.mat']);
    A = MONTH_MEAN;
    
    load([out_dir new_dir '/' var '_' char(ii) '2.mat']);
    B = MONTH_MEAN;
    
    load([out_dir new_dir '/' var '_' char(ii) '3.mat']);
    D = MONTH_MEAN;
    
    months = repmat(1:12,[zlevels 1]);  % X matrix to plot (contains months)
    depths = transp(-zlevels:1:-1);     % Y matrix to plot (contains depths)
    depths = repmat(depths,[1,12]);
   
    %% PLOT MONTH_MEAN (layout [2 3])
    num_plot = num_plot +1;
    
    %% PLOT A
    subplot(3,1,num_plot)
    [C,h] = contourf(months, depths,A);
    clabel(C,h)             % add labels to isolines
    caxis(zlim1)             % zlim for color in the plot
    ylabel('Depth (m)','FontSize', 14, 'FontWeight', 'bold');
    xlabel('MONTHS','FontSize', 10, 'FontWeight', 'bold');
    pos = get(gca, 'position');
    cbr = colorbar('v');    % add color-bar
    title_name = [var ' velocity m/s ' char(ii) ' winds'];
    title(title_name,'FontSize', 14, 'FontWeight', 'bold');      % add title to plot

    %% PLOT B
    subplot(3,1,num_plot+1)
    [C,h] = contourf(months, depths,B);
    clabel(C,h)             % add labels to isolines
    caxis(zlim2)             % zlim for color in the plot
    ylabel('Depth (m)','FontSize', 14, 'FontWeight', 'bold');
    xlabel('MONTHS','FontSize', 10, 'FontWeight', 'bold');
    pos = get(gca, 'position');
    cbr = colorbar('v');    % add color-bar
    title_name = [var ' Variability ' char(ii) ' winds'];
    title(title_name,'FontSize', 14, 'FontWeight', 'bold');      % add title to plot
    
    %% PLOT D
    subplot(3,1,num_plot+2)
    [C,h] = contourf(months,depths,D);
    clabel(C,h)             % add labels to isolines
    caxis(zlim3)             % zlim for color in the plot
    ylabel('Depth (m)','FontSize', 14, 'FontWeight', 'bold');
    xlabel('MONTHS','FontSize', 10, 'FontWeight', 'bold');
    pos = get(gca, 'position');
    cbr = colorbar('v');    % add color-bar
    title_name = [var ' Skewness ' char(ii) ' winds'];
    title(title_name,'FontSize', 14, 'FontWeight', 'bold');      % add title to plot
end

nanmin(nanmin(A))
nanmax(nanmax(A))

nanmin(nanmin(B))
nanmax(nanmax(B))

nanmin(nanmin(D))
nanmax(nanmax(D))

% img = getframe(gcf);
% imwrite(img.cdata, fig_name);
% close all

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
