function yder = CalculateDerivatives(tempApp)
%CalculateDerivatives 08/23/2018 EJH Calculate Derivatives
% for uncertainties and confidence bands
% one concatenated vector for derivatives for all data sets. Data sets may
% not be all the same length.
yder = zeros(tempApp.bucket.Ndata,tempApp.Float.Nfloat);
floatvalues = tempApp.Float.Value;
for jpar = 1:tempApp.Float.Nfloat
  allvec = [];
  deltapar = tempApp.Opt.delta4deriv*floatvalues(jpar);
  if(floatvalues(jpar) == 0)
    deltapar = tempApp.Opt.delta4deriv;
  end
  floatvalues(jpar) = floatvalues(jpar) + deltapar;
  for k = 1:tempApp.Float.Nfloat
    tempApp.Ans(tempApp.Float.Experiment(k)). ...
        Value(tempApp.Float.Parameter(k)) = floatvalues(k);
  end
  %% impose links
  tempApp.Ans = ImposeLinks(tempApp.Ans,tempApp.bucket.Nexps);
  for index = 1:tempApp.bucket.Nexps
    temp = DEERcalc(tempApp,index);
    allvec = [allvec,(temp.YFit - tempApp.Fit(index).YFit)/ ...
      tempApp.Data(index).rnoise];
  end
  %%
  yder(1:tempApp.bucket.Ndata,jpar) = allvec/deltapar;
  floatvalues(jpar) = floatvalues(jpar) - deltapar;  
  for k = 1:tempApp.Float.Nfloat
    tempApp.Ans(tempApp.Float.Experiment(k)). ...
        Value(tempApp.Float.Parameter(k)) = floatvalues(k);
  end
end

