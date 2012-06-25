function isSucceed = WriteData(fileName, metadata, RootDir, NrChannelPerImage, Markers)

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

