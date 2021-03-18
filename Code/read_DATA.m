function [ x,Z,dx ]= read_DATA(file)
% 03/30/2010 modified EJH
% Get Bruker Data Set
% file is the file name for the bruker data set
% Use the Bruker  file convention, and do not add extension names
% "file" . dsc and .dta are assumed
% Z contains the x and y values in a 2 column matrix
%  plot(Z(:,1),Z(:,2))  to  visualize results

dx= [];
x=[];
Z =[];
A=[];

% spc
% disp('file');disp(file);
tempf = [ file '.DAT'];
fid = fopen( tempf, 'r','ieee-be.l64');
if(fid == -1)
    tempf = [ file '.dat'];
    fid = fopen( tempf, 'r','ieee-be.l64');
    if(fid == -1)
        tempf = [ file '.ASC'];
        fid = fopen( tempf, 'r','ieee-be.l64');
        if(fid == -1)
            tempf = [ file '.asc'];
            fid = fopen( tempf, 'r','ieee-be.l64');
            if(fid == -1); return; end 
        end 
    end 
end 
%
A = importdata(tempf);
if(isstruct(A)) 
    x = transpose(A.data(:,2));
    Z = transpose(A.data(:,3) + i*A.data(:,4)); 
else
    x = transpose(A(:,1));
    Z = transpose(A(:,2) + i*A(:,3)); 
end 
dx = x(1,2) - x(1,1); 
fclose(fid);
return