function app = DetermineStatistics(app)
%DetermineStatistics 08/23/2018 EJH - Calculated BIC values amd other stats
%   BIC values and other stats
app.bucket.RC2 = 0;
app.bucket.totalSSR = 0;
for index = 1:app.bucket.Nexps
    app.bucket.RC2 = app.bucket.RC2 + app.Fit(index).C2;
    app.bucket.totalSSR = app.bucket.totalSSR + app.Fit(index).SSR;
end
app.bucket.RC2 = app.bucket.RC2/app.bucket.NDegFree;
app.redEditField.Value = app.bucket.RC2;
%
app.bucket.BIC = app.bucket.Ndata*log(app.bucket.totalSSR/ ...
    app.bucket.Ndata) + (app.Float.Nfloat + 1)*log(app.bucket.Ndata) ;
app.BICEditField.Value = app.bucket.BIC;
end

