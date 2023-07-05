clc, clearvars ;

current_path = fileparts(matlab.desktop.editor.getActiveFilename);
addpath(current_path)
tmp_folder = join([current_path, '\..\..\temp\']);
cd( tmp_folder)

clear ans suelo_0

x_tamano = 50;
dx = 1;
y_tamano = -30;
dy = -1;
ll_medio = 210;
cov = 0.25;
l_ac = 4;
vLL = [];


suelo_0 = sueloGeneral(x_tamano, dx, y_tamano, dy, ...
                       ll_medio, cov, l_ac, vLL);

tamano_suelo_folder = "x_" + string(x_tamano)+ "--" + "y_" + string(y_tamano) + "--" + "dx_" + string(dx) + "--" + "dy_" + string(dy);
sub_folder = "cov_" + string(cov)+ "--" + "lac_" + string(l_ac);

px = 0:suelo_0.dx:suelo_0.x_tamano;    %px= 0:dx:dimx;
py = 0:suelo_0.dy:suelo_0.y_tamano;  %py= 0:dy:dimy;
n=length(px)*length(py);    %n=length(px)*length(py);    % Número total de nodos

[PX,PY]=meshgrid(px,py);
x=pagetranspose(PX);
y=pagetranspose(PY);
pos = 1:1:n;                % Vector con el número total de nodos
pxy=[pos(:),x(:),y(:)]; 

C=[;];

C = dist(pxy(:,[2 3]),pxy(:,[2 3])');

C_mat=(suelo_0.desv^2).*exp(-C./suelo_0.l_ac);
S = chol(C_mat);
dist_puntos=pagetranspose(C);
dist_puntos=dist_puntos(:);

mu = 0;             % Media de la distribución normal
sigma = 1;          % Desviación Estándar
%rng('default')     % Usar este comando para comprobar resultados

epsilon = normrnd(mu,sigma,[n,1]);

% for i=1:n
%     ep= normrnd(mu,sigma);
%     epsilon(i,1)= ep;
% end

u_n = ones(n,1)*suelo_0.ll_medio;
LL = S*epsilon + u_n;

% pxyl=[pos(:),x(:),y(:),LL(:)];

% vLL=[;];            %Matriz que contiene el LL de cada nodo
suelo_0.vLL = reshape(LL,[abs(suelo_0.x_tamano)+1, abs(suelo_0.y_tamano)+1])';


figure
contourf(PX,PY,suelo_0.vLL)
colorbar;
xlabel('x(m)')
ylabel('z(m)')
title ("LL [%]");

% figure
% surf(PX,PY,vLL)
% colorbar

save('suelo_espacio','suelo_0')
i = 0;
file_exist = 1;
while file_exist == 1
    folder_name = "suelo_" + string(i);
    tmp_folder = join([current_path, '\..\..\resultados\', tamano_suelo_folder + "\", sub_folder + "\",folder_name]);
    file_exist = exist( tmp_folder, "dir");
    i = i + 1;
end
mkdir(tmp_folder);
tmp_file = join([tmp_folder , "\suelo_espacio.mat"]);
copyfile("suelo_espacio.mat", tmp_file);

% save('dx','dx')
% save('dy','dy')
% save('dimx','dimx')
% save('dimy','dimy')
% 
% %xg=100:10:500
% %yg=
% %scatter(epsilon,LL)
% 
% %%%
% function [d] = dist (act,final)
%     act();
%     final();
%     d = sqrt((act(1,1)-final(1,1))^2+(act(1,2)- final(1,2))^2);
% end