%% Proyeccion de Mercator
domaxis = [-84 -70.5 -19 0];

m_proj('mercator',...
    'lon',[domaxis(1) domaxis(2)],...
    'lat',[domaxis(3) domaxis(4)]);
set(0,'DefaultFigureRenderer','zbuffer')

% m_pcolor(lon_rho, lat_rho, mask_rho.*h);
% shading flat
m_usercoast('coastline_h','patch',[0.6 0.6 0.6],'edgecolor','k');
m_grid('box','fancy','fontsize',10);

message1 = sprintf('PERU');
% message2 = sprintf('Lobos\nde Tierra\nIsland');
m_text(-78,-8,message1,'FontSize', 14, 'FontWeight', 'bold', 'color','black');
% m_text(-81.3,-6.35,message2,'FontSize', 14, 'FontWeight', 'bold', 'color','black');

x1 = [-82 -82 -80 -80 -82];
y1 = [-7 -5 -5 -7 -7];
m_line(x1, y1, 'Color','black','LineStyle','--', 'LineWidth',2)
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%