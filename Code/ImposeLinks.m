function Ans = ImposeLinks(Ans,Nexps)
% 8/31/2018 - Revised EJH
% function to impose links on Ans.Values
for index = 1:Nexps
  for j = 1:length(Ans(index).Value)
    if(Ans(index).Link(j))
      Ans(index).Value(j) = ...
        Ans(Ans(index).Experiment(j)).Value(Ans(index).Link(j));
    end
  end
end

