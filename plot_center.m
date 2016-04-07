function varargout = plot_center(varargin)
% PLOT_CENTER M-file for plot_center.fig
%      PLOT_CENTER, by itself, creates a new PLOT_CENTER or raises the existing
%      singleton*.
%
%      H = PLOT_CENTER returns the handle to a new PLOT_CENTER or the handle to
%      the existing singleton*.
%
%      PLOT_CENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_CENTER.M with the given input arguments.
%
%      PLOT_CENTER('Property','Value',...) creates a new PLOT_CENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plot_center_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plot_center_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_center

% Last Modified by GUIDE v2.5 14-May-2009 13:12:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plot_center_OpeningFcn, ...
                   'gui_OutputFcn',  @plot_center_OutputFcn, ...
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

% --- Executes just before plot_center is made visible.
function plot_center_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_center (see VARARGIN)

% Choose default command line output for plot_center
handles.output = hObject;
struct=varargin{2};
handles.dir=struct.dir;
handles.imname=struct.imname;
handles.impix=struct.impix;
handles.h=0;
handles.h1=0;
handles.M=size(handles.imname,2);
handles.sel=1;
handles.pts=[];
set(handles.checkbox2,'Value',0)
set(handles.checkbox2,'Enable','Off')
set(handles.edit1,'String','0')
set(handles.edit2,'String','0')
set(handles.edit3,'String','0')
set(handles.pushbutton4,'Enable','Off')

handles.ims=cell(1,handles.M);
for i=1:handles.M
    handles.ims{i}=imread([handles.dir handles.imname{i}]);
end
set(handles.listbox1,'Value',1)

for i=1:size(handles.imname,2)
    str{i}=sprintf('%s',handles.imname{i});
end
set(handles.listbox1,'string',str)
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using plot_center.
if strcmp(get(hObject,'Visible'),'off')
    axes(handles.axes1);
    cla;
    gca;
    imshow(handles.ims{1})
end

% UIWAIT makes plot_center wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plot_center_OutputFcn(hObject, eventdata, handles)
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
axes(handles.axes1);
cla;

handles.sel = get(handles.listbox1, 'Value');
imshow(handles.ims{handles.sel});
set(handles.checkbox1,'Value',0)
set(handles.checkbox2,'Value',0)
set(handles.checkbox2,'Enable','Off')
set(handles.edit1,'String','0')
set(handles.edit2,'String','0')
set(handles.pushbutton4,'Enable','Off')
handles.h=0;

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

set(hObject, 'String', []);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
selection=get(hObject,'Value');
i=handles.sel;
mtr=1;
warning('off','MATLAB:legend:IgnoringExtraEntries')
if selection==1
    hold on
    for j=1:size(handles.impix{i},1)
        if handles.impix{i}(j,1)~=0
            p_p(mtr,1:5)=handles.impix{i}(j,5:9);
            mtr=mtr+1;
        end
    end
    handles.pts=p_p;
    h=plot(p_p((p_p(:,3)==1),2),p_p((p_p(:,3)==1),1),...
        'oy','markerfacecolor','y','markersize',5);
    set(h,'Displayname','Initial matched points')
    h=plot(p_p((p_p(:,3)==2),2),p_p((p_p(:,3)==2),1),...
        'og','markerfacecolor','g','markersize',5);
    set(h,'Displayname','Recovered single points')
    h=plot(p_p((p_p(:,3)==3),2),p_p((p_p(:,3)==3),1),...
        'or','markerfacecolor','r','markersize',5);
    set(h,'Displayname','Recovered rows/columns')

    set(handles.checkbox2,'Value',0)
    set(handles.checkbox2,'Enable','On')
    set(handles.pushbutton4,'Enable','On')

    
else
    hold on
    ss=get(handles.axes1,'children');
    delete(ss(1:end-1))
    if handles.h1~=0 && ishandle(handles.h1)
        delete(handles.h1)
    end
    set(handles.checkbox2,'Value',0)
    set(handles.checkbox2,'Enable','Off')
    set(handles.pushbutton4,'Enable','Off')
    handles.h=0;
end

hold off

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

