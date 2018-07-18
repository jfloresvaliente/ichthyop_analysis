clear all
close all

dir = 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/';
nc_file = [dir,'vieja_M1.nc'];
disp (['Reading ... ' nc_file]); % Display current file name
ncload(nc_file, 'u','v','h','mask_rho', 'lon_rho', 'lat_rho');

vtransform = 1; 
N = 32;
T = 5;
ZI=[-5 -1000];
ll=length(ZI);

zr = zlevs(h,0*h,6,0,10,N,'r',vtransform);

var = squeeze(u(1,:,:,:));
var = u2rho_3d(var);
varn(1,:,:) = var(N,:,:);

for iz=2:ll 
    varn(iz,:,:) = sigmatoz(var,zr,ZI(iz));
end;
%varn=rho2u_3d(varn); varn(varn==0)=NaN;

%% Proyeccion de m_map
domaxis=[-100 -70 -40 15];
%colaxis=[vmindom vmaxdom];
m_proj('mercator','lon',[domaxis(1) domaxis(2)],...
         'lat',[domaxis(3) domaxis(4)]);
%% Inico de figura
figure
a = squeeze(varn(3,:,:));
size(a)

m_pcolor(lon_rho,lat_rho, a)
shading flat
colorbar
caxis([-0.5 0.5])
%m_usercoast('linetest.mat','patch',[0.6 0.6 0.6],'edgecolor','k');
m_usercoast('coastline_h.mat','patch',[0.6 0.6 0.6],'edgecolor','k');
m_grid('box','fancy','xtick',5,'ytick',7,'tickdir','out','fontsize',10);
%axis(domaxis)


