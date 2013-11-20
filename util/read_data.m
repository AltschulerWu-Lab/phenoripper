function [filenames,metadata,RootDir,NrChannelPerImage,Markers,errorMessage]=read_data(filename,delim)
% READ_DATA Read and parse PhenoRipper metadata files
%
% read_data arguments :
% FILENAME     : the full patch to the medatada file - Required
% DELIM        : the delimiter between the different field - String - Required
%
% Output parameters:
% FILENAMES - cell array containing filenames (different files from the same
% image for the rows)
% METADATA - struct array used by PhenoRipper to store metadata
% ROOTDIR - The root dir from which all paths are specified
% NRCHANNELPERIMAGE - number of channels stored in each image file (1 for
% graysale, 3 for RGB etc)
% MARKERS - Cell array containing marker names
% ERRORMESSAGE - any error message generated
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
% ------------------------------------------------------------------------------
% Copyright ??2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.PhenoRipper.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%


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
    
    while (true) 
        
      data=textscan(fid,'%s',1,'delimiter','\n');  
      if(isempty(data{1}))
         break; 
      end
      tokens=regexp(data{1},delim,'split');
      tokens=tokens{1};
      
      f=regexp(tokens{1},';','split');
      
      file=cell(2,size(f,2));
      for i=1:size(f,2)
        file{1,i}=f{1,i};
        file{2,i}={1,0};
      end
      
%       if(NrChannelPerImage>1)
%         for i=1:NrChannelPerImage
%           file{2,i}={1,0};
%         end
%       end
      
      
      
      
      %filenames{line_counter}=regexp(tokens{1},';','split');
      %filenames{line_counter}=file;

      
      
      indexScaleIntensityA=find(not(cellfun('isempty', strfind(HeaderFields,'PHENORIPPER_I_SCALING_A'))));
      indexScaleIntensityB=find(not(cellfun('isempty', strfind(HeaderFields,'PHENORIPPER_I_SCALING_B'))));

      if(isempty(indexScaleIntensityA) || isempty(indexScaleIntensityB))  
        metadata(line_counter).None=tokens{1};
        for field_num=2:length(HeaderFields)
          metadata(line_counter).(HeaderFields{field_num})=tokens{field_num};
        end
        %data=textscan(fid,'%s',1,'delimiter','\n');
      else
        metadata(line_counter).None=tokens{1};
        for field_num=2:length(HeaderFields)
          if(strcmp(HeaderFields{field_num},'PHENORIPPER_I_SCALING_A'))
            intensity_scaling_a=regexp(tokens{field_num},';','split');
            for i=1:size(f,2)
              file{2,i}{1}=str2double(intensity_scaling_a{1,i});
            end
          elseif(strcmp(HeaderFields{field_num},'PHENORIPPER_I_SCALING_B'))
            intensity_scaling_b=regexp(tokens{field_num},';','split');   
            for i=1:size(f,2)
              file{2,i}{2}=str2double(intensity_scaling_b{1,i});
            end
          else
            metadata(line_counter).(HeaderFields{field_num})=tokens{field_num};
          end
        end
        %data=textscan(fid,'%s',1,'delimiter','\n');
      end
      filenames{line_counter}=file;
      line_counter=line_counter+1;
      if(feof(fid))
          break
      end
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

