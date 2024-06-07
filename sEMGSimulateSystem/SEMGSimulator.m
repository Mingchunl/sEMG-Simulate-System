function varargout = SEMGSimulator(varargin)
% SEMGSIMULATOR MATLAB code for SEMGSimulator.fig
%      SEMGSIMULATOR, by itself, creates a new SEMGSIMULATOR or raises the existing
%      singleton*.
%
%      H = SEMGSIMULATOR returns the handle to a new SEMGSIMULATOR or the handle to
%      the existing singleton*.
%
%      SEMGSIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEMGSIMULATOR.M with the given input arguments.
%
%      SEMGSIMULATOR('Property','Value',...) creates a new SEMGSIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SEMGSimulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SEMGSimulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SEMGSimulator

% Last Modified by GUIDE v2.5 07-Jun-2024 09:46:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SEMGSimulator_OpeningFcn, ...
                   'gui_OutputFcn',  @SEMGSimulator_OutputFcn, ...
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


% --- Executes just before SEMGSimulator is made visible.
function SEMGSimulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SEMGSimulator (see VARARGIN)

% Choose default command line output for SEMGSimulator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes SEMGSimulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SEMGSimulator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in scheme1calculate.
function scheme1calculate_Callback(hObject, eventdata, handles)
% hObject    handle to scheme1calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nMU=str2num(get(handles.nMU,'String'));
xmuall=str2num(get(handles.xmu,'String'));
xmu = xmuall/2;
ymu=str2num(get(handles.ymu,'String'));
fs=str2num(get(handles.fs,'String'));
duration=str2num(get(handles.duration,'String'));
subTissue=str2num(get(handles.subtissue,'String'));
channelscheme = get(handles.channel,'Value');
excitation= str2num(get(handles.MVC_value,'String'));
FrScheme =1;
IED =str2num(get(handles.IED,'String'));
RR = str2num(get(handles.RR,'String'));
global semg emgIPI muap nAMU muaptcell cmu_x cmu_y rMU average_IPI
[semg emgIPI muap nAMU muaptcell cmu_x cmu_y rMU average_IPI] = isometricEMG(nMU,excitation,FrScheme,subTissue,xmu,ymu,channelscheme ,IED,fs,duration,RR);
%muap 64*18*88
%emgIPI 18*10000
assignin('base', 'semg', semg);
assignin('base', 'emgIPI', emgIPI);
assignin('base', 'muap', muap);
assignin('base', 'cmu_x', cmu_x);
assignin('base', 'cmu_x', cmu_x);
assignin('base', 'muapt', muaptcell);
axes(handles.axes1);

%画椭圆肌肉
[x y]=ellipse(0,subTissue+ymu/2,xmu,ymu/2);
H2 = plot(x,y,'r');
set(H2,'LineWidth',2);
hold on
%画MU
for i = 1:size(cmu_x,1)
[cx cy]=circle(cmu_x(i),cmu_y(i),rMU(i));
HH=plot(cx,cy);
set(HH,'LineWidth',2);
hold on
end
axes(handles.axes2);
EMGchannel_num=str2num(get(handles.EMGchannel_num,'String'));
t = (0:1/fs:duration-1/fs);
HH1=plot(t,semg(EMGchannel_num,:));hold on
set(HH1,'LineWidth',0.5);


axes(handles.axes3);
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));
HH1=plot(squeeze(muap(MUchannel_num,MUnum,:)));hold on
set(HH1,'LineWidth',1.5);


axes(handles.axes4);
num2=str2num(get(handles.IPI_num,'String'));
HH1=plot(t,emgIPI(num2,:));hold on
set(HH1,'LineWidth',0.5);


H3= nAMU;
set(handles.nMU_show,'String',H3);

num1=str2num(get(handles.firingrate_num,'String'));
H4= average_IPI(num1);
set(handles.firingrate_show,'String',H4);
function nMU_Callback(hObject, eventdata, handles)
% hObject    handle to nMU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nMU as text
%        str2double(get(hObject,'String')) returns contents of nMU as a double


% --- Executes during object creation, after setting all properties.
function nMU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nMU (see GCBO)
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
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');
function subtissue_Callback(hObject, eventdata, handles)
% hObject    handle to subtissue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subtissue as text
%        str2double(get(hObject,'String')) returns contents of subtissue as a double


% --- Executes during object creation, after setting all properties.
function subtissue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subtissue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmu_Callback(hObject, eventdata, handles)
% hObject    handle to xmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmu as text
%        str2double(get(hObject,'String')) returns contents of xmu as a double


