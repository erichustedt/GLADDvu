classdef CONSTANTS <  matlab.mixin.SetGet
  % 03/30/2018 - EJH
  % class specifying certain constants that are used for calculation of
  % DEER signals
  
  properties(Access = public)
    
    delta_R            = 0.1
    R_max              = 100
    R_sphere           = 500
    delta_R_background = 1.0

  end
  
  methods
    function obj = CONSTANTS()
      
    end
  end

end
