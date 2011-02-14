function regexpHelper()
% REGEXPHELPER is a GUI that helps write regular expressions
%
%   REGEXPHELPER() provides a GUI that helps construct regular expressions.
%   As you type your pattern and string are evaluated for you using the
%   REGEXP Command (If you are unfamiliar with regular expressions please 
%   see HELP REGEXP). 
%
%   Regular Expression patterns are entered into the "Regexp Pattern" Box.
%   Every Regular expression needs a string to be evaluated, such as 
%   REGEXP(string,pattern). The string to be evaluated is entered in 
%   the "Text" Box. 
%
%   The regular expression pattern and string are evaluated on
%   the fly. As you type the "Matches" found by your regular expression
%   pattern are displayed in the "Matches" Box.
%   
%   Example using REGEXPHELPER
%       % Bring up the RegexpHelper GUI
%       regexpHelper();
%       % Enter your pattern in the "Pattern" Box
%       % Enter your string in the "Text" Box
%       % See your matches come up in the "Matches" box as you type

PatternToolTipText = ...
    ['This is the regular expression pattern box. What you enter here is evaluated in a ',char(13),...
    'regular expression such as regexp(string,RegexpPattern)'];
TextToolTipText = 'Put the string you want to evaluate with a regular expression here';
MatchesToolTipText = 'As you type the regular expression will be evaluated, the results will show up here.';

ExampleRegexpPattern = '(?<TheLetter>B)';
ExampleRegexpString = 'A B C';

h = [];
%% The Parent figure
mfigure = figure('name','RegexpHelper');
set(mfigure,'NumberTitle','off');
set(mfigure,'MenuBar','none');
set(mfigure,'visible','on');
set(mfigure,'closerequestfcn',@(obj, event) closeRequestFcn);
set(mfigure,'Resize','on');
set(mfigure,'DoubleBuffer','on');
set(mfigure,'ResizeFcn',@(obj,event) resizeFun);
set(mfigure,'units','characters');

%% The Regular Expression Pattern label box
PatternTextBox = uicontrol(mfigure,'Style','Text');
set(PatternTextBox,'units','characters');
set(PatternTextBox,'String',['Regexp',char(13),'Pattern',char(13)]);
set(PatternTextBox,'position',[0 53 10 50]);
set(PatternTextBox,'FontName','arial');
set(PatternTextBox,'FontSize',10);
set(PatternTextBox,'BackgroundColor',get(mfigure,'Color'))

%% The Text box label
TextTextBox = uicontrol(mfigure,'Style','text');
set(TextTextBox,'units','characters');
set(TextTextBox,'String','Text');
set(TextTextBox,'position',[0 45 10 2]);
set(TextTextBox,'String','Text');
set(TextTextBox,'FontSize',10);
set(TextTextBox,'FontName','arial');
set(TextTextBox,'BackgroundColor',get(mfigure,'Color'))

%% Label for the matches text box
MatchesTextBox = uicontrol(mfigure,'Style','text');
set(MatchesTextBox,'FontName','arial');
set(MatchesTextBox,'FontSize',10);
set(MatchesTextBox,'units','characters');
set(MatchesTextBox,'String','Matches');
set(MatchesTextBox,'position',[0 20 10 2]);
set(MatchesTextBox,'BackgroundColor',get(mfigure,'Color'));

%% Java Text box for the string to be regexp'ed
jStringBox = javaObject('javax.swing.JEditorPane');
set(jStringBox,'ToolTipText',TextToolTipText);
set(jStringBox,'KeyReleasedCallback',@(obj,event) regexplistener);
jScrollPane = javaObject('javax.swing.JScrollPane',jStringBox);
jScrollPane.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
[hScrollComponent,hScrollContainer] = javacomponent(jScrollPane);
set(hScrollContainer,'Units','character');
set(hScrollContainer,'position',[1 12 70 10]);
thehighlighter = jStringBox.getHighlighter();
jStringBox.setText(ExampleRegexpString);

%% Matches from the regexp are displayed in this Java text box
jAnsBox = javaObject('javax.swing.JEditorPane');
set(jAnsBox,'ToolTiptext',MatchesToolTipText);
jAnsScrollPane = javaObject('javax.swing.JScrollPane',jAnsBox);
[hAnsComponent,hAnsContainer] = javacomponent(jAnsScrollPane);
set(hAnsContainer,'Units','character');
set(hAnsContainer,'position',[1 1 70 10]);

%% Create a highlighter to be used later
yellowHighlighter = javaObject(...
    'javax.swing.text.DefaultHighlighter$DefaultHighlightPainter', java.awt.Color.yellow);

%% Regular expression Java text box
jPatternBox = javaObject('javax.swing.JEditorPane');
set(jPatternBox,'ToolTipText',PatternToolTipText);
jPatternScrollBox = javaObject('javax.swing.JScrollPane',jPatternBox);
jPatternScrollBox.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
[hPatternComponent,hPatternContainer] = javacomponent(jPatternScrollBox);
set(hPatternContainer,'Units','character');
set(hPatternContainer,'position',[1 26.5 70 1.5]);
set(jPatternBox,'KeyReleasedCallback',@(obj,event) regexplistener);
jPatternBox.setText(ExampleRegexpPattern);

%% Import text button
importTextButton = uicontrol('style','pushbutton');
set(importTextButton,'String','Import Text...');
set(importTextButton,'Units','Characters');
webButtonLength = 15;
webButtonHeight = 1.5;
set(importTextButton,'Position',[34 23 webButtonLength webButtonHeight]);
set(importTextButton,'Callback',@(obj,event) importtextcallback());

