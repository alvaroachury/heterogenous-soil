% close all;
clc, clearvars ;

cortes = [4,6];                          % Corte que será analizado en Opensees [nodos]. i.e. corte = 4 es un corte a 3m.

%% DATOS
NF = -5;        %Posición del Nivel freático
gammaw = 10;    % kN/m3
gammasat= 21;   % kN/m3 de la arcilla
GS = 2.55;      % De la arcilla
OCR = 1;        % Asumimos suelo normalmente consolidado
k=1;            % Asumido Braja Das
gravedad = 9.81;    %m/s2 

%% INPUTS PAPER PUBLISHED

cc = [0.56, 1.35, 1.91, 2.08, 2.10, 3.27, 3.80, 5.65];
e50 = [2.05, 2.28, 2.76, 2.93, 2.87, 3.60, 3.97, 4.39];
LL = [87, 120, 148, 196, 204, 234, 300, 348];
clear suelo_0
LP = [44, 25, 22, 19, 20, 22, 29, 30];
load('suelo_Espacio','suelo_0')

s1= suelo(LL(1), cc(1), e50(1), LP(1), 0.00039); % gammaref cuando G/Gmax = 0.5.
s2= suelo(LL(2), cc(2), e50(2), LP(2), 0);
s3= suelo(LL(3), cc(3), e50(3), LP(3), 0);
s4= suelo(LL(4), cc(4), e50(4), LP(4), 0);
s5= suelo(LL(5), cc(5), e50(5), LP(5), 0);
s6= suelo(LL(6), cc(6), e50(6), LP(6), 0);
s7= suelo(LL(7), cc(7), e50(7), LP(7), 0);
s8= suelo(LL(8), cc(8), e50(8), LP(8), 0.019); 

% for corte_index = 1:length(cortes)
    corte_index = 1;
    corte = cortes(corte_index);
    % x = 4:50;
    % y = s1.e0 - s1.cc * log10 (x/4);
    % semilogx (x,y)
    % grid on
    
     

    %% PRESIÓN DE PORORS, e, ESFUEROS TOTALES Y ESFUERZOS EFECTIVOS
    
    pporos = ones((suelo_0.y_tamano/suelo_0.dy) + 1, (suelo_0.x_tamano/suelo_0.dx) + 1);
    for pporos_index = 1:( suelo_0.y_tamano / suelo_0.dy ) + 1
        pporos(pporos_index, :) = cellfun(@(x) gammaw * ( NF - ( 1 - pporos_index) ) .* x , num2cell(pporos(pporos_index, :)));
    end
    
    esfT = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);       % Matriz Esfuerzos Totales
    esfeff = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);     % Matriz Esfuerzos Effectivos
    relv = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);      % Matriz relación de vacíos de cada nodo
    gsat = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);     % Matriz gamma (asumido condición parcialmente saturado)
    
    vIP = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    Rho = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    nu = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    cohesion = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    %% Gmax 
    
    % Gmax_pp en MPa                       
    % Gmax_pp=(16.91.*relv.^-1.728);
    
    %%% Gmax_final

    vK0 = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);          % Matriz con los valores de K0 para cada nodo. Ecuación de Braja Das.
    vSigma0 = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    Gmax_final = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    Vs = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    gammaref = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    esfT = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    esfeff = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    relv = zeros(( suelo_0.y_tamano / suelo_0.dy) + 1, ( suelo_0.x_tamano / suelo_0.dx) + 1);
    temp = [];    
    temp_hab = [];    

