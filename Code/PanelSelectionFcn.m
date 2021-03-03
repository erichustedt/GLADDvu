function app = PanelSelectionFcn(app)
% 05/28/2018 - EJH
% set selected tab view
      app.GenericTable.Visible = 'off';
      selectedButton = app.ViewButtonGroup.SelectedObject;
      if selectedButton.UserData == 1
        app.view = 'Data';
        for itab = 1:app.bucket.Nexps + 1
          app.DataPanel(itab).Visible = 'on';
          app.AnswerTablePanel(itab).Visible = 'off';
          app.FitPanel(itab).Visible = 'off';
          app.P_R_Panel(itab).Visible = 'off';
        end
        app.StatisticsTablePanel.Visible = 'off';
      elseif selectedButton.UserData == 2
        app.view = 'Answer';
        for itab = 1:app.bucket.Nexps + 1
          app.DataPanel(itab).Visible = 'off';
          app.AnswerTablePanel(itab).Visible = 'on';
          app.FitPanel(itab).Visible = 'off';
          app.P_R_Panel(itab).Visible = 'off';
        end
        app.StatisticsTablePanel.Visible = 'off';
      elseif selectedButton.UserData == 3
        app.view = 'Fit';
        for itab = 1:app.bucket.Nexps + 1
          app.DataPanel(itab).Visible = 'off';
          app.AnswerTablePanel(itab).Visible = 'off';
          app.FitPanel(itab).Visible = 'on';
          app.P_R_Panel(itab).Visible = 'off';
        end
        app.StatisticsTablePanel.Visible = 'off';
      elseif selectedButton.UserData == 4
        app.view = 'P(R)';
        for itab = 1:app.bucket.Nexps + 1
          app.DataPanel(itab).Visible = 'off';
          app.AnswerTablePanel(itab).Visible = 'off';
          app.FitPanel(itab).Visible = 'off';
          app.P_R_Panel(itab).Visible = 'on';
        end
        app.StatisticsTablePanel.Visible = 'off';
      elseif selectedButton.UserData == 5
        app.view = 'Statistics';
        for itab = 1:app.bucket.Nexps + 1
          app.DataPanel(itab).Visible = 'off';
          app.AnswerTablePanel(itab).Visible = 'off';
          app.FitPanel(itab).Visible = 'off';
          app.P_R_Panel(itab).Visible = 'off';
        end
        app.StatisticsTablePanel.Visible = 'on';
      end 
end

