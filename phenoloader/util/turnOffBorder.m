function turnOffBorder(handles)
% TURNOFFBORDER turns off the border of a handle
%   TURNOFFBORDER(handles) sets the border handles for the component to be
%   off
%
%   FINDPATTERNFEAT arguments:
%   handles - handles for the component that will have the color border
% ------------------------------------------------------------------------------
% Copyright ??2013, The University of Texas Southwestern Medical Center 
% Authors:
% Austin Ouyang for the Altschuler and Wu Lab
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

    jComponent = findjobj(handles);

    % Prepare the red border panel
    colorBorder = javax.swing.border.LineBorder(java.awt.Color.gray,0,0);
    colorBorderPanel = javax.swing.JPanel;
    colorBorderPanel.setBorder(colorBorder);
    colorBorderPanel.setOpaque(0);  % transparent interior, red border
    colorBorderPanel.setBounds(jComponent.getBounds);
    isSettable = ismethod(jComponent,'setBorder');

       
    jParent = jComponent.getParent;

    % Most Java components allow modifying their borders
    if isSettable          
        % Set a red border
        jComponent.setBorder(colorBorder);
        try jComponent.setBorderPainted(1); 
            catch, 
        end        
        
        jComponent.repaint;

    % Other Java components are highlighted by a transparent red-
    % border panel, placed on top of them in their parent's space
    elseif ~isempty(jParent)          
        % place the transparent red-border panel on top
        jParent.add(colorBorderPanel);
        jParent.setComponentZOrder(colorBorderPanel,0);          
        jParent.repaint;
    end
    
   