function filterGUI()
  filterHandle=[];
  myhandles=getappdata(0,'myhandles');  
  groupList = fieldnames(myhandles.grouped_metadata{1});
  %Skip the first field which is always files_in_group
  groupList = groupList(2:end);
  gui_width=600;
  gui_height=700;
  background_color='black';
  panel_width=1;
  panel_height=0.05;
  mainFig=figure('position',[0,0,gui_width,gui_height],'Color',background_color,...
    'MenuBar','none','Name','Data Filter');
  topPanel= uipanel('Parent', mainFig, ...
            'Position', [0 .85 panel_width 0.15],...
            'BackgroundColor', 'black','BorderType','none',...
            'Tag', 'topanel');
  uicontrol('Parent', topPanel, 'Style', 'text',...
           'String', 'Filter your data','ForegroundColor', [1 1 1],...
           'Units', 'normalized', 'FontWeight', 'bold', 'FontSize',16,'FontUnits','pixels',...
           'BackgroundColor', [0 0 0], 'Position', [0 0.7 1 0.25]);
  addFilterButton=uicontrol('Parent', topPanel, 'Style', 'pushbutton',...
         'String', 'Add Filter', ...
         'Units', 'normalized', 'FontWeight', 'bold',...
         'BackgroundColor', [1 1 1], 'Position', [0.05 0.3 0.2 0.20],...
         'Callback', {@addFilterCallBack});
  useFilterButton=uicontrol('Parent', topPanel, 'Style', 'pushbutton',...
         'String', 'Apply Filter', ...
         'Units', 'normalized', 'FontWeight', 'bold',...
         'BackgroundColor', [1 1 1], 'Position', [0.75 0.3 0.2 0.20],...
         'Callback', {@useFilterCallBack});
  filterHandle.filter{1}.filterPanel= uipanel('Parent', mainFig, ...
            'Position', [0 .8 panel_width panel_height],...
            'BackgroundColor', 'black','BorderType','none',...
            'Tag', 'userconsole');
  createFilterPanel(filterHandle.filter{1}.filterPanel, groupList, myhandles.grouped_metadata,1,1)
   
  
  function createFilterPanel(parentPanel, groupList, groupedMetadata,filterNr,selectedGroup)
    filterHandle.filter{filterNr}.filterType=uicontrol('Parent', parentPanel, 'Style', 'popup',...
           'String', 'And|Or', ...
           'Units', 'normalized', 'FontWeight', 'bold',...
           'BackgroundColor', [1 1 1], 'Position', [0.02 0 0.1 0.9]);
    filterHandle.filter{filterNr}.GroupList=uicontrol('Parent', parentPanel, 'Style', 'popup',...
           'String', groupList, ...
           'Units', 'normalized', 'FontWeight', 'bold',...
           'BackgroundColor', [1 1 1], 'Position', [0.17 0 0.30 0.9],...
           'Callback', {@groupListCallBack, filterNr,groupedMetadata});           
    filterHandle.filter{filterNr}.GroupOperator=uicontrol('Parent', parentPanel, 'Style', 'popup',...
           'String', '=|!=', ...
           'Units', 'normalized', 'FontWeight', 'bold',...
           'BackgroundColor', [1 1 1], 'Position', [0.48 0 0.06 0.9]); 
    try
      groupFields=cellfun(@(x) cell2mat(getfield(x,groupList{selectedGroup})),...
                groupedMetadata,'UniformOutput',false);
    catch
      groupFields=cellfun(@(x) getfield(x,groupList{selectedGroup}),...
                groupedMetadata,'UniformOutput',false);              
      groupFields=cell2mat(groupFields);
    end    
    if isnumeric(groupFields(1))
      groupFields=uint64(groupFields);
    end
    groupFields=unique(groupFields);
    filterHandle.filter{filterNr}.GroupFields=uicontrol('Parent', parentPanel, 'Style', 'popup',...
           'String', groupFields, ...
           'Units', 'normalized', 'FontWeight', 'bold',...
           'BackgroundColor', [1 1 1], 'Position', [0.55 0 0.30 0.9]);
    filterHandle.filter{filterNr}.RemoveBtn=uicontrol('Parent', parentPanel, 'Style', 'pushbutton',...
           'String', 'Remove', ...
           'Units', 'normalized', 'FontWeight', 'bold',...
           'BackgroundColor', [1 1 1], 'Position', [0.86 0.15 0.13 0.8],...
           'Callback', {@removeFilterCallBack, filterNr});   
  end

  function addFilterCallBack(src, evt)
    NrFilter = size(filterHandle.filter,2);
    panelPosition = 0.8-NrFilter*panel_height;
    filterHandle.filter{NrFilter+1}.filterPanel= uipanel('Parent', mainFig, ...
            'Position', [0 panelPosition panel_width panel_height],...
            'BackgroundColor', 'black','BorderType','none',...
            'Tag', 'userconsole');
   createFilterPanel(filterHandle.filter{NrFilter+1}.filterPanel,...
     groupList, myhandles.grouped_metadata,NrFilter+1,1);
  end

  function removeFilterCallBack(src, evt, filterNr)
    nrOfFilter=size(filterHandle.filter,2);
    if (nrOfFilter==1)
      return;
    end
    filterCell=filterHandle.filter;
    filterHandle.filter=cell(1,nrOfFilter-1);
    nr=1;
    for i=1:nrOfFilter
      if(i~=filterNr)
        filterHandle.filter{nr}=filterCell{i};
        panelPosition = 0.8-(nr-1)*panel_height;
        set(getfield(filterHandle.filter{nr},'filterPanel'),'Position', [0 panelPosition panel_width panel_height]);
        set(getfield(filterHandle.filter{nr},'RemoveBtn'),  'Callback', {@removeFilterCallBack, nr});
        nr=nr+1;
      else
        deleteFilter(filterCell{i});
      end
    end
    
  end

  function deleteFilter(filter)
    filterFileds = fieldnames(filter);
    for i=1:size(filterFileds,1)
      try
      delete(getfield(filter,filterFileds{i}));
      catch exception
        disp(exception);
      end
    end
  end

  function groupListCallBack(src, evt, filterNr,groupedMetadata)
    groupFilter=filterHandle.filter{filterNr};
    groupIndex=get(groupFilter.GroupList, 'Value');
    try
      groupFields=cellfun(@(x) cell2mat(getfield(x,groupList{groupIndex})),...
                groupedMetadata,'UniformOutput',false);
    catch
      groupFields=cellfun(@(x) getfield(x,groupList{groupIndex}),...
                groupedMetadata,'UniformOutput',false);
      groupFields=cell2mat(groupFields);
    end
    groupFields=unique(groupFields);
    if isnumeric(groupFields(1))
      groupFields=uint64(groupFields);
    end
    filterHandle.filter{filterNr}.GroupFields=uicontrol('Parent',...
            filterHandle.filter{filterNr}.filterPanel, 'Style', 'popup',...
           'String', groupFields, ...
           'Units', 'normalized', 'FontWeight', 'bold',...
           'BackgroundColor', [1 1 1], 'Position', [0.55 0 0.30 0.9]);
  end

  function useFilterCallBack(src, evt)
    NrFilter = size(filterHandle.filter,2);
    %Fill up the filterMatrix
    % 1st col is the And(1)/Or(2) operator
    % 2nd col is the group field index selected
    % 3nd col is the group operator equal(1),different(2),<(3),>(4)
    % 4nd col is the group value index selected
    % Order coming from:
    %groupList = fieldnames(myhandles.grouped_metadata{1})
    %groupFields=cellfun(@(x) cell2mat(getfield(x,groupList{selectedGroup})),...
    %             groupedMetadata,'UniformOutput',false);)
    myhandles=getappdata(0,'myhandles');
    myhandles.filterMatrix = zeros(NrFilter,4);
    myhandles.filterLogicList=zeros(NrFilter,1);
    for i=1:NrFilter
      myhandles.filterLogicList(i,1)=get(filterHandle.filter{i}.filterType,'Value');
      myhandles.filterMatrix(i,2)=get(filterHandle.filter{i}.GroupList,'Value');
      myhandles.filterMatrix(i,3)=get(filterHandle.filter{i}.GroupOperator,'Value');
      myhandles.filterMatrix(i,4)=get(filterHandle.filter{i}.GroupFields,'Value');
    end
    setappdata(0,'myhandles',myhandles);
    delete(gcf);
  end

%   function selectedString=getSelectedString(comboBox)
%     index = get(comboBox,'Value');
%     stringList = get(comboBox,'String');
%     selectedString=stringList{index};
%   end

end