% --- Executes during object creation, after setting all properties.
function xmu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymu_Callback(hObject, eventdata, handles)
% hObject    handle to ymu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymu as text
%        str2double(get(hObject,'String')) returns contents of ymu as a double


% --- Executes during object creation, after setting all properties.
function ymu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration as text
%        str2double(get(hObject,'String')) returns contents of duration as a double


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fs_Callback(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs as text
%        str2double(get(hObject,'String')) returns contents of fs as a double


% --- Executes during object creation, after setting all properties.
function fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel.
function channel_Callback(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel


% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in changeperiod_value.
function changeperiod_value_Callback(hObject, eventdata, handles)
% hObject    handle to changeperiod_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns changeperiod_value contents as cell array
%        contents{get(hObject,'Value')} returns selected item from changeperiod_value


% --- Executes during object creation, after setting all properties.
function changeperiod_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeperiod_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function gama_value_Callback(hObject, eventdata, handles)
% hObject    handle to gama_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gama_value as text
%        str2double(get(hObject,'String')) returns contents of gama_value as a double


% --- Executes during object creation, after setting all properties.
function gama_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gama_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


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



function MVC_value_Callback(hObject, eventdata, handles)
% hObject    handle to MVC_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MVC_value as text
%        str2double(get(hObject,'String')) returns contents of MVC_value as a double


% --- Executes during object creation, after setting all properties.
function MVC_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MVC_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FrScheme.
function FrScheme_Callback(hObject, eventdata, handles)
% hObject    handle to FrScheme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FrScheme contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FrScheme


% --- Executes during object creation, after setting all properties.
function FrScheme_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrScheme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IED_Callback(hObject, eventdata, handles)
% hObject    handle to IED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IED as text
%        str2double(get(hObject,'String')) returns contents of IED as a double


% --- Executes during object creation, after setting all properties.
function IED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in firingrate_num.
function firingrate_num_Callback(hObject, eventdata, handles)
% hObject    handle to firingrate_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  average_IPI
num1=str2num(get(handles.firingrate_num,'String'));
H4= average_IPI(num1);
set(handles.firingrate_show,'String',H4);

% Hints: contents = cellstr(get(hObject,'String')) returns firingrate_num contents as cell array
%        contents{get(hObject,'Value')} returns selected item from firingrate_num


% --- Executes during object creation, after setting all properties.
function firingrate_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firingrate_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox12.
function listbox12_Callback(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox12


% --- Executes during object creation, after setting all properties.
function listbox12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EMGchannel_num.
function EMGchannel_num_Callback(hObject, eventdata, handles)
% hObject    handle to EMGchannel_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2,'reset');
global semg 
fs=str2num(get(handles.fs,'String'));
duration=str2num(get(handles.duration,'String'));
t = (0:1/fs:duration-1/fs);
axes(handles.axes2);
EMGchannel_num=str2num(get(handles.EMGchannel_num,'String'));
HH1=plot(t,semg(EMGchannel_num,:));hold on
set(HH1,'LineWidth',0.5);
% Hints: contents = cellstr(get(hObject,'String')) returns EMGchannel_num contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EMGchannel_num


% --- Executes during object creation, after setting all properties.
function EMGchannel_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EMGchannel_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MUnum.
function MUnum_Callback(hObject, eventdata, handles)
% hObject    handle to MUnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MUnum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MUnum
cla(handles.axes3,'reset');
global  muap
axes(handles.axes3);
MUchannel_num=str2num(get(handles.MUchannel_num,'String'));
MUnum = str2num(get(handles.MUnum,'String'));
HH1=plot(squeeze(muap(MUchannel_num,MUnum,:)));hold on
set(HH1,'LineWidth',1.5);


% --- Executes during object creation, after setting all properties.
function MUnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MUnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in IPInum.
function IPInum_Callback(hObject, eventdata, handles)
% hObject    handle to IPInum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns IPInum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from IPInum


% --- Executes during object creation, after setting all properties.
function IPInum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IPInum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to EMGchannel_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EMGchannel_num as text
%        str2double(get(hObject,'String')) returns contents of EMGchannel_num as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EMGchannel_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MUchannel_num_Callback(hObject, eventdata, handles)
% hObject    handle to MUchannel_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MUchannel_num as text
%        str2double(get(hObject,'String')) returns contents of MUchannel_num as a double
cla(handles.axes3,'reset');
global muap 
axes(handles.axes3);
MUchannel_num=str2num(get(handles.MUchannel_num,'String'));
MUnum = str2num(get(handles.MUnum,'String'));
HH1=plot(squeeze(muap(MUchannel_num,MUnum,:)));hold on
set(HH1,'LineWidth',1.5);




% --- Executes during object creation, after setting all properties.
function MUchannel_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MUchannel_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to MUnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MUnum as text
%        str2double(get(hObject,'String')) returns contents of MUnum as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MUnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IPI_num_Callback(hObject, eventdata, handles)
% hObject    handle to IPI_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IPI_num as text
%        str2double(get(hObject,'String')) returns contents of IPI_num as a double
cla(handles.axes4,'reset');
global emgIPI
fs=str2num(get(handles.fs,'String'));
duration=str2num(get(handles.duration,'String'));
t = (0:1/fs:duration-1/fs);
axes(handles.axes4);
num2=str2num(get(handles.IPI_num,'String'));
HH1=plot(t,emgIPI(num2,:));hold on
set(HH1,'LineWidth',0.5);

% --- Executes during object creation, after setting all properties.
function IPI_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IPI_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to firingrate_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firingrate_num as text
%        str2double(get(hObject,'String')) returns contents of firingrate_num as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firingrate_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_value_Callback(hObject, eventdata, handles)
% hObject    handle to step_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_value as text
%        str2double(get(hObject,'String')) returns contents of step_value as a double


% --- Executes during object creation, after setting all properties.
function step_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MUchannel_num2_Callback(hObject, eventdata, handles)
% hObject    handle to MUchannel_num2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MUchannel_num2 as text
%        str2double(get(hObject,'String')) returns contents of MUchannel_num2 as a double
cla(handles.axes3,'reset');
axes(handles.axes3);
global muapCell
step =str2num(get(handles.step_value,'String'));
duration=str2num(get(handles.duration,'String'));
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));

