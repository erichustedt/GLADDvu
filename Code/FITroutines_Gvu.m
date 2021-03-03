% --- April 26th 2018 - EJH
function [ app, exitflag, endreason ] = ...
  FITroutines_Gvu( chisquaredhandle, app )
%% Initialize
% delete plots for individual data tabs = 2:index+1
for index = 1:app.bucket.Nexps
  temp = findobj(app.UIAxesP_R_(index+1),'Type','Line');
  delete(temp);
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Residuals');
  delete(temp);
  yyaxis(app.UIAxesFit(index+1),'left');
  temp = findobj(app.UIAxesFit(index+1),'Type','Text');
  delete(temp);
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Fit');
  delete(temp);
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Background');
  delete(temp);
  temp = findobj(app.UIAxesFit(index+1),'Type','Line','Tag','Background');
  delete(temp);
end
%
pause(0.0001);
%% Generate inital fit to the data based on starting parameters
app.Float = FLOAT(app.Ans,app.bucket.Nexps);
app.parametersEditField.Value = app.Float.Nfloat;
floatvalues = app.Float.Value;
floatnames = app.Float.Name;
% Copy lower and upper limits
ll = zeros(1,app.Float.Nfloat);
ul = zeros(1,app.Float.Nfloat);
for j = 1:app.Float.Nfloat
  ll(j) = ...
    app.Ans( app.Float.Experiment(j) ).LowerLimit( app.Float.Parameter(j) );
  ul(j) = ...
    app.Ans( app.Float.Experiment(j) ).UpperLimit( app.Float.Parameter(j) );
end
% set options for interior point - used as hybrid function also
fmc_options = optimoptions('fmincon','Display','iter');
if app.Opt.PlotIntermediate
  fmc_options = optimoptions(fmc_options,'OutputFcn', ...
    @(x,optimValues,state)FMC_Plot_Iterates(x,optimValues,state,app));
end
% This is section for interiorpoint routine% in Matlab 2015b and
% earlier verisions these options have different
% names = MaxIter and MaxFunEvals. - 4/18/2018 EJH
fmc_options.MaxIterations = app.Opt.MaxIterations_IP;
fmc_options.MaxFunctionEvaluations = app.Opt.MaxFunctionEvaluations_IP;
% StepTolerance terminates if change in parameter values is small
fmc_options.StepTolerance = app.Opt.StepTolerance_IP;
fmc_options.ObjectiveLimit = 0.;
%
if app.Opt.interiorpoint
  app.EditField.Value = 'Interior Point Algorithm Running';
  app.EditField.FontColor = [0.0 0.0 0.5];
  A = [];
  Aeq = [];
  b = [];
  beq = [];
  nonlcon = [];
  try
      [floatvalues,~,exitflag,output] = fmincon(chisquaredhandle, ...
          floatvalues,A,b,Aeq,beq,ll,ul, ...
          nonlcon,fmc_options);  
      endreason = 'Interior Point Algorithm Finished'; 
      app.bucket.Iter = output.iterations;
  catch
      endreason = 'Interior Point Algorithm Failed'; 
      pause
  end
  %

elseif app.Opt.globalsearch
  % This is section for Global Search routine
  app.EditField.Value = 'Global Search Algorithm Running';
  app.EditField.FontColor = [0.0 0.0 0.5];
  problem = createOptimProblem('fmincon', ...
    'objective',chisquaredhandle,'x0',(ll + ul)/2,'lb',ll,'ub',ul);
  problem.options.MaxIterations = app.Opt.MaxIterations_GS;
  problem.options.MaxFunctionEvaluations = ...
    app.Opt.MaxFunctionEvaluations_GS;
  %   StepTolerance terminates if change in parameter values is small
  problem.options.StepTolerance = app.Opt.StepTolerance_GS;
  problem.options.ObjectiveLimit = 0.;
  
  valuesearch                     = GlobalSearch;
  valuesearch.Display             = 'iter';
  valuesearch.StartPointsToRun    = 'bounds';
  valuesearch.FunctionTolerance   = 1.e-04;
  valuesearch.XTolerance          = 1.e-03;
  valuesearch.NumTrialPoints      = app.Opt.NumTrialPoints_GS;
  valuesearch.NumStageOnePoints   = app.Opt.NumStageOnePoints_GS;
  valuesearch.MaxTime             = app.Opt.MaxTime_GS;
  valuesearch.PlotFcn             = @gsplotbestf;
  [floatvalues,~,exitflag,output] = run(valuesearch,problem);
  endreason = 'Global Search Finished';
  app.bucket.Iter = output.funcCount;
