%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

%%
% Directory where will be created new directories to indices and figures
out_dir  = 'C:/Users/ASUS/Desktop/contour_plots/';
new_dir  = 'south_bay2';
out_name = [out_dir, new_dir,'/', new_dir];
winds    = {'daily','clim'}; % Type of simulation
% year_in  = 2009;
% year_on  = 2011;
month_in = 1;
month_on = 12;
var      = 'u';
zlim     = [-0.15 0.15];
zlevels  = 100;
XY = load ([out_name, '.txt']);
wind_labels = {'Daily','Monthly'}; % Type of simulation

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

% year_interval  = year_on - year_in + 1;
month_interval = month_on - month_in + 1;
num_plot = 0;
% index3D        = year_interval*month_interval;

for ii = winds; % loop for each type winds
figure
    % change next line if ROMS files are stored in other directory
    roms_directory = ['H:/Ascat_', char(ii), '/'];
    
    % Get ROMS-mean currents (v,u,w) from ROMS Mmean file
    ncload ([roms_directory 'newperush_Mmean.nc'], var, 'h'); % ROMS file name
    disp(['Reading... ' roms_directory 'newperush_Mmean.nc'])
    var_mean = eval(var);
    
     VAR_2d_mat = NaN(zlevels,12);
%     in3D = 0;
%     VAR = zeros([zlevels 15 index3D]);
    
%     for year = year_in:year_on;         % loop for each year
        for month = month_in:month_on;  % loop for each month
            
%             ncfile = [roms_directory, 'newperush_avg.Y' num2str(year) '.M' num2str(month) '.newperush.nc'];
%             ncload(ncfile, var, 'h');
%             disp(['Reading... ' ncfile])
            
            % Get var_mean in 3D for each mean-motnh
            var_mean_3d = squeeze (var_mean(month,:,:,:));
            if var == 'u'; var_mean_3d = u2rho_3d(var_mean_3d);units = ' (m/s) ';end;
            if var == 'v'; var_mean_3d = v2rho_3d(var_mean_3d);units = ' (m/s) ';end;
            if var == 'w';
                var_mean_3d = var_mean_3d.*86400;units = ' (m/day) ';
            end; 
%             var_mean_3d = var_mean_3d.*100; % conver m/s to cm/s
            
            % Get var_roms in 3D for each month-roms
%             dat = eval(var);
%             VAR_2d_mat = zeros([zlevels,15]);
%             
%             if(year == 2012 && month == 12);
%                VAR_2d_mat = NaN(zlevels,12);
%             else
            
%             for jj = 1:15; % loop for each step-time
                
                % Get variable in 3D for each motnh
%                 VAR_3d = squeeze(dat(jj,:,:,:));
%                 if var == 'u'; VAR_3d = u2rho_3d(VAR_3d);end;
%                 if var == 'v'; VAR_3d = v2rho_3d(VAR_3d);end; 
%                 varDiff = var_mean_3d - VAR_3d;
                
                XY_mat = zeros(zlevels,size(XY,1));
                
                for hh = 1:size(XY,1) % loop for each point
                    xy = XY(hh,:);
                    dep = h(xy(1,1), xy(1,2));
                    pz = zlevs(dep,0,6.5,0,10,42,'r',1); 
                    a = pz;                             % sample points
%                     b = varDiff(:,xy(1,1), xy(1,2));    % values
                    b = var_mean_3d(:,xy(1,1), xy(1,2));    % values
                    c = -zlevels:1:-1;                  % new sample points
                    d = interp1(a,b,c);
                    XY_mat(:,hh) = d;
                    
                end
                xv_mean = nanmean(XY_mat,2);
                VAR_2d_mat(:,month) = xv_mean;
%             end
        end            
%             in3D = in3D + 1;
%             VAR(:,:,in3D) = VAR_2d_mat;
%             disp(['iterator ' num2str(in3D) ' - variable ' var ' - winds ' char(ii)])

   %% PLOT MONTH_MEAN
    months = repmat(1:12,[zlevels 1]);  % X matrix to plot (contains months)
    depths = transp(-zlevels:1:-1);     % Y matrix to plot (contains depths)
    depths = repmat(depths,[1,12]);
    
    num_plot = num_plot +1;
%     subplot(2,1,num_plot)
%     [C,h] = contourf(months, depths, MONTH_MEAN);
    [C,h] = contourf(months, depths, VAR_2d_mat);
%     v = [0];
%     clabel(C,h,v)             % add labels to isolines
    clabel(C,h)             % add labels to isolines
    caxis(zlim)             % zlim for color in the plot
    ylabel('Depth (m)','FontSize', 14, 'FontWeight', 'bold');
    xlabel('MONTHS','FontSize', 14, 'FontWeight', 'bold');
    pos = get(gca, 'position');
    cbr = colorbar('v');    % add color-bar
    title_name = ['Velocity ' var units char(wind_labels( num_plot)) ' ' 'winds'];
    title(title_name,'FontSize', 14, 'FontWeight', 'bold');      % add title to plot 

end
%     end
%     file_name = [out_dir,new_dir, '/',char(var),'_', char(ii),'.mat'];
%     save(file_name,'VAR','-mat')
% end

% close all; clear all

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%