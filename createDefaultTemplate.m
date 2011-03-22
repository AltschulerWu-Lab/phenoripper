%Create the default template list
function templates=createDefaultTemplate()
  templates=[];
  
  %TRUE RegExp
  %templates{1}=Template('A1/xxxxxxxx-1.png','(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(-1.png)$','A1/xxxxxxxx-1.png');
  %templates{2}=Template('c1-r1-xxxxxxxx-1.png','c(?<Row>[1-9])-r(?<Column>[0-9]{1,2})-\S*(-1.png)$','c1-r1-xxxxxxxx-1.png');
  %templates{3}=Template('w1-xxxxxxxx-1.png','w(?<Well>[0-9]{1,2})-\S*(-1.png)$','w1-xxxxxxxx-1.png');

  %RegExp conataining the LABEL (e.g. __SEPARATOR__ and __EXTENSION__)
  templates{1}=MyTemplate('A1/xxxxxxxx__SEPARATOR__dapi.__EXTENSION__','(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{2}=MyTemplate('c1-r1-xxxxxxxx__SEPARATOR__1.__EXTENSION__','c(?<Row>[1-9])-r(?<Column>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{3}=MyTemplate('w1-xxxxxxxx__SEPARATOR__dapi.__EXTENSION__','w(?<Well>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{4}=MyTemplate('Well A03/Alexa 488 - n000000.__EXTENSION__','Well (?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/(?<Channel>.*)(?<Separator> - )\S*(?<Extension>.__EXTENSION__)$');
  
  
  
  
  
  
  
  %A1/xxxxxxxx-dapi.png
  %(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(-)(?<ChannelNr>[a-z,A-Z]*)(.png)$
  
  %(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?<Separator>-)(?<Channel>\S*)(?<Extension>.png)$
  
  %NEW FORMAT
  %(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?<Separator>-)(?<Channel>\S*).(?<Extension>png)$
  
  
  
  %(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?<Separator>$$SEPARATOR$$)(?<Channel>\S*)(?<Extension>.$$EXTENSION$$)$
  
  
  
  %NEW FORMAT
  %(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?#Separator)(?<Channel>\S*)(?<Extension>.(?#Separator))$
  
  
  
  save('default-templates.mat','templates');
end



  %(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$
  %c(?<Row>[1-9])-r(?<Column>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$
  %w(?<Well>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$
  
  %A1/xxxxxxxx__SEPARATOR__1.__EXTENSION__



%Search though the regular expression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Get the separator
%regexp(test,'.*\(\?<Separator>(?<Sep>.*?)\).*')

%Get the channel
%regexp(test,'.*\(\?<Channel>(?<Chan>.*?)\).*')

%Get the Extension
%regexp(test,'.*\(\?<Extension>(?<Ext>*?)\).*')