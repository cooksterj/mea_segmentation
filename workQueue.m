function varargout = workQueue(varargin)
% WORKQUEUE MATLAB code for workQueue.fig
%      WORKQUEUE, by itself, creates a new WORKQUEUE or raises the existing
%      singleton*.
%
%      H = WORKQUEUE returns the handle to a new WORKQUEUE or the handle to
%      the existing singleton*.
%
%      WORKQUEUE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WORKQUEUE.M with the given input arguments.
%
%      WORKQUEUE('Property','Value',...) creates a new WORKQUEUE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before workQueue_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to workQueue_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help workQueue

% Last Modified by GUIDE v2.5 08-Jan-2019 13:46:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @workQueue_OpeningFcn, ...
    'gui_OutputFcn',  @workQueue_OutputFcn, ...
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

function workQueue_OpeningFcn(hObject, eventdata, handles, varargin)
% WORKQUEUE_OPENINGFCN This function has no output args, see OutputFcn.
% hObject
%
% INPUT:
%     hObject:    Handle to figure
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)
%     varargin:   Command line arguments to waveformAnalysis (see VARARGIN)

% Choose default command line output for workQueue
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes workQueue wait for user response (see UIRESUME)
% uiwait(handles.workQueueFigure);

function varargout = workQueue_OutputFcn(hObject, eventdata, handles)
% WORKQUEUE_OUTPUTFCN - Outputs from this function are returned to the command line.
%
% INPUT:
%     hObject:    Handle to figure
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)
%     varargin:   Command line arguments to waveformAnalysis (see VARARGIN)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ---------------------CUSTOM IMPLEMENTATIONS---------------------------
function workQueueRemoveRowButton_Callback(hObject, eventdata, handles)
% WORKQUEUEREMOVEROWBUTTON_CALLBACK Remove work queue row - when called.
% a row is removed from the work queue UI.  Once removed, the data
% and selectRow variables in the figure are updated.
%
% INPUT:
%     hObject:    Handle to figure
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

workQueueFunctions = segmentation.functions.ui.workQueue.workQueue_f;
workQueueFunctions.removeRow(handles);

function wellElectrodeWorkQueueTable_CellSelectionCallback(hObject, eventdata, handles)
% WELLELECTRODEWORKQUEUETABLE_CELLSELECTIONCALLBACK Cell selection - everytime
% a cell is selected in the work queue figure, update the selectedRow variable
% with the index position.
%
% INPUT:
%     hObject:    Handle to figure
%     eventdata:  Reserved - to be defined in a future version of MATLAB
%     handles:    Structure with handles and user data (see GUIDATA)

workQueueFunctions = segmentation.functions.ui.workQueue.workQueue_f;
workQueueFunctions.cellSelection(eventdata, handles);

function wellElectrodeWorkQueueTable_CellEditCallback(hObject, eventdata, handles)
% TODO: Comments 
%
% INPUT:
%     hObject    handle to wellElectrodeWorkQueueTable (see GCBO)
%     eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%          Indices: row and column indices of the cell(s) edited
%          PreviousData: previous data for the cell(s) edited
%          EditData: string(s) entered by the user
%          NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%          Error: error string when failed to convert EditData to appropriate value for Data
%     handles    structure with handles and user data (see GUIDATA)

workQueueFunctions = segmentation.functions.ui.workQueue.workQueue_f;
workQueueFunctions.updateWorkQueue(eventdata, handles);
