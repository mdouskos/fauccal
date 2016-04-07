function varargout = exclude(varargin)
% EXCLUDE M-file for exclude.fig
%      EXCLUDE, by itself, creates a new EXCLUDE or raises the existing
%      singleton*.
%
%      H = EXCLUDE returns the handle to a new EXCLUDE or the handle to
%      the existing singleton*.
%
%      EXCLUDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXCLUDE.M with the given input arguments.
%
%      EXCLUDE('Property','Value',...) creates a new EXCLUDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exclude_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exclude_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exclude

% Last Modified by GUIDE v2.5 16-Sep-2006 13:42:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exclude_OpeningFcn, ...
                   'gui_OutputFcn',  @exclude_OutputFcn, ...
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


% --- Executes just before exclude is made visible.
function exclude_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exclude (see VARARGIN)

% Choose default command line output for exclude

set(handles.listbox1,'Value',1);
strs1=get(handles.listbox1,'String');
if size(strs1,1)<2
    strs1=cellstr(strs1);
end
handles.sel1=strs1{1};
set(handles.listbox2,'Value',1);
strs2=get(handles.listbox2,'String');
if size(strs2,1)<2
    strs2=cellstr(strs2);
end
handles.sel2=strs2{1};
handles.initstr=strs1;
% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes exclude wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exclude_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

strs=get(handles.listbox1,'String');
ind=get(handles.listbox1,'Value');
if size(strs,1)<2
    strs=cellstr(strs);
end
if isempty(ind)
    ind=1;
end
handles.sel1=strs{ind};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

strs=get(handles.listbox2,'String');
ind=get(handles.listbox2,'Value');
if size(strs,1)<2
    strs=cellstr(strs);
end
if isempty(ind)
    ind=1;
end
handles.sel2=strs{ind};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear tmpstr1
str2=get(handles.listbox2,'String');
if size(str2,1)<2
    str2=cellstr(str2);
end
str1=get(handles.listbox1,'String');
if size(str1,1)<2
    str1=cellstr(str1);
end
if ~isempty(str1{1})
    if isempty(str2{1})
        set(handles.listbox2,'String',handles.sel1);
    elseif size(str2,1)==1
        str2=cellstr(str2);
        if (strcmp(handles.sel1,str2)>0)==0
            str2{size(str2,1)+1}=handles.sel1;
            set(handles.listbox2,'String',str2);
        end
    else
        if (strcmp(handles.sel1,str2)>0)==0
            str2{size(str2,1)+1}=handles.sel1;
            set(handles.listbox2,'String',str2);
        end
    end
    ind_r=find(strcmp(str1,handles.sel1)==1);
    if size(str1,1)>1
        for i=1:size(str1,1)-1
            if i<ind_r
                tmpstr1{i}=str1{i};
            else
                tmpstr1{i}=str1{i+1};
            end
        end
    else
        tmpstr1{1}=[];
    end
    clear str1
    str1=tmpstr1;
    set(handles.listbox1,'String',str1)
end
set(handles.listbox1,'Value',1);
strs1=get(handles.listbox1,'String');
if size(strs1,1)<2
    strs1=cellstr(strs1);
end
handles.sel1=strs1{1};
set(handles.listbox2,'Value',1);
strs2=get(handles.listbox2,'String');
if size(strs2,1)<2
    strs2=cellstr(strs2);
end
handles.sel2=strs2{1};
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear tmpstr2
str2=get(handles.listbox2,'String');
if size(str2,1)<2
    str2=cellstr(str2);
end
str1=get(handles.listbox1,'String');
if size(str1,1)<2
    str1=cellstr(str1);
end
if ~isempty(str2{1})
    if isempty(str1{1})
        set(handles.listbox1,'String',handles.sel2);
    elseif size(str1,1)==1
        str1=cellstr(str1);
        if (strcmp(handles.sel2,str1)>0)==0
            str1{size(str1,1)+1}=handles.sel2;
            set(handles.listbox1,'String',str1);
        end
    else
        if (strcmp(handles.sel2,str1)>0)==0
            str1{size(str1,1)+1}=handles.sel2;
            set(handles.listbox1,'String',str1);
        end
    end
    ind_r=find(strcmp(str2,handles.sel2)==1);
    if size(str2,1)>1
        for i=1:size(str2,1)-1
            if i<ind_r
                tmpstr2{i}=str2{i};
            else
                tmpstr2{i}=str2{i+1};
            end
        end
    else
        tmpstr2{1}=[];
    end
    clear str2
    str2=tmpstr2;
    set(handles.listbox2,'String',str2)
end
set(handles.listbox1,'Value',1);
strs1=get(handles.listbox1,'String');
if size(strs1,1)<2
    strs1=cellstr(strs1);
end
handles.sel1=strs1{1};
set(handles.listbox2,'Value',1);
strs2=get(handles.listbox2,'String');
if size(strs2,1)<2
    strs2=cellstr(strs2);
end
handles.sel2=strs2{1};
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.listbox2,'String',handles.initstr)
set(handles.listbox1,'String','')
set(handles.listbox1,'Value',1);
strs1=get(handles.listbox1,'String');
if size(strs1,1)<2
    strs1=cellstr(strs1);
end
handles.sel1=strs1{1};
set(handles.listbox2,'Value',1);
strs2=get(handles.listbox2,'String');
if size(strs2,1)<2
    strs2=cellstr(strs2);
end
handles.sel2=strs2{1};

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.listbox1,'String',handles.initstr)
set(handles.listbox2,'String','')
set(handles.listbox1,'Value',1);
strs1=get(handles.listbox1,'String');
if size(strs1,1)<2
    strs1=cellstr(strs1);
end
handles.sel1=strs1{1};
set(handles.listbox2,'Value',1);
strs2=get(handles.listbox2,'String');
if size(strs2,1)<2
    strs2=cellstr(strs2);
end
handles.sel2=strs2{1};

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ex_pnt
str2=get(handles.listbox2,'String');
if size(str2,1)<2
    str2=cellstr(str2);
end
if ~isempty(str2{1})
    for i=1:size(str2,1)
        ex_pnt(i,:)=sscanf(str2{i},'%i%i%f%f%f',2)';
    end
end
guidata(hObject, handles);
close exclude


% ----------------------------------------
function myinit(hObject, eventdata, handles)
handles=guidata(hObject);

for i=1:size(eventdata,1)
    strs1{i}= sprintf('%6i   %8i   %8.2f   %7.2f   %6.3f',eventdata(i,:));
end
set(handles.listbox1,'String',strs1)
set(handles.listbox1,'Value',1);
strs1=get(handles.listbox1,'String');
if size(strs1,1)<2
    strs1=cellstr(strs1);
end
handles.sel1=strs1{1};
set(handles.listbox2,'Value',1);
strs2=get(handles.listbox2,'String');
if size(strs2,1)<2
    strs2=cellstr(strs2);
end
handles.sel2=strs2{1};
handles.initstr=strs1;
% Update handles structure
handles.output = hObject;
guidata(hObject, handles);
