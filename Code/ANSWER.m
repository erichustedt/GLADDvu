classdef ANSWER < handle
    %   03/30/2018 - EJH - ANSWER class
    %   DEERcalc - read
    %   specifyComponent
    %   splitComponent
    %   specifyShape
    %   specifyBackground
    %   specifyGlobalModel
    
    properties(Access = public)
        Name
        Value
        Fixed
        Experiment
        Link
        LowerLimit
        UpperLimit
    end
    
    methods
        function obj = ANSWER(app, index)
            if index == 1
                % if necessary, specify answer structure for 1st experiment
                % using default parameters. 13 parameters for 1 experiment
                obj.Name = {'depth';'lambda';'dimension';'concentration'; ...
                    'backgroundD';'scale';'time_shift'; ...
                    'shape';'r0_1';'width_1';'beta_1';'zeta_1';'amp_1'};
                obj.Value = [0.3;5.0;3;0.0;0.0;1.0;0.0;1; ...
                    25.0;5.0;2.0;0.0;1.0];
                obj.Fixed = [0;0;1;1;1;0;1;1;0;0;1;1;1];
                obj.Experiment = ones(13,1);
                obj.Link = zeros(13,1);
                obj.LowerLimit = [0;4;1;25;0;0.8;-200;1;15;0.05; ...
                    0.25;-10;1];
                obj.UpperLimit = [1.5;6;4;1000;75;1.2;200;10; ...
                    60.;25;25;10;1];
                % update for shape
                obj.specifyShape(app);
                % update for background
                obj.specifyBackground(app);
                % update for number of components
                obj.specifyComponents(app,index);
            else
                % adding a new experiment so I'm copying values for 1st
                % experiment then updating as necessary
                mparams = length(app.Ans(1).Name);
                obj.Name = app.Ans(1).Name;
                obj.Value = app.Ans(1).Value;
                obj.Fixed = app.Ans(1).Fixed;
                obj.Experiment = index*ones(mparams,1);
                obj.Link = app.Ans(1).Link;
                obj.LowerLimit = app.Ans(1).LowerLimit;
                obj.UpperLimit = app.Ans(1).UpperLimit;
                % update links for globals
                obj.specifyGlobalModel(app,index);
            end
        end
        
        function specifyComponents(obj,app,index)
            mparams = length(obj(1).Name);
            mcomps = (mparams - 8)/5;
            ncomps = app.bucket.Ncomps;
            nparams = 8 + 5*ncomps;
            %
            if ncomps < mcomps
                % number of components decreases
                obj.Name = obj.Name(1:nparams);
                obj.Value = obj.Value(1:nparams);
                obj.Fixed = obj.Fixed(1:nparams);
                obj.Experiment = obj.Experiment(1:nparams);
                obj.Link = obj.Link(1:nparams);
                obj.LowerLimit = obj.LowerLimit(1:nparams);
                obj.UpperLimit = obj.UpperLimit(1:nparams);
                return
            elseif ncomps == mcomps
                % number of components isn't changed
                return
            elseif ncomps > mcomps
                % number of components increases
                base = {'r0_';'width_';'beta_';'zeta_';'amp_'};
                mx = mparams;
                for m = mcomps+1:ncomps
                    addendum ={horzcat(base{1},num2str(m)); ...
                        horzcat(base{2},num2str(m)); ...
                        horzcat(base{3},num2str(m)); ...
                        horzcat(base{4},num2str(m)); ...
                        horzcat(base{5},num2str(m))};
                    obj.Name = vertcat(obj.Name,addendum);
                    temp = 25.0 + (m-1)*5.0;
                    mx = mx + 1;
                    obj.Value = vertcat(obj.Value, ...
                        [temp;5.0;2.0;0.0;0.5]);
                    obj.Fixed = vertcat(obj.Fixed, ...
                        [0;0;obj.Fixed(12);obj.Fixed(13);0]);
                    obj.Experiment = vertcat(obj.Experiment, ...
                        [index;index;index;index;index]);
                    obj.Link = vertcat(obj.Link,zeros(5,1));
                    obj.LowerLimit = vertcat(obj.LowerLimit, ...
                        [15;0.05;0.25;-10;0]);
                    obj.UpperLimit = vertcat(obj.UpperLimit, ...
                        [60;25;25;10;1]);
                    % update links for globals
                    obj.specifyGlobalModel(app,index);
                end
                return
            end
        end
        
        function splitComponent(obj,app)
            disp('Split');
        end
        
        function specifyShape(obj,app)
            mparams = length(obj(1).Name);
            mcomps = (mparams - 8)/5;
            obj.Value(8) = app.bucket.Shape;
            for m = 1:mcomps
                mx = 5*m;
                if app.bucket.Shape == 1 || app.bucket.Shape == 5
                    % Gaussian or Rice
                    obj.Fixed(6+mx) = 1;
                    obj.Fixed(7+mx) = 1;
                elseif app.bucket.Shape == 8
                    % Variable (kurtosis)
                    obj.Fixed(6+mx) = 0;
                    obj.Fixed(7+mx) = 1;
                elseif app.bucket.Shape == 9
                    % Skew
                    obj.Fixed(6+mx) = 1;
                    obj.Fixed(7+mx) = 0;
                elseif app.bucket.Shape == 10
                    % GSND
                    obj.Fixed(6+mx) = 0;
                    obj.Fixed(7+mx) = 0;
                elseif app.bucket.Shape == 11
                    % Custom
                end
            end
            
        end
        
        function specifyBackground(obj,app)
            if app.bucket.Background == 0
                % None
                obj.Fixed(2) = 1;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 1;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'backgroundA'};
                obj.Name(3) = {'backgroundB'};
                obj.Name(4) = {'backgroundC'};
                obj.Name(5) = {'backgroundD'};
                obj.Value(2) = 0;
                obj.Value(3) = 0;
                obj.Value(4) = 0;
                obj.Value(5) = 0;
            elseif app.bucket.Background == 1
                % 3 dimensional exponential - lambda
                obj.Fixed(2) = 0;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 1;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'lambda'};
                obj.Name(3) = {'dimension'};
                obj.Name(4) = {'concentration'};
                obj.Name(5) = {'backgroundD'};
                obj.Value(3) = 3;
            elseif app.bucket.Background == 2
                % calculated excluded volume
                obj.Fixed(2) = 1;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 0;
                obj.Fixed(5) = 0;
                obj.Name(2) = {'lambda'};
                obj.Name(3) = {'backgroundB'};
                obj.Name(4) = {'concentration'};
                obj.Name(5) = {'rho'};
            elseif app.bucket.Background == 3
                % 2 dimensional exponential
                obj.Fixed(2) = 0;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 1;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'lambda'};
                obj.Name(3) = {'dimension'};
                obj.Name(4) = {'backgroundC'};
                obj.Name(5) = {'backgroundD'};
                obj.Value(3) = 2;
            elseif app.bucket.Background == 4
                % variable dimension exponential
                obj.Fixed(2) = 0;
                obj.Fixed(3) = 0;
                obj.Fixed(4) = 1;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'lambda'};
                obj.Name(3) = {'dimension'};
                obj.Name(4) = {'backgroundC'};
                obj.Name(5) = {'backgroundD'};
            elseif app.bucket.Background == 5
                % user 1
                obj.Fixed(2) = 1;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 1;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'backgroundA'};
                obj.Name(3) = {'backgroundB'};
                obj.Name(4) = {'backgroundC'};
                obj.Name(5) = {'backgroundD'};
            elseif app.bucket.Background == 6
                % user 2
                obj.Fixed(2) = 1;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 1;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'backgroundA'};
                obj.Name(3) = {'backgroundB'};
                obj.Name(4) = {'backgroundC'};
                obj.Name(5) = {'backgroundD'};
            elseif app.bucket.Background == 7
                % 3 dimensional exponential - concentration
                obj.Fixed(2) = 1;
                obj.Fixed(3) = 1;
                obj.Fixed(4) = 0;
                obj.Fixed(5) = 1;
                obj.Name(2) = {'lambda'};
                obj.Name(3) = {'dimension'};
                obj.Name(4) = {'concentration'};
                obj.Name(5) = {'backgroundD'};
            end
        end
        
        function specifyGlobalModel(obj,app,index)
            if index == 1
                return
            else
                mparams = length(obj.Name);
                if app.bucket.GlobalModel == 0
                    % nothing linked
                    for m = 1:mparams
                        obj.Experiment(m) = index;
                        obj.Link(m) = 0;
                    end
                elseif app.bucket.GlobalModel == 1
                    % depth not linked
                    for m = 1:mparams
                        obj.Experiment(m) = 1;
                        obj.Link(m) = m;
                    end
                    if app.bucket.Background == 1
                        obj.Experiment(4) = index;
                        obj.Link(4) = 0;
                    elseif app.bucket.Background ==2
                        obj.Experiment(2) = index;
                        obj.Link(2) = 0;
                    elseif app.bucket.Background ==7
                        obj.Experiment(2) = index;
                        obj.Link(2) = 0;
                    end
                    obj.Experiment(1) = index;
                    obj.Link(1) = 0;
                    obj.Experiment(6) = index;
                    obj.Link(6) = 0;
                    obj.Experiment(7) = index;
                    obj.Link(7) = 0;
                    obj.Experiment(8) = index;
                    obj.Link(8) = 0;
                elseif app.bucket.GlobalModel == 2
                    % depth and background not linked
                    for m = 1:8
                        obj.Experiment(m) = index;
                        obj.Link(m) = 0;
                    end
                    for m = 9:mparams
                        obj.Experiment(m) = 1;
                        obj.Link(m) = m;
                    end
                elseif app.bucket.GlobalModel == 3
                    % depth, background, and amplitudes not linked
                    for m = 1:8
                        obj.Experiment(m) = index;
                        obj.Link(m) = 0;
                    end
                    for m = 9:mparams
                        obj.Experiment(m) = 1;
                        obj.Link(m) = m;
                    end
                    for m = 18:5:mparams
                        obj.Experiment(m) = index;
                        obj.Link(m) = 0;
                    end
                elseif app.bucket.GlobalModel == 4
                    % depth and amplitudes not linked
                    for m = 1:mparams
                        obj.Experiment(m) = 1;
                        obj.Link(m) = m;
                    end
                    if app.bucket.Background == 1
                        obj.Experiment(4) = index;
                        obj.Link(4) = 0;
                    elseif app.bucket.Background ==2
                        obj.Experiment(2) = index;
                        obj.Link(2) = 0;
                    elseif app.bucket.Background ==7
                        obj.Experiment(2) = index;
                        obj.Link(2) = 0;
                    end
                    obj.Experiment(1) = index;
                    obj.Link(1) = 0;
                    obj.Experiment(6) = index;
                    obj.Link(6) = 0;
                    obj.Experiment(7) = index;
                    obj.Link(7) = 0;
                    obj.Experiment(8) = index;
                    obj.Link(8) = 0;
                    for m = 9:mparams
                        obj.Experiment(m) = 1;
                        obj.Link(m) = m;
                    end
                    for m = 18:5:mparams
                        obj.Experiment(m) = index;
                        obj.Link(m) = 0;
                    end
                elseif app.bucket.GlobalModel == 5
                    % Custom
                elseif app.bucket.GlobalModel == 5
                    % Custom
                end
            end
        end
    end
end
