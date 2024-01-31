function varargout = waveformAnalysis(varargin)
% WAVEFORMANALYSIS MATLAB code for waveformAnalysis.fig
%      WAVEFORMANALYSIS, by itself, creates a new WAVEFORMANALYSIS or raises the existing
%      singleton*.
%
%      H = WAVEFORMANALYSIS returns the handle to a new WAVEFORMANALYSIS or the handle to
%      the existing singleton*.
%
%      WAVEFORMANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVEFORMANALYSIS.M with the given input arguments.
%
%      WAVEFORMANALYSIS('Property','Value',...) creates a new WAVEFORMANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waveformAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waveformAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waveformAnalysis

% Last Modified by GUIDE v2.5 10-Jan-2019 11:40:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @waveformAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @waveformAnalysis_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function waveformAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% WAVEFORMANALYSIS_OPENINGFCN This function has no output args, see
% OutputFcn. Executes just before waveformAnalysis is made visible
%
% INPUT:
%     hObject:    Handle to figure
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)
%     varargin:   Command line arguments to waveformAnalysis (see VARARGIN)

% Choose default command line output for waveformAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Allow the appropriate libraries to be accessible.
addpath(strcat(pwd,'/McsMatlabDataTools_1.0.3/McsMatlabDataTools/'));
import +McsHDF5.*

% Set the keep/skip helper toggle button - phantom.
set(handles.ns, 'Value', 1);

% ----------------------------REQUIRED----------------------------------
% The following functions are required and should never be deleted.
% If removed, the application will throw execptions or not function properly.
% Implementation is not required - presence of is.
function fileRead_Callback(hObject, eventdata, handles)

function fileH5_Callback(hObject, eventdata, handles)

function analysis_Callback(hObject, eventdata, handles)

function redoToggle_Callback(hObject, eventdata, handles)

function waveformOptionsPanel_SelectionChangedFcn(hObject, eventdata, handles)
% ----------------------------------------------------------------------

% ---------------------CUSTOM IMPLEMENTATIONS---------------------------
function varargout = waveformAnalysis_OutputFcn(hObject, eventdata, handles)
% WAVEFORMANALYSIS_OUTPUTFCN Outputs from this function are returned to the command line.
% varargout  cell array for returning output args (see VARARGOUT);
%
% INPUT:
%     hObject:    Handle to figure.
%     eventdata:  Reserved - to be defined in a future version of MATLAB.
%     handles:    Structure with handles and user data (see GUIDATA).

% Get default command line output from handles structure
varargout{1} = handles.output;

function wellSelectAll_Callback(hObject, eventdata, handles)
% WELLSELECTALL_CALLBACK Executes when the 'Select All' button is selected in the
% well panel.  All of the well checkboxes are selected.
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

checkboxFunctions = segmentation.functions.ui.main.checkbox_f;
checkboxFunctions.selectAllWells(handles);

function wellClearAll_Callback(hObject, eventdata, handles)
% WELLCLEARALL_CALLBACK Executes when the 'Clear All' button is selected in the
% well panel.  All of the well checkboxes are cleared.
%
% INPUT:
%     hObject:    Handle to wellClearAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

checkboxFunctions = segmentation.functions.ui.main.checkbox_f;
checkboxFunctions.clearAllWells(handles);

function electrodeSelectAll_Callback(hObject, eventdata, handles)
% ELECTRODESELECTALL_CALLBACK Executes when the 'Select All' button is selected in
% the electrode panel.  All of the electrode checkboxes are selected.
%
% INPUT:
%     hObject:    Handle to electrodeSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

checkboxFunctions = segmentation.functions.ui.main.checkbox_f;
checkboxFunctions.selectAllElectrodes(handles);

function electrodeClearAll_Callback(hObject, eventdata, handles)
% ELECTRODECLEARALL_CALLBACK Executed when the 'Clear All' button is selected in the
% electrode panel.  All of the electrodes are will not be selected.
%
% INPUT:
%     hObject:    Handle to electrodeClearAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

checkboxFunctions = segmentation.functions.ui.main.checkbox_f;
checkboxFunctions.clearAllElectrodes(handles);

