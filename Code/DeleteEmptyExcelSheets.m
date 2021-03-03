% DeleteEmptyExcelSheets: deletes all empty sheets in an xls-file
%
%==========================================================================
% Version : 1.0
% Author : hnagel
% Date : 27/04/2007
% Tested : 02/05/2007 (DR)
%==========================================================================
%
% This function looped through all sheets and deletes those sheets that are
% empty. Can be used to clean a newly created xls-file after all results
% have been saved in it.
%
% References: Torsten Jacobsen, "delete standard excel sheet"
%---------------------------------------------------------------------
function DeleteEmptyExcelSheets(fileName)
% Here test if fileName has a declared file type. If not make it an .xls
% file
[~,~,t3] = fileparts(fileName);
testName = fileName;
if isempty(t3)
  testName = [fileName '.xls'];
end
% Check whether the file exists
% 06/22/2016 EJH modified for both xls and xlsx files
if ~exist(testName,'file')
  if isempty(t3)
    testName = [fileName '.xlsx'];
    if ~exist(testName,'file')
      error([fileName ' does not exist !']);
    end
  else
    error([fileName ' does not exist !']);
  end
% else
    % Check whether it is an Excel file
    % xlsfinfo creates an EXCEL.EXE process that is not closed. Code above
    % checks file extension so it is not really necessary
    % typ = xlsfinfo(fileName);
    % if ~strcmp(typ,'Microsoft Excel Spreadsheet')
    %   error([fileName ' not an Excel sheet !']);
    % end
end

% If fileName does not contain a "\" the name of the current path is added
% to fileName. The reason for this is that the full path is required for
% the command "excelObj.workbooks.Open(fileName)" to work properly.
if isempty(strfind(fileName,'\'))
  fileName = [cd '\' fileName];
end

excelObj = actxserver('Excel.Application');
excelWorkbook = excelObj.workbooks.Open(fileName);
worksheets = excelObj.sheets;
sheetIdx = 1;
sheetIdx2 = 1;
numSheets = worksheets.Count;
% Prevent beeps from sounding if we try to delete a non-empty worksheet.
excelObj.EnableSound = false;

% Loop over all sheets
while sheetIdx2 <= numSheets
  % Saves the current number of sheets in the workbook
  temp = worksheets.count;
  % Check whether the current worksheet is the last one. As there always
  % need to be at least one worksheet in an xls-file the last sheet must
  % not be deleted.
  if or(sheetIdx>1,numSheets-sheetIdx2>0)
    % worksheets.Item(sheetIdx).UsedRange.Count is the number of used cells.
    % This will be 1 for an empty sheet. It may also be one for certain other
    % cases but in those cases, it will beep and not actually delete the sheet.
    if worksheets.Item(sheetIdx).UsedRange.Count == 1
      worksheets.Item(sheetIdx).Delete;
    end
  end
  % Check whether the number of sheets has changed. If this is not the
  % case the counter "sheetIdx" is increased by one.
  if temp == worksheets.count;
    sheetIdx = sheetIdx + 1;
  end
  sheetIdx2 = sheetIdx2 + 1; % prevent endless loop...
end
excelObj.EnableSound = true;
excelObj.displayalerts = false;
excelWorkbook.Save;
excelWorkbook.Close(false);
excelObj.Quit;
delete(excelObj);
return;