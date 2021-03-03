classdef DEERdata < handle
    %   04/25/2018 - EJH - DEERdata class
    %   DEERdata - read
    %   DEER_truncate - truncate and phase
    %   DEER_zero - determine zero time
    %   DEER_initialize - determine initial parameters
    %   DEER_first - calculate initial DEER signals
    
    properties(Access = public)
        fullname            % full filename with path
        filename            % filename
        deer_t              % time vector
        deer_t0             % zero-adjusted time vector
        deer_r              % real data (phased,zero-adjusted,scaled)
        deer_i              % imaginary data (phased,zero-adjusted,scaled)
        z1                  % Real and Imaginary - original data
        z4                  % Real and Imaginary - truncated and phased
        dx                  % time increment
        npts                % number of data points
        nfit                % number of data points after truncation
        first               % first data point
        last                % last point after truncation
        rnoise              % noise level
        phase               % phase
        weight              % weights for each point in .least squares
        GAUSSIAN            % Gaussian fit to early time data
        Pd
        Pf
    end
    
    methods
        function obj = DEERdata(app, filename, directory, filetype, index)
            
            obj.fullname = char(strcat(directory,filename));
            obj.filename = char(filename);
            fprintf('%s \n  ', obj.fullname );
            obj.fullname = obj.fullname(1:strfind(obj.fullname,'.')-1);
            % read in data file
            if filetype == 1
                test1 = exist([obj.fullname '.DTA'],'file');
                test2 = exist([obj.fullname '.DSC'],'file');
                if test1 == 2 && test2 == 2
                    [obj.deer_t, obj.z1, obj.dx] = ...
                        read_elexsys(obj.fullname);
                    obj.npts = length(obj.deer_t);
                    obj.deer_t = obj.deer_t*1.e-09;
                    obj.dx = obj.dx*1.e-09;
                    % first step is truncate
                    obj.DEER_Truncate(app, index);
                end
            elseif filetype == 2
                [obj.deer_t,obj.z1,obj.dx] = ...
                            read_ASCIITEXT([obj.fullname '.txt']);
                obj.deer_t0 = obj.deer_t*1.e-09;
                obj.nfit = length(obj.deer_t0);
                obj.deer_r = real(obj.z1);
                obj.rnoise = imag(obj.z1(1));
                obj.z4 = obj.z1;
                obj.weight = ones(size(obj.deer_t0))/(obj.rnoise^2);
            elseif filetype == 3
                [obj.deer_t,obj.z1,obj.dx] = ...
                    read_ASCIIDATA([obj.fullname '.dat']);
                obj.npts = length(obj.deer_t);
                obj.deer_t = obj.deer_t*1.e-09;
                obj.dx = obj.dx*1.e-09;
                % first step is truncate
                obj.DEER_Truncate(app, index);
            end 
        end
        
        function DEER_Truncate(obj, app, index)
            % Truncate - 1st step
            obj.first = 1;
            obj.last = obj.npts - ...
                ceil(app.TruncateEditField(index).Value*1.e-09/obj.dx);
            obj.deer_t0 = obj.deer_t(obj.first:obj.last);
            y = real(obj.z1(obj.first:obj.last));
            z = imag(obj.z1(obj.first:obj.last));
            obj.nfit = length(obj.deer_t0);
            % Phase - 2nd step
            if app.AutoPhaseCheckBox(index).Value
                d = sum(y);
                e = sum(z);
                f = sum(y.*y) - sum(z.*z) ;
                g = sum(y.*z) ;
                a = -2*d*e + 2*g*obj.nfit;
                b = d^2 - e^2 - f*obj.nfit ;
                t2p = a/b;
                phi = atan(t2p)/2;
                % This phi value will be between -45 and +45 degrees or -pi/4 to pi/4
                if abs(d/e) > 1
                    % if d/e is greater than 1 then phi is either in the correct quadrant or
                    % need to add pi
                    if d < 0
                        phi = phi + pi;
                    end
                else
                    % if d/e is less than 1 then either need to add pi/2 or subtract pi/2
                    if e < 0
                        phi = phi + pi/2;
                    else
                        phi = phi - pi/2;
                    end
                end
                %hyu
                c = (sin(phi)*d + cos(phi)*e)/obj.nfit;
                %
                obj.phase = phi*180/pi;
                % these are the new signals - here return truncated data
                obj.z4 = cos(phi)*(y + 1i*z) - sin(phi)*(z - 1i*y); % is phased and truncated
                % In some cases phi may actually maximize the imaginary component
                % in that case phi is off by 90 degrees. Check to see if the sum
                % of the Real signal is less than the sum of the Imaginary.
                d = sum(real(obj.z4));
                e = sum(imag(obj.z4));
                if abs(d) < abs(e)
                    % phase if off so need to adjust. Try 90 degrees.
                    phi = phi - pi/2;
                    obj.phase = phi*180/pi;
                    % these are the new signals - here return truncated data
                    obj.z4 = cos(phi)*(y + 1i*z) - sin(phi)*(z - 1i*y); % is phased and truncated
                end
                app.PhaseEditField(index).Value = obj.phase;
            else
                obj.phase = app.PhaseEditField(index).Value;
                phi = obj.phase*pi/180;
                c = 0;
                %
                obj.z4 = cos(phi)*(y + 1i*z) - sin(phi)*(z - 1i*y); % is phased and truncated
            end
            % use only middle half of truncated data to estimate noise level
            z = imag(obj.z4(ceil(obj.nfit/4):ceil(3*obj.nfit/4)));
            q = sum(z)/length(z);
            temp = (z - q).^2;
            obj.rnoise = sqrt(sum(temp)/length(temp));
            %
            fprintf('%s %5.2f \n  ', ' Phase= ', obj.phase );
            fprintf('%s %5.2f \n  ', ' Noise= ', obj.rnoise );
            fprintf('%s %5.2f \n  ', ' Imaginary Constant Value= ', c );
            % 3rd step is zero-adjust
            obj.DEER_Zero(app, index);
        end
        
        function DEER_Zero(obj, app, index)
            % Zero - 3rd step
            scale = max(real(obj.z4));
            fprintf('  %s %f \n', 'initial scale factor= ', scale);
            obj.deer_r = real(obj.z4)/scale;
            obj.deer_i = imag(obj.z4)/scale;
            obj.rnoise = obj.rnoise/scale;
            %
            if app.AutoZeroCheckBox(index).Value
                [obj.deer_r, obj.deer_i, obj.rnoise, obj.GAUSSIAN.par, ...
                    obj.GAUSSIAN.xg, obj.GAUSSIAN.yg1, obj.GAUSSIAN.yg2] = ...
                    zero_deer(obj.deer_t0, obj.deer_r, obj.deer_i, obj.rnoise);
                tzero = obj.GAUSSIAN.par(2);
                app.ZeroEditField(index).Value = tzero;
            else
                tzero = app.ZeroEditField(index).Value;
            end
            obj.deer_t0 = obj.deer_t0 - 1.e-09*tzero;
            %
            obj.weight = ones(size(obj.deer_t0))/(obj.rnoise^2);
            % plot zero determination
            app.UIAxesZero(index).NextPlot = 'add';
            temp = plot(app.UIAxesZero(index), ...
                        obj.GAUSSIAN.xg,obj.GAUSSIAN.yg1,'Tag','Data');
            temp.LineStyle = 'none';
            temp.Marker = 'o';
            temp.MarkerSize = 3;
            temp.Color = [0.00 0.75 0.00];
            temp = plot(app.UIAxesZero(index), ...
                        obj.GAUSSIAN.xg,obj.GAUSSIAN.yg2,'Tag','Fit');
            temp.LineStyle = '-';
            temp.Color = 'k';
            %
            q = ['\fontname{Times New Roman} \it Zero Time\rm = ' ...
                num2str(tzero,'%6.2f') '\it ns' ];
            text(app.UIAxesZero(index), ...
                                'Units','normalized','String', ...
                                q,'Position',[0.00 0.05 0],'FontSize',14);
            %
            temp.Parent.XLim = [(min(temp.XData) - 10) ...
                                (max(temp.XData) + 10)];
            temp.Parent.YLim = [(min(obj.GAUSSIAN.yg1) - 0.001) ...
                                (max(obj.GAUSSIAN.yg1) + 0.001)];          
            % 4th step is automatically determine initial parameters
            % but need to create answer file first
            drawnow; 
        end
        
        function DEER_AIP(obj, app, index)
          % Initialize - 4th step
          if app.AIPCheckBox.Value
            temp_mid = floor(obj.nfit/2);
            temp_x = obj.deer_t0(temp_mid:end);
            temp_y = obj.deer_r(temp_mid:end);
            temp_poly = polyfit(temp_x,real(log(temp_y)),1);
            temp_z = temp_y./exp(temp_poly(1)*abs(temp_x));
            depth = 1 - temp_z(end);
            lambda = real(log10(temp_poly(1)));
            concentration = (10^lambda)*1.0e-03/depth;
            temp_half = 1 - depth/2;
            [~, idx] = min(abs(obj.deer_r - temp_half));
            r0 = 6407*(abs(obj.deer_t0(idx))^(1/3));
            app.Ans(index).Value(1) = depth;
            app.Ans(index).Value(2) = lambda;
            app.Ans(index).Value(4) = concentration;
            if app.bucket.Ncomps == 1
              app.Ans(index).Value(9) = r0;
            end
          end
        end
 
    end
    
