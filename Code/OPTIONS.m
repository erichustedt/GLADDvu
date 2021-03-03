classdef OPTIONS <  matlab.mixin.SetGet
  % 03/30/2018 - EJH
  % class specifying certain options that are used for fitting of
  % DEER data
  
  properties(Access = public)
    % fmincon
    interiorpoint               = true;
    MaxIterations_IP            = 2000;
    MaxFunctionEvaluations_IP   = Inf;
    StepTolerance_IP            = 1.e-08;
    % global search
    globalsearch                = false;
    MaxIterations_GS            = 1000;
    MaxFunctionEvaluations_GS   = 50000;
    NumTrialPoints_GS           = 5000;
    NumStageOnePoints_GS        = 4000;
    MaxTime_GS                  = 900; 
    StepTolerance_GS            = 1.e-06;
    % particle swarm
    particleswarm               = false;
    SetInitialSwarmMatrix       = 0;
    SwarmSizeFactor             = 50;
    SelfAdjustmentWeight        = 1.49;
    SocialAdjustmentWeight      = 1.49;
    FunctionTolerance           = 1.e-08
    MinNeighborsFraction        = 0.25;
    % output
    output2Excel                = 1;
    output2ASCII                = 0;
    output2MAT                  = 0;
    PlotIntermediate            = true;
    % miscellaneous
    phase                       = true;
    gaussianfit                 = true;
    confidence                  = false
    truncate_start              = 0;
    truncate_end                = 0;
    delta4deriv                 = 0.01
    
  end
  
  methods
    function obj = OPTIONS()
      
    end
  end

end
