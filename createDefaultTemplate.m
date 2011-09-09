%Create the default template list
function templates=createDefaultTemplate()
  templates=[];
  templates{1}=MyTemplate('A1/xxxxxxxx__SEPARATOR__1.__EXTENSION__','(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{2}=MyTemplate('c1-r2-xxxxxxxx__SEPARATOR__1.__EXTENSION__','c(?<Row>[1-9])-r(?<Column>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{3}=MyTemplate('w1-xxxxxxxx__SEPARATOR__dapi.__EXTENSION__','w(?<Well>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{4}=MyTemplate('Well A03/Alexa 488 - n000000.__EXTENSION__','Well (?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\/(?<Channel>.*)(?<Separator> - )\S*(?<Extension>.__EXTENSION__)$');
  templates{5}=MyTemplate('HT01/HT01A004/image_1.__EXTENSION__','\S*\/HT(?<Plate>[0-9]*)(?<Row>[A-Z]*)(?<Column>[0-9]*)\/\S*_(?<ImgNum>[0-4]*)(?<Extension>.__EXTENSION__)$',true);
  save('default-templates_unix.mat','templates');
  
  
  templates=[];
  templates{1}=MyTemplate('A1\xxxxxxxx__SEPARATOR__1.__EXTENSION__','(?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\\\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{2}=MyTemplate('c1-r2-xxxxxxxx__SEPARATOR__1.__EXTENSION__','c(?<Row>[1-9])-r(?<Column>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{3}=MyTemplate('w1-xxxxxxxx__SEPARATOR__dapi.__EXTENSION__','w(?<Well>[0-9]{1,2})-\S*(?<Separator>__SEPARATOR__)(?<Channel>\S*)(?<Extension>.__EXTENSION__)$');
  templates{4}=MyTemplate('Well A03\Alexa 488 - n000000.__EXTENSION__','Well (?<Row>[A-Z]*)(?<Column>[0-9]{1,2})\\(?<Channel>.*)(?<Separator> - )\S*(?<Extension>.__EXTENSION__)$');
  templates{5}=MyTemplate('HT01\HT01A004\image_1.__EXTENSION__','\S*\/HT(?<Plate>[0-9]*)(?<Row>[A-Z]*)(?<Column>[0-9]*)\\\S*_(?<ImgNum>[0-4]*)(?<Extension>.__EXTENSION__)$',true);
  save('default-templates_windows.mat','templates');
end