selection=get(hObject,'Value');
i=handles.sel;
p_p=handles.pts;
fact=100;
if selection==1
    hold on
    for i=1:size(p_p,1)
        h=plot([p_p(i,2),p_p(i,2)+fact*p_p(i,4)],...
            [p_p(i,1),p_p(i,1)-fact*p_p(i,5)],'c','LineWidth',2);
        if i==1
            set(h,'Displayname','Residuals')
        else
            hAnnotation = get(h,'Annotation');
            hLegendEntry = get(hAnnotation','LegendInformation');
            set(hLegendEntry,'IconDisplayStyle','off')
        end
    end
else
    hold on
    ss=get(handles.axes1,'children');
    delete(ss(1:(size(p_p,1)+(handles.h~=0))));
    handles.h=0;
end
hold off

% Update handles structure
guidata(hObject, handles);


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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i=handles.sel;
a=sscanf(get(handles.edit1,'String'),'%f');
b=sscanf(get(handles.edit2,'String'),'%f');
if  ~isempty(a) && size(a,1)==1
    handles.X=a;
else
    errordlg('X must be a number','Error')
    return
end
if ~isempty(b) && size(b,1)==1
    handles.Y=b;
else
    errordlg('Y must be a number','Error')
    return
end
for j=1:size(handles.impix{i},1)
    dx1=handles.impix{i}(j,6)-handles.X;
    dy1=handles.impix{i}(j,5)-handles.Y;
    segs(j)=abs(dx1)+abs(dy1);
end
[s_min s_ind]=min(segs(:));
str=sprintf('%i',handles.impix{i}(s_ind,4));

set(handles.edit3,'String',str);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i=handles.sel;
d=sscanf(get(handles.edit3,'String'),'%f');
if ~isempty(d) && size(d,1)==1 && d-round(d)==0 
    if d>0 && d<=size(handles.impix{i},1)
        str1=sprintf('%.3f (%.3f)',handles.impix{i}(d,6),handles.impix{i}(d,8));
        str2=sprintf('%.3f (%.3f)',handles.impix{i}(d,5),handles.impix{i}(d,9));
        set(handles.edit1,'String',str1)
        set(handles.edit2,'String',str2)
    end
else
    errordlg('Point number must be an integer','Error')
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection=get(hObject,'Value');
i=handles.sel;

if selection==1
    d=sscanf(get(handles.edit3,'String'),'%f');
    if ~isempty(d) && size(d,1)==1 && d-round(d)==0
        if d>0 && d<=size(handles.impix{i},1)
            if handles.h~=0 && ishandle(handles.h)
                delete(handles.h)
            end
            hold on
            handles.h=plot(handles.impix{i}(d,6),handles.impix{i}(d,5),'om','markerfacecolor','none','markersize',11,'LineWidth',2);
            set(handles.h,'Displayname','Selected point')
            hold off
            pushbutton3_Callback(hObject, eventdata, handles)
        end
    else
        errordlg('Point number must be an integer','Error')    
    end
end

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ishandle(1)
    close(1)
end
figure(1);
imshow(handles.ims{handles.sel})
hold on
if get(handles.checkbox1,'Value')==1
    p_p=handles.pts;
    h=plot(p_p((p_p(:,3)==1),2),p_p((p_p(:,3)==1),1),...
        'oy','markerfacecolor','y','markersize',5);
    set(h,'Displayname','Initial Points')
    h=plot(p_p((p_p(:,3)==2),2),p_p((p_p(:,3)==2),1),...
        'og','markerfacecolor','g','markersize',5);
    set(h,'Displayname','Missing Points')
    h=plot(p_p((p_p(:,3)==3),2),p_p((p_p(:,3)==3),1),...
        'or','markerfacecolor','r','markersize',5);
    set(h,'Displayname','Additional rows/cols')
    if get(handles.checkbox2,'Value')==1
        fact=100;
        for i=1:size(p_p,1)
            h=plot([p_p(i,2),p_p(i,2)+fact*p_p(i,4)],...
                [p_p(i,1),p_p(i,1)-fact*p_p(i,5)],'c','LineWidth',2);
            if i==1
                set(h,'Displayname','Residuals')
            else
                hAnnotation = get(h,'Annotation');
                hLegendEntry = get(hAnnotation','LegendInformation');
                set(hLegendEntry,'IconDisplayStyle','off')
            end
        end
    end
end
hold off


% --------------------------------------------------------------------
function uitoggletool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
warning('off','MATLAB:legend:PlotEmpty')
if strcmp(get(hObject,'State'),'on')
    handles.h1=legend(handles.axes1,'show');
    set(handles.h1,'fontsize',9)
else
    if handles.h1~=0 && ishandle(handles.h1)
       delete(handles.h1)
    end
end

% Update handles structure
guidata(hObject, handles);
