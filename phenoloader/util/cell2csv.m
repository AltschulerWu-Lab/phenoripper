function [overwrite status] = cell2csv(rootDir, nrChannel, markers, fileName, cellArray, separator, excelYear, decimal)
% Writes cell array content into a *.csv file.
% 
% CELL2CSV(fileName, cellArray, separator, excelYear, decimal)
%
% fileName     = Name of the file to save. [ i.e. 'text.csv' ]
% cellArray    = Name of the Cell Array where the data is in
% separator    = sign separating the values (default = ';')
% excelYear    = depending on the Excel version, the cells are put into
%                quotes before they are written to the file. The separator
%                is set to semicolon (;)
% decimal      = defines the decimal separator (default = '.')
%
%         by Sylvain Fiedler, KA, 2004
% updated by Sylvain Fiedler, Metz, 06
% fixed the logical-bug, Kaiserslautern, 06/2008, S.Fiedler
% added the choice of decimal separator, 11/2010, S.Fiedler

%% Checking für optional Variables
if ~exist('separator', 'var')
    separator = ',';
end

if ~exist('excelYear', 'var')
    excelYear = 1997;
end

if ~exist('decimal', 'var')
    decimal = '.';
end

%% Setting separator for newer excelYears
if excelYear > 2000
    separator = ';';
end

%% Write file
overwrite = 1;
if exist(fileName)
    choice = questdlg('Filename exists already. Do you wish to replace the file?','', ...	
	'Yes','No','No');
    
    switch choice
        case 'Yes'
            overwrite = 1;
        case 'No'
            overwrite = 0;            
    end
end
    
status = 0;
if (~exist(fileName) | overwrite)
    datei = fopen(fileName, 'w');
    if datei<3
       status = 0;
       warndlg({'Cannot open file to write!','Make sure directory is writable!'});
       return; 
    end

    ln1 = ['#RootDir:' rootDir ',,'];
    ln2 = ['#NrChannelPerImage:' num2str(nrChannel) ',,'];
    ln3 = ['#Markers:'];
    for k = 1:length(markers)
        if k==length(markers)
            ln3 = [ln3 markers{k}];
        else
            ln3 = [ln3 markers{k} ';'];
        end
    end
    ln3 = [ln3 ',,'];

    fprintf(datei, '%s', ln1);
    fprintf(datei, '\n');
    fprintf(datei, '%s', ln2);
    fprintf(datei, '\n');
    fprintf(datei, '%s', ln3);
    fprintf(datei, '\n');
    fprintf(datei, '%s', ',,');
    fprintf(datei, '\n');
    fprintf(datei, '%s', ',,');
    fprintf(datei, '\n');
    fprintf(datei, '%s', ',,');
    fprintf(datei, '\n');
    fprintf(datei, '%s', ',,');
    fprintf(datei, '\n');


    for z=1:size(cellArray, 1)
        for s=1:size(cellArray, 2)

            var = eval(['cellArray{z,s}']);
            % If zero, then empty cell
            if size(var, 1) == 0
                var = '';
            end
            % If numeric -> String
            if isnumeric(var)
                var = num2str(var);
                % Conversion of decimal separator (4 Europe & South America)
                % http://commons.wikimedia.org/wiki/File:DecimalSeparator.svg
                if decimal ~= '.'
                    var = strrep(var, '.', decimal);
                end
            end
            % If logical -> 'true' or 'false'
            if islogical(var)
                if var == 1
                    var = 'TRUE';
                else
                    var = 'FALSE';
                end
            end
            % If newer version of Excel -> Quotes 4 Strings
            if excelYear > 2000
                var = ['"' var '"'];
            end

            % OUTPUT value
            fprintf(datei, '%s', var);

            % OUTPUT separator
            if s ~= size(cellArray, 2)
                fprintf(datei, separator);
            end
        end
        if z ~= size(cellArray, 1) % prevent a empty line at EOF
            % OUTPUT newline        
    %         fprintf(datei, '%s', ',,');
            fprintf(datei, '\n');
        end
    end
    % fprintf(datei, '%s', ',,');
    % Closing file
    fclose(datei);
    % END
    
    status = 1;
end