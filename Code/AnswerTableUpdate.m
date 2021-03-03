function output = AnswerTableUpdate(app)
% 3/30/2018 EJH - Function to update Answer File (Table) in Answer Tab view  

    output = app.AnswerTable;
    % loop over all data sets
    for index = 1:app.bucket.Nexps
        rownames = app.Ans(index).Name;
        data = [app.Ans(index).Value app.Ans(index).Fixed ...
        app.Ans(index).Experiment app.Ans(index).Link ...
        app.Ans(index).LowerLimit app.Ans(index).UpperLimit];
        output(index).Data = horzcat(rownames,num2cell(data)); 
    end
    
return