shift_amount = 0; 
for i = 1:round(duration/step)
    if mod(i, 8) == 0
         muap = squeeze(muapCell{MUchannel_num, MUnum, i})- (muapCell{MUchannel_num-1, MUnum, i});
    else
    muap = squeeze(muapCell{MUchannel_num+1, MUnum, i})- (muapCell{MUchannel_num, MUnum, i});
    end
    HH1=plot(muap);hold on
    set(HH1,'LineWidth',1.5);
    hold on;
end

% --- Executes during object creation, after setting all properties.
function MUchannel_num2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MUchannel_num2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MUnum2_Callback(hObject, eventdata, handles)
% hObject    handle to MUnum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MUnum2 as text
%        str2double(get(hObject,'String')) returns contents of MUnum2 as a double
cla(handles.axes3,'reset');
global  muap
axes(handles.axes3);
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));
HH1=plot(squeeze(muap(MUchannel_num,MUnum,:)));hold on
set(HH1,'LineWidth',1.5);
hold on

% --- Executes during object creation, after setting all properties.
function MUnum2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MUnum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in danji2.
function danji2_Callback(hObject, eventdata, handles)
% hObject    handle to danji2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of danji2
cla(handles.axes3,'reset');
axes(handles.axes3);
global muapCell
step =str2num(get(handles.step_value,'String'));
duration=str2num(get(handles.duration,'String'));
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));

shift_amount = 0; 
for i = 1:round(duration/step)
 
    muap = squeeze(muapCell{MUchannel_num, MUnum, i});
    HH1=plot(muap);hold on
    set(HH1,'LineWidth',1.5);
    hold on;
end

% --- Executes on button press in shuangji2.
function shuangji2_Callback(hObject, eventdata, handles)
% hObject    handle to shuangji2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shuangji2
cla(handles.axes3,'reset');
axes(handles.axes3);
global muapCell
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));
step =str2num(get(handles.step_value,'String'));
duration=str2num(get(handles.duration,'String'));
shift_amount = 0; 
for i = 1:round(duration/step)
    if mod(i, 8) == 0
         muap = squeeze(muapCell{MUchannel_num, MUnum, i})- (muapCell{MUchannel_num-1, MUnum, i});
    else
    muap = squeeze(muapCell{MUchannel_num+1, MUnum, i})- (muapCell{MUchannel_num, MUnum, i});
    end
    HH1=plot(muap);hold on
    set(HH1,'LineWidth',1.5);
    hold on;
end


