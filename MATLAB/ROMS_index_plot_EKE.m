%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

winds = {'clim','daily'}; % Type of simulation
zlevels = 100;
% zlim = [0, 0.0025];
zlim = [0  0.0015];

out_dir = 'C:/Users/ASUS/Desktop/contour_plots/';
new_dir = 'island';

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
num_plot = 0;

for ii = winds;
    
    % change next line if ROMS files are stored in other directory
    directory = [out_dir, new_dir,'/'];
    fig_name = [directory 'EKE.tif'];
    title_name = ['EKE ' char(ii) ' winds'];

    load ([directory, char('u'),'_',char(ii)]);
    u2 = VAR.^2;
    load ([directory, char('v'),'_',char(ii)]);
    v2 = VAR.^2;
    
    EKE = (u2+v2)/2;
    
    month_in = 1:12;
    MONTH_MEAN = zeros([zlevels 12]);
    
    for jj = month_in
        month_index = jj:12:size(EKE,3);
        month = EKE(:,:,month_index);
        month = nanmean(month,3);
        month = nanmean(month,2);

        MONTH_MEAN(:,jj) = month;
    end
    
    months = repmat(1:12,[zlevels 1]);  % X matrix to plot (contains months)
    depths = transp(-zlevels:1:-1);     % Y matrix to plot (contains depths)
    depths = repmat(depths,[1,12]);
    
    num_plot = num_plot +1;
    subplot(2,1,num_plot)
    [C,h] = contourf(months, depths, MONTH_MEAN);
    clabel(C,h)             % add labels to isolines
    caxis(zlim)             % zlim for color in the plot
    ylabel('Depth (m)','FontSize', 14, 'FontWeight', 'bold');
    xlabel('MONTHS','FontSize', 14, 'FontWeight', 'bold');
    pos = get(gca, 'position');
    cbr = colorbar('v');    % add color-bar
    title(title_name,'FontSize', 14, 'FontWeight', 'bold');      % add title to plot 
    
end

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
