
close all; clear all; clc  % clear workspace
potencia = 3;
zlim = [1.8e-6, 20000];
in_plot = 0;
winds = {'clim','daily'};
var = 'w';
units = 'cm/s';
figname = ['D:/' var num2str(potencia) '_variability.tiff'];
name = [' variability of velocity ^' num2str(potencia) ' '];

figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
for kk = winds
    in_plot = in_plot + 1;
    subplot(2,1,in_plot)
    directory = ['D:/Ascat_', char(kk), '/'];
    load ([directory 'variability_p1/' 'variability_' var])
    M = M.^potencia;
    
    depth = load ([directory 'variability_p1/' 'variability_depths_u.txt']);
    
    month_in = 1:12;
    MONTH_MEAN = zeros([42 12]);
    
    for ii = month_in
        month_index = ii:12:60;
        for jj = month_index
        month = M(:,:,month_index);
        N = nanmean(month,3);
        N = nanmean(N,2);
        end
        MONTH_MEAN(:,ii) = N;
    end
    MONTH_MEAN = MONTH_MEAN.*MONTH_MEAN;
    lati = repmat(1:12,[42 1]); % X matrix to plot (contains months)
    depth = flipud(repmat(depth,[1,12]));
    
    [C,h] = contourf(lati, depth, MONTH_MEAN);
    clabel(C,h)%,v_lines); % add labels to isolines
    caxis(zlim) % zlim for color in the plot
    ylabel('Depth (m)');
    xlabel('MONTHS');
    pos = get(gca, 'position');
    cbr = colorbar('v'); % add color-bar
    title([var name units ' ' char(kk) ' winds']); % add title to plot 
    
end

img = getframe(gcf);
imwrite(img.cdata, figname);
close all

% MONTH_MEAN
% nccreate('myfile.nc','pi');
% ncwrite('myfile.nc','pi',3.1);
% ncwriteatt('myfile.nc','/','creation_time',datestr(now));
% % overwrite existing data
% ncwrite('myfile.nc','pi',3.1416);
% ncdisp('myfile.nc');
