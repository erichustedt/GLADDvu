classdef DEERcalc < matlab.mixin.Copyable
    %   04/03/2018 - EJH - DEERcalc class
    %   DEERcalc - read
    %   calculateFresnels - calculate Fresnel integrals, depends on Time
    %   calculateBackground - calculate background signal
    %   calculateDistribution - calculate P(R) and intraobject signal
    %   calculateFit - calculate DEER signal
    %   calculateChisquared - calculate chisquared for single data set
    
    properties(Access = public)
        % DEERcalc 
        R
        Param 
    end
    
    properties(Access = public,NonCopyable)
        % DEERcalc
        Time 
        % calculateFresnels
        Kernel
        % calculateBackground
        Back
        % calculateDistribution
        NormAmp
        P
        Component
        Short
        Mean
        Width
        % calculateFit
        YFit
        % calculateChisquared
        Residuals
        C2
        SSR
        % confidence bands
        delta_PR
        upper
        lower
    end
    
    methods
        function obj = DEERcalc(app,index)
            obj.Param = PARAM(app.Ans(index));
            % time
            obj.Time = app.Data(index).deer_t0 + obj.Param.time_shift;
            % distances
            obj.R = app.Con.delta_R:app.Con.delta_R:app.Con.R_max;
            try
                if isequal(app.Fit(index).Time,obj.Time) && ...
                                           isequal(app.Fit(index).R,obj.R)
                    obj.Kernel = app.Fit(index).Kernel;
                    obj.calculateBackground(app,index);
                else
                    obj.calculateFresnels(app,index);
                end
            catch
                obj.calculateFresnels(app,index);
            end
        end
        
        function obj = calculateFresnels(obj,app,index)
            % frequencies
            W = 326.977e+09./(obj.R.^3);
            W = transpose(W);
            % determine matrix of Fresnel integrals
            % this matrix is independent of the probability distribution
            a = 3*bsxfun(@times,W,abs(obj.Time));
            q = sqrt(2*a/pi);
            [CS,SS] = FCS_CS2(q);
            CS = CS./q;
            SS = SS./q;
            ineq0 = find(q == 0.0);
            CS(ineq0) = 0;
            SS(ineq0) = 0;
            obj.Kernel = CS.*cos(W*abs(obj.Time))+ SS.*sin(W*abs(obj.Time));
            obj.calculateBackground(app,index);
        end
        
        function obj = calculateBackground(obj,app,index)
            if app.bucket.Background == 2
                % --------------------------------------------------------- 
                % Changed to use analytical approach derived by 
                % Kattnig et al., J. Phys. Chem. B, 117, 16542 (2013).
                % --------------------------------------------------------- 
                % Begin calculation of background signal
                % Check to see if concentration is zero, if it is background is 1
                obj.Back = ones(1,size(obj.Time,2));
                if(obj.Param.concentration == 0); return; end
                % Define Constants
                av = 6.02214129e+23;
                mu_0 = 1.2566370614359173e-06;
                ge = -2.00231930436153;
                bm = 9.27400968e-24;
                hb = 1.0545717253362894e-34;
                % Calculate constants
                c_temp = obj.Param.concentration*av*1.e-03;
                b_temp = 8*pi*pi/(9*sqrt(3));
                a_temp = mu_0*ge*ge;
                a_temp = a_temp*bm*bm/(4*pi*hb);
                % Calculate d_R vector
                d_R = a_temp*1.e+30*abs(obj.Time)/((2.*obj.Param.rho)^3);
                % From Kattnig et al. Table S1
                d_R_0 = [0., 0.15625, 0.3125, 0.625, 0.9375, 1.25, 1.5625, 1.875, ...
                    2.1875, 2.5, 3.125, 3.75, 4.375, 5,6.25, 6.875, 7.5, 8.125, 8.75, ...
                    10.,11.25, 12.5, 13.75, 15, 17.5, 18.75, 20., 21.25, 22.5, 25, 27.5, ...
                    30., 32.5, 35, 40., 45, 50., 75.857758, 123.974776, 202.612701, ...
                    331.131121, 541.169527, 884.436519, 1445.439771, 2362.290663, ...
                    3860.705432, 6309.573445, 10311.772746, 16852.590448, 27542.287033, ...
                    45012.520621, 73564.225446, 120226.443462, 196486.778999, ...
                    321119.490936, 524807.46025, 857695.898591, 1401737.418347, ...
                    2290867.652768, 3743978.389824, 6118805.757518, 10000000];
                alpha_0 = [0,0.0516270700000000,0.102895760000000,0.202975730000000, ...
                    0.297688570000000,0.384972230000000,0.463406930000000, ...
                    0.532277640000000,0.591543660000000,0.641728810000000, ...
                    0.718774000000000,0.772415410000000,0.810565400000000, ...
                    0.838147620000000,0.871525750000000,0.881361710000000, ...
                    0.889298990000000,0.896623370000000,0.903750140000000, ...
                    0.916791220000000,0.927152810000000,0.934514710000000, ...
                    0.939708170000000,0.944395120000000,0.952978860000000, ...
                    0.956136260000000,0.958589080000000,0.960882380000000, ...
                    0.963182670000000,0.967038580000000,0.969821790000000, ...
                    0.972495620000000,0.974537590000000,0.976349320000000, ...
                    0.979283620000000,0.981616590000000,0.983481890000000, ...
                    0.989101164553674,0.993330797023318,0.995917850480765, ...
                    0.997502614703514,0.998584004174124,0.999103256105760, ...
                    0.999423783493774,0.999673883818870,0.999787517817007, ...
                    0.999871762307149,0.999921970557832,0.999942185389556, ...
                    0.999969714130379,0.999981099927959,0.999988412121255, ...
                    0.999993263739334,0.999995959883410,0.999997663298731, ...
                    0.999998536204496,0.999999090928803,0.999999363295624, ...
                    0.999999654950117,0.999999800945140,0.999999867912926,0.999999908772070];
                if obj.Param.rho == 0
                    alphatimest = obj.Time;
                else
                    alpha = spline(d_R_0,alpha_0,d_R);
                    alphatimest = obj.Time.*alpha;
                end
                k_temp = b_temp*obj.Param.depth*c_temp*a_temp*alphatimest;
                obj.Back = exp(-abs(k_temp));
            elseif app.bucket.Background == 0
                obj.Back = ones(size(obj.Time));
            else 
                if app.bucket.Background == 7
                    alpha = obj.Param.concentration*1000*obj.Param.depth;
                else
                    
                    alpha = 10^obj.Param.lambda;
                end
                temp = (abs(obj.Time)*alpha).^(obj.Param.dimension/3);
                obj.Back = exp(-temp);
            end
            obj.calculateDistribution(app,index);
        end
        
        function obj = calculateDistribution(obj,app,index)
            % determine probability distribution and calculate intraobject signal
            %%
            obj.P = zeros(1,size(obj.R,2));
            %%
            if(obj.Param.ng > 0)
                if(obj.Param.ng>1)
                    ampr = obj.Param.amp;
                    ampb = zeros(size(ampr));
                    ampc = zeros(size(ampr));
                    ampb(1)= ampr(1);
                    for n= 1:obj.Param.ng - 1
                        ampb(n+1) = ampb(n)*ampr(n+1);
                        ampc(n) = 1. - ampr(n+1);
                    end
                    ampc(obj.Param.ng) = 1.;
                    ampr = ampb.*ampc;
                else
                    ampr= obj.Param.amp;
                end
                obj.NormAmp = ampr;
                if(obj.Param.shape == 1)
                    %% Gaussian
                    s = ( bsxfun(@minus,obj.R,obj.Param.r0') ).^2;
                    s = bsxfun(@rdivide,s,2*(obj.Param.width.^2)');
                    s = exp(-s);
                    ampr = ampr/(sqrt(2*pi))./obj.Param.width;
                    obj.P = ampr*s;
                    obj.Component = bsxfun(@times,ampr',s);
                end
                %
                if(obj.Param.shape == 5)
                    %% Rice
                    % below is based on work of M. Richards at G. Tech. "A Numerical
                    % Issue in Computing the Rician and Non-Central Chi-Square
                    % Probability Density Functions"
                    for kz = 1:obj.Param.ng
                        v = obj.Param.r0(kz);
                        s = obj.Param.width(kz);
                        ka = find(2*obj.R*v/s^2 < 500.);
                        kb = find(2*obj.R*v/s^2 >= 500.);
                        temp(ka) = (obj.R(ka) ./ s.^2) .* ...
                            exp(-0.5 * (obj.R(ka).^2 + v.^2) ./ s.^2) .* ...
                            besseli(0, obj.R(ka).* v ./ s.^2);
                        temp(kb) = sqrt(obj.R(kb)/(2*pi*v*s^2)).* ...
                            exp(-(obj.R(kb) - v).^2/2/s^2);
                        temp(temp<0) = 0.;
                        obj.P = obj.P + ampr(kz)*temp;
                    end
                end
                if(obj.Param.shape == 6)
                    %% Laplace
                    % This is a Generalized Normal Distribution
                    % https://en.wikipedia.org/wiki/Generalized_normal_distribution
                    % with betaf = 1
                    % Nadarajah, J. Appl. Stat. 32, 685-694 (2005)
                    alpha = sqrt(0.5)*obj.Param.width;
                    s = ( bsxfun(@minus,obj.R,obj.Param.r0') );
                    s = bsxfun(@rdivide,s,(alpha)');
                    s = exp(-abs(s));
                    ampr = ampr./(2*alpha);
                    obj.P = ampr*s;
                    obj.Component = bsxfun(@times,ampr',s);
                end
                if(obj.Param.shape == 7)
                    %% Uniform-ish
                    % This is a Generalized Normal Distribution
                    % https://en.wikipedia.org/wiki/Generalized_normal_distribution
                    % with betaf = 10
                    % Nadarajah, J. Appl. Stat. 32, 685-694 (2005)
                    betaf = 10.;
                    alpha = sqrt(gamma(1./betaf)/gamma(3./betaf))*obj.Param.width;
                    s = ( bsxfun(@minus,obj.R,obj.Param.r0') );
                    s = bsxfun(@rdivide,s,(alpha)');
                    s = exp(-abs(s).^betaf);
                    ampr = betaf*ampr./(2.*alpha*gamma(1./betaf));
                    obj.P = ampr*s;
                    obj.Component = bsxfun(@times,ampr',s);
                end
                if(obj.Param.shape == 8)
                    %% Variable
                    % This is a Generalized Normal Distribution
                    % https://en.wikipedia.org/wiki/Generalized_normal_distribution
                    % with variable betaf
                    % Nadarajah, J. Appl. Stat. 32, 685-694 (2005)
                    betaf = obj.Param.beta;
                    alpha = sqrt(gamma(1./betaf)./gamma(3./betaf)).*obj.Param.width;
                    s = ( bsxfun(@minus,obj.R,obj.Param.r0') );
                    s = bsxfun(@rdivide,s,(alpha)');
                    s = bsxfun(@power,abs(s'),betaf);
                    s = exp(-s)';
                    ampr = betaf.*ampr./(2.*alpha.*gamma(1./betaf));
                    obj.P = ampr*s;
                    obj.Component = bsxfun(@times,ampr',s);
                end
                if(obj.Param.shape == 9)
                    %% Skewed
                    % This is a Skewed Normal Distribution
                    zetaf = obj.Param.zeta;
                    temp1 = bsxfun(@rdivide,bsxfun(@minus,obj.R', ...
                        obj.Param.r0),obj.Param.width);
                    temp1 = 2.*normpdf(temp1);
                    temp2 = bsxfun(@rdivide, ...
                        normcdf(bsxfun(@rdivide, ...
                        bsxfun(@times, ...
                        zetaf,bsxfun(@minus,obj.R',obj.Param.r0)), ...
                        obj.Param.width)),obj.Param.width);
                    s = (temp1.*temp2)';
                    obj.P = ampr*s;
                    obj.Component = bsxfun(@times,ampr',s);
                end
                if(obj.Param.shape == 10)
                    %% Generalized Skew Normal Distribution
                    % This is a Generalized Skewed Normal Distribution
                    % Nadarajah and Kotz, Stat. & Prob. Lett. 65, 269-277 (2003)
                    %         BELOW IS A VERSION THAT USES THE CDF OF THE GND TO CALCULATE THE
                    %         PDF OF THE GSND. IT USES THE igamma FUNCTION AND IS SLOW.
                    %         m = 1:find(ampr,1,'last');
                    %         a = ampr(m);
                    %         c = Param.r0(m);
                    %         w = Param.width(m);
                    %         b = Param.beta(m);
                    %         z = Param.zeta(m);
                    %         N1 = (b.*gamma(3./b).^0.5)./(2*gamma(1./b).^1.5.*w);
                    %         T1 = bsxfun(@minus,obj.R,c');
                    %         T2 = ((gamma(1./b)./gamma(3./b)).^0.5).*w;
                    %         T3 = bsxfun(@rdivide, T1, T2');
                    %         T4 = bsxfun(@mtimes, N1, exp(-bsxfun(@power,abs(T3),b'))')';
                    %         M1 = bsxfun(@mtimes,z,T3');
                    %         M2B = bsxfun(@igamma,1./b,abs(bsxfun(@power,M1,b)));
                    %         M3B = bsxfun(@rdivide,M2B,2*gamma(1./b));
                    %         CDF = 0.5 + sign(M1).*(0.5 - M3B);
                    betaf = obj.Param.beta;
                    % normalization factor
                    N1 = (betaf.*gamma(3./betaf).^0.5)./ ...
                        (2*gamma(1./betaf).^1.5.*obj.Param.width);
                    % pdf of a GND
                    T1 = bsxfun(@minus,obj.R,obj.Param.r0');
                    T2 = ((gamma(1./betaf)./gamma(3./betaf)).^0.5).*obj.Param.width;
                    T4 = bsxfun(@mtimes,N1, ...
                        exp(-bsxfun(@power,bsxfun(@rdivide,abs(T1),T2'),betaf'))')';
                    % cdf of a Gaussian distribution with zeta
                    CDF = 0.5*(1 + erf(bsxfun(@times,obj.Param.zeta', ...
                        bsxfun(@rdivide,T1,sqrt(2)*obj.Param.width'))));
                    s = 2*T4.*CDF;
                    obj.P = ampr*s;
                    obj.Component = bsxfun(@times,ampr',s);
                end
            end
            try
                obj.Short = app.Con.delta_R*obj.P*obj.Kernel;
                o1 = trapz(obj.P);
                o2 = dot(obj.R,obj.P);
                obj.Mean = o2/o1;
                o3 = dot((obj.R - obj.Mean).^2,obj.P);
                obj.Width = sqrt(o3/o1);
                %
                obj.calculateFit(app,index);
            catch
            end
        end
        
        function obj = calculateFit(obj,app,index)
            if obj.Short(1) == 0
              obj.Short(1) = 1;
            end
            obj.YFit = obj.Param.scale* ...
                (1 - obj.Param.depth*(1-obj.Short)).*obj.Back;
            obj.calculateChisquared(app,index);
        end
        
        function obj = calculateChisquared(obj,app,index)
            obj.Residuals = app.Data(index).deer_r - obj.YFit;
            obj.SSR = sum(obj.Residuals.^2);
            obj.C2 = sum((obj.Residuals.^2).*app.Data(index).weight);
        end
        
    end
end