function readH5_Callback(hObject, eventdata, handles)
% READH5_CALLBACK Read .h5 - read into the figure an .h5 file when
% file > select .h5 file selected.  Detect the experiment's wells,
% and set the following attribute on the figure:
%     [1] file name:       .h5 file name.
%     [2] file path:       File path of .h5 file.
%     [3] data:            McsHDF5 file data.
%     [4] distinct wells:  Distinct wells from data.
%     [5] save directory:  The save directory.
%
% INPUT:
%     hObject:    Handle to readH5 (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

readH5Functions = segmentation.functions.ui.main.readH5_f;
readH5Functions.read(handles);

function initializeWaveformButton_Callback(hObject, eventdata, handles)
% INITIALIZEWAVEFORMBUTTON_CALLBACK Executed when the 'Initialize Waveform' button is
% selected. The following is executed:
%   [1] The h5 file name, path, results save directory, progress bar, and well/electrode
%       work queue is saved to the figure.
%   [2] For each record (row) in the well/electrode work queue, process a new
%       experiment.
%   [3] Once finished processing, save the file(s) and supporting .mat
%       to the appropriate save directory.
%
% INPUT:
%     hObject:    Handle to initializeWaveformButton (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

processH5Functions = segmentation.functions.ui.main.processH5_f;
processH5Functions.initialize(handles);

function waveformAnalysisFigure_KeyPressFcn(hObject, eventdata, handles)
% WAVEFORMANALYSISFIGURE_KEYPRESSFCN When the enter key is entered, and the focus is on the main
% figure, the Keep toggle button in the waveform processing button panel will have
% a value of 1 (i.e. it has been selected)
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

if(strcmp(convertCharsToStrings(eventdata.EventName), "KeyPress") && strcmp(convertCharsToStrings(eventdata.Key), "return"))
    set(handles.keepToggle, 'Value', 1);
end

function keepToggle_KeyPressFcn(hObject, eventdata, handles)
% KEEPTOGGLE_KEYPRESSFCN When the enter key is entered, and the focus is on the the
% keep toggle button, the Keep toggle button in the waveform processing button panel will have
% a value of 1 (i.e. it has been selected).  The user may select 'keep' and hit 'enter' on the
% next iteration.  Focus may be on the keep toggle button itself.
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

if(strcmp(convertCharsToStrings(eventdata.EventName), "KeyPress") && strcmp(convertCharsToStrings(eventdata.Key), "return"))
    set(handles.keepToggle, 'Value', 1)
end

function directorySelectionButtom_Callback(hObject, eventdata, handles)
% DIRECTORYSELECTIONBUTTOM_CALLBACK Custom save directory - instead of using
% the default location (.h5 file location) specify where the summary .csv
% and .mat files should be saved. The save directory attribute in the
% firgure will also be updated.
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

saveFunctions = segmentation.functions.ui.main.saveResults_f;
saveFunctions.directorySelect(handles);

function analyizeData_Callback(hObject, eventdata, handles)
% ANALYIZEDATA_CALLBACK Analyze data - call the summaryAnalysis package
% in the analysis folder.  Histograms and basic statistics are produced in
% the form of figures.
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

fileDir = uigetdir;
summaryAnalysis(fileDir);

function queueWellElectrodeButton_Callback(hObject, eventdata, handles)
% QUEUEWELLELECTRODEBUTTON_CALLBACK Add to the well electrode work queue - when
% selected, add a well electrode combination to the work queue window.
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

checkboxFunctions = segmentation.functions.ui.main.checkbox_f;
wellSelection = checkboxFunctions.getWellSelection(handles);
electrodeSelection = checkboxFunctions.getElectrodeSelection(handles);

workQueueFunctions = segmentation.functions.ui.main.workQueue_f;
workQueueFunctions.queueWellElectrodeCombo(handles, wellSelection, electrodeSelection);

function viewWellElectrodeQueueButton_Callback(hObject, eventdata, handles)
% VIEWWELLELECTRODEQUEUEBUTTON_CALLBACK Display well electrode work queue window - 
% if selected, display to the user the contents of the wellElectrodeCombo variable.
%
% INPUT:
%     hObject:    Handle to wellSelectAll (see GCBO)
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

workQueueHandles = workQueue;
workQueueFunctions = segmentation.functions.ui.main.workQueue_f;
workQueueFunctions.setWellElectrodeWorkQueue(handles, workQueueHandles);
