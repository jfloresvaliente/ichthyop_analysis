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

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

year_interval  = year_on - year_in + 1;
month_interval = month_on - month_in + 1;
index3D        = year_interval*month_interval;

for ii = winds; % loop for each type winds
    
    % change next line if ROMS files are stored in other directory
    roms_directory = ['H:/Ascat_', char(ii), '/'];
    
    % Get ROMS-mean currents (v,u,w) from ROMS Mmean file
    ncload ([roms_directory 'newperush_Mmean.nc'], var); % ROMS file name
    var_mean = eval(var);
    in3D = 0;
    VAR = zeros([zlevels 15 index3D]);
    
    for year = year_in:year_on;         % loop for each year
        for month = month_in:month_on;  % loop for each month
            
            ncfile = [roms_directory, 'newperush_avg.Y' num2str(year) '.M' num2str(month) '.newperush.nc'];
            ncload(ncfile, var, 'h');
            disp(['Reading... ' ncfile])
            
            % Get var_mean in 3D for each mean-motnh
            var_mean_3d = squeeze (var_mean(month,:,:,:));             
            if var == 'u'; var_mean_3d = u2rho_3d(var_mean_3d);end;
            if var == 'v'; var_mean_3d = v2rho_3d(var_mean_3d);end;                
%             var_mean_3d = var_mean_3d.*100; % conver m/s to cm/s
            
            % Get var_roms in 3D for each month-roms
            dat = eval(var);
            VAR_2d_mat = zeros([zlevels,15]);
            
            if(year == 2012 && month == 12);
               VAR_2d_mat = NaN(zlevels,15);
            else
            
            for jj = 1:15; % loop for each step-time
                
                % Get variable in 3D for each motnh
                VAR_3d = squeeze(dat(jj,:,:,:));
                if var == 'u'; VAR_3d = u2rho_3d(VAR_3d);end;
                if var == 'v'; VAR_3d = v2rho_3d(VAR_3d);end; 
                varDiff = var_mean_3d - VAR_3d;
                
                XY_mat = zeros(zlevels,size(XY,1));
                
                for hh = 1:size(XY,1) % loop for each point
                    xy = XY(hh,:);
                    dep = h(xy(1,1), xy(1,2));
                    pz = zlevs(dep,0,6.5,0,10,42,'r',1); 
                    a = pz;                             % sample points
                    b = varDiff(:,xy(1,1), xy(1,2));    % values
                    c = -zlevels:1:-1;                  % new sample points
                    d = interp1(a,b,c);
                    XY_mat(:,hh) = d;
                    
                end
                xv_mean = nanmean(XY_mat,2);
                VAR_2d_mat(:,jj) = xv_mean;
            end
            end            
            in3D = in3D + 1;
            VAR(:,:,in3D) = VAR_2d_mat;
            disp(['iterator ' num2str(in3D) ' - variable ' var ' - winds ' char(ii)])

        end
    end
    file_name = [out_dir,new_dir, '/',char(var),'_', char(ii),'.mat'];
    save(file_name,'VAR','-mat')
end

close all; clear all

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
