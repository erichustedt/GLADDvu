function [app] = SaveWindow1(app,savename,savepath,savetype)
%SaveWindow1 - 03/25/2019 EJH
% Save figure panel to a file 
app.EditField.Value = 'Saving Figure';
app.EditField.FontColor = [0.0 0.0 0.5];
copyFigure = figure;
copyFigure.Visible = 'off';
copyAxes = axes(copyFigure);
% Copy all UIAxes children, take over axes limits and aspect ratio.;
tempPanel = findall(app.TabGroup.SelectedTab,'Type','uipanel','Visible','on');
tempAxes = findall(tempPanel,'Type','axes');
if contains(app.view,{'Data'})
  tempAxes = tempAxes(2);
end
allChildren = tempAxes.XAxis.Parent.Children;
copyobj(allChildren, copyAxes)
copyAxes.XLim = tempAxes.XLim;
copyAxes.YLim = tempAxes.YLim;
copyAxes.ZLim = tempAxes.ZLim;
copyAxes.PlotBoxAspectRatio = tempAxes.PlotBoxAspectRatio;
copyAxes.XLabel = tempAxes.XLabel;
copyAxes.YLabel = tempAxes.YLabel;
copyAxes.XAxis.Exponent = tempAxes.XAxis.Exponent;
copyAxes.XTick = tempAxes.XTick;
copyAxes.XTickLabel = tempAxes.XTickLabel;
try
  legendNames = tempAxes.Legend.String;
  lgd = legend(copyAxes,legendNames);
  lgd.Box = tempAxes.Legend.Box;
  lgd.Location = tempAxes.Legend.Location;
  lgd.Interpreter = tempAxes.Legend.Interpreter;
catch
end
if savetype == 3
  % save as fig file
  copyFigure.Visible = 'on';
  savefig(copyFigure,[savepath,savename]);
else
  % Save as png and jpg files.
  saveas(copyFigure,[savepath,savename]);
end
% Delete the temporary figure.
delete(copyFigure);
end