end

function [ x,Z,dx ]= read_elexsys(file)
% 03/30/2010 modified EJH
% Get Bruker Data Set
% file is the file name for the bruker data set
% Use the Bruker  file convention, and do not add extension names
% "file" . dsc and .dta are assumed
% Z contains the x and y values in a 2 column matrix
%  plot(Z(:,1),Z(:,2))  to  visualize results

dx= [];
x=[];
Z =[];

fid = fopen( [ file '.DTA'], 'r','ieee-be.l64');
if(fid == -1)
    return;
end
[Z,~]= fread(fid,inf,'float64');
fclose(fid);
fid = fopen( [ file '.DSC'], 'r');
[info,~] = textscan(fid,'%s');
fclose(fid);
%
temp = find(ismember(info{:,1},'XMIN')==1);
XMIN = str2double(info{1,1}{temp(1)+1,1});
temp = find(ismember(info{:,1},'XWID')==1);
XWID = str2double(info{1,1}{temp(1)+1,1});
temp = find(ismember(info{:,1},'XPTS')==1);
XPTS = str2double(info{1,1}{temp(1)+1,1});
%
dx = XWID/(XPTS-1);
x = XMIN + dx*(0:(XPTS-1));
%%
if length(Z)==2*XPTS
    z0=Z;
    Z=zeros(XPTS,1);
    for k=1:XPTS
        Z(k)=z0(2*k-1)+1i*z0(2*k);
    end
