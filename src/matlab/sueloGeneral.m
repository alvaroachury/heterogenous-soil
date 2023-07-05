classdef sueloGeneral
    % Se definen y almacenan caracteristicas generales del suelo como
    % dimenciones y parametros relacionados con la variabilidad del mismo
    properties
        x_tamano
        y_tamano
        dx % Discretización en x (m)
        dy % Discretización en y (m)
        ll_medio                % Valor medio del LL
        cov                    % COV = 0.3 (JP)    COV = 0.25 (Muñoz & Caicedo)
        desv         % Desviación estándar (%)
        l_ac                     % Longitud de autocorrelación (m)
        vLL
        relv
        vLP
        Rho
        Vs
        nu
        cohesion
        gammaref
        Gmax_final        
        gsat
    end
    methods
        function self = sueloGeneral(x_tamano, dx, y_tamano, dy, ...
                                     ll_medio, cov, l_ac, vLL)
            % l_medio: Valor medio del LL 
            % cov: COV = 0.3 (JP)    COV = 0.25 (Muñoz & Caicedo)
            % desv: Desv = COV*v_medio;         % Desviación estándar (%)
            % l_ac: Longitud de autocorrelación (m) (Lt)

            self.x_tamano = x_tamano;
            self.dx = dx;
            self.y_tamano = y_tamano;
            self.dy = dy;
            self.ll_medio = ll_medio;
            self.cov = cov;
            self.desv = self.cov * self.ll_medio;
            self.l_ac = l_ac;
            self.vLL = vLL;
            self.relv = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.vLP = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.Rho = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.Vs = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.nu = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.cohesion = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.gammaref = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.Gmax_final = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
            self.gsat = zeros(( self.y_tamano / self.dy) + 1, ( self.x_tamano / self.dx) + 1);
        end

        function self = vaciosXNodo( self, i, s)
            m_0 = self.relv( i, :) == 0;
            m_1 = isnan(self.relv( i, :));
            self.relv(i,:) = self.relv(i,:) + s .* xor( m_0, m_1 );
        end

        function self = limitePlastico( self, i, s)
            m_0 = self.vLP(i,:) == 0;
            m_1 = isnan(self.vLP(i,:));
            self.vLP( i, :) = self.vLP( i, :) + s .* xor( m_0, m_1 );
        end

%         function 
%             
%         end
    end
end