% --- Executes on button press in danji1.
function danji1_Callback(hObject, eventdata, handles)
% hObject    handle to danji1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of danji1
cla(handles.axes3,'reset');
global  muap
axes(handles.axes3);
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));
HH1=plot(squeeze(muap(MUchannel_num,MUnum,:)));hold on
set(HH1,'LineWidth',1.5);

% --- Executes on button press in shuangji1.
function shuangji1_Callback(hObject, eventdata, handles)
% hObject    handle to shuangji1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shuangji1
cla(handles.axes3,'reset');
global  muap
axes(handles.axes3);
MUchannel_num=str2num(get(handles.MUchannel_num2,'String'));
MUnum = str2num(get(handles.MUnum2,'String'));
if mod(MUchannel_num,8)==0
    muap1 = squeeze(muap(MUchannel_num,MUnum,:))-squeeze(muap(MUchannel_num-1,MUnum,:));
else
    muap1 = squeeze(muap(MUchannel_num+1,MUnum,:))-squeeze(muap(MUchannel_num,MUnum,:));
end
HH1=plot(muap1);
hold on
set(HH1,'LineWidth',1.5);


% --- Executes on button press in danji3.
function danji3_Callback(hObject, eventdata, handles)
% hObject    handle to danji3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of danji3
cla(handles.axes2,'reset');
global semg 
fs=str2num(get(handles.fs,'String'));
duration=str2num(get(handles.duration,'String'));
axes(handles.axes2);
EMGchannel_num=str2num(get(handles.EMGchannel_num,'String'));
t = (0:1/fs:duration-1/fs);
HH1=plot(t,semg(EMGchannel_num,:));hold on
set(HH1,'LineWidth',0.5);

% --- Executes on button press in togglebutton9.
function togglebutton9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton9
cla(handles.axes2,'reset');
global semg 
fs=str2num(get(handles.fs,'String'));
duration=str2num(get(handles.duration,'String'));
axes(handles.axes2);
EMGchannel_num=str2num(get(handles.EMGchannel_num,'String'));
t = (0:1/fs:duration-1/fs);
if mod(EMGchannel_num,8)==0
    emg =semg(EMGchannel_num,:)-semg(EMGchannel_num-1,:);
else
    emg = semg(EMGchannel_num+1,:)-semg(EMGchannel_num,:);
end
HH1=plot(t,emg);hold on
set(HH1,'LineWidth',0.5);

function [x,y]=ellipse(xc,yc,a,b)
% 椭圆参数
%xc = 0; % 椭圆中心 x 坐标
%yc = 0; % 椭圆中心 y 坐标
%a = 2; % 长半轴长度
%b = 1; % 短半轴长度
theta = 0:0.01:2*pi; % 角度范围

% 计算椭圆上的点
x = xc + a * cos(theta);
y = yc + b * sin(theta);

axis equal; % 设置坐标轴比例相等，以保持椭圆形状准确显示


% --- Executes during object creation, after setting all properties.
function scheme3calculate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scheme3calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
if get(hObject, 'Value') == 1
    set(handles.scheme1calculate,'Visible','off');
    
        
    
        set(handles.MVC,'Visible','on');
        set(handles.MVC_value,'Visible','on');

        set(handles.changeperiod,'Visible','on');
        set(handles.changeperiod_value,'Visible','on');
        set(handles.step,'Visible','on');
        set(handles.step_value,'Visible','on');
        set(handles.uibuttongroup4,'Visible','on');
  

        set(handles.danji1,'Visible','off');
        set(handles.shuangji1,'Visible','off')
        set(handles.danji2,'Visible','on');
        set(handles.shuangji2,'Visible','on');
        set(handles.nAMU_show,'Visible','on');

        set(handles.text46,'Visible','off');
        set(handles.firingrate_num,'Visible','off');
        set(handles.text44,'Visible','off');
        set(handles.firingrate_show,'Visible','off');
end

% --- Executes during object creation, after setting all properties.
function uibuttongroup3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
if get(hObject, 'Value') == 1
        set(handles.scheme1calculate,'Visible','on');
       

    
        set(handles.MVC,'Visible','on');
        set(handles.MVC_value,'Visible','on');

        set(handles.changeperiod,'Visible','off');
        set(handles.changeperiod_value,'Visible','off');
        set(handles.uibuttongroup4,'Visible','off');
        

        set(handles.step,'Visible','off');
        set(handles.step_value,'Visible','off');

        set(handles.MUchannel_num,'Visible','on');
        set(handles.MUnum,'Visible','on');
        set(handles.MUchannel_num2,'Visible','off');
        set(handles.MUnum2,'Visible','off');

        set(handles.danji1,'Visible','on');
        set(handles.shuangji1,'Visible','on');
        set(handles.danji2,'Visible','off');
        set(handles.shuangji2,'Visible','off');
        set(handles.nAMU_show,'Visible','off');

        set(handles.text46,'Visible','on');
        set(handles.firingrate_num,'Visible','on');
        set(handles.text44,'Visible','on');
        set(handles.firingrate_show,'Visible','on');

