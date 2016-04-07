function varargout = fauccal(varargin)
% FAUCCAL M-file for fauccal.fig
%      FAUCCAL, by itself, creates a new FAUCCAL or raises the existing
%      singleton*.
%
%      H = FAUCCAL returns the handle to a new FAUCCAL or the handle to
%      the existing singleton*.
%
%      FAUCCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FAUCCAL.M with the given input arguments.
%
%      FAUCCAL('Property','Value',...) creates a new FAUCCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fauccal_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fauccal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fauccal

% Last Modified by GUIDE v2.5 16-Jun-2009 01:07:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fauccal_OpeningFcn, ...
                   'gui_OutputFcn',  @fauccal_OutputFcn, ...
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


% --- Executes just before fauccal is made visible.
function fauccal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fauccal (see VARARGIN)

% Choose default command line output for fauccal
handles.output = hObject;

clc
fprintf('Fauccal Toolbox by Valsamis Douskos\n\n');
set(handles.radiobutton1,'Value',1)
set(handles.checkbox1,'Value',1)
set(handles.checkbox2,'Value',1)
set(handles.checkbox3,'Value',1)
set(handles.checkbox4,'Value',1)
set(handles.checkbox4,'Enable','on')
set(handles.checkbox5,'Value',0)
set(handles.checkbox6,'Value',0)
set(handles.checkbox7,'Value',1)
set(handles.edit1,'String','0.01')
set(handles.edit2,'String','50')
set(handles.edit3,'String','0.1')
set(handles.edit4,'String','0.0001')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','off')
set(handles.popupmenu1,'Value',1)
handles.ipsec=4;
handles.ipbas=4;
handles.ipsk=1;
handles.ground=1;
handles.mess=0;
handles.bproj=0;
handles.uncert=0;
handles.s_im=0.1;
handles.s_gr=0.0001;
handles.basic_kr=0.01;
handles.max_iter=50;
handles.dd=0;
handles.meth=1;
handles.resize=1;
tmp_ip=handles.ipsec+handles.ipbas;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fauccal wait for user response (see UIRESUME)
% uiwait(handles.fauccal);


% --- Outputs from this function are returned to the command line.
function varargout = fauccal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.radiobutton1,'Value',1)

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val=get(handles.checkbox1,'Value');
if val==0
    handles.ipbas=3;
else
    handles.ipbas=4;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val=get(handles.checkbox2,'Value');
if val==0
    handles.ipsk=0;
else
    handles.ipsk=1;
end
guidata(hObject, handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val=get(handles.checkbox3,'Value');
if val==0
    handles.dec=get(handles.checkbox4,'Value');
    set(handles.checkbox4,'Value',0)
    set(handles.checkbox4,'Enable','off')
    set(handles.popupmenu1,'Enable','off')
    handles.ipsec=0;
else
    set(handles.checkbox4,'Value',handles.dec)
    set(handles.checkbox4,'Enable','on')
    set(handles.popupmenu1,'Enable','on')
    if handles.dec==1
        handles.ipsec=4;
    else
        handles.ipsec=2;
    end
    handles.dd=get(handles.popupmenu1,'Value')-1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val=get(handles.checkbox4,'Value');
if val==0
    handles.ipsec=2;
else
    handles.ipsec=4;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(handles.checkbox5,'Value');
if val==0
    handles.uncert=0;
    set(handles.edit3,'Enable','off');
    set(handles.edit4,'Enable','off');
else
    handles.uncert=1;
    set(handles.edit3,'Enable','on');
    set(handles.edit4,'Enable','on');
end
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
val=get(handles.checkbox6,'Value');
if val==0
    handles.bproj=0;
else
    handles.bproj=1;
end
guidata(hObject, handles);

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
val=get(handles.checkbox7,'Value');
if val==0
    handles.resize=0;
else
    handles.resize=1;
end
guidata(hObject, handles);


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp_ip=handles.ipsec+handles.ipbas;
sw=0;
if handles.uncert==1
    a=sscanf(get(handles.edit3,'String'),'%f');
    b=sscanf(get(handles.edit4,'String'),'%f');
    if  ~isempty(a) && size(a,1)==1
        handles.s_im=a;
    else
        errordlg('Sigma Image Value must be a number','Error')
        sw=1;
    end
    if ~isempty(b) && size(b,1)==1
        handles.s_gr=b;
    else
        errordlg('Sigma Ground Value must be a number','Error')
        sw=1;
    end
end
c=sscanf(get(handles.edit1,'String'),'%f');
d=sscanf(get(handles.edit2,'String'),'%f');
if  ~isempty(c) && size(c,1)==1
    handles.basic_kr=c;
else
    errordlg('Convergence limit must be a number','Error')
    sw=1;
end
if ~isempty(d) && size(d,1)==1 && d-round(d)==0
    handles.max_iter=d;
else
    errordlg('Maximum number of iterations must be an integer','Error')
    sw=1;
end

if sw==0
    bundle(handles);
end


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = questdlg(['Close ' 'Fauccal' '?'],...
                     ['Close ' 'Fauccal' '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

clc
delete(handles.fauccal)
close all

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val=get(handles.popupmenu1,'Value');
if val==1
    handles.dd=0;
else
    handles.dd=1;
end
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function men_exit_Callback(hObject, eventdata, handles)
% hObject    handle to men_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = questdlg(['Close ' 'Fauccal' '?'],...
                     ['Close ' 'Fauccal' '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

clc
delete(handles.fauccal)


% --------------------------------------------------------------------
function men_file_Callback(hObject, eventdata, handles)
% hObject    handle to men_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function men_help_Callback(hObject, eventdata, handles)
% hObject    handle to men_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function men_about_Callback(hObject, eventdata, handles)
% hObject    handle to men_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

about
