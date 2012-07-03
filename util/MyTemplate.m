classdef MyTemplate
% MyTemplate all templates are instances of this class
%
% Usage:
% MyTemplate a;
% [idx edx ext mat tok a.Groupby]=regexp(a.Name,a.Pattern,'start','end','tokenExtents','match','tokens','names');
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
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


  properties
    Example = '';
    %Pattern doen't contain a true Regular expression since some stuff are
    %stored in a tag way :
    %__SEPARATOR__ replace any kind of separator (e.g. -, ch, etc...)
    %__EXTENSION__ replace any kind of file extension (e.g. png, tiff etc...)
    Pattern = '';
    Description='';
    isMultiChannel=false;
  end
  
  methods
    function obj = MyTemplate(a,b,c)
      if(nargin == 3)
        obj.Example = a;
        obj.Pattern = b;
        obj.isMultiChannel = c;
      elseif(nargin == 2)
        obj.Example = a;
        obj.Pattern = b;
      elseif(nargin == 1)
        obj.Example = a;
      end
    end

    function obj=getOSTemplate(obj)
      if(isunix)
         obj.Pattern = regexprep(obj.Pattern, '\\\\', '\/');
      else
         obj.Pattern = regexprep(obj.Pattern, '\/', '\\');
      end
    end    

    function regExpression=getRegularExpression(obj,fileExtension,channelSep)
      %Replace first the channel separator tag  by the selected one
      %regExpression = regexprep(obj.Pattern,'.*\(\?<Separator>(?<Sep>.*?)\).*',channelSep);
      regExpression = regexprep(obj.Pattern,'__SEPARATOR__',channelSep);
      %Then replace first the file extension tag by the selected one
      %regExpression = regexprep(regExpression,'.*\(\?<Extension>(?<Ext>*?)\).*',fileExtension);
      regExpression = regexprep(regExpression,'__EXTENSION__',fileExtension);
    end
    
       

%     function regExpression=setExample(obj,example)
%       %Replace first the channel separator tag  by the selected one
%       %regExpression = regexprep(obj.Pattern,'.*\(\?<Separator>(?<Sep>.*?)\).*',channelSep);
%       obj.Example = regexprep(obj.Pattern,'__SEPARATOR__',channelSep)
%       %Then replace first the file extension tag by the selected one
%       %regExpression = regexprep(regExpression,'.*\(\?<Extension>(?<Ext>*?)\).*',fileExtension);
%       obj.Example = regexprep(regExpression,'__EXTENSION__',fileExtension)
%     end
    
    
    function obj=setPattern(obj,pattern)      
      %Replace first the separator by the Tag separator
      [~, ~, ~, ~, ~, group]=regexp(pattern,'.*\(\?<Separator>(?<Sep>.*?)\).*');      
      if(isfield(group,'Sep') && length(group)>0 && ~isempty(group.Sep))
        obj.Pattern = regexprep(pattern,'group.Sep','__SEPARATOR__');  
      end
      %Then replace first the file extension by the Tag file extension
      [~, ~, ~, ~, ~, group]=regexp(pattern,'.*\(\?<Extension>(?<Ext>.*?)\)');      
      if(isfield(group,'Ext') && length(group)>0 && ~isempty(group))
        obj.Pattern = regexprep(pattern,'group.Ext','.__EXTENSION__');  
      end
    end
    
    function name=getName(obj,fileExtension,channelSep)
      name = regexprep(obj.Example,'__SEPARATOR__',channelSep);
      %Then replace first the file extension by the Tag file extension
      name = regexprep(name,'__EXTENSION__',fileExtension);
    end
    
    function groupbyList=getGroupbyList(obj)
      [~, ~, ~, ~, ~, group]=regexp(obj.Example, obj.Pattern, 'start','end','tokenExtents','match','tokens','names');
      if(isempty(group))
        warndlg('Regular expression doesn''t match with the example!');
      else
        %Remove the internal group used to indicate Separator, Extension
        %and Channel
        if(~obj.isMultiChannel)
          try
          group=rmfield(group,'Separator');
          group=rmfield(group,'Channel');
          catch
            warndlg('Single Channel Template must contain the Separator and Channel identifier in their regular expression');
            return;
          end
        end
        group=rmfield(group,'Extension');
        groupbyList=fieldnames(group);
      end
        [~, ~, ~, ~, ~, group]=regexp(obj.Example,['.*(?<sep>' filesep ').*'],'start','end','tokenExtents','match','tokens','names');
      if(~isempty(group))
        
        position=length(groupbyList)+1;
        groupbyList{position}='Dir';
      end
    end
    
    function groupExampleList=getGroupExampleList(obj)
      [~, ~, ~, ~, ~, group]=regexp(obj.Example, obj.Pattern, 'start','end','tokenExtents','match','tokens','names');
      if(isempty(group))
        warndlg('Regular expression doesn''t match with the example!');
      else
        %Remove the internal group used to indicate Separator, Extension
        %and Channel
        if(~obj.isMultiChannel)
          try
          group=rmfield(group,'Separator');
          group=rmfield(group,'Channel');
          catch
            warndlg('Single Channel Template must contain the Separator and Channel identifier in their regular expression');
            return;
          end
        end
        group=rmfield(group,'Extension');
        
        fieldValues=(struct2cell(group));
        groupExampleList=cellfun(@(x,y) [x '=' y],fieldnames(group),fieldValues,'uni',0);
      end
        [tokenExt,group]=...
          regexp(obj.Example,['.*(?<sep>' filesep ').*'],'tokenExtents','names');
      if(~isempty(group))
        dirName=obj.Example(1:tokenExt{1}(1));
        position=length(groupExampleList)+1;
        groupExampleList{position}=['Dir=' dirName];
      end
    end
    
  end%methods
  
