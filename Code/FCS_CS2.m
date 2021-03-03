function [C,S] = FCS_CS2(x)

% FRESNEL(X) calculates the values of the Fresnel integrals for real values
% of vector X,
%   i.e.
%       C = \int_0^x cos(pi*t^2/2) dt,
%       S = \int_0^x sin(pi*t^2/2) dt
%
% SYNTAX
%       [C,S] = fresnel(X)
%   where,
%       X      is an array of values on which the Fresnel integral are to
%              be evaluated
%
%   The outputs have the same shape as the input.
%
% HOW THE INTEGRALS ARE CALCULATED
% - Values of X in the interval [-5,5] are generated
%   and interpolated ('spline').
% - Values outside the interval [-5,5] are evaluated using the
%   approximations under Table 7.7 in [1]. The error is less than
%   3e-007.
%
% REFERENCES
% [1] Abramowitz, M. and Stegun, I. A. (Eds.). "Error Function and Fresnel
%     Integrals." Ch. 7 in Handbook of Mathematical Functions with
%     Formulas, Graphs, and Mathematical Tables, 9th printing. New York:
%     Dover, pp. 295-329, 1970.
%
% By C. Saragiotis, May 2008
% Modified by EJH January 2018
%% Initialization
persistent z fC05 fS05 x0 C0 S0;
% has table of exact values of Fresnel integrals already been calculated
if isempty(z) || isempty(fC05) || isempty(fS05)
    z = 0:0.005:5; 
    [fC05,fS05] = fcs(z);
    x0 =zeros(size(x));
end

%% Main
% is input same as previous
if isequal(x0,x)
    C = C0;
    S = S0;
else
    sgn = sign(x);
    x = abs(x);
    
    % Find x values <= 5 
    i05 = x <= 5;
    
    C = 0.5 + (0.3183099-0.0968./x.^4) .* sin(pi/2*x.^2)./x - ...
        (0.10132-0.154./x.^4) .* cos(pi/2*x.^2)./x.^3;
    C(i05) = interp1(z, fC05, x(i05), 'spline'); % Use interpolation for |x| <= 5
    C = sgn.*C;             % Fresnel C is an odd function
    %
    S = 0.5 - (0.3183099-0.0968./x.^4) .* cos(pi/2*x.^2)./x - ...
        (0.10132-0.154./x.^4) .* sin(pi/2*x.^2)./x.^3;
    S(i05) = interp1(z, fS05,x(i05),'spline');   % Use interpolation for |x| <= 5
    S = sgn.*S;             % Fresnel S is an odd function
    C0 = C;
    S0 = S;
    x0 = x;
end