% Just to make sure everything is aligned
resizeFun();
regexplistener();

h.setText = @setText;

    function setText(newText)
        jStringBox.setText(newText);
    end

    function importtextcallback()
        h.ResourceString = [];
        selection = []; %#ok<NASGU>
        %todo: add in other ways of importing text
        %selection = menu('Import Text ....','from the web','from a file','from the workspace');
        selection = menu('Import Text ...','from the web');
        if ~isempty(selection)
            switch selection
                case 1
                    hSelection = WebsiteScreenScrapeFigure(h);
                    % Wait for the ui to finish
                    uiwait(hSelection.mfigure);
            end
        end
    end

    function resizeFun()
        mfigpos = get(mfigure,'position'); %figure window
        mfigheight = mfigpos(4);
        mfigwidth = mfigpos(3)-15;
        jboxheight = 1.5;
        buttonheight = 1;
        offsetpos = 11;

        set(hPatternContainer,'position',[offsetpos mfigheight-4-jboxheight mfigwidth 4]);% pattern
        set(PatternTextBox,'position',[0 mfigheight-2-jboxheight-1 10 3]);

        set(importTextButton,'Position',[offsetpos+34 mfigheight-4-jboxheight-.5-jboxheight-.5-buttonheight-.4 webButtonLength webButtonHeight]);
        shareboxheight = ((mfigheight-4-jboxheight-.5-jboxheight-.5-buttonheight-3)/2);

        set(hScrollContainer,'position',[offsetpos shareboxheight+2 mfigwidth shareboxheight]); %Text Area
        set(TextTextBox,'position',[0 shareboxheight+2+shareboxheight-2 10 2]);

        set(hAnsContainer,'position',[offsetpos 1 mfigwidth shareboxheight]); %answer box
        set(MatchesTextBox,'position',[0 1+shareboxheight-2 10 2]);
    end
idx = [];

h.RegexpListener = @regexplistener;
    function regexplistener()
        awtinvoke(thehighlighter,'removeAllHighlights()')%todo: figure out how to remove this
        while ~isempty(thehighlighter.getHighlights())
            pause(.001);
        end
        thestring = char(jStringBox.getText());
        pattern = char(jPatternBox.getText());

        [idx edx ext mat tok nam] = regexp(thestring,pattern,...
            'start','end','tokenExtents','match','tokens','names');

        %if get(matchbutton,'Value')
        fnames = fieldnames(nam);
        if ~isempty(nam)
            newtext = [num2str(length(nam)), ' Matches',char(13)];

            for namidx = 1:length(nam)
                for fnamesidx = 1:length(fnames)
                    newtext = [newtext, fnames{fnamesidx},' : ', nam(namidx).(fnames{fnamesidx}),char(13)]; %#ok<AGROW>
                end
                newtext = [newtext,char(13)]; %#ok<AGROW>
            end
        else
            newtext = 'No matches found';
        end
        jAnsBox.setText(newtext);
        for termsidx = 1:length(idx)
            startOffset = length(strfind(thestring(1:idx(termsidx)),char(13)));
            endOffset = length(strfind(thestring(1:edx(termsidx)),char(13)));
            thehighlighter.addHighlight((idx(termsidx)-1-startOffset),(edx(termsidx)-endOffset),yellowHighlighter);
        end

    end

    function closeRequestFcn()
        closereq;
    end
end

function h = WebsiteScreenScrapeFigure(hParent)
h = [];
h.Parent = hParent;

mfigure = figure('name','Import text from a website');
set(mfigure,'NumberTitle','off');
set(mfigure,'MenuBar','none');
set(mfigure,'visible','on');
set(mfigure,'Resize','off');
set(mfigure,'DoubleBuffer','on');
set(mfigure,'units','characters');
set(mfigure,'position',[266 57 60 10])
h.mfigure = mfigure;

websiteTextBox = uicontrol(mfigure,'style','edit');
set(websiteTextBox,'units','characters');
set(websiteTextBox,'position',[2 6 55 1.5]);
set(websiteTextBox,'BackgroundColor',[1 1 1])
h.websiteTextBox = websiteTextBox;

websitetext = uicontrol(mfigure,'style','text');
set(websitetext,'units','characters');
set(websitetext,'string','The URL goes here');
set(websitetext,'position',[15 8 20 1]);
h.websitetext = websitetext;

okbutton = uicontrol(mfigure,'style','pushbutton');
set(okbutton,'string','OK');
set(okbutton,'units','characters');
set(okbutton,'position',[10 2.2 12 3]);
set(okbutton,'callback',@(obj,event) okcallback());

cancelbutton = uicontrol(mfigure,'style','pushbutton');
set(cancelbutton,'string','CANCEL');
set(cancelbutton,'units','characters');
set(cancelbutton,'position',[25 2.2 12 3]);
set(cancelbutton,'callback',@(obj,event) closeRequestFunction);

errorStatusBar = uicontrol(h.mfigure,'style','edit');
set(errorStatusBar,'units','characters');
set(errorStatusBar,'position',[0 0 59 1.5]);
h.errorStatusBar = errorStatusBar;

    function okcallback()
        url = get(websiteTextBox,'String');
        try
            string = strtrim(deblank(urlread(url)));
            %string = regexprep(string,char(13),' ');

            % Set parents resource string
            if ~isempty(hParent)
                hParent.setText(string);
            end
            % close figure window
            closeRequestFunction();
        catch e
            % display error
            set(errorStatusBar,'String',e.message);
            set(errorStatusBar,'ForegroundColor','r');
        end
    end

    function closeRequestFunction()
        closereq;
    end

end
