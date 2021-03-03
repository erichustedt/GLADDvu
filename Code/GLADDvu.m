classdef GLADDvu < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        GLADDvuUIFigure           matlab.ui.Figure
        AddFilesButton            matlab.ui.control.Button
        ClearDataButton           matlab.ui.control.Button
        TabGroup                  matlab.ui.container.TabGroup
        Tab                       matlab.ui.container.Tab
        DataPanel                 matlab.ui.container.Panel
        UIAxesZero                matlab.ui.control.UIAxes
        AutoTruncateCheckBox      matlab.ui.control.CheckBox
        TruncateEditField         matlab.ui.control.NumericEditField
        AutoZeroCheckBox          matlab.ui.control.CheckBox
        ZeroEditField             matlab.ui.control.NumericEditField
        AutoPhaseCheckBox         matlab.ui.control.CheckBox
        PhaseEditField            matlab.ui.control.NumericEditField
        UIAxesData                matlab.ui.control.UIAxes
        FitPanel                  matlab.ui.container.Panel
        UIAxesFit                 matlab.ui.control.UIAxes
        AnswerTablePanel          matlab.ui.container.Panel
        AnswerTable               matlab.ui.control.Table
        P_R_Panel                 matlab.ui.container.Panel
        UIAxesP_R_                matlab.ui.control.UIAxes
        StatisticsTablePanel      matlab.ui.container.Panel
        StatisticsTable           matlab.ui.control.Table
        ViewButtonGroup           matlab.ui.container.ButtonGroup
        DataPanelButton           matlab.ui.control.RadioButton
        AnswerPanelButton         matlab.ui.control.RadioButton
        FitPanelButton            matlab.ui.control.RadioButton
        P_R_PanelButton           matlab.ui.control.RadioButton
        StatisticsPanelButton     matlab.ui.control.RadioButton
        ProcessButton             matlab.ui.control.Button
        InitializeButton          matlab.ui.control.Button
        AutoTruncateCheckBoxAll   matlab.ui.control.CheckBox
        TruncateEditFieldAll      matlab.ui.control.NumericEditField
        AutoPhaseCheckBoxAll      matlab.ui.control.CheckBox
        AutoZeroCheckBoxAll       matlab.ui.control.CheckBox
        ComponentsLabel           matlab.ui.control.Label
        ComponentsSpinner         matlab.ui.control.Spinner
        BackgroundDropDownLabel   matlab.ui.control.Label
        BackgroundDropDown        matlab.ui.control.DropDown
        GlobalDropDownLabel       matlab.ui.control.Label
        GlobalModelDropDown       matlab.ui.control.DropDown
        FitButton                 matlab.ui.control.Button
        OptionsButton             matlab.ui.control.Button
        ConstantsButton           matlab.ui.control.Button
        MethodDropDownLabel       matlab.ui.control.Label
        MethodDropDown            matlab.ui.control.DropDown
        EditField                 matlab.ui.control.EditField
        GenericTable              matlab.ui.control.Table
        SaveStatisticsButton      matlab.ui.control.Button
        ShapeDropDownLabel        matlab.ui.control.Label
        ShapeDropDown             matlab.ui.control.DropDown
        SaveResultsButton         matlab.ui.control.Button
        AutoFitCheckBox           matlab.ui.control.CheckBox
        ConfIntCheckBox           matlab.ui.control.CheckBox
        AIPCheckBox               matlab.ui.control.CheckBox
        ResultsBoxPanel           matlab.ui.container.Panel
        datasetsEditFieldLabel    matlab.ui.control.Label
        datasetsEditField         matlab.ui.control.NumericEditField
        parametersEditFieldLabel  matlab.ui.control.Label
        parametersEditField       matlab.ui.control.NumericEditField
        iterationsEditFieldLabel  matlab.ui.control.Label
        iterationsEditField       matlab.ui.control.NumericEditField
        redLabel                  matlab.ui.control.Label
        redEditField              matlab.ui.control.NumericEditField
        BICEditFieldLabel         matlab.ui.control.Label
        BICEditField              matlab.ui.control.NumericEditField
        WriteStatisticsButton     matlab.ui.control.Button
        ClearStatisticsButton     matlab.ui.control.Button
        SaveWindow2Button         matlab.ui.control.Button
        SaveWindow1Button         matlab.ui.control.Button
        All1SaveButton            matlab.ui.control.Button
    end

    properties (Access = public)
        bucket                      % storage bucket for miscellaneous
        view                        % specifies current selected view
        Ans = ANSWER.empty(0,0)     % structure for Answer
        Con = CONSTANTS();          % structure for all simulation Constants
        Data = DEERdata.empty(0,0)  % structure for all Data
        Opt = OPTIONS();            % structure for all Options
        Float = FLOAT.empty(0,0)    % structure for all Float parameters
        Fit = DEERcalc.empty(0,0)
    end
    
    methods (Access = private)
        
        function addTab(app,index,name)
            % Create UITab 1 plus 1 for each data set
            app.Tab(index) = uitab(app.TabGroup);
            app.Tab(index).Title = name;
            app.Tab(index).BackgroundColor = [0.825 0.825 0.825];
            app.Tab(index).ForegroundColor = [0 0 0.800];
            
            % Create Data Panel for plotting data
            app.DataPanel(index) = uipanel(app.Tab(index));
            app.DataPanel(index).BorderType = 'none';
            app.DataPanel(index).TitlePosition = 'centertop';
            app.DataPanel(index).Title = 'Data';
            app.DataPanel(index).Position = [10 10 750 460];
            app.DataPanel(index).Visible = 'on';
            app.DataPanel(index).Tag = 'Group 2';
            % Create UIAxesData
            app.UIAxesData(index) = uiaxes(app.DataPanel(index));
            xlabel(app.UIAxesData(index), 'Time (\mus)')
            if index == 1
                % axes for all data sets combined
                app.UIAxesData(index).Position = [10 10 730 420];
                app.UIAxesData(index).NextPlot = 'add';
            else
                % 2 -> n+1, axes for individual data sets
                app.UIAxesData(index).Position = [10 10 530 430];
                app.UIAxesData(index).NextPlot = 'add';
                % Create UIAxesZero
                app.UIAxesZero(index - 1) = uiaxes(app.DataPanel(index));
                xlabel(app.UIAxesZero(index - 1), 'Time (ns)');
                app.UIAxesZero(index - 1).NextPlot = 'add';
                app.UIAxesZero(index - 1).Position = [540 10 200 335];
                % Create AutoTruncateCheckBox
                app.AutoTruncateCheckBox(index - 1) = uicheckbox(app.DataPanel(index));
                app.AutoTruncateCheckBox(index - 1).Text = 'Auto Truncate';
                app.AutoTruncateCheckBox(index - 1).Position = [550 410 96.9375 15];
                app.AutoTruncateCheckBox(index - 1).Value = app.AutoTruncateCheckBoxAll.Value;
                % Create AutoPhaseCheckBox
                app.AutoPhaseCheckBox(index - 1) = uicheckbox(app.DataPanel(index));
                app.AutoPhaseCheckBox(index - 1).Text = 'Auto Phase';
                app.AutoPhaseCheckBox(index - 1).Position = [550 380 84.046875 15];
                app.AutoPhaseCheckBox(index - 1).Value = true;
                % Create AutoZeroCheckBox
                app.AutoZeroCheckBox(index - 1) = uicheckbox(app.DataPanel(index));
                app.AutoZeroCheckBox(index - 1).Text = 'Auto Zero';
                app.AutoZeroCheckBox(index - 1).Position = [550 350 74.703125 15];
                app.AutoZeroCheckBox(index - 1).Value = app.AutoZeroCheckBoxAll.Value;
                % Create TruncateEditField
                app.TruncateEditField(index - 1) = uieditfield(app.DataPanel(index), 'numeric');
                app.TruncateEditField(index - 1).ValueDisplayFormat = '%.0f';
                app.TruncateEditField(index - 1).Position = [675 407 65 22];
                app.TruncateEditField(index - 1).Value = app.TruncateEditFieldAll.Value;
                % Create PhaseEditField
                app.PhaseEditField(index - 1) = uieditfield(app.DataPanel(index), 'numeric');
                app.PhaseEditField(index - 1).ValueDisplayFormat = '%.1f';
                app.PhaseEditField(index - 1).Position = [675 377 65 22];
                app.AutoPhaseCheckBox(index - 1).Value = app.AutoPhaseCheckBoxAll.Value;
                % Create ZeroEditField
                app.ZeroEditField(index - 1) = uieditfield(app.DataPanel(index), 'numeric');
                app.ZeroEditField(index - 1).ValueDisplayFormat = '%.2f';
                app.ZeroEditField(index - 1).Position = [675 347 65 22];
            end
            
            % Create Table Panel for Answer Table
            app.AnswerTablePanel(index) = uipanel(app.Tab(index));
            app.AnswerTablePanel(index).BorderType = 'none';
            app.AnswerTablePanel(index).TitlePosition = 'centertop';
            app.AnswerTablePanel(index).Position = [10 10 750 460];
            app.AnswerTablePanel(index).Visible = 'off';
            app.AnswerTablePanel(index).Tag = 'Group 2';
            if index == 1
                % jtable for distance distribution
                app.AnswerTablePanel(index).Title = 'Distance Distribution';
            else
                % answer files for individual data sets
                app.AnswerTablePanel(index).Title = 'Answer File';
                app.AnswerTable(index-1) = uitable(app.AnswerTablePanel(index));
                app.AnswerTable(index-1).Position = [10 10 730 420];
                app.AnswerTable(index-1).ColumnName = {'Parameter'; 'Value'; 'Fixed'; ...
                    'Experiment';'Link'; 'Lower Limit'; 'Upper Limit'};
                app.AnswerTable(index-1).ColumnEditable = [false true true true true true true];
                app.AnswerTable(index-1).CellEditCallback = createCallbackFcn(app, @AnswerTableCellEdit, true);
                app.AnswerTable(index-1).UserData = index - 1;
            end
            
            % Create Fit Panel for plotting fits
            % index = 1 for all, 2->n+1 for individual
            app.FitPanel(index) = uipanel(app.Tab(index));
            app.FitPanel(index).BorderType = 'none';
            app.FitPanel(index).TitlePosition = 'centertop';
            app.FitPanel(index).Title = 'Fit';
            app.FitPanel(index).Position = [10 10 750 460];
            app.FitPanel(index).Visible = 'off';
            app.FitPanel(index).Tag = 'Group 2';
            % Create UIAxesFit
            app.UIAxesFit(index) = uiaxes(app.FitPanel(index));
            xlabel(app.UIAxesFit(index), 'Time (\mus)');
            app.UIAxesFit(index).NextPlot = 'add';
            app.UIAxesFit(index).Position = [10 10 730 420];
            
            % Create P(R) Panel for plotting distance distributions
            % index = 1 for all, 2->n+1 for individual
            app.P_R_Panel(index) = uipanel(app.Tab(index));
            app.P_R_Panel(index).BorderType = 'none';
            app.P_R_Panel(index).TitlePosition = 'centertop';
            app.P_R_Panel(index).Title = 'P(R)';
            app.P_R_Panel(index).Position = [10 10 750 460];
            app.P_R_Panel(index).Visible = 'off';
            app.P_R_Panel(index).Tag = 'Goup 2';
            %
            app.UIAxesP_R_(index) = uiaxes(app.P_R_Panel(index));
            xlabel(app.UIAxesP_R_(index), 'R (Å)');
            ylabel(app.UIAxesP_R_(index), 'P(R)');
            app.UIAxesP_R_(index).NextPlot = 'add';
            app.UIAxesP_R_(index).XLim = [0 app.Con.R_max];            % set x-axis scale
            app.UIAxesP_R_(index).XAxis.LimitsMode = 'manual';         % do not recalculate x-axis scale
            app.UIAxesP_R_(index).Position = [10 10 730 420];
            
            % Create Statistics Panel for BIC values (jtable)
            % only one panel for all statistics
            if index == 1
                app.StatisticsTablePanel = uipanel(app.Tab);
                app.StatisticsTablePanel.BorderType = 'none';
                app.StatisticsTablePanel.TitlePosition = 'centertop';
                app.StatisticsTablePanel.Title = 'Statistics';
                app.StatisticsTablePanel.Position = [10 10 750 460];
                app.StatisticsTablePanel.Visible = 'off';
                app.StatisticsTablePanel.Tag = 'Group 2';
                % Create StatisticsTable
                app.StatisticsTable = uitable(app.StatisticsTablePanel);
                app.StatisticsTable.ColumnName = {'N exps' 'Filename' 'n' 'Shape' 'Backgr.' 'Global Model' 'N' 'm' 'SSR' 'Red. Chi-squared' 'BIC' 'dBIC'};
                app.StatisticsTable.RowName = {};
                app.StatisticsTable.FontAngle = 'italic';
                app.StatisticsTable.Position = [10 10 730 420];
                app.StatisticsTable.ColumnWidth = {35 127 35 50 50 100 30 30 60 60 90 60};
            end
            
        end
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
      % This is code that should be in create fcn's below
      % specify UserData for ViewButtonGroup
      app.DataPanelButton.UserData = 1;
      app.AnswerPanelButton.UserData = 2;
      app.FitPanelButton.UserData = 3;
      app.P_R_PanelButton.UserData = 4;
      app.StatisticsPanelButton.UserData = 5;
      % specify ItemsData for BackgroundDropDown
      app.BackgroundDropDown.ItemsData = [0 1 2 3 4 5 6 7];
      % specify ItemsData for ShapeDropDown
      app.ShapeDropDown.ItemsData = [1 5 8 9 10 11];
      % specify ItemsData for GlobalModelDropDown
      app.GlobalModelDropDown.ItemsData = [0 1 2 3 4 5];
      % specify ItemsData for MethodDropDown
      app.MethodDropDown.ItemsData = [1 5 9];
      % number of data files is zero
      app.bucket.Nexps = 0;
      % initialize shape
      app.bucket.Shape = 1;
      % initialize background
      app.bucket.Background = 1;
      % 1 component
      app.bucket.Ncomps = 1;
      % initialize global model
      app.bucket.GlobalModel = 0;
      %
      app.bucket.Statistics = {};
      %
      app.Tab.delete;
      app.addTab(1,'All');

      app = SpecifyTags(app);
      % turn off panels until data is loaded
      app.DataPanel.Visible = 'off';
      app.AnswerTablePanel.Visible = 'off';
      app.FitPanel.Visible = 'off';
      app.P_R_Panel.Visible = 'off';
      app.StatisticsTablePanel.Visible = 'off';

      set(findall(0,'Tag','Group B'),'Enable','off');
      set(findall(0,'Tag','Group C'),'Enable','off');
      set(findall(0,'Tag','Group D'),'Enable','off');
        end

        % Button pushed function: AddFilesButton
        function AddFilesButtonPushed(app, event)
            % add new data function -------------
            [filename, directory, filetype] = uigetfile({ ...
                '*.DTA','Bruker Data Files (*.DTA)'; ...
                '*.TXT','TXT Data Files (*.TXT)'; ...
                '*.DAT','DAT Data Files (*.DAT)'},...
                'Open Data Files','MultiSelect','on');
            app.bucket.datadir = directory;
            if filetype == 0
                return;
            end
            app = SuspendAll(app);
            app.EditField.Value = 'Reading Data';
            app.EditField.FontColor = [0.0 0.0 0.5];
            % Below is necessary to restore app.UIFigure to top window
            app.GLADDvuUIFigure.Visible = 'off';
            app.GLADDvuUIFigure.Visible = 'on';
            %
            filename = cellstr(filename);
            index = app.bucket.Nexps;
            Nnew = length(filename);
            
            % allow axis scales to be updated
            app.UIAxesFit(1).XAxis.LimitsMode = 'auto';
            for itab = 1:app.bucket.Nexps + 1
                app.UIAxesData(itab).XAxis.LimitsMode = 'auto';
            end
            %
            for inew = 1:Nnew
                % do not add same filename twice
                lnew = false;
                if app.bucket.Nexps == 0
                    % if there is no data add file
                    lnew = true;
                else
                    % if filename is already loaded do not add
                    if ~strcmp(filename(inew),app.bucket.filename)
                        lnew = true;
                    end
                end
                if lnew
                    index = index + 1;
                    app.addTab(index + 1,char(filename(inew)));
                    app.bucket.filename(index) = filename(inew);
                    DataTemp = DEERdata(app,filename(inew),directory,filetype,index);
                    % append new DEERdata object to existing
                    app.Data = [app.Data,DataTemp];
                    AnsTemp = ANSWER(app,index);
                    % append new Ans object to existing
                    app.Ans = [app.Ans,AnsTemp];
                end
            end
            app.bucket.Nexps = index;
            app.datasetsEditField.Value = index;
            % plot data
            app = PlotData(app);
            % number of data points (after truncation) is zero
            app.bucket.Ndata = 0;
            % determine initial parameters and total number of data points
            temp_min = 1.;
            temp_max = 0.;
            for index = 1:app.bucket.Nexps
                % AIP checkbox is tested in DEER_AIP method - auto initialize parameters
                temp_min = min(temp_min,min(app.Data(index).deer_r));
                temp_max = max(temp_max,max(app.Data(index).deer_r));
                app.Data(index).DEER_AIP(app,index);
                app.bucket.Ndata = app.bucket.Ndata + app.Data(index).nfit;
            end
            range = temp_max - temp_min;
            temp_min = temp_min - 0.02*range;
            temp_max = temp_max + 0.02*range;
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata- app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            %
            app.FitPanelButton.Value = 1;
            app.view = 'Fit';
            for itab = 1:app.bucket.Nexps + 1
                app.DataPanel(itab).Visible = 'off';
                app.AnswerTablePanel(itab).Visible = 'off';
                app.FitPanel(itab).Visible = 'on';
                app.P_R_Panel(itab).Visible = 'off';
            end
            %
            legeD = legend(app.UIAxesData(1),[app.Data.Pd],string(app.bucket.filename));
            legeD.Interpreter = 'none';
            legeD.Box = 'off';
            if ~verLessThan('matlab','9.2')   % check if version earlier than 2017a
                legeD.AutoUpdate = 'off'; % never auto update legend - increases speed
            end
            app.bucket.legeF = legend(app.UIAxesFit(1),[app.Data.Pf],string(app.bucket.filename));
            app.bucket.legeF.Interpreter = 'none';
            app.bucket.legeF.Box = 'off';
            if ~verLessThan('matlab','9.2')   % check if version earlier than 2017a
                app.bucket.legeF.AutoUpdate = 'off'; % never auto update legend - increases speed
            end
            app.bucket.legeP = legend(app.UIAxesP_R_(1),string(app.bucket.filename));
            app.bucket.legeP.Interpreter = 'none';
            app.bucket.legeP.Box = 'off';
            if ~verLessThan('matlab','9.2')   % check if version earlier than 2017a
                app.bucket.legeP.AutoUpdate = 'off'; % never auto update legend - increases speed
            end
            % do not update axis scales
            app.UIAxesFit(1).XAxis.LimitsMode = 'manual';
            app.UIAxesFit(1).YAxis.Limits = [temp_min,temp_max];
            app.UIAxesData(1).YAxis.Limits = [temp_min,temp_max];
            for itab = 1:app.bucket.Nexps + 1
                app.UIAxesData(itab).XAxis.LimitsMode = 'manual';
                app.UIAxesData(itab).YAxis.LimitsMode = 'manual';
                % now set all x ticks to microseconds
                xt = arrayfun(@num2str,get(app.UIAxesData(itab),'xtick')*1e6,'un',0);
                set(app.UIAxesData(itab),'xticklabel',xt);
                xt = arrayfun(@num2str,get(app.UIAxesFit(itab),'xtick')*1e6,'un',0);
                set(app.UIAxesFit(itab),'xticklabel',xt);
            end
            % now set all x ticks to microseconds
            xt = arrayfun(@num2str,get(app.UIAxesData(1),'xtick')*1e6,'un',0);
            set(app.UIAxesData(1),'xticklabel',xt);
            %
            app = UnSuspendAll(app);
            app.EditField.Value = 'Data Read';
            app.EditField.FontColor = [0.0 0.5 0.0];
            %
            set(findall(0,'Tag','Group B'),'Enable','on')
            if app.bucket.Nexps > 1
                app.GlobalModelDropDown.Enable = 'on';
            else
                app.GlobalModelDropDown.Enable = 'off';
            end
            app.TabGroup.Visible = 'on';
        end

        % Button pushed function: ClearDataButton
        function ClearDataButtonPushed(app, event)
            %
            app.EditField.Value = 'Removing All Data';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            app.bucket.Nexps = 0;
            app.bucket = rmfield(app.bucket,'filename');
            app.Data = DEERdata.empty(0,0) ;
            app.Fit = DEERcalc.empty(0,0) ;
            %
            app.DataPanel = app.DataPanel.empty(0,0);
            app.AnswerTablePanel = app.AnswerTablePanel.empty(0,0);
            app.FitPanel = app.FitPanel.empty(0,0);
            app.P_R_Panel = app.P_R_Panel.empty(0,0);
            %
            app.UIAxesZero = app.UIAxesZero.empty(0,0);
            app.UIAxesData = app.UIAxesData.empty(0,0);
            %
            app = ClearResults(app);
            %
            app.AutoTruncateCheckBox = app.AutoTruncateCheckBox.empty(0,0);
            app.AutoPhaseCheckBox = app.AutoPhaseCheckBox.empty(0,0);
            app.AutoZeroCheckBox = app.AutoZeroCheckBox.empty(0,0);
            app.TruncateEditField = app.TruncateEditField.empty(0,0);
            app.PhaseEditField = app.PhaseEditField.empty(0,0);
            app.ZeroEditField = app.ZeroEditField.empty(0,0);
            %
            app.Ans = ANSWER.empty(0,0);
            app.AnswerTable = app.AnswerTable.empty(0,0);
            app.Tab = app.Tab.empty(0,0);
            %
            app.TabGroup.empty(0,0);
            app.TabGroup.Children.delete;
            %
            app.addTab(1,'All');
            %
            app.EditField.Value = 'Ready to Add Data';
            app.EditField.FontColor = [0.0 0.5 0.0];
            %
            app.EditField.Value = 'Data Cleared';
            app.EditField.FontColor = [0.0 0.5 0.0];
            app = UnSuspendAll(app);
            set(findall(0,'Tag','Group B'),'Enable','off');
            set(findall(0,'Tag','Group C'),'Enable','off');
            set(findall(0,'Tag','Group D'),'Enable','off');
            app.TabGroup.Visible = 'off';
        end

        % Selection changed function: ViewButtonGroup
        function ViewButtonGroupSelectionChanged(app, event)
      app = PanelSelectionFcn(app);
        end

        % Value changed function: MethodDropDown
        function MethodDropDownValueChanged(app, event)
            value = app.MethodDropDown.Value;
            if value == 1
                app.Opt.interiorpoint = true;
                app.Opt.globalsearch = false;
                app.Opt.particleswarm = false;
            elseif value == 5
                app.Opt.interiorpoint = false;
                app.Opt.globalsearch = true;
                app.Opt.particleswarm = false;
            elseif value == 9
                app.Opt.interiorpoint = false;
                app.Opt.globalsearch = false;
                app.Opt.particleswarm = true;
            end
            % if OPTIONS table is open change its selected minimization method
            if app.view
                temp = struct(app.Opt);
                app.GenericTable.Data = struct2cell(temp);
            end
        end
        
        % Cell edit callback: GenericTable: Constants
        function ConstantsEditFcn(app, event)
            app.EditField.Value = 'Editing Constants';
            app.EditField.FontColor = [0.0 0.0 0.5];
            itemp = event.Indices(1);
            ftemp = fieldnames(app.Con);
            ftemp = char(ftemp(itemp));
            app.Con.(ftemp) = event.NewData;
        end

        % Button pushed function: OptionsButton
        function OptionsButtonPushed(app, event)
            if ~strcmp(app.view,'Options')
                app = SuspendAll(app);
                app.view = 'Options';
                temp = struct(app.Opt);
                app.GenericTable.RowName = fieldnames(temp);
                app.GenericTable.Data = struct2cell(temp);
                app.GenericTable.ColumnName = 'Values';
                app.GenericTable.ColumnEditable = true;
                app.GenericTable.CellEditCallback = createCallbackFcn(app, @OptionsEditFcn, true);
                app.GenericTable.ForegroundColor = [0 0 0];
                app.GenericTable.Visible = 'on';
                app.GenericTable.Enable = 'on';
                app.OptionsButton.Enable = 'on';
                app.TabGroup.Visible = 'off';
            else
                app.GenericTable.Enable = 'off';
                app.GenericTable.Visible = 'off';
                app = PanelSelectionFcn(app);
                app = UnSuspendAll(app);
                app.TabGroup.Visible = 'on';
            end
        end

        % Button pushed function: SaveStatisticsButton
        function SaveStatisticsButtonPushed(app, event)
      app.EditField.Value = 'Saving Fit Statistics';
      app.EditField.FontColor = [0.0 0.0 0.5];
      app = SuspendAll(app);
      app = SaveStatistics(app);
      app.EditField.Value = 'Fit Statistics Saved';
      app.EditField.FontColor = [0.0 0.5 0.0];
      app = UnSuspendAll(app);
      set(findall(0,'Tag','Group D'),'Enable','on');
      app.ViewButtonGroup.SelectedObject = app.StatisticsPanelButton;
      app = PanelSelectionFcn(app);
        end

        % Button pushed function: ConstantsButton
        function ConstantsButtonPushed(app, event)
            if ~strcmp(app.view,'Constants')
                app = SuspendAll(app);
                app.view = 'Constants';
                temp = struct(app.Con);
                app.GenericTable.RowName = fieldnames(temp);
                app.GenericTable.Data = struct2cell(temp);
                app.GenericTable.ColumnName = 'Values';
                app.GenericTable.ColumnEditable = true;
                app.GenericTable.CellEditCallback = createCallbackFcn(app, @ConstantsEditFcn, true);
                app.GenericTable.ForegroundColor = [0 0 0];
                app.GenericTable.Visible = 'on';
                app.GenericTable.Enable = 'on';
                app.ConstantsButton.Enable = 'on';
                app.TabGroup.Visible = 'off';
            else
                app.GenericTable.Enable = 'off';
                app.GenericTable.Visible = 'off';
                app = PanelSelectionFcn(app);
                % perform initial calculations
                try
                  % number of iterations is zero
                  app.bucket.Iter = 0;
                  app = InitializeCalcs(app);
                catch
                end
                app.EditField.FontColor = [0.0 0.5 0.0];
                app.EditField.Value = 'Initialized';
                app = UnSuspendAll(app);
            end
        end

        % Callback function
        function OptionsEditFcn(app, event)
            app.EditField.Value = 'Editing Options';
            app.EditField.FontColor = [0.0 0.5 0.0];
            itemp = event.Indices(1);
            ftemp = fieldnames(app.Opt);
            ftemp = char(ftemp(itemp));
            if itemp == 1 ||  itemp == 5 ||  itemp == 9
                app.Opt.interiorpoint = false;
                app.Opt.globalsearch = false;
                app.Opt.particleswarm = false;
                if event.NewData == true
                    app.Opt.(ftemp) = true;
                    temp = struct(app.Opt);
                    app.GenericTable.Data = struct2cell(temp);
                    %
                    app.EditField.Value = ftemp;
                    app.EditField.FontColor = [0.00 0.50 0.00];
                    app.MethodDropDown.Value = itemp;
                    %
                    app.ViewButtonGroup.Visible = 'on';
                    app.AutoTruncateCheckBoxAll.Visible = 'on';
                    app.TruncateEditFieldAll.Visible = 'on';
                    app.AutoPhaseCheckBoxAll.Visible = 'on';
                    app.AutoZeroCheckBoxAll.Visible = 'on';
                    app.ClearDataButton.Visible = 'on';
                    app.AddFilesButton.Visible = 'on';
                    app.ProcessButton.Visible = 'on';
                    app.InitializeButton.Visible = 'on';
                    app.ComponentsSpinner.Visible = 'on';
                    % app.AutoFitCheckBox.Visible = 'on';
                    % app.BackgroundDropDown.Visible = 'on';
                    app.GlobalModelDropDown.Visible = 'on';
                    app.FitButton.Visible = 'on';
                    % app.ConfIntCheckBox.Visible = 'on';
                    app.OptionsButton.Visible = 'on';
                    app.ConstantsButton.Visible = 'on';
                    app.SaveStatisticsButton.Visible = 'on';
                    app.SaveResultsButton.Visible = 'on';
                    app.MethodDropDown.Visible = 'on';
                else
                    app.EditField.Value = 'select a minimization method';
                    app.EditField.FontColor = [0.50 0.00 0.00];
                    %
                    app.ViewButtonGroup.Visible = 'off';
                    app.AutoTruncateCheckBoxAll.Visible = 'off';
                    app.TruncateEditFieldAll.Visible = 'off';
                    app.AutoPhaseCheckBoxAll.Visible = 'off';
                    app.AutoZeroCheckBoxAll.Visible = 'off';
                    app.ClearDataButton.Visible = 'off';
                    app.AddFilesButton.Visible = 'off';
                    app.ProcessButton.Visible = 'off';
                    app.InitializeButton.Visible = 'off';
                    app.ComponentsSpinner.Visible = 'off';
                    app.AutoFitCheckBox.Visible = 'off';
                    app.BackgroundDropDown.Visible = 'off';
                    app.GlobalModelDropDown.Visible = 'off';
                    app.FitButton.Visible = 'off';
                    app.ConfIntCheckBox.Visible = 'off';
                    app.OptionsButton.Visible = 'off';
                    app.ConstantsButton.Visible = 'off';
                    app.SaveStatisticsButton.Visible = 'off';
                    app.SaveResultsButton.Visible = 'off';
                    app.MethodDropDown.Visible = 'off';
                end
            else
                app.Opt.(ftemp) = event.NewData;
            end
        end

        % Value changed function: ComponentsSpinner
        function ComponentsSpinnerValueChanged(app, event)
            app.EditField.Value = 'Initializing';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            app.bucket.Ncomps = app.ComponentsSpinner.Value;
            %
            for index = 1:app.bucket.Nexps
                app.Ans(index).specifyComponents(app,index);
            end
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata - app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            app = UnSuspendAll(app);
            app.EditField.Value = 'Initialized';
            app.EditField.FontColor = [0.0 0.5 0.0];
        end

        % Value changed function: BackgroundDropDown
        function BackgroundChangedFcn(app, event)
            if event.Value == 5 || event.Value == 6
                app.EditField.Value = 'User background not yet implemented';
                app.EditField.FontColor = [0.5 0.0 0.0];
                app.BackgroundDropDown.Value = event.PreviousValue;
                return;
            end
            app.EditField.Value = 'Initializing';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            app.bucket.Background = app.BackgroundDropDown.Value;
            %
            for index = 1:app.bucket.Nexps
                app.Ans(index).specifyBackground(app);
            end
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata- app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            app = UnSuspendAll(app);
            app.EditField.Value = 'Initialized';
            app.EditField.FontColor = [0.0 0.5 0.0];
        end

        % Value changed function: GlobalModelDropDown
        function GlobalModelChangedFcn(app, event)
            app.EditField.Value = 'Initializing';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            app.bucket.GlobalModel = app.GlobalModelDropDown.Value;
            %
            for index = 2:app.bucket.Nexps
                app.Ans(index).specifyGlobalModel(app,index);
            end
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata- app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            app = UnSuspendAll(app);
            app.EditField.Value = 'Initialized';
            app.EditField.FontColor = [0.0 0.5 0.0];
        end

        % Value changed function: ShapeDropDown
        function ShapeChangedFcn(app, event)
            app.EditField.Value = 'Initializing';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            app.bucket.Shape = app.ShapeDropDown.Value;
            %
            for index = 1:app.bucket.Nexps
                app.Ans(index).specifyShape(app);
            end
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata- app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            app = UnSuspendAll(app);
            app.EditField.Value = 'Initialized';
            app.EditField.FontColor = [0.0 0.5 0.0];
        end

        % Button pushed function: ProcessButton
        function ProcessButtonPushed(app, event)
            app.EditField.Value = 'Processing Data';
            app.EditField.FontColor = [0.0 0.0 0.5];
            % one change at a time. disable some input
            app = SuspendAll(app);
            % delete existing plots
            temp = findobj(app.UIAxesData(1),'Type','Line');
            delete(temp);
            temp = findobj(app.UIAxesFit(1),'Type','Line');
            delete(temp);
            temp = findobj(app.UIAxesFit(1),'Type','Text');
            delete(temp);
            temp = findobj(app.UIAxesP_R_(1),'Type','Line');
            delete(temp);
            for index = 1:app.bucket.Nexps
                temp = findobj(app.UIAxesData(index+1),'Type','Line');
                delete(temp);
                temp = findobj(app.UIAxesData(index+1),'Type','Text');
                delete(temp);
                temp = findobj(app.UIAxesZero(index),'Type','Line');
                delete(temp);
                temp = findobj(app.UIAxesZero(index),'Type','Text');
                delete(temp);
                yyaxis(app.UIAxesFit(index+1),'right');
                temp = findobj(app.UIAxesFit(index+1),'Type','Line');
                delete(temp);
                yyaxis(app.UIAxesFit(index+1),'left');
                temp = findobj(app.UIAxesFit(index+1),'Type','Line');
                delete(temp);
                temp = findobj(app.UIAxesFit(index+1),'Type','Text');
                delete(temp);
                temp = findobj(app.UIAxesP_R_(index+1),'Type','Line');
                delete(temp);
            end
            clear temp;
            app.EditField.Value = 'Initializing';
            app.EditField.FontColor = [0.0 0.0 0.5];
            for index = 1:app.bucket.Nexps
                app.Data(index).DEER_Truncate(app,index);
                temp(index) = app.Data(index).deer_t0(end); % need this for setting XLim
            end
            % plot data
            app = PlotData(app);
            % manually rescale x axes
            temp = max(temp);
            app.UIAxesFit(1).XLim = [app.UIAxesFit(1).XLim(1) temp + 250.e-09];
            app.UIAxesData(1).XLim = [app.UIAxesData(1).XLim(1) temp + 250.e-09];
            xt = arrayfun(@num2str,get(app.UIAxesData(1),'xtick')*1e6,'un',0);
            set(app.UIAxesData(1),'xticklabel',xt);
            xt = arrayfun(@num2str,get(app.UIAxesFit(1),'xtick')*1e6,'un',0);
            set(app.UIAxesFit(1),'xticklabel',xt);
            % number of data points (after truncation) is zero
            app.bucket.Ndata = 0;
            % determine initial parameters and total number of data points
            for index = 1:app.bucket.Nexps
                % AIP checkbox is tested in DEER_AIP method
                app.Data(index).DEER_AIP(app,index);
                app.bucket.Ndata = app.bucket.Ndata + app.Data(index).nfit;
            end
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata- app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            app = UnSuspendAll(app);                      % enable some input
            app.EditField.Value = 'Initialized';
            app.EditField.FontColor = [0.0 0.5 0.0];
        end

        % Button pushed function: InitializeButton
        function InitializeButtonPushed(app, event)
            app.EditField.Value = 'Initializing';
            app.EditField.FontColor = [0.0 0.0 0.5];
            if isempty(app.bucket.Suspended)
                app = SuspendAll(app);
            end
            % impose links
            app.Ans = ImposeLinks(app.Ans,app.bucket.Nexps);
            % update answer tables
            app.AnswerTable = AnswerTableUpdate(app);
            %
            app.Float = FLOAT(app.Ans,app.bucket.Nexps);
            app.parametersEditField.Value = app.Float.Nfloat;
            app.bucket.NDegFree = app.bucket.Ndata- app.Float.Nfloat;
            % number of iterations is zero
            app.bucket.Iter = 0;
            % perform initial calculations
            app = InitializeCalcs(app);
            app = UnSuspendAll(app);
            app.EditField.Value = 'Initialized';
            app.EditField.FontColor = [0.0 0.5 0.0];
        end

        % Button pushed function: FitButton
        function FitButtonPushed(app, event)
            % disable other buttons
            app.EditField.Value = 'Fitting Data';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            % change panel view
            app.ViewButtonGroup.SelectedObject = app.FitPanelButton;
            app = PanelSelectionFcn(app);
            app.TabGroup.SelectedTab = app.Tab(1);
            %
            app.EditField.Value = strcat(string ...
                (app.MethodDropDown.Items(find ...
                (app.MethodDropDown.ItemsData==app.MethodDropDown.Value)))," running");
            app.EditField.FontColor = [0.0 0.0 0.5];
            drawnow;
            chisquaredhandle = @(floatvalues,extra)chisquared_DEER_driver_Gvu(floatvalues,app);
            [ app, exitflag, endreason ] = FITroutines_Gvu( chisquaredhandle, app );
            % enable other buttons
            app = UnSuspendAll(app);
            set(findall(0,'Tag','Group C'),'Enable','on');
            %
        end

        % Button pushed function: SaveResultsButton
        function SaveResultsButtonPushed(app, event)
            app.EditField.Value = 'Saving Results';
            app.EditField.FontColor = [0.0 0.0 0.5];
            if isempty(app.bucket.Suspended)
                app = SuspendAll(app);
            end
            [savename,savepath,savetype] = uiputfile({'*.xlsx','Excel File (*.xlsx)'; ...
                '*.dat',  'ASCII File (*.dat)'; ...
                '*.mat','MAT-file (*.mat)'},'Save Results',...
                [app.bucket.datadir,'Results']);
            [app] = SaveResults(app,savepath,savename,savetype);
            app = UnSuspendAll(app);
            app.EditField.FontColor = [0.0 0.5 0.0];
            app.EditField.Value = 'Results Written to File';
        end

        % Cell edit callback: AnswerTable
        function AnswerTableCellEdit(app, event)
            % modified 9/27/2019 - EJH
            app.EditField.Value = 'Answer Table Edited - Please Initialize';
            app.EditField.FontColor = [0.0 0.0 0.5];
            if isempty(app.bucket.Suspended)
                app = SuspendAll(app);
            end
            row_edited = event.Indices(1);
            column_edited = event.Indices(2);
            index_edited = event.Source.UserData;
            old_value = event.PreviousData;
            new_value = event.NewData;
            % make answer tables editable
            for index = 1:app.bucket.Nexps
                app.AnswerTable(index).Enable = 'on';
            end
            %
            if row_edited == 13
                % cannot change amp_1
                new_value = old_value;
                app.AnswerTable(index_edited).Data(row_edited,column_edited) = num2cell(new_value);
                return
            end
            %
            if column_edited == 2
                % change to Value column - Check Limits
                ll = app.Ans(index_edited).LowerLimit(row_edited);
                ul = app.Ans(index_edited).UpperLimit(row_edited);
                if new_value < ll
                    new_value = ll;
                    app.AnswerTable(index_edited).Data(row_edited,column_edited) = num2cell(new_value);
                elseif new_value > ul
                    new_value = ul;
                    app.AnswerTable(index_edited).Data(row_edited,column_edited) = num2cell(new_value);
                end
                app.Ans(index_edited).Value(row_edited) = new_value;
            elseif column_edited == 3 
                % change to Fixed column - Check if zero or one
                if ~(new_value == 0 || new_value == 1)
                  new_value = old_value;
                  app.AnswerTable(index_edited).Data(row_edited,column_edited) = num2cell(new_value);
                end
                app.Ans(index_edited).Fixed(row_edited) = new_value;
            elseif column_edited == 4
                % change to Experiment column - Must be integer between 1 and Nexps
                if ~(floor(new_value) == new_value) || new_value < 1 || new_value > app.bucket.Nexps
                    new_value = old_value; % if not valid revert to previous value
                    app.AnswerTable(index_edited).Data(row_edited,column_edited) = num2cell(new_value);
                else
                    % set to new value
                    app.Ans(index_edited).Experiment(row_edited) = new_value; 
                    % set global model to custom
                    app.GlobalModelDropDown.Value = 5;
                    app.bucket.GlobalModel = app.GlobalModelDropDown.Value;
                    % if current Link is zero set to row_edited
                    if new_value ~= index_edited
                      % new value is not experiment number - change Link
                      if cell2mat(app.AnswerTable(index_edited).Data(row_edited,5)) == 0
                        app.AnswerTable(index_edited).Data(row_edited,5) = num2cell(row_edited);
                        app.Ans(index_edited).Link(row_edited) = row_edited;
                      end
                    else
                      app.AnswerTable(index_edited).Data(row_edited,5) = num2cell(0);
                      app.Ans(index_edited).Link(row_edited) = 0;
                    end
                end
            elseif column_edited == 5
                % change to Link column - Must be integer between 0 and number of parameters
                if ~(floor(new_value) == new_value) || new_value < 0 || new_value > length(app.Ans(index_edited).Value)
                    new_value = old_value;
                    app.AnswerTable(index_edited).Data(row_edited,column_edited) = num2cell(new_value);
                end
                app.Ans(index_edited).Link(row_edited) = new_value;
                % set global model to custom
                app.GlobalModelDropDown.Value = 5;
                app.bucket.GlobalModel = app.GlobalModelDropDown.Value;
            elseif column_edited == 6
                % change to Lower Limit or Upper Limit column
                app.Ans(index_edited).LowerLimit(row_edited) = new_value;
            elseif column_edited == 7
                % change to Upper Limit or Upper Limit column
                app.Ans(index_edited).UpperLimit(row_edited) = new_value;
            end
            app.InitializeButton.Enable = 'on';
        end

        % Value changed function: TruncateEditFieldAll
        function TruncateEditFieldAllValueChanged(app, event)
      value = app.TruncateEditFieldAll.Value;
      for index = 1:app.bucket.Nexps
        app.TruncateEditField(index).Value = value;
      end
        end

        % Button pushed function: WriteStatisticsButton
        function WriteStatisticsButtonPushed(app, event)
            [file,path] = uiputfile('*.xlsx','Save As:',app.bucket.datadir);
            if exist(strcat(path,file)) == 2
                delete(strcat(path,file));
            end
            out = [app.StatisticsTable.ColumnName';app.StatisticsTable.Data];
            % this instance of xlswrite is ok
            xlswrite(strcat(path,file),out);
        end

        % Button pushed function: ClearStatisticsButton
        function ClearStatisticsButtonPushed(app, event)
          answer = questdlg('Do you want to delete all saved statistics?', ...
            'Clear Statitics?','Yes','No');
          if strcmp(answer,'Yes')
            app.bucket.Statistics = {};
            app.StatisticsTable.Data = app.bucket.Statistics;
            set(findall(0,'Tag','Group D'),'Enable','off');
          end
        end

        % Button pushed function: SaveWindow2Button
        function SaveWindow2ButtonPushed(app, event)
            app.EditField.Value = 'Saving Figure';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            [savename,savepath,~] = uiputfile({'*.jpg','JPEG (*.jpg)'; ...
                '*.png',  'Portable Network Graphics (*.png)'},'Save Results',[pwd,'\Figure']);
            try
                
                tempTab = app.TabGroup.SelectedTab;
                holdTabColor = tempTab.BackgroundColor;
                tempTab.BackgroundColor = 'w';
                tempPanel = findall(tempTab,'Type','uipanel','Visible','on');
                holdPanelColor = tempPanel.BackgroundColor;
                tempPanel.BackgroundColor = 'w';
                if contains(app.view,{'Fit' 'P(R)'})
                    tempAxes = findall(tempPanel,'Type','axes');
                    axePos = tempAxes.Position;
                    holdAxesColor = tempAxes.BackgroundColor;
                    tempAxes.BackgroundColor = 'w';
                elseif contains(app.view,{'Data'})
                    tempAxes = findall(tempPanel,'Type','axes');
                    tempAxes = tempAxes(2);
                    axePos = tempAxes.Position;
                    holdAxesColor = tempAxes.BackgroundColor;
                    tempAxes.BackgroundColor = 'w';
                else
                    axePos = [10 20 750 460];
                end
                pause(1);
                guiPos = app.GLADDvuUIFigure.Position;
                panelPos = tempPanel.Position;
                robot = java.awt.Robot();
                JsSize = java.awt.Toolkit.getDefaultToolkit().getScreenSize();
                MsSize = get(0,'ScreenSize');
                hcorr = JsSize.width/MsSize(3);
                vcorr = JsSize.height/MsSize(4);
                temp(1) = (guiPos(1) + panelPos(1) + axePos(1) - 2)*hcorr;
                temp(2) = (guiPos(2) + panelPos(2) + axePos(1) - 2)*vcorr;
                temp(3) = (axePos(3)-2)*hcorr;
                temp(4) = (axePos(4)-2)*vcorr;
                temp(2) = JsSize.height - (temp(2) + temp(4));
                pos = [temp(1) temp(2) 1.02*temp(3) 1.02*temp(4)];
                rect = java.awt.Rectangle(pos(1),pos(2),pos(3),pos(4));
                cap = robot.createScreenCapture(rect);
                rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
                imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
                imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
                imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
                imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
                imwrite(imgData,[savepath,savename]);
                tempTab.BackgroundColor = holdTabColor;
                tempPanel.BackgroundColor = holdPanelColor;
                if contains(app.view,{'Data' 'Fit' 'P(R)'})
                    tempAxes.BackgroundColor = holdAxesColor;
                end
                drawnow;
                app.EditField.Value = 'Figure Saved';
                app.EditField.FontColor = [0.0 0.5 0.0];
            catch
                app.EditField.Value = 'Error Saving Figure';
                app.EditField.FontColor = [0.5 0.0 0.0];
            end
            app = UnSuspendAll(app);
        end

        % Button pushed function: SaveWindow1Button
        function SaveWindow1ButtonPushed(app, event)
            app.EditField.Value = 'Saving Figure';
            app.EditField.FontColor = [0.0 0.0 0.5];
            app = SuspendAll(app);
            [savename,savepath,savetype] = uiputfile({'*.jpg','JPEG (*.jpg)'; ...
                '*.png', 'Portable Network Graphics (*.png)';'*.fig', 'Matlab Figure (*.fig)'}, ...
                'Save Results',[pwd,'\Figure']);
            try
                if contains(app.view,{'Data' 'Fit' 'P(R)'})
                    app = SaveWindow1(app,savename,savepath,savetype);
                    app.EditField.Value = 'Figure Saved';
                    app.EditField.FontColor = [0.0 0.5 0.0];
                else
                    app.EditField.Value = 'Method only works for plots';
                    app.EditField.FontColor = [0.5 0.0 0.0];
                end
            catch
                app.EditField.Value = 'Error Saving Figure';
                app.EditField.FontColor = [0.5 0.0 0.0];
            end
            app = UnSuspendAll(app);
        end

        % Button pushed function: All1SaveButton
        function Save1ClickButtonPushed(app, event)
          app.EditField.Value = 'Saving Results, Figures, and Statistics';
          app.EditField.FontColor = [0.0 0.0 0.5];
          app = SuspendAll(app);
          [app.bucket.savename,savepath,savetype] = uiputfile({'*.xlsx','Excel File (*.xlsx)'; ...
            '*.dat',  'ASCII File (*.dat)'; ...
            '*.mat','MAT-file (*.mat)'},'Save Results',...
            [app.bucket.datadir,'Results']);
          [app] = SaveResults(app,savepath,app.bucket.savename,savetype);
          app.EditField.FontColor = [0.0 0.5 0.0];
          app.EditField.Value = 'Results Written to File'; 
          [~,name,~] = fileparts(app.bucket.savename);
          temp = [name '_Fits.fig'];
          savetype = 3;
          app.ViewButtonGroup.SelectedObject = app.FitPanelButton;
          app = PanelSelectionFcn(app);
          app = SaveWindow1(app,temp,savepath,savetype);
          temp = [name '_P(R).fig'];
          savetype = 3;
          app.ViewButtonGroup.SelectedObject = app.P_R_PanelButton;
          app = PanelSelectionFcn(app);
          app = SaveWindow1(app,temp,savepath,savetype);
          app = SaveStatistics(app);
          app.EditField.Value = 'Fit Statistics Saved';
          app = UnSuspendAll(app);
          set(findall(0,'Tag','Group D'),'Enable','on');
          app.EditField.FontColor = [0.0 0.5 0.0];
          app.EditField.Value = 'Results, Figures, and Statistics Saved';
          app.bucket.savename = [];
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create GLADDvuUIFigure and hide until all components are created
            app.GLADDvuUIFigure = uifigure('Visible', 'off');
            app.GLADDvuUIFigure.Position = [100 50 1000 600];
            app.GLADDvuUIFigure.Name = 'GLADDvu';
            app.GLADDvuUIFigure.Resize = 'off';

            % Create AddFilesButton
            app.AddFilesButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.AddFilesButton.ButtonPushedFcn = createCallbackFcn(app, @AddFilesButtonPushed, true);
            app.AddFilesButton.BackgroundColor = [0.749 1 0.749];
            app.AddFilesButton.Position = [920 522 70 20];
            app.AddFilesButton.Text = 'Add FIles';

            % Create ClearDataButton
            app.ClearDataButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.ClearDataButton.ButtonPushedFcn = createCallbackFcn(app, @ClearDataButtonPushed, true);
            app.ClearDataButton.BackgroundColor = [1 0.749 0.749];
            app.ClearDataButton.Enable = 'off';
            app.ClearDataButton.Position = [920 560 70 20];
            app.ClearDataButton.Text = 'Clear Data';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GLADDvuUIFigure);
            app.TabGroup.Visible = 'off';
            app.TabGroup.Position = [10 10 770 510];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Tab';
            app.Tab.BackgroundColor = [0.827450980392157 0.827450980392157 0.827450980392157];
            app.Tab.ForegroundColor = [0 0 0.803921568627451];

            % Create DataPanel
            app.DataPanel = uipanel(app.Tab);
            app.DataPanel.BorderType = 'none';
            app.DataPanel.TitlePosition = 'centertop';
            app.DataPanel.Title = 'Data';
            app.DataPanel.Visible = 'off';
            app.DataPanel.Position = [10 20 750 460];

            % Create UIAxesZero
            app.UIAxesZero = uiaxes(app.DataPanel);
            app.UIAxesZero.DataAspectRatio = [1 1 1];
            app.UIAxesZero.PlotBoxAspectRatio = [1 1 1];
            app.UIAxesZero.XLim = [0 1];
            app.UIAxesZero.YLim = [0 1];
            app.UIAxesZero.ZLim = [0 1];
            app.UIAxesZero.CLim = [0 1];
            app.UIAxesZero.GridColor = [0.15 0.15 0.15];
            app.UIAxesZero.GridAlpha = 0.15;
            app.UIAxesZero.MinorGridColor = [0.1 0.1 0.1];
            app.UIAxesZero.MinorGridAlpha = 0.25;
            app.UIAxesZero.XColor = [0.15 0.15 0.15];
            app.UIAxesZero.XTick = [0 0.5 1];
            app.UIAxesZero.YColor = [0.15 0.15 0.15];
            app.UIAxesZero.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.UIAxesZero.ZColor = [0.15 0.15 0.15];
            app.UIAxesZero.ZTick = [0 0.5 1];
            app.UIAxesZero.CameraPosition = [0.5 0.5 9.16025403784439];
            app.UIAxesZero.CameraTarget = [0.5 0.5 0.5];
            app.UIAxesZero.CameraUpVector = [0 1 0];
            app.UIAxesZero.Position = [560 81 180 200];

            % Create AutoTruncateCheckBox
            app.AutoTruncateCheckBox = uicheckbox(app.DataPanel);
            app.AutoTruncateCheckBox.Text = 'Auto Truncate';
            app.AutoTruncateCheckBox.Position = [610 410 95 15];
            app.AutoTruncateCheckBox.Value = true;

            % Create TruncateEditField
            app.TruncateEditField = uieditfield(app.DataPanel, 'numeric');
            app.TruncateEditField.ValueDisplayFormat = '%.0f';
            app.TruncateEditField.Position = [675 420 65 22];

            % Create AutoZeroCheckBox
            app.AutoZeroCheckBox = uicheckbox(app.DataPanel);
            app.AutoZeroCheckBox.Text = 'Auto Zero';
            app.AutoZeroCheckBox.Position = [609 364 74.703125 15];
            app.AutoZeroCheckBox.Value = true;

            % Create ZeroEditField
            app.ZeroEditField = uieditfield(app.DataPanel, 'numeric');
            app.ZeroEditField.ValueDisplayFormat = '%.2f';
            app.ZeroEditField.Position = [675 360 65 22];

            % Create AutoPhaseCheckBox
            app.AutoPhaseCheckBox = uicheckbox(app.DataPanel);
            app.AutoPhaseCheckBox.Text = 'Auto Phase';
            app.AutoPhaseCheckBox.Position = [609 392 84.046875 15];
            app.AutoPhaseCheckBox.Value = true;

            % Create PhaseEditField
            app.PhaseEditField = uieditfield(app.DataPanel, 'numeric');
            app.PhaseEditField.ValueDisplayFormat = '%.1f';
            app.PhaseEditField.Position = [675 390 65 22];

            % Create UIAxesData
            app.UIAxesData = uiaxes(app.DataPanel);
            title(app.UIAxesData, 'Title')
            xlabel(app.UIAxesData, 'X')
            ylabel(app.UIAxesData, 'Y')
            app.UIAxesData.DataAspectRatio = [1 1 1];
            app.UIAxesData.PlotBoxAspectRatio = [1 1 1];
            app.UIAxesData.XLim = [0 1];
            app.UIAxesData.YLim = [0 1];
            app.UIAxesData.ZLim = [0 1];
            app.UIAxesData.CLim = [0 1];
            app.UIAxesData.GridColor = [0.15 0.15 0.15];
            app.UIAxesData.GridAlpha = 0.15;
            app.UIAxesData.MinorGridColor = [0.1 0.1 0.1];
            app.UIAxesData.MinorGridAlpha = 0.25;
            app.UIAxesData.XColor = [0.15 0.15 0.15];
            app.UIAxesData.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.UIAxesData.YColor = [0.15 0.15 0.15];
            app.UIAxesData.YTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.UIAxesData.ZColor = [0.15 0.15 0.15];
            app.UIAxesData.ZTick = [0 0.5 1];
            app.UIAxesData.CameraPosition = [0.5 0.5 9.16025403784439];
            app.UIAxesData.CameraTarget = [0.5 0.5 0.5];
            app.UIAxesData.CameraUpVector = [0 1 0];
            app.UIAxesData.Position = [10 80 500 350];

            % Create FitPanel
            app.FitPanel = uipanel(app.Tab);
            app.FitPanel.BorderType = 'none';
            app.FitPanel.TitlePosition = 'centertop';
            app.FitPanel.Title = 'Fit';
            app.FitPanel.Visible = 'off';
            app.FitPanel.Position = [10 20 750 460];

            % Create UIAxesFit
            app.UIAxesFit = uiaxes(app.FitPanel);
            title(app.UIAxesFit, 'Title')
            xlabel(app.UIAxesFit, 'X')
            ylabel(app.UIAxesFit, 'Y')
            app.UIAxesFit.DataAspectRatio = [1 1 1];
            app.UIAxesFit.PlotBoxAspectRatio = [1 1 1];
            app.UIAxesFit.XLim = [0 1];
            app.UIAxesFit.YLim = [0 1];
            app.UIAxesFit.ZLim = [0 1];
            app.UIAxesFit.CLim = [0 1];
            app.UIAxesFit.GridColor = [0.15 0.15 0.15];
            app.UIAxesFit.GridAlpha = 0.15;
            app.UIAxesFit.MinorGridColor = [0.1 0.1 0.1];
            app.UIAxesFit.MinorGridAlpha = 0.25;
            app.UIAxesFit.XColor = [0.15 0.15 0.15];
            app.UIAxesFit.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.UIAxesFit.YColor = [0.15 0.15 0.15];
            app.UIAxesFit.YTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.UIAxesFit.ZColor = [0.15 0.15 0.15];
            app.UIAxesFit.ZTick = [0 0.5 1];
            app.UIAxesFit.CameraPosition = [0.5 0.5 9.16025403784439];
            app.UIAxesFit.CameraTarget = [0.5 0.5 0.5];
            app.UIAxesFit.CameraUpVector = [0 1 0];
            app.UIAxesFit.Position = [10 10 730 440];

            % Create AnswerTablePanel
            app.AnswerTablePanel = uipanel(app.Tab);
            app.AnswerTablePanel.BorderType = 'none';
            app.AnswerTablePanel.TitlePosition = 'centertop';
            app.AnswerTablePanel.Title = 'Answer Files';
            app.AnswerTablePanel.Visible = 'off';
            app.AnswerTablePanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.AnswerTablePanel.HandleVisibility = 'off';
            app.AnswerTablePanel.Position = [10 20 750 460];

            % Create AnswerTable
            app.AnswerTable = uitable(app.AnswerTablePanel);
            app.AnswerTable.ColumnName = {'Parameter'; 'Value'; 'Fixed'; 'Experiment'; 'Link'; 'Lower Limit'; 'Upper Limit'};
            app.AnswerTable.RowName = {};
            app.AnswerTable.ColumnEditable = [false true false true true true true];
            app.AnswerTable.CellEditCallback = createCallbackFcn(app, @AnswerTableCellEdit, true);
            app.AnswerTable.Position = [10 10 730 420];

            % Create P_R_Panel
            app.P_R_Panel = uipanel(app.Tab);
            app.P_R_Panel.BorderType = 'none';
            app.P_R_Panel.TitlePosition = 'centertop';
            app.P_R_Panel.Title = 'P(R)';
            app.P_R_Panel.Visible = 'off';
            app.P_R_Panel.FontAngle = 'italic';
            app.P_R_Panel.Position = [10 20 750 460];

            % Create UIAxesP_R_
            app.UIAxesP_R_ = uiaxes(app.P_R_Panel);
            xlabel(app.UIAxesP_R_, 'R')
            ylabel(app.UIAxesP_R_, 'P(R)')
            app.UIAxesP_R_.FontAngle = 'italic';
            app.UIAxesP_R_.Position = [11 173 740 259];

            % Create StatisticsTablePanel
            app.StatisticsTablePanel = uipanel(app.Tab);
            app.StatisticsTablePanel.BorderType = 'none';
            app.StatisticsTablePanel.TitlePosition = 'centertop';
            app.StatisticsTablePanel.Title = 'Statistics';
            app.StatisticsTablePanel.Visible = 'off';
            app.StatisticsTablePanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.StatisticsTablePanel.HandleVisibility = 'off';
            app.StatisticsTablePanel.Position = [30 0 750 460];

            % Create StatisticsTable
            app.StatisticsTable = uitable(app.StatisticsTablePanel);
            app.StatisticsTable.ColumnName = {'N exps'; 'Filename'; 'Shape'; 'n'; 'Backgr.'; 'Global Model'; 'N'; 'm'; 'SSR'; 'Red. Chi-squared'; 'BIC'; 'dBIC'};
            app.StatisticsTable.RowName = {};
            app.StatisticsTable.ColumnEditable = [false false false false false false false false false false false false false false false];
            app.StatisticsTable.FontAngle = 'italic';
            app.StatisticsTable.FontSize = 7;
            app.StatisticsTable.Position = [10 10 730 420];

            % Create ViewButtonGroup
            app.ViewButtonGroup = uibuttongroup(app.GLADDvuUIFigure);
            app.ViewButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ViewButtonGroupSelectionChanged, true);
            app.ViewButtonGroup.ForegroundColor = [0 0 1];
            app.ViewButtonGroup.BorderType = 'none';
            app.ViewButtonGroup.TitlePosition = 'centertop';
            app.ViewButtonGroup.Title = 'Panel View';
            app.ViewButtonGroup.FontWeight = 'bold';
            app.ViewButtonGroup.Position = [20 533 286 52];

            % Create DataPanelButton
            app.DataPanelButton = uiradiobutton(app.ViewButtonGroup);
            app.DataPanelButton.Text = 'Data';
            app.DataPanelButton.FontColor = [0 0 1];
            app.DataPanelButton.Position = [3 7 47.359375 15];
            app.DataPanelButton.Value = true;

            % Create AnswerPanelButton
            app.AnswerPanelButton = uiradiobutton(app.ViewButtonGroup);
            app.AnswerPanelButton.HandleVisibility = 'off';
            app.AnswerPanelButton.Text = 'Answer';
            app.AnswerPanelButton.FontColor = [0 0 1];
            app.AnswerPanelButton.Position = [57 7 62 15];

            % Create FitPanelButton
            app.FitPanelButton = uiradiobutton(app.ViewButtonGroup);
            app.FitPanelButton.Text = 'Fit';
            app.FitPanelButton.FontColor = [0 0 1];
            app.FitPanelButton.Position = [126 7 35.34375 15];

            % Create P_R_PanelButton
            app.P_R_PanelButton = uiradiobutton(app.ViewButtonGroup);
            app.P_R_PanelButton.Text = 'P(R)';
            app.P_R_PanelButton.FontColor = [0 0 1];
            app.P_R_PanelButton.Position = [167 7 47 15];

            % Create StatisticsPanelButton
            app.StatisticsPanelButton = uiradiobutton(app.ViewButtonGroup);
            app.StatisticsPanelButton.Text = 'Statistics';
            app.StatisticsPanelButton.FontColor = [0 0 1];
            app.StatisticsPanelButton.Position = [221 7 70 15];

            % Create ProcessButton
            app.ProcessButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.ProcessButton.ButtonPushedFcn = createCallbackFcn(app, @ProcessButtonPushed, true);
            app.ProcessButton.BackgroundColor = [0.749 0.851 1];
            app.ProcessButton.Enable = 'off';
            app.ProcessButton.Position = [920 484 70 20];
            app.ProcessButton.Text = 'Process';

            % Create InitializeButton
            app.InitializeButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.InitializeButton.ButtonPushedFcn = createCallbackFcn(app, @InitializeButtonPushed, true);
            app.InitializeButton.BackgroundColor = [0.749 0.749 1];
            app.InitializeButton.Enable = 'off';
            app.InitializeButton.Position = [920 447 70 20];
            app.InitializeButton.Text = 'Initialize';

            % Create AutoTruncateCheckBoxAll
            app.AutoTruncateCheckBoxAll = uicheckbox(app.GLADDvuUIFigure);
            app.AutoTruncateCheckBoxAll.Text = 'Truncate All';
            app.AutoTruncateCheckBoxAll.FontColor = [0.6392 0.0784 0.1804];
            app.AutoTruncateCheckBoxAll.Position = [317 538 91 15];
            app.AutoTruncateCheckBoxAll.Value = true;

            % Create TruncateEditFieldAll
            app.TruncateEditFieldAll = uieditfield(app.GLADDvuUIFigure, 'numeric');
            app.TruncateEditFieldAll.Limits = [0 10000];
            app.TruncateEditFieldAll.ValueDisplayFormat = '%.0f';
            app.TruncateEditFieldAll.ValueChangedFcn = createCallbackFcn(app, @TruncateEditFieldAllValueChanged, true);
            app.TruncateEditFieldAll.HorizontalAlignment = 'left';
            app.TruncateEditFieldAll.FontColor = [0.6392 0.0784 0.1804];
            app.TruncateEditFieldAll.Position = [405 535 49 22];

            % Create AutoPhaseCheckBoxAll
            app.AutoPhaseCheckBoxAll = uicheckbox(app.GLADDvuUIFigure);
            app.AutoPhaseCheckBoxAll.Text = 'Phase All';
            app.AutoPhaseCheckBoxAll.FontColor = [0.6392 0.0784 0.1804];
            app.AutoPhaseCheckBoxAll.Position = [464 539 72.703125 15];
            app.AutoPhaseCheckBoxAll.Value = true;

            % Create AutoZeroCheckBoxAll
            app.AutoZeroCheckBoxAll = uicheckbox(app.GLADDvuUIFigure);
            app.AutoZeroCheckBoxAll.Text = 'Zero All';
            app.AutoZeroCheckBoxAll.FontColor = [0.6392 0.0784 0.1804];
            app.AutoZeroCheckBoxAll.Position = [547 539 63.34375 15];
            app.AutoZeroCheckBoxAll.Value = true;

            % Create ComponentsLabel
            app.ComponentsLabel = uilabel(app.GLADDvuUIFigure);
            app.ComponentsLabel.HorizontalAlignment = 'right';
            app.ComponentsLabel.VerticalAlignment = 'top';
            app.ComponentsLabel.Position = [858 369 74 15];
            app.ComponentsLabel.Text = 'Components';

            % Create ComponentsSpinner
            app.ComponentsSpinner = uispinner(app.GLADDvuUIFigure);
            app.ComponentsSpinner.Limits = [1 9];
            app.ComponentsSpinner.ValueDisplayFormat = '%1i';
            app.ComponentsSpinner.ValueChangedFcn = createCallbackFcn(app, @ComponentsSpinnerValueChanged, true);
            app.ComponentsSpinner.BackgroundColor = [0.9608 1 0.9608];
            app.ComponentsSpinner.Position = [940 366 50 22];
            app.ComponentsSpinner.Value = 1;

            % Create BackgroundDropDownLabel
            app.BackgroundDropDownLabel = uilabel(app.GLADDvuUIFigure);
            app.BackgroundDropDownLabel.HorizontalAlignment = 'right';
            app.BackgroundDropDownLabel.VerticalAlignment = 'top';
            app.BackgroundDropDownLabel.Enable = 'off';
            app.BackgroundDropDownLabel.Position = [805 412 70 15];
            app.BackgroundDropDownLabel.Text = 'Background';

            % Create BackgroundDropDown
            app.BackgroundDropDown = uidropdown(app.GLADDvuUIFigure);
            app.BackgroundDropDown.Items = {'None', 'Exponential', 'Excl. Volume', '2 Dimensional', 'Variable Dim.', 'User 1', 'User 2', 'Concentration'};
            app.BackgroundDropDown.ValueChangedFcn = createCallbackFcn(app, @BackgroundChangedFcn, true);
            app.BackgroundDropDown.Enable = 'off';
            app.BackgroundDropDown.BackgroundColor = [1 0.9608 0.9608];
            app.BackgroundDropDown.Position = [890 408 100 22];
            app.BackgroundDropDown.Value = 'Exponential';

            % Create GlobalDropDownLabel
            app.GlobalDropDownLabel = uilabel(app.GLADDvuUIFigure);
            app.GlobalDropDownLabel.BackgroundColor = [0.9216 0.9608 1];
            app.GlobalDropDownLabel.HorizontalAlignment = 'right';
            app.GlobalDropDownLabel.VerticalAlignment = 'top';
            app.GlobalDropDownLabel.Position = [835 291 40 15];
            app.GlobalDropDownLabel.Text = 'Global';

            % Create GlobalModelDropDown
            app.GlobalModelDropDown = uidropdown(app.GLADDvuUIFigure);
            app.GlobalModelDropDown.Items = {'nothing', 'not depth', 'not depth and background', 'not depth backgr. ampl.', 'not depth and amplitudes', 'custom'};
            app.GlobalModelDropDown.ValueChangedFcn = createCallbackFcn(app, @GlobalModelChangedFcn, true);
            app.GlobalModelDropDown.BackgroundColor = [0.9216 0.9608 1];
            app.GlobalModelDropDown.Position = [890 291 100 22];
            app.GlobalModelDropDown.Value = 'nothing';

            % Create FitButton
            app.FitButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.FitButton.ButtonPushedFcn = createCallbackFcn(app, @FitButtonPushed, true);
            app.FitButton.BackgroundColor = [1 1 1];
            app.FitButton.Enable = 'off';
            app.FitButton.Position = [920 213 70 22];
            app.FitButton.Text = {'Fit'; ''};

            % Create OptionsButton
            app.OptionsButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.OptionsButton.ButtonPushedFcn = createCallbackFcn(app, @OptionsButtonPushed, true);
            app.OptionsButton.BackgroundColor = [1 1 0.9216];
            app.OptionsButton.Position = [807 174 70 22];
            app.OptionsButton.Text = {'Options'; ''};

            % Create ConstantsButton
            app.ConstantsButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.ConstantsButton.ButtonPushedFcn = createCallbackFcn(app, @ConstantsButtonPushed, true);
            app.ConstantsButton.BackgroundColor = [1 0.949 0.902];
            app.ConstantsButton.Position = [920 174 70 22];
            app.ConstantsButton.Text = {'Constants'; ''};

            % Create MethodDropDownLabel
            app.MethodDropDownLabel = uilabel(app.GLADDvuUIFigure);
            app.MethodDropDownLabel.HorizontalAlignment = 'right';
            app.MethodDropDownLabel.VerticalAlignment = 'top';
            app.MethodDropDownLabel.Position = [829 252 46 15];
            app.MethodDropDownLabel.Text = 'Method';

            % Create MethodDropDown
            app.MethodDropDown = uidropdown(app.GLADDvuUIFigure);
            app.MethodDropDown.Items = {'Interior Point', 'Global Search', 'Particle Swarm'};
            app.MethodDropDown.ValueChangedFcn = createCallbackFcn(app, @MethodDropDownValueChanged, true);
            app.MethodDropDown.BackgroundColor = [1 1 0.9216];
            app.MethodDropDown.Position = [890 252 100 22];
            app.MethodDropDown.Value = 'Interior Point';

            % Create EditField
            app.EditField = uieditfield(app.GLADDvuUIFigure, 'text');
            app.EditField.Editable = 'off';
            app.EditField.HorizontalAlignment = 'right';
            app.EditField.FontSize = 24;
            app.EditField.FontWeight = 'bold';
            app.EditField.FontColor = [0 0.502 0];
            app.EditField.Position = [313 560 466 33];
            app.EditField.Value = 'Ready to Add Data';

            % Create GenericTable
            app.GenericTable = uitable(app.GLADDvuUIFigure);
            app.GenericTable.ColumnName = {'Values'};
            app.GenericTable.RowName = {};
            app.GenericTable.ForegroundColor = [1 1 1];
            app.GenericTable.Visible = 'off';
            app.GenericTable.Position = [15 19 770 510];

            % Create SaveStatisticsButton
            app.SaveStatisticsButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.SaveStatisticsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveStatisticsButtonPushed, true);
            app.SaveStatisticsButton.BackgroundColor = [0.9216 1 0.9608];
            app.SaveStatisticsButton.Enable = 'off';
            app.SaveStatisticsButton.Position = [811 11 82 22];
            app.SaveStatisticsButton.Text = 'Save Statistics';

            % Create ShapeDropDownLabel
            app.ShapeDropDownLabel = uilabel(app.GLADDvuUIFigure);
            app.ShapeDropDownLabel.HorizontalAlignment = 'right';
            app.ShapeDropDownLabel.VerticalAlignment = 'top';
            app.ShapeDropDownLabel.Enable = 'off';
            app.ShapeDropDownLabel.Position = [835 334 40 15];
            app.ShapeDropDownLabel.Text = 'Shape';

            % Create ShapeDropDown
            app.ShapeDropDown = uidropdown(app.GLADDvuUIFigure);
            app.ShapeDropDown.Items = {'Gaussian', 'Rice', 'Variable', 'Skewed', 'GSND', 'Custom'};
            app.ShapeDropDown.ValueChangedFcn = createCallbackFcn(app, @ShapeChangedFcn, true);
            app.ShapeDropDown.Enable = 'off';
            app.ShapeDropDown.BackgroundColor = [0.9608 0.9608 1];
            app.ShapeDropDown.Position = [890 330 100 22];
            app.ShapeDropDown.Value = 'Gaussian';

            % Create SaveResultsButton
            app.SaveResultsButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.SaveResultsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveResultsButtonPushed, true);
            app.SaveResultsButton.BackgroundColor = [0.149 0.149 0.149];
            app.SaveResultsButton.FontWeight = 'bold';
            app.SaveResultsButton.FontColor = [0.9412 0.9412 0.9412];
            app.SaveResultsButton.Enable = 'off';
            app.SaveResultsButton.Position = [900 11 90 22];
            app.SaveResultsButton.Text = 'Save Results';

            % Create AutoFitCheckBox
            app.AutoFitCheckBox = uicheckbox(app.GLADDvuUIFigure);
            app.AutoFitCheckBox.Enable = 'off';
            app.AutoFitCheckBox.Text = 'AUTO';
            app.AutoFitCheckBox.FontWeight = 'bold';
            app.AutoFitCheckBox.FontColor = [0 0.4392 0];
            app.AutoFitCheckBox.Position = [807 369 58 15];

            % Create ConfIntCheckBox
            app.ConfIntCheckBox = uicheckbox(app.GLADDvuUIFigure);
            app.ConfIntCheckBox.Enable = 'off';
            app.ConfIntCheckBox.Text = 'Conf. Int.';
            app.ConfIntCheckBox.FontWeight = 'bold';
            app.ConfIntCheckBox.Position = [807 217 80 15];

            % Create AIPCheckBox
            app.AIPCheckBox = uicheckbox(app.GLADDvuUIFigure);
            app.AIPCheckBox.Text = 'Auto Initialize Parameters';
            app.AIPCheckBox.FontColor = [0.6392 0.0784 0.1804];
            app.AIPCheckBox.Position = [620 539 159 15];
            app.AIPCheckBox.Value = true;

            % Create ResultsBoxPanel
            app.ResultsBoxPanel = uipanel(app.GLADDvuUIFigure);
            app.ResultsBoxPanel.BackgroundColor = [0.949 0.949 1];
            app.ResultsBoxPanel.Position = [790 445 125 131];

            % Create datasetsEditFieldLabel
            app.datasetsEditFieldLabel = uilabel(app.ResultsBoxPanel);
            app.datasetsEditFieldLabel.HorizontalAlignment = 'right';
            app.datasetsEditFieldLabel.FontName = 'Times New Roman';
            app.datasetsEditFieldLabel.FontWeight = 'bold';
            app.datasetsEditFieldLabel.FontColor = [0.3608 0.0784 0.1804];
            app.datasetsEditFieldLabel.Position = [66 103 50 22];
            app.datasetsEditFieldLabel.Text = 'data sets';

            % Create datasetsEditField
            app.datasetsEditField = uieditfield(app.ResultsBoxPanel, 'numeric');
            app.datasetsEditField.Limits = [0 Inf];
            app.datasetsEditField.ValueDisplayFormat = '%.0f';
            app.datasetsEditField.Editable = 'off';
            app.datasetsEditField.FontName = 'Times New Roman';
            app.datasetsEditField.FontColor = [0.3608 0.0784 0.1804];
            app.datasetsEditField.Position = [6 103 25 22];

            % Create parametersEditFieldLabel
            app.parametersEditFieldLabel = uilabel(app.ResultsBoxPanel);
            app.parametersEditFieldLabel.HorizontalAlignment = 'right';
            app.parametersEditFieldLabel.FontName = 'Times New Roman';
            app.parametersEditFieldLabel.FontWeight = 'bold';
            app.parametersEditFieldLabel.FontColor = [0.3608 0.0784 0.1804];
            app.parametersEditFieldLabel.Position = [52 79 64 22];
            app.parametersEditFieldLabel.Text = 'parameters';

            % Create parametersEditField
            app.parametersEditField = uieditfield(app.ResultsBoxPanel, 'numeric');
            app.parametersEditField.ValueDisplayFormat = '%.0f';
            app.parametersEditField.Editable = 'off';
            app.parametersEditField.FontName = 'Times New Roman';
            app.parametersEditField.FontColor = [0.3608 0.0784 0.1804];
            app.parametersEditField.Position = [6 79 25 22];

            % Create iterationsEditFieldLabel
            app.iterationsEditFieldLabel = uilabel(app.ResultsBoxPanel);
            app.iterationsEditFieldLabel.HorizontalAlignment = 'right';
            app.iterationsEditFieldLabel.FontName = 'Times New Roman';
            app.iterationsEditFieldLabel.FontWeight = 'bold';
            app.iterationsEditFieldLabel.FontColor = [0.3608 0.0784 0.1804];
            app.iterationsEditFieldLabel.Position = [62 31 54 22];
            app.iterationsEditFieldLabel.Text = 'iterations';

            % Create iterationsEditField
            app.iterationsEditField = uieditfield(app.ResultsBoxPanel, 'numeric');
            app.iterationsEditField.ValueDisplayFormat = '%.0f';
            app.iterationsEditField.Editable = 'off';
            app.iterationsEditField.FontName = 'Times New Roman';
            app.iterationsEditField.FontColor = [0.3608 0.0784 0.1804];
            app.iterationsEditField.Position = [6 31 38 22];

            % Create redLabel
            app.redLabel = uilabel(app.ResultsBoxPanel);
            app.redLabel.FontName = 'Times New Roman';
            app.redLabel.FontWeight = 'bold';
            app.redLabel.FontColor = [0.3608 0.0784 0.1804];
            app.redLabel.Position = [6 55 47 22];
            app.redLabel.Text = 'red. ?² =';

            % Create redEditField
            app.redEditField = uieditfield(app.ResultsBoxPanel, 'numeric');
            app.redEditField.ValueDisplayFormat = '%.4f';
            app.redEditField.Editable = 'off';
            app.redEditField.FontName = 'Times New Roman';
            app.redEditField.FontColor = [0.3608 0.0784 0.1804];
            app.redEditField.Position = [51 55 65 22];

            % Create BICEditFieldLabel
            app.BICEditFieldLabel = uilabel(app.ResultsBoxPanel);
            app.BICEditFieldLabel.HorizontalAlignment = 'right';
            app.BICEditFieldLabel.FontName = 'Times New Roman';
            app.BICEditFieldLabel.FontWeight = 'bold';
            app.BICEditFieldLabel.FontAngle = 'italic';
            app.BICEditFieldLabel.FontColor = [0.3608 0.0784 0.1804];
            app.BICEditFieldLabel.Position = [6 7 36 22];
            app.BICEditFieldLabel.Text = 'BIC =';

            % Create BICEditField
            app.BICEditField = uieditfield(app.ResultsBoxPanel, 'numeric');
            app.BICEditField.ValueDisplayFormat = '%.1f';
            app.BICEditField.Editable = 'off';
            app.BICEditField.FontName = 'Times New Roman';
            app.BICEditField.FontColor = [0.3608 0.0784 0.1804];
            app.BICEditField.Position = [52 7 64 22];

            % Create WriteStatisticsButton
            app.WriteStatisticsButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.WriteStatisticsButton.ButtonPushedFcn = createCallbackFcn(app, @WriteStatisticsButtonPushed, true);
            app.WriteStatisticsButton.BackgroundColor = [0.9216 1 0.9608];
            app.WriteStatisticsButton.FontColor = [0.4706 0.6706 0.1882];
            app.WriteStatisticsButton.Enable = 'off';
            app.WriteStatisticsButton.Position = [811 44 82 22];
            app.WriteStatisticsButton.Text = 'Write Statistics';

            % Create ClearStatisticsButton
            app.ClearStatisticsButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.ClearStatisticsButton.ButtonPushedFcn = createCallbackFcn(app, @ClearStatisticsButtonPushed, true);
            app.ClearStatisticsButton.BackgroundColor = [0.9216 1 0.9608];
            app.ClearStatisticsButton.FontColor = [1 0 0];
            app.ClearStatisticsButton.Enable = 'off';
            app.ClearStatisticsButton.Position = [811 77 82 22];
            app.ClearStatisticsButton.Text = 'Clear Statistics';

            % Create SaveWindow2Button
            app.SaveWindow2Button = uibutton(app.GLADDvuUIFigure, 'push');
            app.SaveWindow2Button.ButtonPushedFcn = createCallbackFcn(app, @SaveWindow2ButtonPushed, true);
            app.SaveWindow2Button.BackgroundColor = [0.9294 0.6902 0.1294];
            app.SaveWindow2Button.FontSize = 10;
            app.SaveWindow2Button.FontWeight = 'bold';
            app.SaveWindow2Button.FontColor = [0.6392 0.0784 0.1804];
            app.SaveWindow2Button.Position = [900 44 90 22];
            app.SaveWindow2Button.Text = 'Save Window 2';

            % Create SaveWindow1Button
            app.SaveWindow1Button = uibutton(app.GLADDvuUIFigure, 'push');
            app.SaveWindow1Button.ButtonPushedFcn = createCallbackFcn(app, @SaveWindow1ButtonPushed, true);
            app.SaveWindow1Button.BackgroundColor = [0.6392 0.0784 0.1804];
            app.SaveWindow1Button.FontSize = 10;
            app.SaveWindow1Button.FontWeight = 'bold';
            app.SaveWindow1Button.FontColor = [0.9294 0.6902 0.1294];
            app.SaveWindow1Button.Position = [900 77 90 22];
            app.SaveWindow1Button.Text = 'Save Window 1';

            % Create All1SaveButton
            app.All1SaveButton = uibutton(app.GLADDvuUIFigure, 'push');
            app.All1SaveButton.ButtonPushedFcn = createCallbackFcn(app, @Save1ClickButtonPushed, true);
            app.All1SaveButton.IconAlignment = 'center';
            app.All1SaveButton.BackgroundColor = [0.9882 1 0.3804];
            app.All1SaveButton.FontSize = 22;
            app.All1SaveButton.FontColor = [0 0 1];
            app.All1SaveButton.Position = [810 110 84 44];
            app.All1SaveButton.Text = '1-Click';

            % Show the figure after all components are created
            app.GLADDvuUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GLADDvu

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.GLADDvuUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.GLADDvuUIFigure)
        end
    end
end