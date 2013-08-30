function handles_visibility(handles,vis)

    switch vis
        case 0
            strvis = 'off';
        case 1
            strvis = 'on';
        otherwise
            error('Invalid second parameter!');
    end

    if ishandle(handles)
        set(handles,'Visible',strvis);
    end