function varargout = Results(varargin)
% RESULTS M-file for Results.fig
%      RESULTS, by itself, creates a new RESULTS or raises the existing
%      singleton*.
%
%      H = RESULTS returns the handle to a new RESULTS or the handle to
%      the existing singleton*.
%
%      RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTS.M with the given input arguments.
%
%      RESULTS('Property','Value',...) creates a new RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Results_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Results

% Last Modified by GUIDE v2.5 04-Sep-2006 19:32:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Results_OpeningFcn, ...
                   'gui_OutputFcn',  @Results_OutputFcn, ...
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


% --- Executes just before Results is made visible.
function Results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Results (see VARARGIN)

% Choose default command line output for Results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Results wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close Results

% --------------------------
function mycb(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hands=guidata(hObject);
title1=('Central Projection Parameters');
switch eventdata{3}
    case {3,5,7}
        txt1{1,1}=[sprintf('c=%.3f',eventdata{1}(1)),...
            sprintf(' %c ',char(177)),...
            sprintf('%.3f pixels',eventdata{2}(1))];
        p_i=0;
    otherwise
        txt1{1,1}=[sprintf('cx=%.3f',eventdata{1}(1)),...
        	sprintf(' %c ',char(177)),...
        	sprintf('%.3f pixels',eventdata{2}(1))];
        txt1{2,1}=[sprintf('ar=%.6f',eventdata{1}(2)),...
        	sprintf(' %c ',char(177)),...
        	sprintf('%.6f',eventdata{2}(2))];
        txt1{3,1}=[sprintf('(cy=%.3f',eventdata{5}(1)),...
        	sprintf(' %c ',char(177)),...
        	sprintf('%.3f pixels)',eventdata{5}(2))];    
        p_i=2;
end
txt1{2+p_i,1}=[sprintf('xo=%.3f',eventdata{1}(3)),...
    sprintf(' %c ',char(177)),...
    sprintf('%.3f pixels',eventdata{2}(3))];
txt1{3+p_i,1}=[sprintf('yo=%.3f',eventdata{1}(4)),...
    sprintf(' %c ',char(177)),...
    sprintf('%.3f pixels',eventdata{2}(4))];
if eventdata{6}(3)==1
    txt1{4+p_i,1}=[sprintf('sk=%.6f',eventdata{6}(1)),...
        sprintf(' %c ',char(177)),...
        sprintf('%.6f',eventdata{6}(2))];
end
switch eventdata{3}
    case {5,6,7,8}
        title2=sprintf('Radial Distortion Parameters');
        txt2{1,1}=[sprintf('k1=%.3e',eventdata{1}(5)),...
            sprintf(' %c ',char(177)),...
            sprintf('%.2e',eventdata{2}(5))];
        txt2{2,1}=[sprintf('k2=%.3e',eventdata{1}(6)),...
            sprintf(' %c ',char(177)),...
            sprintf('%.2e',eventdata{2}(6))];
        if (eventdata{3}==7 || eventdata{3}==8)
            title3=sprintf('Decentering Distortion Parameters');
            txt3{1,1}=[sprintf('p1=%.3e',eventdata{1}(7)),...
                sprintf(' %c ',char(177)),...
                sprintf('%.2e',eventdata{2}(7))];
            txt3{2,1}=[sprintf('p2=%.3e',eventdata{1}(8)),...
                sprintf(' %c ',char(177)),...
                sprintf('%.2e',eventdata{2}(8))];
        end
end
set(hands.text1,'String',title1)
set(hands.text3,'String',txt1)
if eventdata{3}>=5
    set(hands.text4,'String',title2)
    set(hands.text5,'String',txt2)
    if eventdata{3}>=7
        set(hands.text6,'String',title3)
        set(hands.text7,'String',txt3)
    end
end
txt4=[sprintf('Sigma=%.3f',eventdata{4})];
set(hands.text8,'String',txt4)

