function app = PlotResults(app)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for index = 1:app.bucket.Nexps 
  yyaxis(app.UIAxesFit(index+1),'right');
  temp = plot(app.UIAxesFit(index+1), ...
              app.Data(index).deer_t0,app.Fit(index).Residuals);
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = 'b';
  temp.MarkerSize = 9;
  temp.Tag = 'Residuals';
  temp = max(abs(app.Fit(index).Residuals));
  app.UIAxesFit(index+1).YLim = [-1.2*temp,+1.2*temp];
  app.UIAxesFit(index+1).YColor = 'b'; 
  app.UIAxesFit(index+1).YLabel.String = 'Residuals';
  %
  plot(app.UIAxesP_R_(index+1), ...
    app.Fit(index).R,app.Fit(index).P,'LineWidth',2,'LineStyle','-', ...
    'Color','r','Tag','Residuals');
  app.UIAxesP_R_(index+1).YLim = app.UIAxesP_R_(1).YLim;
  app.UIAxesP_R_(index+1).XLim = [0 app.Con.R_max];     % set x-axis scale
  legend(app.UIAxesFit(index+1),{'Data','Fit','Background','Residuals'},...
          'Location','northeast');
  legend(app.UIAxesFit(index+1),'boxoff');
  %
  yyaxis(app.UIAxesFit(index+1),'left');
  temp = plot(app.UIAxesFit(index+1), ...
              app.Data(index).deer_t0,app.Fit(index).YFit);
  temp.LineStyle = '-'; 
  temp.Marker = 'none';
  temp.LineWidth = 2 ;
  temp.Color = 'k';
  temp.Tag = 'Fit' ; 
  back = (1-app.Ans(index).Value(1))*app.Fit(index).Back;
  temp = plot(app.UIAxesFit(index+1),app.Data(index).deer_t0,back);
  temp.LineStyle = '-'; 
  temp.Marker = 'none';
  temp.LineWidth = 2 ;
  temp.Color = 'g';
  temp.Tag = 'Background'; 
  q = strcat('$\chi^2 = ',num2str(app.Fit(index).C2,'%12.0f'), ...
    '\;\;iterations = ',num2str(app.bucket.Iter),'$');
  text(0.01,0.075,q, ...
    'Parent',app.UIAxesFit(index+1),'Units','normalized', ...
    'FontSize',12,'Interpreter','latex','Tag','Chisquared'); 
  q = strcat('$',num2str(app.Data(index).nfit,'%12.0f'), ' points$');
  text(0.01,0.025,q, ...
    'Parent',app.UIAxesFit(index+1),'Units','normalized', ...
    'FontSize',12,'Interpreter','latex','Tag','Points');
  app.UIAxesFit(index+1).YLim = app.UIAxesFit(1).YLim;
end
drawnow;
end