end

Z=permute(Z,[2,1]);
end

function [deer_r,deer_i,rnoise,par,xfit,yfit,ytemp]= zero_deer(x,y,z,rnoise)
[~,imax] = max(y);
obj.nfit = 2*imax;
if x(obj.nfit) < 100.e-09
    xfit = x(x<100e-09);
    obj.nfit = length(xfit);
end
xfit = 1.e09*x(1:obj.nfit);
yfit = y(1:obj.nfit);
par0(1) = 1/2;
par0(2) = xfit(imax);
par0(3) = 100;
par0(4) = 1/2;
%
options = optimset('Display','off','TolFun',1e-8,'Tolx',1e-8);
[par,~,exitflag,output] = ...
    fminsearch(@(par)differfunc(par,xfit,yfit),par0,options);
%
ytemp = par(1)*exp( (-1*(xfit - par(2)).^2)/(2*par(3)*par(3))) + par(4) ;
fprintf(' \n %s %i ', ...
    ' exitflag for fitting Gaussian to early time data= ', exitflag);
fprintf(' \n %s \n ', ' ');
disp(output);
fprintf(' %s ', 'Gaussian parameters for zero time fitting= ');
disp(par);
bb = par(1) + par(4);
deer_r = y/bb;
deer_i = z/bb;
rnoise = rnoise/bb;
end

function F = differfunc(par,xfit,yfit)
G  = gaussianfun(par,xfit);
F= sum((yfit - G).^2);
end

function G = gaussianfun(par,xfit)
G = par(1)*exp( (-1*(xfit - par(2)).^2)/(2*par(3)*par(3))) + par(4) ;
end