elseif app.Opt.particleswarm
  % This is section for Particle Swarm routine
  app.EditField.Value = 'Particle Swarm Algorithm Running';
  app.EditField.FontColor = [0.0 0.0 0.5];
  options = optimoptions('particleswarm','HybridFcn', ...
    {@fmincon,fmc_options});
  options = optimoptions(options,'Display','iter');
  options = optimoptions(options,'SocialAdjustmentWeight', ...
    app.Opt.SocialAdjustmentWeight);
  options = optimoptions(options,'SelfAdjustmentWeight', ...
    app.Opt.SelfAdjustmentWeight);
  nswarm = app.Float.Nfloat*app.Opt.SwarmSizeFactor;
  options = optimoptions(options,'SwarmSize',nswarm);
  options = optimoptions(options,'FunctionTolerance', ...
    app.Opt.FunctionTolerance);
  options = optimoptions(options,'MinNeighborsFraction', ...
    app.Opt.MinNeighborsFraction);
  options = optimoptions(options,'ObjectiveLimit',0.);
  if app.Opt.SetInitialSwarmMatrix
    iswarm = zeros(nswarm,app.Float.Nfloat);
    iswarm(1,:) = floatvalues;
    for k = 1:nswarm
      for l = 1:app.Float.Nfloat
        if strcmp(floatnames(l),'depth')
          iswarm(k,l) = floatvalues(l) + 0.05*randn;
        elseif strcmp(floatnames(l),'lambda')
          iswarm(k,l) = floatvalues(l) + 0.2*randn;
        elseif strcmp(floatnames(l),'scale')
          iswarm(k,l) = floatvalues(l) + 0.02*randn;
        elseif strcmp(floatnames(l),'concentration')
          iswarm(k,l) = floatvalues(l) + 100.*randn;
        elseif strcmp(floatnames(l),'rho')
          iswarm(k,l) = 15 + rand*(ul(l)-15);
        elseif strncmp(floatnames(l),'r0',2)
          iswarm(k,l) = floatvalues(l) + 5*randn;
        else
          iswarm(k,l) = ll(l) + (ul(l)-ll(l))*rand;
        end
        if iswarm(k,l) < ll(l) || iswarm(k,l) > ul(l)
          iswarm(k,l) = floatvalues(l);
        end
      end
    end
    options = optimoptions(options,'InitialSwarmMatrix',iswarm);
  end
  options = optimoptions(options,'HybridFcn',@fmincon);
  options = optimoptions(options,'PlotFcn',@pswplotbestf);
  [floatvalues,~,exitflag,output] = particleswarm(chisquaredhandle, ...
    app.Float.Nfloat,ll,ul,options);
  endreason = 'Particle Swarm Finished';
  app.EditField.FontColor = [0.0 0.5 0.0];
  app.bucket.Iter = output.iterations;
else
  endreason = 'No Fitting Routine Chosen';
  app.EditField.FontColor = [0.0 0.0 0.5]; 
end
%
app.EditField.Value = endreason;
%% update Float
app.Float.Value = floatvalues;
%% copy float values to answer table
for k = 1:app.Float.Nfloat
  app.Ans(app.Float.Experiment(k)).Value(app.Float.Parameter(k)) = ...
    floatvalues(k);
end
%% update lambda/concentration
if app.bucket.Background == 1
  for index = 1:app.bucket.Nexps
    app.Ans(index).Value(4) = ...
      (10^app.Ans(index).Value(2))*1.0e-03/app.Ans(index).Value(1) ;
  end
elseif app.bucket.Background == 2 || app.bucket.Background == 7
  for index = 1:app.bucket.Nexps
    app.Ans(index).Value(2) = ...
      log10(app.Ans(index).Value(4)*1000*app.Ans(index).Value(1)) ;
  end
