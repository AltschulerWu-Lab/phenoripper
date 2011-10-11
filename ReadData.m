% Parse the Metadata file which describe for each image the different group
% Parameters :
% @filename     : the full patch to the medatada file - Required
% @delim        : the delimiter between the different field - String - Required
%
% Output parameters:
% @filenames
% @metadata
% @RootDir
% @NrChannelPerImage
% @Markers
% @errorMessage
%
% Metadata file example (simple Text file):
% #RootDir:/home/project/2006_10_Subpopulations/plates/070330_Subpopulation_Final_24hr/normalized_images/
% #NrChannelPerImage:1
% #Markers:DAPI;Actin;Tubulin 
% 
% FileNames,Drug,DrugClass
% B16/HeLa9515-2.png;B16/HeLa9515-3.png;B16/HeLa9515-1.png,Aldosterone, Glucocorticoid receptor
% B16/HeLa9504-2.png;B16/HeLa9504-3.png;B16/HeLa9504-1.png,Aldosterone, Glucocorticoid receptor
%
%  Copyright (C) B. Pavie and S. Rajaram for Altschuler and Wu Lab, 2011
% -------------------------------------------------------------------------

function [filenames,metadata,RootDir,NrChannelPerImage,Markers,errorMessage]=ReadData(filename,delim)
%     fid0 = fopen(filename,'rt');
%     nLines = 0;
%     while (fgets(fid0) ~= -1),
%       nLines = nLines+1;
%     end
%     fclose(fid0);

    CommonVar=cell(1,1);
    n=1;
    fid =fopen(filename);
    data=textscan(fid,'%s',1,'delimiter','\n');
    while(~strcmp(data{1,1},'')&&~strcmp(data{1,1}{1}(1),',') )
      CommonVar(n,1)=data{1,1};
      n=n+1;
      data=textscan(fid,'%s',1,'delimiter','\n');
    end
    
    %Extract the Common variables(RootDir, NrChannelPerImage and Markers)
    %Only RootDir is required, NrChannelPerImage will be 1 per default and
    %Markers will be populated later if they are not in the MetaData file
    errorMessage='';
    RootDir = getVarValue(CommonVar,'#RootDir:');
    if(isempty(RootDir))
      errorMessage=['Root Directory has not been specified. You should'...
      ' have a line like #RootDir:C:\myDir\ describing your root directory'];
      filenames='';
      metadata='';
      RootDir='';
      NrChannelPerImage='';
      Markers='';
      return;
    end
    RootDir=regexprep(RootDir,',*$','');%Remove the comma added by excel
    
    NrChannelPerImage = getVarValue(CommonVar,'#NrChannelPerImage:');
    if(~isempty(NrChannelPerImage))
      %Remove the comma added by excel
      NrChannelPerImage=regexprep(NrChannelPerImage,',*$','');
    end
    if(isempty(NrChannelPerImage))
      NrChannelPerImage=1;
    else
      try
      NrChannelPerImage=str2double(NrChannelPerImage);
      catch
        errorMessage=['NrChannelPerImage is not a integer!'];
        return;
      end
    end
    Markers = getVarValue(CommonVar,'#Markers:');
    
    if(~isempty(Markers))
      Markers=regexprep(Markers,',*$','');%Remove the comma added by excel
      Markers=regexp(Markers,';','split');
    end
    
    %Skip the empty line(s) or the line starting with a comma
    %(edited with excel and re-saved)which separate description of variable
    %from the metadata per image.
    while(strcmp(data{1,1},'')||strcmp(data{1,1}{1}(1),','))
      CommonVar(n,1)=data{1,1};
      n=n+1;
      data=textscan(fid,'%s',1,'delimiter','\n');
    end
    
    %Skip the line starting with a comma (edited with excel and re-saved)
%     while(strcmp(data{1,1},''))
%       CommonVar(n,1)=data{1,1};
%       n=n+1;
%       data=textscan(fid,'%s',1,'delimiter','\n');
%     end
    
    
    %Read the header Row
    HeaderRow=data;
    HeaderFields=regexp(cell2mat(HeaderRow{1}),delim,'split');
    metadata=struct;
    %filenames=cell(nLines-1,1);
    filenames=cell(0);
    line_counter=1;
    %Read the fileName
    data=textscan(fid,'%s',1,'delimiter','\n');
    while (~feof(fid)) 
        tokens=regexp(data{1},delim,'split');
        tokens=tokens{1};
        filenames{line_counter}=regexp(tokens{1},';','split');
        metadata(line_counter).None=tokens{1};
        for field_num=2:length(HeaderFields)
                metadata(line_counter).(HeaderFields{field_num})=tokens{field_num};
        end
        line_counter=line_counter+1;
       data=textscan(fid,'%s',1,'delimiter','\n');
    end
    
    if(NrChannelPerImage==1 && size(Markers,2)~=size(filenames{1,1},2))
        errorMessage='Number of marker and number of image does not match!';
    elseif(NrChannelPerImage>1&&size(Markers,2)~=NrChannelPerImage)
        errorMessage='Number of channel per image and number of marker does not match!';
    end
    
  %Internal function to extract the value of the Common Variable present
  %in the header of the Metadata file.
  function value=getVarValue(varCell,var)
    [startIndex, ~, ~, ~, ~, ~, valueCell]=regexp(varCell,var);
    index = find(~cellfun('isempty',startIndex));
    if(~isempty(index))
      valueCell=valueCell{index};
      value=valueCell{1,2};
    else
      value=[];
    end
    
  end
end

