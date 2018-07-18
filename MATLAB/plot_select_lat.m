%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% PLOT VERTICAL MEAN IN Z LEVELS FROM PREVIOUS SECTION SELECTED
% aim1 = Compute vertical sections from ROMS file
% aim2 = save figures (.png)
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%% Needed variables: lon, lat (from another file) and coordinates (XY)
roms_file = 'D:/Ascat_clim/newperush_avg.Y2010.M12.newperush.nc';
nc_coords = ncload (roms_file,'lon_rho','lat_rho');
lon_rho = lon_rho-360;
clear('nc_coords');

%% Type of ROMS simulation and out directory
simu = {'clim' 'daily'};
out_file = 'section_bay_5';

%% Select variables to plot
variables = {'w'};
out_dir = 'C:/Users/ASUS/Desktop/contour_plots/';
out_file = [out_dir,out_file,'/',out_file];
XY = load ([out_file, '.txt']);
zlev = 11; % limit for z depth
nmonth = 12; % number of months to plot
zlim = [-3.5 12];

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
 
for ii = variables; % loop for all variables
    var = char(ii);

    for kk = 1:nmonth;
        num_plot = 1;
        figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
        for p = simu; % loop for type simulation
    directory = ['D:/Ascat_', char(p), '/']; % ROMS file directory
    roms_file = ['newperush_SmeanZ_', char(p), '.nc'];
    nc = ncload ([directory,roms_file],'Z',var);
    subplot(1,2,num_plot); % call plot device
    
    vertical_mat = zeros([zlev size(XY,1)]); % pre-allocate matrix for vertical values
    zlimit = zeros(nmonth , 2);
    
    for pixel = 1:size(XY,1); % loop for month
        vertical = zeros(zlev,1); %pre-allocate vector for vertical values        
        
        for depth = zlev:-1:1 % loop for zlevels
            dat = eval(var); % call variable data
            dat = squeeze(dat(kk,depth,:,:));
            if var == 'v'; dat = v2rho_2d(dat).*100;units = 'cm/s';end;
            if var == 'u'; dat = u2rho_2d(dat).*100;units = 'cm/s';end;
            if var == 'w'; dat = dat.*86400; units = 'm/d';end;
            
            cell_vall = zeros(size(XY,1),1); % pre-allocate cell for each grid-point
            for m = 1:size(XY,1); % loop to get values only in grid-points selected
                cell_vall(m) = dat(XY(m,1),XY(m,2));
            end
            vertical_mat(depth,:) = cell_vall(:,1); % save vertical vector in a matrix
            vertical(depth) = nanmean(cell_vall); % get mean of values in grid-points selected
%             vertical = fliplr(vertical);
        end
        vertical_mat(depth,:) = cell_vall(:,1); % save vertical vector in a matrix
        clear('cell.vall','vertical');
        
    end
    
%     if num_plot == 1;
%         zcol = [min(min(vertical_mat)) max(max(vertical_mat))];
%         zlim = round(zcol*100)/100;
%     end   
    
    
    
    %% Plot Vertical Matrix
    lati = (pixel):-1:1;
%     lati = (-1*pixel):1:-1;
%     lati = 1:1:(pixel);

    lati = repmat(lati,[zlev 1]); % X matrix to plot (contains months)
    depth = repmat(Z(1:zlev), [1,pixel]); % Y matrix to plot (contains depths)
    
    [C,h] = contourf(lati, depth, vertical_mat); % plot vertical matrix
    clabel(C,h)%,v_lines); % add labels to isolines
    caxis(zlim) % zlim for color in the plot
    ylabel('Depth (m)');
    xlabel('Pixels from the coast');
    pos = get(gca, 'position');
    cbr = colorbar('v'); % add color-bar
    title([var ' velocity ' units ' ' char(p) ' winds']); % add title to plot
    num_plot = num_plot+1;
    
        end
%% Save plot
img = getframe(gcf);
imwrite(img.cdata, [out_file '_' var '_month' num2str(kk) '.tif']);
close all
    end
    
end



% for ii = variables; % loop for all variables
%     var = char(ii);
%     num_plot = 1;
%     figure('units','normalized','outerposition',[0 0 1 1]); % open plot device
% for p = simu; % loop for type simulation
%     directory = ['D:/Ascat_', char(p), '/']; % ROMS file directory
%     roms_file = ['newperush_SmeanZ_', char(p), '.nc'];
%     nc = ncload ([directory,roms_file],'Z',var);
%     subplot(1,2,num_plot); % call plot device
%     
%     vertical_mat = zeros([zlev size(XY,1)]); % pre-allocate matrix for vertical values
%     for pixel = 1:size(XY,1); % loop for month
%         vertical = zeros(zlev,1); %pre-allocate vector for vertical values        
%         
%         for depth = zlev:-1:1 % loop for zlevels
%             dat = eval(var); % call variable data
%             dat = squeeze(dat(nmonth,depth,:,:));
%             if var == 'v'; dat = v2rho_2d(dat).*100;units = 'cm/s';end;
%             if var == 'u'; dat = u2rho_2d(dat).*100;units = 'cm/s';end;
%             if var == 'w'; dat = dat.*86400; units = 'm/d';end;
%             
%             cell_vall = zeros(size(XY,1),1); % pre-allocate cell for each grid-point
%             for m = 1:size(XY,1); % loop to get values only in grid-points selected
%                 cell_vall(m) = dat(XY(m,1),XY(m,2));
%             end
%             vertical_mat(depth,:) = cell_vall(:,1); % save vertical vector in a matrix
%             vertical(depth) = nanmean(cell_vall); % get mean of values in grid-points selected
%         end
%         vertical_mat(depth,:) = cell_vall(:,1); % save vertical vector in a matrix
%         clear('cell.vall','vertical');
%     end
%     
%     if num_plot == 1;
%         zcol = [min(min(vertical_mat)) max(max(vertical_mat))];
%         zlim = round(zcol*100)/100;
%     end
%                    
%     %% Plot Vertical Matrix
%     lati = (pixel):-1:1;
% %     lati = (-1*pixel):1:-1;
% %     lati = (pixel):-1:1;
% 
%     lati = repmat(lati,[zlev 1]); % X matrix to plot (contains months)
%     depth = repmat(Z(1:zlev), [1,pixel]); % Y matrix to plot (contains depths)
%     
%     [C,h] = contourf(lati, depth, vertical_mat); % plot vertical matrix
%     clabel(C,h)%,v_lines); % add labels to isolines
%     caxis(zlim) % zlim for color in the plot
%     ylabel('Depth (m)');
%     xlabel('Pixels from the coast');
%     pos = get(gca, 'position');
%     cbr = colorbar('v'); % add color-bar
%     title([var ' velocity ' units ' ' char(p) ' winds']); % add title to plot
%     num_plot = num_plot+1;
%     
% end
% %% Save plot
% img = getframe(gcf);
% imwrite(img.cdata, [out_file '_' var,'.tif']);
% close all
% end



%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%

