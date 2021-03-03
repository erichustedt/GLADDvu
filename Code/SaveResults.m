function [app] = SaveResults(app,savepath,savename,savetype)
%SaveResults - 03/25/2019 EJH
% Save results to a file
try
  if savetype == 1
    % save as Excel File
    disp('Saving results in Excel files')
    xlsxFile = strcat(savepath,savename);
    % delete Excel file if it already exists
    if isfile(xlsxFile)
      delete(xlsxFile);
    end
    % SUMMARY
    sheet = 'SUMMARY';
    tempG = {char(datetime)};
    tempA = char(app.BackgroundDropDown.Items( ...
      app.BackgroundDropDown.ItemsData==app.bucket.Background));
    tempB = [num2str(app.bucket.Ncomps),' ', ...
      char(app.ShapeDropDown.Items(app.bucket.Shape))];
    tempC = char(app.GlobalModelDropDown.Items(app.bucket.GlobalModel+1));
    tempD = app.MethodDropDown.Items( ...
      app.MethodDropDown.ItemsData==app.MethodDropDown.Value);
    tempE = ['reduced chi-squared = ',num2str(app.bucket.RC2)];
    tempF = ['BIC = ',num2str(app.bucket.BIC)];
    tempH = ['SSR = ',num2str(app.bucket.totalSSR)];
    temp = [tempG;tempE;tempF;tempH;tempA;tempB;tempC;tempD];
    temp = [temp;app.bucket.filename'];
    xlswrite(xlsxFile,temp,sheet);
    temp = [[app.Data.npts]',[app.Data.phase]', ...
      [app.TruncateEditField(1:app.bucket.Nexps).Value]', ...
      [app.Data.nfit]',[app.ZeroEditField(1:app.bucket.Nexps).Value]', ...
      [app.Data.rnoise]',[app.Fit.SSR]'];
    temp = num2cell(temp);
    temp = [app.bucket.filename',temp];
    xlswrite(xlsxFile,temp,sheet,'A8');
    ilocation = 8 + app.bucket.Nexps;
    for index = 1:app.bucket.Nexps
      location = ['A' num2str(ilocation)];
      xlswrite(xlsxFile,app.bucket.filename(index),sheet,location);
      location = ['B' num2str(ilocation)];
      xlswrite(xlsxFile,app.Fit(index).SSR,sheet,location);
      ilocation = ilocation + 1;
      location = ['A' num2str(ilocation)];
      xlswrite(xlsxFile,{'r0'},sheet,location);
      location = ['B' num2str(ilocation)];
      xlswrite(xlsxFile,app.Fit(index).Param.r0,sheet,location);
      ilocation = ilocation + 1;
      location = ['A' num2str(ilocation)];
      xlswrite(xlsxFile,{'width'},sheet,location);
      location = ['B' num2str(ilocation)];
      xlswrite(xlsxFile,app.Fit(index).Param.width,sheet,location);
      ilocation = ilocation + 1;
      location = ['A' num2str(ilocation)];
      xlswrite(xlsxFile,{'beta'},sheet,location);
      location = ['B' num2str(ilocation)];
      xlswrite(xlsxFile,app.Fit(index).Param.beta,sheet,location);
      ilocation = ilocation + 1;
      location = ['A' num2str(ilocation)];
      xlswrite(xlsxFile,{'zeta'},sheet,location);
      location = ['B' num2str(ilocation)];
      xlswrite(xlsxFile,app.Fit(index).Param.zeta,sheet,location);
      ilocation = ilocation + 1;
      location = ['A' num2str(ilocation)];
      xlswrite(xlsxFile,{'fraction'},sheet,location);
      location = ['B' num2str(ilocation)];
      xlswrite(xlsxFile,app.Fit(index).NormAmp,sheet,location);
      ilocation = ilocation + 1;
    end
    for index = 1:app.bucket.Nexps
      % ANSWER
      sheet = ['ANSWER(',num2str(index),')'];
      temp_a = [app.bucket.filename(index),properties(app.Ans(index))'];
      temp_b= [num2cell(1:length(app.Ans(index).Name))', ...
        app.Ans(index).Name,num2cell( ...
        [app.Ans(index).Value,app.Ans(index).Fixed, ...
        app.Ans(index).Experiment, ...
        app.Ans(index).Link,app.Ans(index).LowerLimit, ...
        app.Ans(index).UpperLimit])];
      xlswrite(xlsxFile,[temp_a;temp_b],sheet);
      % FIT
      temp = ["Time","Data","Fit","Background","Residuals"; ...
        app.Fit(index).Time',app.Data(index).deer_r', ...
        app.Fit(index).YFit', ...
        (1-app.Ans(index).Value(1))*app.Fit(index).Back', ...
        app.Fit(index).Residuals'];
      sheet = ['Fit(',num2str(index),')'];
      xlswrite(xlsxFile,temp,sheet);
      xlswrite(xlsxFile,app.bucket.filename(index),sheet,'F1:F1');
      % DISTRIBUTION
      temp = ["R","Probability","upper","lower","delta"; ...
        app.Fit(index).R',app.Fit(index).P',app.Fit(index).upper', ...
        app.Fit(index).lower',app.Fit(index).delta_PR'];
      sheet = ['Distribution(',num2str(index),')'];
      xlswrite(xlsxFile,temp,sheet);
      try
        temp = findpeaks(app.Fit(index).P,app.Fit(index).R);
        modes_number = length(temp);
      catch
        modes_number = 0;
      end
      temp = ["Mean = ";"Width = ";"Components =";"Modes = "];
      xlswrite(xlsxFile,app.bucket.filename(index),sheet,'F1:F1');
      xlswrite(xlsxFile,temp,sheet,'F2:F5');
      temp = [app.Fit(index).Mean;app.Fit(index).Width; ...
        app.bucket.Ncomps;modes_number];
      xlswrite(xlsxFile,temp,sheet,'G2:G5');
      % DATA
      sheet = ['Data(',num2str(index),')'];
      temp = [app.Data(index).deer_t',real(app.Data(index).z1)', ...
        imag(app.Data(index).z1)'];
      xlswrite(xlsxFile,temp,sheet);
      temp = [ app.Data(index).deer_t0',real(app.Data(index).z4)', ...
        imag(app.Data(index).z4)', ...
        app.Data(index).deer_r',app.Data(index).deer_i'];
      xlswrite(xlsxFile,temp,sheet,'D1');
      xlswrite(xlsxFile,app.bucket.filename(index),sheet,'I1');
    end
    % UNCERTAINTIES
    temp = ["Name","Value","+/-"; ...
      app.Float.Name,num2cell(app.Float.Value(:)), ...
      num2cell(app.Float.Uncertainty(:))];
    xlswrite(xlsxFile,temp,'Uncertainties');
    % OPTIONS
    temp = properties(app.Opt);
    temp = ["Option","Value";temp,get(app.Opt,temp)'];
    xlswrite(xlsxFile,temp,'Options');
    % CONSTANTS
    temp = properties(app.Con);
    temp = ["Constant","Value";temp,get(app.Con,temp)'];
    xlswrite(xlsxFile,temp,'Constants');  
    % COVARIANCE
    xlswrite(xlsxFile,app.bucket.covariance,'Covariance');
    % delete any empty sheets
    DeleteEmptyExcelSheets(xlsxFile)
  elseif savetype == 2
    % save as ASCII Files
    disp('Saving results in ASCII files')
    [~,asciiFile,~] = fileparts(savename);
    asciiFile = strcat(savepath,asciiFile);
    outfile = strcat(asciiFile,'_summary.dat');
    fid = fopen(outfile,'w');
    fprintf('\n %s %s \n',outfile,'is open.');
    fprintf(fid,'%s \n',char(datetime));
    fprintf(fid,'%s \n', ...
      char(app.BackgroundDropDown.Items(app.bucket.Background)));
    fprintf(fid,'%2d %s %s \n',[app.bucket.Ncomps,' ', ...
      char(app.ShapeDropDown.Items(app.bucket.Shape))]);
    fprintf(fid,'\n %s \n', ...
      char(app.GlobalModelDropDown.Items(app.bucket.GlobalModel+1)));
    fprintf(fid,'%s \n', ...
      char(app.MethodDropDown.Items( ...
      app.MethodDropDown.ItemsData==app.MethodDropDown.Value)));
    fprintf(fid,'%s %10.5f \n','reduced chi-squared = ',app.bucket.RC2);
    fprintf(fid,'%s %10.5f \n \n','BIC = ',app.bucket.BIC);
    for index = 1:app.bucket.Nexps
      fprintf(fid,'%s %4d % 12.5f %4d %4d %4d % 12.5f % 12.5f \n \n', ...
        char(app.bucket.filename(index)), ...
        app.Data(index).npts,app.Data(index).phase, ...
        app.Data(index).nfit,app.TruncateEditField(index).Value, ...
        app.Data(index).nfit, ...
        app.ZeroEditField(index).Value,app.Data(index).rnoise);
    end
    %
    for index = 1:app.bucket.Nexps
      fprintf(fid,'%s \n',char(app.bucket.filename(index)));
      fprintf(fid,'r0      ');
      fprintf(fid,'%10.3f',app.Fit(index).Param.r0);
      fprintf(fid,'\n');
      fprintf(fid,'width   ');
      fprintf(fid,'%10.3f',app.Fit(index).Param.width);
      fprintf(fid,'\n');
      fprintf(fid,'beta    ');
      fprintf(fid,'%10.3f',app.Fit(index).Param.beta);
      fprintf(fid,'\n');
      fprintf(fid,'zeta    ');
      fprintf(fid,'%10.3f',app.Fit(index).Param.zeta);
      fprintf(fid,'\n');
      fprintf(fid,'fraction');
      fprintf(fid,'%10.3f',app.Fit(index).NormAmp);
      fprintf(fid,'\n');
    end
    fclose(fid);
    %
    outfile = strcat(asciiFile,'_uncertainties.dat');
    fid = fopen(outfile,'w');
    fprintf('\n %s %s \n',outfile,'is open.');
    fprintf(fid,'Name     Value         +/- \n');
    for i = 1:app.Float.Nfloat
      fprintf(fid,'%s %12.5e %12.5e \n',char(app.Float.Name(i)), ...
        app.Float.Value(i), ...
        app.Float.Uncertainty(i));
    end
    fclose(fid);
    %
    for index = 1:app.bucket.Nexps
      outfile = strcat(asciiFile,'_',num2str(index),'_distribution.dat');
      fid = fopen(outfile,'w');
      fprintf('\n %s %s \n',outfile,'is open.');
      fprintf(fid,'%s ', ...
        '    Dist.      Prob.      95% Lower  95% Upper  Delta');
      for n = 1:length(app.Fit(index).R)
        fprintf(fid,'\n %10.5f %10.5f %10.5f %10.5f %10.5f',...
          app.Fit(index).R(n), app.Fit(index).P(n), ...
          app.Fit(index).upper(n), app.Fit(index).lower(n), ...
          app.Fit(index).delta_PR(n) );
      end
      fclose(fid);
      %
      outfile = strcat(asciiFile,'_',num2str(index),'_fit.dat');
      fid = fopen(outfile,'w');
      fprintf('\n %s %s \n',outfile,'is open.');
      fprintf(fid,'%s ', ...
        '      Time         Data         Fit          Backgr.      Resid.');
      back = (1-app.Ans(index).Value(1))*app.Fit(index).Back;
      corr1 = app.Data(index).deer_r./app.Fit(index).Back;
      corr2 = app.Fit(index).YFit./app.Fit(index).Back;
      for n = 1:app.Data(index).nfit
        fprintf(fid, ...
          '\n %12.5g %12.5f %12.5f %12.5f %12.5f %12.5f %12.5f',...
          app.Data(index).deer_t0(n), ...
          app.Data(index).deer_r(n), app.Fit(index).YFit(n), ...
          back(n), app.Fit(index).Residuals(n), corr1(n), corr2(n) );
      end
      fclose(fid);
    end
    fclose('all');
  else
    % save as Matlab mat File
    save([savepath,savename],'app');
  end
catch
end
end