end


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
if get(hObject, 'Value') == 1
    set(handles.scheme1calculate,'Visible','off');
       
    
        set(handles.MVC,'Visible','on');
        set(handles.MVC_value,'Visible','on');

        set(handles.changeperiod,'Visible','on');
        set(handles.changeperiod_value,'Visible','on');
        
        set(handles.step,'Visible','on');
        set(handles.step_value,'Visible','on');

        set(handles.gama,'Visible','on');
        set(handles.gama_value,'Visible','on');
        
        set(handles.MUchannel_num,'Visible','off');
        set(handles.MUnum,'Visible','off');
        set(handles.MUchannel_num2,'Visible','on');
        set(handles.MUnum2,'Visible','on');

        set(handles.danji1,'Visible','off');
        set(handles.shuangji1,'Visible','off');
        set(handles.danji2,'Visible','on');
        set(handles.shuangji2,'Visible','on');
        set(handles.nAMU_show,'Visible','off');

        set(handles.text46,'Visible','on');
        set(handles.firingrate_num,'Visible','on');
        set(handles.text44,'Visible','on');
        set(handles.firingrate_show,'Visible','on');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 从全局变量获取结果数据
global semg muap emgIPI muaptcell;

% 弹出保存文件对话框，让用户选择保存路径
savePath = uigetdir('选择保存路径');

% 检查用户是否取消了保存操作（点击了取消按钮）
if isequal(savePath, 0)
    disp('保存被取消');
    return;
end

% 保存结果1
filename1 = fullfile(savePath, 'semg.mat');
save(filename1, 'semg');

% 保存结果2
filename2 = fullfile(savePath, 'muap.mat');
save(filename2, 'muap');

% 保存结果3
filename3 = fullfile(savePath, 'emgIPI.mat');
save(filename3, 'emgIPI');

% 保存结果3
filename4 = fullfile(savePath, 'muaptcell.mat');
save(filename4, 'muaptcell');

disp('数据保存成功');



function RR_Callback(hObject, eventdata, handles)
% hObject    handle to RR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RR as text
%        str2double(get(hObject,'String')) returns contents of RR as a double


% --- Executes during object creation, after setting all properties.
function RR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to changeperiod_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeperiod_value as text
%        str2double(get(hObject,'String')) returns contents of changeperiod_value as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeperiod_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % 打开文件选择对话框
        [filename, filepath] = uigetfile({'*.txt', '文本文件 (*.txt)'; '*.mat', 'MAT文件 (*.mat)'}, '选择信号文件');
        
        if isequal(filename, 0) || isequal(filepath, 0)
            % 用户取消了文件选择
            return;
        else
            % 读取信号数据
            fullpath = fullfile(filepath, filename);
            
            try
                % 根据文件类型进行处理
                [~, ~, ext] = fileparts(fullpath);
                
                if strcmpi(ext, '.txt')
                    % 读取文本文件
                    signal = dlmread(fullpath);
                elseif strcmpi(ext, '.mat')
                    % 读取MAT文件
                    data = load(fullpath);
                    signal = data.signal;  % 假设MAT文件中的信号存储在名为"signal"的变量中
                  
                else
                    error('不支持的文件类型');
                end
                global excitation
              excitation =signal;
                % 将信号保存在工作区中
                assignin('base', 'excitation', signal);
                % 创建图形窗口并展示信号
                figure;
                plot(signal);
                title('信号展示');
                xlabel('时间');
                ylabel('幅值');
                
            catch
                errordlg('读取信号失败', '错误');
            end
        end

% --- Executes on button press in togglebutton11.
function togglebutton11_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton11
cla(handles.axes1,'reset');
axes(handles.axes1);
 global excitation

 t = linspace(0, 9, 9*2000);
HH1=plot(t,excitation);hold on
set(HH1,'LineWidth',1);

% --- Executes on button press in togglebutton12.
function togglebutton12_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton12


% --- Executes during object deletion, before destroying properties.
function text15_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to text15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function text15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
