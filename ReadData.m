function [filenames,metadata]=ReadData(filename,delim)
    fid0 = fopen(filename,'rt');
    nLines = 0;
    while (fgets(fid0) ~= -1),
      nLines = nLines+1;
    end
    fclose(fid0); 


    fid =fopen(filename);
    HeaderRow=textscan(fid,'%s',1,'delimiter','\n');
    HeaderFields=regexp(cell2mat(HeaderRow{1}),delim,'split');
    metadata=struct;
    filenames=cell(nLines-1,1);
    line_counter=1;
    data=textscan(fid,'%s',1,'delimiter','\n');
    while (~feof(fid)) 
        tokens=regexp(data{1},delim,'split');
        tokens=tokens{1};
        filenames{line_counter}=regexp(tokens{1},';','split');
        for field_num=2:length(HeaderFields)
                metadata(line_counter).(HeaderFields{field_num})=tokens{field_num};
        end
        line_counter=line_counter+1;
       data=textscan(fid,'%s',1,'delimiter','\n');
    end
end

