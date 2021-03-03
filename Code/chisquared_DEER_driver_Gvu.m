function [ redchisquared ] = chisquared_DEER_driver_Gvu(float, app)
% 04/25/2018 - EJH 
% This version only calculates Chisquared for use with algorithms that only
% fit based on chisquared ('fminsearch','SIMPSA','fmincon',
% 'globalsearch','particleswarm').
% Globals version  
%% copy Float values to answer table
for k = 1:app.Float.Nfloat
    app.Ans(app.Float.Experiment(k)).Value(app.Float.Parameter(k)) = ...
                                           float(k);
end
% reduced chisquared is zero
redchisquared = 0;
%% impose links
app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
for index = 1:app.bucket.Nexps
  app.Fit(index) = DEERcalc(app,index);
  redchisquared = redchisquared + app.Fit(index).C2; 
end
%%
redchisquared = redchisquared/app.bucket.NDegFree;
%
return 