%     for i = 1:( suelo_0.y_tamano / suelo_0.dy) + 1
        
        if i == 1
            esfT( i, :) = 0;
        else
            esfT( i, :) = esfT( i - 1, :) + gsat( i - 1, :) * abs( suelo_0.dy);
        end
        
        esfeff(i, :) = esfT(i, :) - pporos(i, :); 

        s1 = seteyValue(s1, esfeff(i,:));
        s2 = seteyValue(s2, esfeff(i,:));
        s3 = seteyValue(s3, esfeff(i,:));
        s4 = seteyValue(s4, esfeff(i,:));
        s5 = seteyValue(s5, esfeff(i,:));
        s6 = seteyValue(s6, esfeff(i,:));
        s7 = seteyValue(s7, esfeff(i,:));
        s8 = seteyValue(s8, esfeff(i,:));

        suelo_0 = vaciosXNodo( suelo_0, i, s1.seteyValue(esfeff( i, :)).ey, suelo_0.vLL(i,:) <= s1.LL);
        suelo_0 = limitePlastico( suelo_0, i, s1.LP, suelo_0.vLL(i,:) <= s1.LL);
        
        temp = interp1( [ s1.LL; s2.LL; s3.LL; s4.LL; s5.LL; s6.LL; s7.LL; s8.LL], ...
               [ s1.seteyValue( esfeff( i, 1)).ey; ...
               s2.seteyValue( esfeff( i, 1)).ey; ...
               s3.seteyValue( esfeff( i, 1)).ey; ...
               s4.seteyValue( esfeff( i, 1)).ey; ...
               s5.seteyValue( esfeff( i, 1)).ey; ...
               s6.seteyValue( esfeff( i, 1)).ey; ...
               s7.seteyValue( esfeff( i, 1)).ey; ...
               s8.seteyValue( esfeff( i, 1)).ey], ...
               suelo_0.vLL( i, :));

        temp = lineal( s1.seteyValue( esfeff( i, :)).ey, ...
               s2.seteyValue( esfeff( i, :)).ey, ... 
               repmat( s1.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ... 
               repmat( s2.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL(i,:) > s1.LL;
        comp_1 = suelo_0.vLL (i,:) <= s2.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);

        temp = interp1([ s1.LL; s2.LL], [ s1.LP; s2.LP], suelo_0.vLL( i, :));

        temp_0 = interp1([ s1.LL; s2.LL; s3.LL; s4.LL; s5.LL; s6.LL; s7.LL; s8.LL], [ s1.LP; s2.LP; s3.LP; s4.LP; s5.LP; s6.LP; s7.LP; s8.LP], suelo_0.vLL( i, :));

        temp = interp1([ repmat( s1.LL, [ 1, ( suelo_0.x_tamano/suelo_0.dx) + 1]) ;...
               repmat( s2.LL, [ 1, ( suelo_0.x_tamano/suelo_0.dx) + 1])], ...
               [ repmat( s1.LP, [ 1, ( suelo_0.x_tamano/suelo_0.dx) + 1]); ...
               repmat( s2.LP, [ 1, ( suelo_0.x_tamano/suelo_0.dx) + 1])], ...
               suelo_0.vLL( i, :));
        
        suelo_0 = limitePlastico( suelo_0, i, temp, comp_0 .* comp_1);

        temp = lineal( s2.seteyValue( esfeff( i, :)).ey, s3.seteyValue( esfeff( i, :)).ey, ...
                       repmat( s2.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
                       repmat( s3.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
                       suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL( i, :) > s2.LL;
        comp_1 = suelo_0.vLL( i, :) <= s3.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);
        
        temp = interp1( [ s2.LL; s3.LL], [ s2.LP; s3.LP], suelo_0.vLL( i, :));
        suelo_0 = limitePlastico( suelo_0, i, temp, comp_0 .* comp_1);
        

%         vLP( i, :) = vLP( i, :) + (interp1( [ repmat( s2.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]); ... 
%                      repmat( s3.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1])], ...
%                      [ repmat( s2.LP, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]);...
%                      repmat( s3.LP, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]) ], ...
%                      suelo_0.vLL( i, :)));
        

        temp = lineal( s3.seteyValue( esfeff( i, :)).ey, s4.seteyValue( esfeff( i, :)).ey, ...
               repmat( s3.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               repmat( s4.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL( i, :) > s3.LL;
        comp_1 = suelo_0.vLL( i, :) <= s4.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);
        
        temp = vLP( i, :) == 0;
        vLP( i, :) = vLP( i, :) + (interp1( [ s3.LL; s4.LL], [ s3.LP; s4.LP], suelo_0.vLL( i, :))) .* temp;

        temp = lineal( s4.seteyValue( esfeff(i, :)).ey, s5.seteyValue( esfeff( i, :)).ey, ... 
               repmat( s4.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               repmat( s5.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL( i, :) > s4.LL; 
        comp_1 = suelo_0.vLL( i, :) <= s5.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);

        temp = vLP( i, :) == 0;
        vLP( i, :) = vLP( i, :) + ( interp1( [ s4.LL; s5.LL], [ s4.LP; s5.LP], suelo_0.vLL(i,:))) .* temp;

        temp = lineal( s5.seteyValue( esfeff( i, :)).ey, s6.seteyValue( esfeff( i, :)).ey, ...
               repmat( s5.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               repmat( s6.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL( i, :) > s5.LL;
        comp_1 = suelo_0.vLL( i, :) <= s6.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);

        temp = vLP( i, :) == 0;
        vLP( i, :) = vLP( i, :) + ( interp1( [ s5.LL; s6.LL], [ s5.LP; s6.LP], suelo_0.vLL( i, :))) .* temp;
        clear comp_0
        temp = lineal( s6.seteyValue( esfeff( i, :)).ey, s7.seteyValue( esfeff( i, :)).ey, ...
               repmat( s6.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               repmat( s7.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL( i, :) > 290.0;
        comp_1 = suelo_0.vLL( i, :) <= s7.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);
        
        temp = vLP( i, :) == 0;
        vLP( i, :) = vLP( i, :) + ( interp1( [ s6.LL; s7.LL], [ s6.LP; s7.LP], suelo_0.vLL( i,:))) .* temp;

        temp = lineal( s7.seteyValue( esfeff( i, :)).ey, s8.seteyValue( esfeff( i, :)).ey, ...
               repmat( s7.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               repmat( s8.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]), ...
               suelo_0.vLL( i, :));
        comp_0 = suelo_0.vLL( i, :) > s7.LL; 
        comp_1 = suelo_0.vLL( i, :) <= s8.LL;
        suelo_0 = vaciosXNodo( suelo_0, i, temp, comp_0 .* comp_1);

        temp = vLP( i, :) == 0;
        vLP( i, :) = vLP( i, :) + ( interp1( [ s7.LL; ...
                     s8.LL], ...
                     [ s7.LP ; ...
                     s8.LP ], ...
                     suelo_0.vLL(i,:))) .* temp;
%         vLP( i, :) = vLP( i, :) + ( interp1( [ repmat( s7.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]); ...
%                      repmat( s8.LL, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1])], ...
%                      [ repmat( s7.LP , [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]); ...
%                      repmat( s8.LP, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1])], ...
%                      suelo_0.vLL(i,:))) * temp;

        temp = s8.seteyValue( esfeff( i, :)).ey;
        
        suelo_0 = vaciosXNodo( suelo_0, i, temp, suelo_0.vLL( i, :) > s8.LL);

        temp_comp = vLP(i,:) == 0;
        vLP(i,:) = vLP(i,:) + s8.LP * temp_comp;

        gsat(i, :) = ( gammaw * ( suelo_0.relv(i, :) + GS)) / (1 + suelo_0.relv(i,:));
        
        vIP(i, :) = suelo_0.vLL( i, :) - vLP( i, :);

        comp_0 = vIP( i, :) <= 40;
        comp_1 = vIP( i, :) > 0;
        temp =  comp_0 .* comp_1;
        vK0( i, :) = 0.4 + 0.007 * ( vIP( i, :));
        
        temp = vK0( 1, :) == 0;
        vK0( i, :) = vK0( i, :) + (0.68 + 0.001 * ( vIP( i, :) - 40)) .* temp; 

        vSigma0( i, :) = (1/3) * (esfeff( i, :) + 2 * vK0( i, :) .* esfeff( i, :));

        Gmax_final( i, :) = ( 16.91 * relv( i, :) .^ ( -1.728)) .* ( vSigma0( i, :) / 50) .^ ( 0.5);

        temp = suelo_0.vLL( i, :) <= 95.9;                                      % LL para s1 gammaref.    
        gammaref( i, :) = s1.gammaref * temp;
        
        comp_0 = suelo_0.vLL( i, :) > 95.9;              % LL para s8 gammaref.
        comp_1 = suelo_0.vLL( i, :) <= 370.8;
        temp = comp_0 .* comp_1;
        temp_comp = gammaref( i, :) == 0; 
        gammaref( i, :) = gammaref( i, :) + ( 6.77 * ( 10^-5) * suelo_0.vLL( i, :) - 0.0061) .* temp .* temp_comp;
        
        temp = suelo_0.vLL( i, :) > 370.8;
        temp_comp = gammaref( i, :) == 0; 
        gammaref( i, :) = s8.gammaref * ( temp_comp .* temp);

        Rho( i, :) = gsat( i, :) ./ gravedad;      % Densidad del suelo en Mg/m3

        Vs( i, :) = sqrt( ( Gmax_final( i, :) * 1E6) / ( Rho( i, :) * 1000));

        cohesion( i, :) = repmat( 95 , [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]);
        nu( i, :) = repmat( 0.45, [ 1, (suelo_0.x_tamano/suelo_0.dx) + 1]);
    end
    
    px = 0:suelo_0.dx:suelo_0.x_tamano;
    py = 0:suelo_0.dy:suelo_0.y_tamano;
    [PX, PY] = meshgrid(px, py);
    
    vIP = suelo_0.vLL - vLP;
    
    %% Gráficas
    
    figure
    contourf(PX,PY,pporos)
    colorbar;
    title ("Presion de Poros (u)");
    
    % figure
    % contourf (PX,PY, vLL)
    % colorbar;
    % title ("Límite Líquido");
    % 
    % figure
    % contourf (PX,PY, gsat)
    % colorbar;
    % title ("Gamma Saturado");
    % 
    % f0=figure('Units', 'centimeters', 'Position', [0 0 12 9]);
    % contourf (PX,PY, esfeff)
    % cb=colorbar;
    % xlabel('x(m)')
    % ylabel('z(m)')
    % title (cb,"Esf. efectivos [%]");
    % colorbar;
    % title ("Esfuerzos Efectivos");
    % set(gca,'FontName','Times New Roman');
    % print(f0,'Resultados/esfeff.png','-dpng','-r3000')
    % 
    % figure
    % contourf (PX,PY, esfT)
    % colorbar;
    % title ("Esfuerzos Totales");
    % 
    % figure
    % contourf (PX,PY, relv)
    % colorbar;
    % title ("Relación de Vacíos");
    
    %%% Fin gráficas
    
    
 
  

    
    %% gammaref 
            % gammaref es la deformación cortante de referencia a una presión de confinamiento efectiva. Valor del eje x en la gráfica de crtante vs def. P (gammaref,tmax)
    

    
    %% vs= sqrt(Gmax/rho)        Según la teoría de elasticidad.
    
    

    
    
    %% GRÁFICAS 2
    
    f1=figure('Units', 'centimeters', 'Position', [0 0 12 9]);
    contourf (PX,PY, suelo_0.vLL)
    cb=colorbar;
    xlabel('x(m)')
    ylabel('z(m)')
    title (cb,"LL [%]");
    % set(gca,'FontName','Times New Roman');
    % print(f1,'Resultados/LL.png','-dpng','-r3000')
    
    % 
    % figure
    % contourf (PX,PY, vLP)
    % colorbar;
    % xlabel('x(m)')
    % ylabel('z(m)')
    % title ("LP [%]");
    % 
    % figure
    % contourf (PX,PY, vIP)
    % colorbar;
    % xlabel('x(m)')
    % ylabel('z(m)')
    % title ("IP [%]");
    % 
    % % figure
    % % contourf (PX,PY, Gmax_pp)
    % % colorbar;
    % % xlabel('x(m)')
    % % ylabel('z(m)')
    % % title ("Gmax (paper) MPa");
    % 
    
    f2=figure('Units', 'centimeters', 'Position', [0 0 12 9]);
    contourf(PX, PY, Gmax_final)
    cb=colorbar;
    xlabel('x(m)')
    ylabel('z(m)')
    title (cb,"Gmax [MPa]");
    % set(gca,'FontName','Times New Roman');
    % print(f2,'Resultados/Gmax.png','-dpng','-r3000')
    
    f3=figure('Units', 'centimeters', 'Position', [0 0 12 9]);
    contourf (PX,PY, gammaref)
    cb=colorbar;
    xlabel('x(m)')
    ylabel('z(m)')
    title (cb,"gammaref [-]");
    % set(gca,'FontName','Times New Roman');
    % print(f3,'Resultados/gammaref.png','-dpng','-r3000')
    
    f4=figure('Units', 'centimeters', 'Position', [0 0 12 9]);
    contourf(PX,PY, Vs)
    cb=colorbar;
    xlabel('x(m)')
    ylabel('z(m)')
    title (cb,"Vs [m/s]");
    % set(gca,'FontName','Times New Roman');
    % print(f4,'Resultados/Vs.png','-dpng','-r3000')
    
    f5=figure('Units', 'centimeters', 'Position', [0 0 12 9]);
    contourf (PX,PY, relv)
    cb=colorbar;
    xlabel('x(m)')
    ylabel('z(m)')
    title (cb,"Relación de Vacíos [-]");
    % set(gca,'FontName','Times New Roman');
    % print(f5,'Resultados/Relv.png','-dpng','-r3000')
    
    f6=figure ('Units', 'centimeters', 'Position', [0 0 12 9]);
    contourf (PX,PY, gsat)
    cb=colorbar;
    xlabel('x(m)')
    ylabel('z(m)')
    title (cb,"\gamma sat [kPa]");
    % set(gca,'FontName','Times New Roman');
    % print(f6,'Resultados/gsat.png','-dpng','-r3000')
    
    %%% FIN Gráficas
    
    %% PREPARACIÓN DE VECTORES
    
    x=0:1:30; x=x';
    xint=0.5:1:30.5; xint=xint';        % int = intermedio
    xgrafica = flip(xint);
    
    % rho
    y = Rho( :, corte);
    Rhoint = interp1( x, y, xint);
    Rhoinv = flip(Rhoint);
    
    %         figure 
    %         plot (Rhoinv,xgrafica)
    %         set(gca,'YDir','reverse')
    
    % Vs0
    y=Vs(:,corte);
    Vsint=interp1(x,y,xint);
    Vsinv = flip(Vsint);
    
    %         figure 
    %         plot (Vsinv,xgrafica)
    %         set(gca,'YDir','reverse')
    
    % nu0
    y = nu(:,corte);
    nuint=interp1(x,y,xint);
    nuinv = flip(nuint);
    
    %         figure 
    %         plot (nuinv,xgrafica)
    %         set(gca,'YDir','reverse')
    
    %cohesion
    y = cohesion(:,corte);
    cohesionint = interp1( x, y, xint);
    cohesioninv = flip(cohesionint);
    
    %         figure 
    %         plot (cohesioninv,xgrafica)
    %         set(gca,'YDir','reverse')
    
    
    % gammaref
    y=gammaref(:,corte);
    gammarefint=interp1(x,y,xint);
    gammarefinv = flip(gammarefint);
    
    %         figure 
    %         plot (gammarefinv,xgrafica)
    %         set(gca,'YDir','reverse')
    
    %% CURVAS DE DEGRADACIÓN
    
    gamma =[1.00E-6; 3.16E-6; 1.00E-5; 3.16E-5; 1.00E-4; 3.16E-4; 1.00E-3; 3.16E-3; 1.00E-2; 3.16E-2; 1.00E-1];
    gamma = gamma';
    degradacionG = [];
    aux = [];
    
    nombre_archivo = sprintf('curvasdeg.txt');
    archivo = fopen(nombre_archivo, 'w');
    for k=1: length (gammarefinv)
        for i=1: length (gamma)
            vgammaref=gammarefinv(k);
            if i==1
                degradacionG (i)=1;
            else
                degradacionG (i)= 1/(1+(gamma (i)/vgammaref)^0.736);
            end
        aux(i)=degradacionG (i);
        end
        datos = [gamma, aux];
        line = sprintf('nDMaterial PressureIndependMultiYield %d 2 $rho(%d) $G(%d) $bulk(%d) $cohesion(%d) $gammaPeak $phi $refPress $pressCoeff  -11\\', k,k,k,k,k);
        fprintf(archivo, '%s\n', line);
        fprintf(archivo, '\t\t');
        for j = 1:length (gamma)
            fprintf(archivo, '%d %d ', gamma(j), aux(j));
        end
        fprintf(archivo, '\n\n');
    end
    fclose(archivo);
    degradacionG = degradacionG';
    
    
    %% Generación de archivos para Open Sees
    
    os_rho0 = fopen('rho0.txt', 'w');
    for i = 1:length(Rhoinv)
        str = ['set rho(' num2str(i) ') ' num2str(Rhoinv(i))];
        fprintf(os_rho0, '%s\n', str);
    end
    fclose(os_rho0);
    
    
    os_Vs0 = fopen('Vs0.txt', 'w');
    for i = 1:length(Vsinv)
        str = ['set Vs(' num2str(i) ') ' num2str(Vsinv(i))];
        fprintf(os_Vs0, '%s\n', str);
    end
    fclose(os_Vs0);
    
    
    os_nu0 = fopen('nu0.txt', 'w');
    for i = 1:length(nuinv)
        str = ['set nu(' num2str(i) ') ' num2str(nuinv(i))];
        fprintf(os_nu0, '%s\n', str);
    end
    fclose(os_nu0);
    
    
    os_cohesion = fopen('cohesion.txt', 'w');
    for i = 1:length(cohesioninv)
        str = ['set cohesion(' num2str(i) ') ' num2str(cohesioninv(i))];
        fprintf(os_cohesion, '%s\n', str);
    end
    fclose(os_cohesion);
    
    %% CAMPO HOMOGÉNEO
    
    layers = abs(suelo_0.y_tamano / suelo_0.dy);
    Pi = 1/layers;
    
    % Corte que será analizado en Opensees [nodos]. i.e. corte = 4 es un corte a 3m. # definido en la preparación de vectores
    
    % Gmax_final
    y=Gmax_final(:,corte);
    Gmax_finalint=interp1(x,y,xint);
    Gmax_finalinv = flip(Gmax_finalint);
    
    %% LÍMITE INFERIOR
    
    %%% G*
    G_aux =0;
    for k=1: layers
        G_aux= G_aux + Pi/Gmax_finalinv(k);
    end
    Gmax_ai = 1/G_aux;  
    
    vGmax_ai = [];
    for i=1:layers
        vGmax_ai (i)= Gmax_ai; 
    end
    vGmax_ai = vGmax_ai';
    
    %%% gammaref*
    gammaref_aux =0;
    for k=1: layers
        gammaref_aux= gammaref_aux + Pi/gammarefinv(k);
    end
    gammaref_ai = 1/gammaref_aux;
    
    vgammaref_ai = [];
    for i=1:layers
            vgammaref_ai (i)= gammaref_ai; 
    end
    vgammaref_ai = vgammaref_ai';
    
    %%% Rho*
    Rho_aux =0;
    for k=1: layers
        Rho_aux= Rho_aux + Pi/Rhoinv(k);
    end
    Rho_ai = 1/Rho_aux;
    
    vRho_ai = [];
    for i=1:layers
            vRho_ai (i)= Rho_ai; 
    end
    vRho_ai = vRho_ai';
    
    %%% Vs*
    Vs_ai = sqrt((Gmax_ai*1E6)/(Rho_ai*1000));
    
    vVs_ai = [];
    for i=1:layers
            vVs_ai (i)= Vs_ai; 
    end
    vVs_ai = vVs_ai';
    
    
    %% LÍMITE INFERIOR - CURVAS DE DEGRADACION
    
    gamma =[1.00E-6; 3.16E-6; 1.00E-5; 3.16E-5; 1.00E-4; 3.16E-4; 1.00E-3; 3.16E-3; 1.00E-2; 3.16E-2; 1.00E-1];
    gamma = gamma';
    degradacionG_ai = [];
    aux = [];
    
    mkdir('LimiteInf')
    nombre_archivo = sprintf('LimiteInf/curvasdeg_ai.txt');
    archivo = fopen(nombre_archivo, 'w');
    for k=1: length (vgammaref_ai)
        for i=1: length (gamma)
            vgammaref=vgammaref_ai(k);
            if i==1
                degradacionG_ai (i)=1;
            else
                degradacionG_ai (i)= 1/(1+(gamma (i)/vgammaref)^0.736);
            end
        aux(i)=degradacionG_ai (i);
        end
        datos = [gamma, aux];
        line = sprintf('nDMaterial PressureIndependMultiYield %d 2 $rho(%d) $G(%d) $bulk(%d) $cohesion(%d) $gammaPeak $phi $refPress $pressCoeff  -11\\', k,k,k,k,k);
        fprintf(archivo, '%s\n', line);
        fprintf(archivo, '\t\t');
        for j = 1:length (gamma)
            fprintf(archivo, '%d %d ', gamma(j), aux(j));
        end
        fprintf(archivo, '\n\n');
    end
    fclose(archivo);
    degradacionG_ai = degradacionG_ai';
    
    %% LÍMITE INFERIOR - VECTORES OS
    
    os_rho0_ai = fopen('LimiteInf/rho0_ai.txt', 'w');
    for i = 1:length(vRho_ai)
        str = ['set rho(' num2str(i) ') ' num2str(vRho_ai(i))];
        fprintf(os_rho0_ai, '%s\n', str);
    end
    fclose(os_rho0_ai);
    
    
    os_Vs0_ai = fopen('LimiteInf/Vs0_ai.txt', 'w');
    for i = 1:length(vVs_ai)
        str = ['set Vs(' num2str(i) ') ' num2str(vVs_ai(i))];
        fprintf(os_Vs0_ai, '%s\n', str);
    end
    fclose(os_Vs0_ai);
    
    
    os_nu0 = fopen('LimiteInf/nu0.txt', 'w');
    for i = 1:length(nuinv)
        str = ['set nu(' num2str(i) ') ' num2str(nuinv(i))];
        fprintf(os_nu0, '%s\n', str);
    end
    fclose(os_nu0);
    
    
    os_cohesion = fopen('LimiteInf/cohesion.txt', 'w');
    for i = 1:length(cohesioninv)
        str = ['set cohesion(' num2str(i) ') ' num2str(cohesioninv(i))];
        fprintf(os_cohesion, '%s\n', str);
    end
    fclose(os_cohesion);
    
    
    
    %% LÍMITE SUPERIOR
    
    %%% G*
    Gmax_as =0;
    for k=1: layers
        Gmax_as= Gmax_as + Pi*Gmax_finalinv(k);
    end
    vGmax_as = [];
    for i=1:layers
        vGmax_as (i)= Gmax_as; 
    end
    vGmax_as = vGmax_as';
    
    %%% gammaref*
    gammaref_as =0;
    for k=1: layers
        gammaref_as= gammaref_as + Pi*gammarefinv(k);
    end
    vgammaref_as = [];
    for i=1:layers
            vgammaref_as (i)= gammaref_as; 
    end
    vgammaref_as = vgammaref_as';
    
    %%% Rho*
    Rho_as =0;
    for k=1: layers
        Rho_as= Rho_as + Pi*Rhoinv(k);
    end
    vRho_as = [];
    for i=1:layers
            vRho_as (i)= Rho_as; 
    end
    vRho_as = vRho_as';
    
    %%% Vs*
    Vs_as = sqrt((Gmax_as*1E6)/(Rho_as*1000));
    vVs_as = [];
    for i=1:layers
            vVs_as (i)= Vs_as; 
    end
    vVs_as = vVs_as';
    
    
    %% LÍMITE SUPERIOR - CURVAS DE DEGRADACION
    
    gamma =[1.00E-6; 3.16E-6; 1.00E-5; 3.16E-5; 1.00E-4; 3.16E-4; 1.00E-3; 3.16E-3; 1.00E-2; 3.16E-2; 1.00E-1];
    gamma = gamma';
    degradacionG_as = [];
    aux = [];
    
    mkdir('LimiteSup')
    nombre_archivo = sprintf('LimiteSup/curvasdeg_as.txt');
    archivo = fopen(nombre_archivo, 'w');
    for k=1: length (vgammaref_as)
        for i=1: length (gamma)
            vgammaref=vgammaref_as(k);
            if i==1
                degradacionG_as (i)=1;
            else
                degradacionG_as (i)= 1/(1+(gamma (i)/vgammaref)^0.736);
            end
        aux(i)=degradacionG_as (i);
        end
        datos = [gamma, aux];
        line = sprintf('nDMaterial PressureIndependMultiYield %d 2 $rho(%d) $G(%d) $bulk(%d) $cohesion(%d) $gammaPeak $phi $refPress $pressCoeff  -11\\', k,k,k,k,k);
        fprintf(archivo, '%s\n', line);
        fprintf(archivo, '\t\t');
        for j = 1:length (gamma)
            fprintf(archivo, '%d %d ', gamma(j), aux(j));
        end
        fprintf(archivo, '\n\n');
    end
    fclose(archivo);
    degradacionG_as = degradacionG_as';
    
    
    %% LÍMITE SUPERIOR - VECTORES OS
    
    os_rho0_as = fopen('LimiteSup/rho0_as.txt', 'w');
    for i = 1:length(vRho_as)
        str = ['set rho(' num2str(i) ') ' num2str(vRho_as(i))];
        fprintf(os_rho0_as, '%s\n', str);
    end
    fclose(os_rho0_as);
    
    
    os_Vs0_as = fopen('LimiteSup/Vs0_as.txt', 'w');
    for i = 1:length(vVs_as)
        str = ['set Vs(' num2str(i) ') ' num2str(vVs_as(i))];
        fprintf(os_Vs0_as, '%s\n', str);
    end
    fclose(os_Vs0_as);
    
    
    os_nu0 = fopen('LimiteSup/nu0.txt', 'w');
    for i = 1:length(nuinv)
        str = ['set nu(' num2str(i) ') ' num2str(nuinv(i))];
        fprintf(os_nu0, '%s\n', str);
    end
    fclose(os_nu0);
    
    
    os_cohesion = fopen('LimiteSup/cohesion.txt', 'w');
    for i = 1:length(cohesioninv)
        str = ['set cohesion(' num2str(i) ') ' num2str(cohesioninv(i))];
        fprintf(os_cohesion, '%s\n', str);
    end
    fclose(os_cohesion);
    
    
    %% Límite Corrected
    
    %%% G*
    
    Gmax_lc =0;
    for k=1: layers
        Gmax_lc= Gmax_lc + Pi*Gmax_finalinv(k);
    end
    vGmax_lc = [];
    for i=1:layers
        vGmax_lc (i)= Gmax_lc; 
    end
    vGmax_lc = vGmax_lc';
    
    %%% gammaref*
    
    gammaref_aux =0;
    for k=1: layers
        gammaref_aux= gammaref_aux + Pi/gammarefinv(k);
    end
    gammaref_lc = 1/gammaref_aux;
    
    vgammaref_lc = [];
    for i=1:layers
            vgammaref_lc (i)= gammaref_lc; 
    end
    vgammaref_lc = vgammaref_lc';
    
    %%% Rho*
    
    Rho_lc =0;
    for k=1: layers
        Rho_lc= Rho_lc + Pi*Rhoinv(k);
    end
    vRho_lc = [];
    for i=1:layers
            vRho_lc (i)= Rho_lc; 
    end
    vRho_lc = vRho_lc';
    
    %%% Vs*
    
    Vs_lc = sqrt((Gmax_lc*1E6)/(Rho_lc*1000));
    vVs_lc = [];
    for i=1:layers
            vVs_lc (i)= Vs_lc; 
    end
    vVs_lc = vVs_lc';
    
    
    %% LÍMITE CORRECTED - CURVAS DE DEGRADACION
    
    gamma =[1.00E-6; 3.16E-6; 1.00E-5; 3.16E-5; 1.00E-4; 3.16E-4; 1.00E-3; 3.16E-3; 1.00E-2; 3.16E-2; 1.00E-1];
    gamma = gamma';
    degradacionG_lc = [];
    aux = [];
    
    mkdir('LimiteCorr')
    nombre_archivo = sprintf('LimiteCorr/curvasdeg_lc.txt');
    archivo = fopen(nombre_archivo, 'w');
    for k=1: length (vgammaref_lc)
        for i=1: length (gamma)
            vgammaref=vgammaref_lc(k);
            if i==1
                degradacionG_lc (i)=1;
            else
                degradacionG_lc (i)= 1/(1+(gamma (i)/vgammaref)^0.736);
            end
        aux(i)=degradacionG_lc (i);
        end
        datos = [gamma, aux];
        line = sprintf('nDMaterial PressureIndependMultiYield %d 2 $rho(%d) $G(%d) $bulk(%d) $cohesion(%d) $gammaPeak $phi $refPress $pressCoeff  -11\\', k,k,k,k,k);
        fprintf(archivo, '%s\n', line);
        fprintf(archivo, '\t\t');
        for j = 1:length (gamma)
            fprintf(archivo, '%d %d ', gamma(j), aux(j));
        end
        fprintf(archivo, '\n\n');
    end
    fclose(archivo);
    degradacionG_lc = degradacionG_lc';
    
    
    %% LÍMITE CORRECTED - VECTORES OS
    
    os_rho0_lc = fopen('LimiteCorr/rho0_lc.txt', 'w');
    for i = 1:length(vRho_lc)
        str = ['set rho(' num2str(i) ') ' num2str(vRho_lc(i))];
        fprintf(os_rho0_lc, '%s\n', str);
    end
    fclose(os_rho0_lc);
    
    
    os_Vs0_lc = fopen('LimiteCorr/Vs0_lc.txt', 'w');
    for i = 1:length(vVs_lc)
        str = ['set Vs(' num2str(i) ') ' num2str(vVs_lc(i))];
        fprintf(os_Vs0_lc, '%s\n', str);
    end
    fclose(os_Vs0_lc);
    
    
    os_nu0 = fopen('LimiteCorr/nu0.txt', 'w');
    for i = 1:length(nuinv)
        str = ['set nu(' num2str(i) ') ' num2str(nuinv(i))];
        fprintf(os_nu0, '%s\n', str);
    end
    fclose(os_nu0);
    
    
    os_cohesion = fopen('LimiteCorr/cohesion.txt', 'w');
    for i = 1:length(cohesioninv)
        str = ['set cohesion(' num2str(i) ') ' num2str(cohesioninv(i))];
        fprintf(os_cohesion, '%s\n', str);
    end
    fclose(os_cohesion);
    
    
    %% PLOTS
    xgrafica = flip(xgrafica);
    xgrafica = -xgrafica;
    
    %         figure 
    %         plot (Gmax_finalint,xgrafica,'r-','DisplayName', 'Heterogeneo')
    %         hold on
    %         plot (vGmax_ai,xgrafica,'b-','DisplayName', 'Limite Inferior')
    %         plot (vGmax_as,xgrafica,'black-','DisplayName', 'Limite Superior')
    %         plot (vGmax_lc,xgrafica,'m-','DisplayName', 'Limite Corregido')
    %         hold off
    %         xlabel 'Gmax [MPa]'
    %         ylabel 'Z (m)'
    %         title('Gmax vs Z')
    % 
    %         figure 
    %         plot (gammarefint,xgrafica,'r-','DisplayName', 'Heterogeneo')
    %         hold on
    %         plot (vgammaref_ai,xgrafica,'b-','DisplayName', 'Limite Inferior')
    %         plot (vgammaref_as,xgrafica,'black-','DisplayName', 'Limite Superior')
    %         plot (vgammaref_lc,xgrafica,'m-','DisplayName', 'Limite Corregido')
    %         hold off
    %         xlabel 'gammaref [-]'
    %         ylabel 'Z (m)'
    %         title('gammaref vs Z')
% end
