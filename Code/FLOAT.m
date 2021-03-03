classdef FLOAT < handle 
    % 03/30/2018 - EJH - FLOAT class
    % parameter that float during fit
  
  properties
    Nfloat
    Name
    Value
    Parameter
    Experiment
    Uncertainty
  end
  
  methods
    
    function obj = FLOAT(Ans,Nexps)
      obj.Nfloat = 0;
      for index = 1:Nexps
        temp = find(~Ans(index).Fixed & ~Ans(index).Link);
        obj.Nfloat = obj.Nfloat + length(temp);
        obj.Name = [obj.Name;Ans(index).Name(temp)];
        obj.Value = [obj.Value;Ans(index).Value(temp)];
        obj.Parameter = [obj.Parameter;temp];
        obj.Experiment = [obj.Experiment;index*ones(size(temp))];
      end 
    end
    
  end
  
end

