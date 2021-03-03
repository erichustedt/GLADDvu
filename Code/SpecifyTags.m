function [app] = SpecifyTags(app)
% SpecifyTags  
%   set tags for app components to specify "Group"
app.AddFilesButton.Tag = 'Group A';
app.OptionsButton.Tag = 'Group A';
app.ConstantsButton.Tag = 'Group A';
app.AutoTruncateCheckBoxAll.Tag = 'Group A';
app.AutoPhaseCheckBoxAll.Tag = 'Group A';
app.AutoZeroCheckBoxAll.Tag = 'Group A';
app.AutoFitCheckBox.Tag = 'Group A';
app.ConfIntCheckBox.Tag = 'Group A';
app.AIPCheckBox.Tag = 'Group A';
app.MethodDropDown.Tag = 'Group A';
app.EditField.Tag = 'Group A';
app.GlobalDropDownLabel.Tag = 'Group A';
app.MethodDropDownLabel.Tag = 'Group A';
app.datasetsEditFieldLabel.Tag = 'Group A';
app.parametersEditFieldLabel.Tag = 'Group A';
app.iterationsEditFieldLabel.Tag = 'Group A';
app.redLabel.Tag = 'Group A';
app.BICEditFieldLabel.Tag = 'Group A';
app.datasetsEditField.Tag = 'Group A';
app.parametersEditField.Tag = 'Group A';
app.iterationsEditField.Tag = 'Group A';
app.redEditField.Tag = 'Group A';
app.BICEditField.Tag = 'Group A';
app.TruncateEditFieldAll.Tag = 'Group A';
%
app.BackgroundDropDown.Tag = 'Group B';
app.BackgroundDropDownLabel.Tag = 'Group B';
app.ShapeDropDown.Tag = 'Group B';
app.ShapeDropDownLabel.Tag = 'Group B';
app.ComponentsSpinner.Tag = 'Group B';
app.ComponentsLabel.Tag = 'Group B';
app.ClearDataButton.Tag = 'Group B';
app.ProcessButton.Tag = 'Group B';
app.InitializeButton.Tag = 'Group B';
app.FitButton.Tag = 'Group B';
app.DataPanelButton.Tag = 'Group B';
app.AnswerPanelButton.Tag = 'Group B';
app.FitPanelButton.Tag = 'Group B';
app.P_R_PanelButton.Tag = 'Group B';
app.GlobalModelDropDown.Tag = 'Group B';
%
app.SaveStatisticsButton.Tag = 'Group C';
app.SaveResultsButton.Tag = 'Group C'; 
%
app.WriteStatisticsButton.Tag = 'Group D';
app.ClearStatisticsButton.Tag = 'Group D';
app.StatisticsPanelButton.Tag = 'Group D';
%
% app.UIAxesZero.Tag = 'Group 1';
app.UIAxesData.Tag = 'Group 1';
app.UIAxesFit.Tag = 'Group 1';
app.UIAxesP_R_.Tag = 'Group 1';
app.GLADDvuUIFigure.Tag = 'Group 1';
app.ResultsBoxPanel.Tag = 'Group 1'; 
app.ViewButtonGroup.Tag = 'Group 1';
%
app.TabGroup.Tag = 'Group 2';
app.FitPanel.Tag = 'Group 2';
app.AnswerTablePanel.Tag = 'Group 2';
app.P_R_Panel.Tag = 'Group 2';
app.DataPanel.Tag = 'Group 2';
app.StatisticsTablePanel.Tag = 'Group 2';
%

end