end%classdef
      
%       function [metadata,files_with_matches]=extract_regexp_metadata(file_matrix,regular_expressions)
%         [number_of_files,files_per_image]=size(file_matrix);
%         metadata=cell(1,number_of_files);
% 
%         dir_start=regexp(file_matrix(:,1),filesep);
%         handles=getappdata(0,'handles');
%         root_directory=get(handles.rootdirectory_edit,'String');
%         for i=1:number_of_files
%           temp=file_matrix(i,:);
%           % handles=getappdata(0,'handles');
%           for j=1:files_per_image
%             if(isempty(regexpi(temp{j},['^' root_directory],'match')))
%               metadata{i}.FileNames{j}=[root_directory filesep temp{j}];
%             else
%               metadata{i}.FileNames{j}=temp{j};
%             end
%           end
%           metadata{i}.None=file_matrix{i,1}; 
%           if(~isempty(dir_start{i}))
%             metadata{i}.Directory=file_matrix{i,1}(1:dir_start{i}(end));
%           else
%             metadata{i}.Directory='';
%           end
%         end
% 
%         files_with_matches=true(number_of_files,files_per_image);
% 
%         for channel=1:files_per_image
%           if(~isempty(regular_expressions{channel}))        
%             file_names=file_matrix(:,channel);
%             pattern=regular_expressions{channel};
%             [idx edx ext mat tok nam] = regexp(file_names,pattern,...
%                 'start','end','tokenExtents','match','tokens','names');
% 
%             matched_bool=~cellfun('isempty',mat);
%             files_with_matches(:,channel)=matched_bool;
%             matched=find(matched_bool);
% 
%             if(~isempty(matched))
%               fnames=fieldnames(nam{matched(1)});
%             else
%               errordlg('No matches');
%             end
% 
%             for i=1:number_of_files
%               if(matched_bool(i))
%                 for j=1:length(fnames)
%                     temp=nam{i}.(fnames{j});
%                     if(strcmp(temp,''))
%                         metadata{i}.(fnames{j})=[];
%                     else
%                         metadata{i}.(fnames{j})=temp;                            
%                     end
%                 end
%               else
%                 for j=1:length(fnames)
%                     metadata{i}.(fnames{j})=[];
%                 end
%               end
%             end
%           end
%         end
%         
%         files_with_matches=any(files_with_matches,2);
%         metadata=metadata(files_with_matches);
%       end% extract_regexp_metadata
