function functionHandles = checkbox_f
% CHECKBOX_F Functions that adjudicate the state of the main UI's checkboxes.
%
% See also:
% checkbox_f>getWellSelection
% checkbox_f>getElectrodeSelection
% checkbox_f>selectAllElectrodes
% checkbox_f>selectAllWells
% checkbox_f>clearAllWells
% checkbox_f>clearAllElectrodes
%
% Author:  Jonthan Cook
% Created: 2018-12-14

functionHandles.clearAllElectrodes = @clearAllElectrodes;
functionHandles.clearAllWells = @clearAllWells;
functionHandles.disableAllWells = @disableAllWells;
functionHandles.getWellSelection = @getWellSelection;
functionHandles.getElectrodeSelection = @getElectrodeSelection;
functionHandles.selectAllElectrodes = @selectAllElectrodes;
functionHandles.selectAllWells = @selectAllWells;
end

function wellRegExpValue = wellRegExp()
% WELLREGEXP Well checkbox regular expression name configuration.
%
% OUTPUT:
%     wellRegExpValue: Char array.
%
% See also:
% checkbox_f

wellRegExpValue = 'well[ABCD][1-6]';
end

function electrodeRegExpValue = electrodeRegExp()
% ELECTRODEREGEXPVALUE Electrode checkbox regular expression name configuration.
%
% OUTPUT:
%     electrodeRegExpValue: Char array.
%
% See also:
% checkbox_f

electrodeRegExpValue = 'electrode[\d{2}]';
end

function clearAllElectrodes(handles)
% CLEARALLELECTRODES All of the well checkboxes in the handles parameter
% are cleared (unchecked).
%
% INPUT:
%     handles:  Structure with handles and user data.
%
% See also:
% checkbox_f

electrodes = findobj(handles.electrodePanel.Children, '-regexp', 'Tag', electrodeRegExp());
for i = 1:length(electrodes)
    electrodes(i).Value = 0;
end
end

function clearAllWells(handles)
% CLEARALLWELLS All of the well checkboxes in the handles parameter are 
% cleared (unchecked).
%
% INPUT:
%     handles:  Structure with handles and user data.
%
% See also:
% checkbox_f

wells = findobj(handles.wellPanel.Children, '-regexp', 'Tag', wellRegExp());
for i = 1:length(wells)
    wells(i).Value = 0;
end
end

function disableAllWells(handles)
% DISABLEALLWELLS All of the well checkboxes in the handles parameter are
% disabled.
%
% INPUT:
%    handles:  Struture with handles and user data.
%
% See also:
% checkbox_f

wells = findobj(handles.wellPanel.Children, '-regexp', 'Tag', wellRegExp());
for i = 1:length(wells)
    wells(i).Enable = 'off';
end
end

function wellLogical = getWellSelection(handles)
% WELLLOGICAL Well logical representation - based on how each well checkbox is
% selected within the handles parameter, return a logical array to represent the
% selection.
%
% INPUT:
%     handles:  Structure with handles and user data.
%
% OUTPUT:
%     wellLogical: A logical array of 24 positions representing the state
%                  of well checkbox selection:
%                  [a1 a2 a3 a4 a5 a6 b1 b2 b3 b4 b5 b6 c1 c2 c3 c4 c5 c6 d1 d2 d3 d4 d5 d6].
% See also:
% checkbox_f

a1 = handles.wellA1.Value;   a2 = handles.wellA2.Value;   a3 = handles.wellA3.Value; a4 = handles.wellA4.Value;   a5 = handles.wellA5.Value;   a6 = handles.wellA6.Value;
b1 = handles.wellB1.Value;   b2 = handles.wellB2.Value;   b3 = handles.wellB3.Value; b4 = handles.wellB4.Value;   b5 = handles.wellB5.Value;   b6 = handles.wellB6.Value;
c1 = handles.wellC1.Value;   c2 = handles.wellC2.Value;   c3 = handles.wellC3.Value; c4 = handles.wellC4.Value;   c5 = handles.wellC5.Value;   c6 = handles.wellC6.Value;
d1 = handles.wellD1.Value;   d2 = handles.wellD2.Value;   d3 = handles.wellD3.Value; d4 = handles.wellD4.Value;   d5 = handles.wellD5.Value;   d6 = handles.wellD6.Value;
wellLogical = [a1 a2 a3 a4 a5 a6 b1 b2 b3 b4 b5 b6 c1 c2 c3 c4 c5 c6 d1 d2 d3 d4 d5 d6];
end

function electrodeLogical = getElectrodeSelection(handles)
% ELECTRODELOGICAL Electrode logical representation - based on how each electrode
% checkbox is selected within the handles parameter, return a logical array to
% represent
%
% INPUT:
%     handles:  Structure with handles and user data.
%
% OUTPUT:
%     wellLogical: A logical array of 12 positions representing the state
%                  of electrode checkbox selection:
%                  [e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12].
% See also:
% checkbox_f

e1 = handles.electrode12.Value;  e2 = handles.electrode13.Value;  e3 = handles.electrode21.Value;  e4 = handles.electrode22.Value;
e5 = handles.electrode23.Value;  e6 = handles.electrode24.Value;  e7 = handles.electrode31.Value;  e8 = handles.electrode32.Value;
e9 = handles.electrode33.Value;  e10 = handles.electrode34.Value; e11 = handles.electrode42.Value; e12 = handles.electrode43.Value;
electrodeLogical = [e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12];
end

function selectAllElectrodes(handles)
% SELECTALLELECTRODES All of the electrode checkboxes in the handles parameter
% are set to true (checked).
%
% INPUT:
%     handles:  Structure with handles and user data.
%
% See also:
% checkbox_f

electrodes = findobj(handles.electrodePanel.Children, '-regexp', 'Tag', electrodeRegExp());
for i = 1:length(electrodes)
    electrodes(i).Value = 1;
end
end

function selectAllWells(handles)
% SELECTALLWELLS All of the well checkboxes in the handles parameter are
% set to true (checked).
%
% INPUT:
%     handles:  Structure with handles and user data.

% See also:
% checkbox_f

wells = findobj(handles.wellPanel.Children, '-regexp', 'Tag', wellRegExp());
for i = 1:length(wells)
    wells(i).Value = 1;
end
end