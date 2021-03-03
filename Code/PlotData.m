function [app] = PlotData(app)
% 4/12/2019 - EJH
% Plots data
% Plot Original Data
for index = 1:app.bucket.Nexps
  temp = plot(app.UIAxesData(index+1), ...
    app.Data(index).deer_t,real(app.Data(index).z1),'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = [0.70 1.00 0.70];
  temp = plot(app.UIAxesData(index+1), ...
    app.Data(index).deer_t,imag(app.Data(index).z1),'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = [0.70 1.00 1.00];
  % plot truncated and scaled data
  temp = plot(app.UIAxesData(index+1), ...
    app.Data(index).deer_t0,real(app.Data(index).z4),'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = [0.0 0.75 0.0];
  temp = plot(app.UIAxesData(index+1), ...
    app.Data(index).deer_t0,imag(app.Data(index).z4),'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = 'b';
  legend(app.UIAxesData(index+1),{'Real (raw)', ...
    'Imaginary (raw)','Real (phased)','Imaginary (phased'}, ...
    'Location','northeast');
  legend(app.UIAxesData(index+1),'boxoff');
  %
  q = ['\fontname{Times New Roman} \it Noise Level\rm = ' ...
    num2str(app.Data(index).rnoise,'%8.5f') ];
  text(app.UIAxesData(index+1), ...
    'Units','normalized','String',q, ...
    'Position',[0.01 0.35 0],'FontSize',14);
  %
  temp = plot(app.UIAxesFit(index+1), ...
    app.Data(index).deer_t0,app.Data(index).deer_r,'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = 'r';
  temp = plot(app.UIAxesData(1),app.Data(index).deer_t0,app.Data(index).deer_r, ...
    'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = colors(index,app.bucket.Nexps);
  temp = plot(app.UIAxesFit(1),app.Data(index).deer_t0,app.Data(index).deer_r, ...
    'Tag','Data');
  temp.LineStyle = 'none';
  temp.Marker = '.';
  temp.Color = colors(index,app.bucket.Nexps);
  %
end
drawnow;
end

