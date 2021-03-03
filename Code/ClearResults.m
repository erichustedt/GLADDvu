function app = ClearResults(app)
% Delete all plots with calculations results 05/14/2018
% EJH
temp = findobj(app.UIAxesP_R_(1),'Type','Line');
delete(temp);
temp = findobj(app.UIAxesFit(1),'Type','Line','Tag','Fit');
delete(temp);
temp = findobj(app.UIAxesFit(1),'Type','Line','Tag','Background');
delete(temp);
temp = findobj(app.UIAxesFit(1),'Type','Text');
delete(temp);
for index = 1:app.bucket.Nexps
  temp = findobj(app.UIAxesP_R_(index+1),'Type','Line');
  delete(temp); 
  temp = findobj(app.UIAxesP_R_(index+1),'Type','Patch');
  delete(temp); 
  yyaxis(app.UIAxesFit(index+1),'right');
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Residuals');
  delete(temp); 
  yyaxis(app.UIAxesFit(index+1),'left');
  temp = findobj(app.UIAxesFit(index+1),'Type','Text');
  delete(temp);
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Fit');
  delete(temp);
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Background');
  delete(temp);
end
end

