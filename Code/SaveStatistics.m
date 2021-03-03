function [app] = SaveStatistics(app)
%SaveStatistics - 03/25/2019 EJH
% Save a line of statistics to statistics table
if isfield(app.bucket,'savename') && ~isempty(app.bucket.savename)
    tempA = app.bucket.savename;
else
    if app.bucket.Nexps == 1
        tempA = char(app.bucket.filename);
    else
        tempA = 'multiple';
    end
end
tempB = char(app.ShapeDropDown.Items( ...
  app.ShapeDropDown.ItemsData==app.bucket.Shape));
tempC = char(app.BackgroundDropDown.Items( ...
  app.BackgroundDropDown.ItemsData==app.bucket.Background));
tempD = char(app.GlobalModelDropDown.Items(app.bucket.GlobalModel+1));
save = {app.bucket.Nexps tempA app.bucket.Ncomps tempB tempC tempD ...
  app.bucket.Ndata app.Float.Nfloat app.bucket.totalSSR ...
  app.bucket.RC2 app.bucket.BIC};
app.bucket.Statistics = vertcat(app.bucket.Statistics,save);
tempBIC = cell2mat(app.bucket.Statistics(:,11));
minBIC = min(tempBIC);
deltaBIC = num2cell(tempBIC - minBIC);
temp = horzcat(app.bucket.Statistics,deltaBIC);
app.StatisticsTable.Data = temp; 

