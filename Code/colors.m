function color = colors(i,ncolors)
% 3/30/2018 EJH - Function to generate RGB values depending on an index i
temp = distinguishable_colors(ncolors,'w');
color = temp(i,:);

