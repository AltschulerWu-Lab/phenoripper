function isSucceed = write_data(fileName, metadata, RootDir, NrChannelPerImage, Markers)
% WRITE_DATA - write metadata to file in PhenoRipper format
%   ISSUCCEED = WRITE_DATA(FILENAME, METADATA, ROOTDIR, ...
%   NRCHANNELPERIMAGE, MARKERS) creates a metadata file, in PhenoRipper
%   format, with name filename. On success isSucceed returnd true.
%
%   write_data arguments:
%   FILENAME - name of output file
%   METADATA - struct array containing image metadata in PhenoRipper format
%   ROOTDIR - root directory name as string. All paths are measured relative to
%   this
%   NRCHANNELPERIMAGE - Number of channels in each image file (e.g. 1 for
%   grayscale)
%   MARKERS - Cell array containing names of markers
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




  %Open the file
  fid =fopen(fileName,'w');
  
  if(fid<0)
    isSucceed=false;
    return;
  end
  
  %Define the Header
  fprintf(fid, '%s\r\n', ['#RootDir:' RootDir]);
  if(~isempty(Markers))
    fprintf(fid, '%s\r\n', ['#NrChannelPerImage:' num2str(NrChannelPerImage)]);
  end
  
   if(~isempty(Markers))
     markers='#Markers:';
     for i=1:length(Markers)
       markers = [markers Markers{i}.name ';'];
     end
    markers = markers(1:length(markers)-1);
    fprintf(fid, '%s\r\n', markers);
   end
  %Add the empty line
  fprintf(fid, '%s\r\n', '');
  
  
  %Add the field names
  fieldNames=fieldnames(metadata{1});
  fields='';
  for i=1:length(fieldNames)
    if(~strcmp(fieldNames{i,1},'None'))
      fields=[fields fieldNames{i,1} ','];
    end
  end
  fields = fields(1:length(fields)-1);
  fprintf(fid, '%s\r\n', fields);
  
  %Add the Metadata per image Format is:
  %fileName1;fileName2;fileName3,fieldGroup1,fieldGroup2
  for i=1:length(metadata)
    %Get the FileNames
    metdataLine=sprintf('%s;',metadata{i}.FileNames{:});
    metdataLine=metdataLine(1:length(metdataLine)-1);
    
    %get the other field and exclude 'None'
    fieldNames=fieldnames(metadata{i});
    for j=1:length(fieldNames)
      if(~strcmp(fieldNames{j,1},'None')&&~strcmp(fieldNames{j,1},'FileNames'))
        metdataLine=[metdataLine ',' metadata{i}.(fieldNames{j})];
      end
    end
    fprintf(fid, '%s\r\n', metdataLine);
  end
  isSucceed=fclose(fid);
end

