function filenames=matched_filenames(file_list,expr,channel_names)
% Each image has n files corresponding to the n channels. We want to group
% the files per image.

% This code takes in:
% file_list : the list of all files in a directory (a cell array) 
% expr : Regular expression used to extract the information from those
% files. Must contain (?<Channel>xxxxxxx)
% channels_name: Cell array which contains the channel names

%Disclaimer: This function doen't do any checking to make sure the file
%exist. Make sure all you channel exist (it won't be checked) 

filenames=cell(0);

%Pick out the part of the regular expression which corresponds to the
%channel
pattern='\(\?<Channel>.*?\)'; 
channel_pattern=regexptranslate('escape',regexp(expr,pattern,'match'));





%BEFORE WAS LIKE THAT - CRASHED IF THE FILE NAME CONTAIN SPACE....
% %Get a simplify regexp from expr to match the channel from a filename
% %Step 1 e.g.: Get the regexp that match everything before CHANNEL
% %    'w(?<Well>[0-9]{1,2})-\S*(?<Separator>-)(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
% %'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
% expr=regexprep(expr,['\S*(?=' cell2mat(channel_pattern) ')'],'\(\?<=$0\)');
% %Step 2 e.g.: Get the regexp that match everything before AND after CHANNEL
% %'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
% %'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?=(?<Extension>.png)$)'
% expr=regexprep(expr,['(?<=' cell2mat(channel_pattern) ')(\S*)'],'\(\?=$0\)');
% %Step 3 e.g.: Simplify RegExp so NO groups are return.
% %'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
% %'(?<=w([0-9]{1,2})-\S*(-))([0-9]{1,2})(?=(.png)$)'
% expr=regexprep(expr,'\?<\w+?>','');

%NOW
%Get a simplify regexp from expr to match the channel from a filename
%Step 1 e.g.: Get the regexp that match everything before CHANNEL
%    'w(?<Well>[0-9]{1,2})-\S*(?<Separator>-)(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
%'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
expr=regexprep(expr,['.*(?=' cell2mat(channel_pattern) ')'],'\(\?<=$0\)');
%Step 2 e.g.: Get the regexp that match everything before AND after CHANNEL
%'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
%'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?=(?<Extension>.png)$)'
expr=regexprep(expr,['(?<=' cell2mat(channel_pattern) ')(.*)'],'\(\?=$0\)');
%Step 3 e.g.: Simplify RegExp so NO groups are return.
%'(?<=w(?<Well>[0-9]{1,2})-\S*(?<Separator>-))(?<Channel>[0-9]{1,2})(?<Extension>.png)$'
%'(?<=w([0-9]{1,2})-\S*(-))([0-9]{1,2})(?=(.png)$)'
expr=regexprep(expr,'\?<\w+?>','');








%Generate a filename list using the channel name list from the filename
%list. It will filter the files that doen't match with the expr.
match_counter=1;
for file_counter=1:length(file_list)
    filename=file_list{file_counter};
    %Extract the position of the channel from the file name.
    [~,~,pos,~,~,~,~]=regexp(filename,expr);
    if(~isempty(pos))
        for i=1:length(channel_names)
            filenames{match_counter,i}=[filename(1:(pos{1}(1)-1)) channel_names{i} filename((pos{1}(2)+1):end)];
        end
        match_counter=match_counter+1;
    end
end

