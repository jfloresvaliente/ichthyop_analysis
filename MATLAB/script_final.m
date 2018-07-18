%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% SCRIPT TO GET DIFFERENCE FROM MEAN-ROMS FILE AND EACH-ROMS FILE
% aim1 = 
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all; clear all; clc  % clear workspace

variables = {'v','u', 'w'};
jj = {'daily'};
% XY = load (['C:/Users/ASUS/Desktop/contour_plots/inside_/', 'inside_bay_4.txt']);
% XY = XY(1,:);
XY = [681 336]; % index for one point

year_in = 2008;
year_on = 2012;
year_interval = year_on - year_in + 1;

month_in = 1;
month_on = 12;
month_interval = month_on - month_in + 1;

for vars = variables
    var = char(vars);
    directory = ['D:/Ascat_', char(jj), '/'];

ncload ([directory 'newperush_Mmean.nc'], char(var)); % ROMS file name
display([directory 'newperush_Mmean.nc']);
var_mean = eval(var); size(var_mean);

index3D = year_interval*month_interval;

M = zeros([42 15 index3D]);
k = 0;
for year = year_in:year_on;
    for month = month_in:month_on;
        
        ncfile = [directory, 'newperush_avg.Y' num2str(year) '.M' num2str(month) '.newperush.nc'];
        ncload(ncfile, char(var));

        month_mean = squeeze(var_mean(month,:,:,:));     
        
        if var == 'v'; month_mean = v2rho_3d(month_mean).*100; units = 'cm/s';end;          
        if var == 'u'; month_mean = u2rho_3d(month_mean).*100; units = 'cm/s';end;
        if var == 'w'; month_mean = month_mean.*86400; units = 'm/d';end;
        month_mean = month_mean(:, XY(1,1), XY(1,2)); % vertical month mean
        
        files_mean = eval(var); size(files_mean);
        
        if(year == 2012 && month == 12);
            diff_mean = NaN(42,15);
        else
            diff_mean = zeros([42 15]);
            for i = 1:15;
            dat = squeeze(files_mean(i,:,:,:)); size(dat);
                if var == 'v'; dat = v2rho_3d(dat).*100; units = 'cm/s';end;          
                if var == 'u'; dat = u2rho_3d(dat).*100; units = 'cm/s';end;
                if var == 'w'; dat = dat.*86400; units = 'm/d';end;
            
                files_vert = dat(:, XY(1,1), XY(1,2));
                diff = month_mean - files_vert;
                diff_mean(:,i) = diff(:,1);
            end
        end
        

        disp([ncfile, ' ... reading ' char(var) ' variable'])
        k = k + 1;
        M(:,:,k) = diff_mean(:,:);
    end    
end

save([directory 'variability/' 'variability_' var '.mat'],'M','-mat')

ncload([directory, 'newperush_avg.Y' num2str(year) '.M' num2str(month) '.newperush.nc'], 'h');
dep = h(XY(1,1), XY(1,2));
pz = zlevs(dep,0,6.5,0,10,42,'r',1);
save([directory 'variability/' 'variability_depths_' var '.txt'],'pz','-ascii');

    
end




