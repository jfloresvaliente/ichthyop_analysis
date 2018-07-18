%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

winds = {'clim','daily'}; % Type of simulation
potencia = 3;
var = 'w';
zlevels = 100;
% zlim = [0, 0.0025];
zlim = [-9.5897e-14 8.0244e-13];

out_dir = 'C:/Users/ASUS/Desktop/contour_plots/';
new_dir = 'up_zone3';

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
num_plot = 0;

for ii = winds;
    
    % change next line if ROMS files are stored in other directory
    directory = [out_dir, new_dir,'/'];
    fig_name = [directory var num2str(potencia) '_variability.tif'];
    
%     if potencia == 1
%         title_name = ['Velocity ' var ' ' char(ii) ' ' 'winds'];
%         out_matfile = [var '_' char(ii) num2str(potencia)];
%     end
    if potencia == 2
        title_name = ['Variability ' var ' ' char(ii) ' ' 'winds'];
        out_matfile = [var '_' char(ii) num2str(potencia)];
    end
    if potencia == 3
        title_name = ['Skewness ' var ' ' char(ii) ' ' 'winds'];
        out_matfile = [var '_' char(ii) num2str(potencia)];
    end
    
%     if potencia == 2
%         title_name = ['Variability ' var ' ' char(ii) ' ' 'winds'];
%         out_matfile = [var '_' char(ii) num2str(potencia)];
%     else
%         title_name = ['Skewness ' var ' ' char(ii) ' ' 'winds'];
%         out_matfile = [var '_' char(ii) num2str(potencia)];
%     end
        
    load ([directory, char(var),'_',char(ii)]);
    vari = (VAR).^potencia;
%     month_index = [1:10 59:60]; % indices de meses no usados to run ichthyop
%     vari(:,:,month_index) = NaN;
    
    month_in = 1:12;
    MONTH_MEAN = zeros([zlevels 12]);
    
    for jj = month_in
        month_index = jj:12:size(vari,3);
        month = vari(:,:,month_index);
        month = nanmean(month,3);
        month = nanmean(month,2);

        MONTH_MEAN(:,jj) = month;
    end
    
    %% Save MONTH_MEAN
    file_name = [directory out_matfile '.mat'];
    save(file_name,'MONTH_MEAN','-mat')
    
    %% PLOT MONTH_MEAN
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

% img = getframe(gcf);
% imwrite(img.cdata, fig_name);
% close all

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
