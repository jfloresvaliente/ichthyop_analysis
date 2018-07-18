%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%%
% Directory where will be created new directories to indices and figures
out_dir  = 'C:/Users/ASUS/Desktop/contour_plots/';
new_dir  = 'up_zone3';
out_name = [out_dir, new_dir,'/', new_dir];
winds    = {'clim','daily'}; % Type of simulation
year_in  = 2009;
year_on  = 2011;
month_in = 1;
month_on = 12;
var      = 'w';
zlevels  = 100;
XY = load ([out_name, '.txt']);
% zlim = [-0.04 0.02];
zlim = [-0.15 .15];

out_dir = 'C:/Users/ASUS/Desktop/contour_plots/';

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
num_plot = 0;

for ii = winds;
    
    % change next line if ROMS files are stored in other directory
    fig_name = [out_dir new_dir '/' var '_mean.tif'];
    ncload (['H:/Ascat_' char(ii) '/' 'newperush_Mmean.nc'], var, 'h'); % ROMS file name
    var_mean = eval(var);
    
    MONTH_MEAN = zeros(zlevels,12);
    for month = 1:12;
        var_month = squeeze(var_mean(month,:,:,:));
        XY_mat = zeros(zlevels,size(XY,1));
        for hh = 1:size(XY,1) % loop for each point
            xy = XY(hh,:);
            dep = h(xy(1,1), xy(1,2));
            pz = zlevs(dep,0,6.5,0,10,42,'r',1); 
            a = pz;                             % sample points
            b = var_month(:,xy(1,1), xy(1,2));    % values
            c = -zlevels:1:-1;                  % new sample points
            d = interp1(a,b,c);
            XY_mat(:,hh) = d;        
        end
        XY_mat = nanmean(XY_mat,2);
        MONTH_MEAN(:,month) = XY_mat; 
    end
    
    %% Save MONTH_MEAN
    file_name = [out_dir,new_dir, '/',char(var),'_', char(ii),'_mean','.mat'];
    save(file_name,'MONTH_MEAN','-mat')
    
    %% PLOT MONTH_MEAN
%     months = repmat(1:12,[zlevels 1]);  % X matrix to plot (contains months)
%     depths = transp(-zlevels:1:-1);     % Y matrix to plot (contains depths)
%     depths = repmat(depths,[1,12]);
%     
%     num_plot = num_plot +1;
%     subplot(1,1,num_plot)
%     [C,h] = contourf(months, depths, MONTH_MEAN);
%     clabel(C,h)             % add labels to isolines
%     caxis(zlim)             % zlim for color in the plot
%     ylabel('Depth (m)','FontSize', 14, 'FontWeight', 'bold');
%     xlabel('MONTHS','FontSize', 14, 'FontWeight', 'bold');
%     pos = get(gca, 'position');
%     cbr = colorbar('v');    % add color-bar
%     title_name = [var ' velocity m/s'];
%     title(title_name,'FontSize', 14, 'FontWeight', 'bold');      % add title to plot 
end

% img = getframe(gcf);
% imwrite(img.cdata, fig_name);
% close all

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%