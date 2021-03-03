function app = InitializeCalcs(app)
% EJH 4/25/2018
% 
app = ClearResults(app);
drawnow;
% reduced chisquared is zero
app.bucket.RC2 = 0;
app.bucket.BIC = 0;
app.BICEditField.Value = app.bucket.BIC;
%  
for index = 1:app.bucket.Nexps 
  app.Fit(index) = DEERcalc(app,index); 
  app.bucket.RC2 = app.bucket.RC2 + app.Fit(index).C2;  
  plot(app.UIAxesFit(1), ...
          app.Data(index).deer_t0,app.Fit(index).YFit, ...
          'LineStyle','-','LineWidth',2,'Color', ...
          colors(index,app.bucket.Nexps),'Tag','Fit');
  back = (1-app.Ans(index).Value(1))*app.Fit(index).Back;
  plot(app.UIAxesFit(1), ...
          app.Data(index).deer_t0,back, ...
          'LineStyle','--','LineWidth',1,'Color', ...
          colors(index,app.bucket.Nexps),'Tag','Background');
  plot(app.UIAxesP_R_(1), ...
      app.Fit(index).R,app.Fit(index).P,'LineWidth',2,'LineStyle','-', ...
      'Color',colors(index,app.bucket.Nexps),'Tag','Distribution');
end
%
app.UIAxesP_R_(1).XLim = [0 app.Con.R_max];            % set x-axis scale
%
app = PlotResults(app);
%
app.bucket.RC2 = app.bucket.RC2/app.bucket.NDegFree;
q = strcat('$\chi_{\nu}^2 = ',num2str(app.bucket.RC2,'%12.4f'), ...
          '\;\;iterations = ',num2str(app.bucket.Iter),'$');
text(0.01,0.05,q,'Parent',app.UIAxesFit(1), ...
               'Units','normalized','FontSize',12,'Interpreter','latex');
app.redEditField.Value = app.bucket.RC2;
app.iterationsEditField.Value = app.bucket.Iter;
drawnow;
end