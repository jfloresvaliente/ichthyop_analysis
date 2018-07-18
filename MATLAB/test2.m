%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

winds = {'clim','daily'}; % Type of simulation
% XY = load (['C:/Users/ASUS/Desktop/contour_plots/inside_/', 'inside_bay_4.txt']);
% XY = XY(1,:);
XY = [681 336]; % index for one point

year_in = 2008;
year_on = 2012;
month_in = 1;
month_on = 12;

var = 'v';

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

year_interval = year_on - year_in + 1;
month_interval = month_on - month_in + 1;
index3D = year_interval*month_interval;

for ii = winds;
    % change next line if ROMS files are stored in other directory
    % directory = ['D:/Ascat_', char(ii), '/'];
    directory = ['/run/media/marissela/JORGE_NEW/Ascat_', char(ii), '/'];    
    
    % Get ROMS-mean currents (v,u,w) from ROMS Mmean file
    ncload ([directory 'newperush_Mmean.nc'], var); % ROMS file name
    var_mean = eval(var);
    
    in3D = 0;
    VAR = zeros([42 15 index3D]);
    for year = year_in:year_on; % loop for each year
        
        % Matrix to store difference (M_mean - data) for 'var' variable
        
              
        for month = month_in:month_on; % loop for each month
            ncfile = [directory, 'newperush_avg.Y' num2str(year) '.M' num2str(month) '.newperush.nc'];
            ncload(ncfile, var);
            
            % Get var_mean in 3D for each mean-motnh
            var_mean_3d = squeeze (var_mean(month,:,:,:));             
            if var == 'u'; var_mean_3d = u2rho_3d(var_mean_3d);end;
            if var == 'v'; var_mean_3d = v2rho_3d(var_mean_3d);end;                

            % Get var_roms in 3D for each month-roms
            dat = eval(var);

            VAR_2d_mat = zeros([42,15]);            
            if(year == 2012 && month == 12);
               VAR_2d_mat = NaN(42,15);
            else
                for jj = 1:15;
                % Get variable in 3D for each motnh
                VAR_3d = squeeze(dat(jj,:,:,:));
                if var == 'u'; VAR_3d = u2rho_3d(VAR_3d);end;
                if var == 'v'; VAR_3d = v2rho_3d(VAR_3d);end; 
                
                varDiff = var_mean_3d - VAR_3d;
                varDiff = varDiff(:, XY(1,1), XY(1,2));
                      
                VAR_2d_mat(:,jj) = varDiff(:,1);
                
                end
            end
            in3D = in3D + 1;
            VAR(:,:,in3D) = VAR_2d_mat;

            disp(ncfile)
            disp(in3D)
        end 
    end
    
    file_name = [directory 'variability/' char(var), '.mat'];
    save(file_name,'VAR','-mat')
end

directory = 'D:/Ascat_daily/';
ncload([directory, 'newperush_avg.Y' num2str(2008) '.M' num2str(1) '.newperush.nc'], 'h');
dep = h(XY(1,1), XY(1,2));
pz = zlevs(dep,0,6.5,0,10,42,'r',1);
save([directory 'variability/depths.txt'],'pz','-ascii');

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