end
%% impose links
app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
%% update answer tables
app.AnswerTable = AnswerTableUpdate(app);
%%
app = InitializeCalcs(app);
%% determine statistics
app = DetermineStatistics(app);
% determine derivatives
derivatives = CalculateDerivatives(app);
% determine uncertainties
curvature = derivatives'*derivatives;
app.bucket.covariance = inv(curvature);
app.Float.Uncertainty = sqrt(diag(app.bucket.covariance)); % std deviations
% 1 sigma 68.27% 31.73%
% 2 sigma 95.45%  4.55% 1.96
% 3 sigma 99.73%  0.27%
% determine confidence bands
% find all Floated variables that determine P(R)
Ifp = find(not(cellfun('isempty',strfind(app.Float.Name,'r0'))));
Ifp = [Ifp;find(not(cellfun('isempty',strfind(app.Float.Name,'width'))))];
Ifp = [Ifp;find(not(cellfun('isempty',strfind(app.Float.Name,'amp'))))];
Ifp = sort([Ifp]);
% delta for each experiment
Pderiv = zeros(app.bucket.Nexps,app.Float.Nfloat,length(app.Fit(index).R));
% make a copy of Fit with R and Param properties
% make a copy of Ans
for index = 1:app.bucket.Nexps
  tempFit(index) = copy(app.Fit(index));
  tempAns(index) = app.Ans(index);
end
% loop over those variables that determine P(R) and find derivatives
for ij = 1:length(Ifp)
  ik = Ifp(ij);
  deltapar = app.Opt.delta4deriv*floatvalues(ik);
  % increment floatvalue and set Ans object
  floatvalues(ik) = floatvalues(ik) + deltapar;
  tempAns(app.Float.Experiment(ik)).Value(app.Float.Parameter(ik)) = ...
      floatvalues(ik);
  % impose links on tempAns.Values
  tempAns = ImposeLinks(tempAns,app.bucket.Nexps);
  for index = 1:app.bucket.Nexps
    % generate parameter object and calculate P(R)
    tempFit(index).Param = PARAM(tempAns(index));
    tempFit(index).calculateDistribution(app,index);
    % calculate derivative 
    Pderiv(index,ik,:) = (tempFit(index).P - app.Fit(index).P)/deltapar;
  end
  % reset floatvalue and Ans object
  floatvalues(ik) = floatvalues(ik) - deltapar;
  tempAns(app.Float.Experiment(ik)).Value(app.Float.Parameter(ik)) = ...
      floatvalues(ik);
end
% from derivatives calculate delta(R)
pMax = 0.;
for index = 1:app.bucket.Nexps
  temp = squeeze(Pderiv(index,:,:));
  app.Fit(index).delta_PR = sqrt(diag(temp'*app.bucket.covariance*temp))';
  app.Fit(index).upper = app.Fit(index).P + 2*app.Fit(index).delta_PR;
  pMax = max([pMax,app.Fit(index).upper]);
  app.Fit(index).lower = app.Fit(index).P - 2*app.Fit(index).delta_PR;
  patch(app.Fit(index).R, app.Fit(index).upper,'r','LineStyle','none',...
    'FaceAlpha',0.25,'Parent',app.UIAxesP_R_(index+1))
  patch(app.Fit(index).R,app.Fit(index).lower,'w','LineStyle','none', ...
    'Parent',app.UIAxesP_R_(index+1));
end
% adjust y-axis scale for P(R) plots to fully display confidence bands
app.UIAxesP_R_(1).YLim = [0,1.05*pMax];
for index = 1:app.bucket.Nexps
  app.UIAxesP_R_(index+1).YLim = app.UIAxesP_R_(1).YLim;
end
%
return

function stop = FMC_Plot_Iterates(x,optimValues,~,app)
%
redchisquared = 0;
%
temp1 = findobj(app.UIAxesFit(1),'Type','Line','Tag','Fit');
temp2 = findobj(app.UIAxesFit(1),'Type','Line','Tag','Background');
temp3 = findobj(app.UIAxesP_R_(1),'Type','Line');
for index = 1:app.bucket.Nexps
  j = app.bucket.Nexps + 1 - index;
  temp1(j).YData = app.Fit(index).YFit;
  back = (1-app.Ans(index).Value(1))*app.Fit(index).Back;
  temp2(j).YData = back;
  redchisquared = redchisquared + app.Fit(index).C2;
  temp3(j).YData = app.Fit(index).P;
end
%
redchisquared = redchisquared/app.bucket.NDegFree;
app.redEditField.Value = redchisquared;
app.iterationsEditField.Value = optimValues.iteration;
%
temp = findobj(app.UIAxesFit(1),'Type','Text');
q = strcat('$\chi_{\nu}^2 = ',num2str(redchisquared), ...
  '\;\;iterations = ',num2str(optimValues.iteration),'$');
temp.String = q;
%
pause(0.0001);
% drawnow; % much slower
stop = false;
return