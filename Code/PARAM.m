classdef PARAM < dynamicprops
    % 04/02/2018 - EJH PARAM class specifying parameters used for
    % simulating DEER data. PARAM is another way of specifying parameters 
    % in Ans.Value
    
    properties(Access = public)
        r0
        width
        beta
        zeta
        amp
        ng
    end
    
    methods
        function obj = PARAM(Ans)
            
            nparam = length(Ans.Value);
            
            kr = 0;
            ks = 0;
            kb = 0;
            kz = 0;
            ka = 0;
            
            for k = 1:nparam
                
                if strncmpi(Ans.Name(k),'r0_',3)
                    kr = kr + 1; obj.r0(kr) = Ans.Value(k);
                    
                elseif strncmpi(Ans.Name(k),'width',5)
                    ks = ks + 1; obj.width(ks)= Ans.Value(k);
                    
                elseif strncmpi(Ans.Name(k),'beta',4)
                    kb = kb + 1; obj.beta(kb) = Ans.Value(k);
                    
                elseif strncmpi(Ans.Name(k),'zeta',4)
                    kz = kz + 1; obj.zeta(kz) = Ans.Value(k);
                    
                elseif strncmpi(Ans.Name(k),'amp_',4)
                    ka = ka + 1; obj.amp(ka) = Ans.Value(k);
                    
                else
                    temp = char(Ans.Name(k));
                    addprop(obj,temp);
                    obj.(temp) =  Ans.Value(k); 
                end 
            end
            obj.ng = length(obj.r0);
            
        end
    end
end

