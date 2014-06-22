function varargout = mygui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mygui_OpeningFcn, ...
                   'gui_OutputFcn',  @mygui_OutputFcn, ...
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


% --- Executes just before mygui is made visible.
function mygui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mygui (see VARARGIN)

% Choose default command line output for mygui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mygui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mygui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in loadfile.
function loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    filename = uigetfile;
    set(handles.filename,'String',filename)

    global storedStructure;
    storedStructure = load(['wtc_mat/' filename]);

    global nmat;
    nmat = readmidi(['wtc_midi/' filename(1:strfind(filename,'.')) 'mid']);

    global tempo;
    tempo = gettempo(nmat);

    axes(handles.proll);
    pianoroll(nmat,'num','sec');
    axis off

  	[m,I] = max(nmat(:,1));
  	global endtime;
  	endtime = m+nmat(I,2);
 	%xlim([0 endtime]);

	cM = storedStructure.cMtn;
	cV = storedStructure.cVtn;

	axes(handles.classmatrix);
	cla;
	axes(handles.classvector);
	cla;

	axes(handles.classmatrix);
	for i = 1:size(cM,1)
		lines = cM{i};
		for j = 1:size(lines,1)
			x = lines(j,:).*(tempo/60);
			if isempty(x) break;
			else
				y = [i i];
				plot(x,y,'-k')
				hold on;
			end
		end
	end
	set(gca,'xtick',[]);
	xlim([0 endtime])
	ylim([1 351]);
	axes(handles.classvector);
	bar(cV);
	xlim([1 351]);

% --- Executes on slider movement.
function filterclass_Callback(hObject, eventdata, handles)
% hObject    handle to filterclass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

	f = round(351*((1-get(hObject,'Value'))*1000)/1000);
	axes(handles.classvector);
	xlim([1 f]);
	axes(handles.classmatrix);
	ylim([1 f]);


% --- Executes during object creation, after setting all properties.
function filterclass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterclass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in plotdistance.
function plotdistance_Callback(hObject, eventdata, handles)
% hObject    handle to plotdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

	win = get(handles.windowsize,'Value')*10;
    set(handles.WindowSize,'String',['Window Size = ' num2str(win) 'beats']);
	hop = get(handles.hopsize,'Value')*10;
	set(handles.HopSize,'String',['Hop Size = ' num2str(hop) 'beats']);

	global orderedtn;
	load pcsetdata

	global nmat;
	%qnmat = quantize(nmat, 1/32, 1/32, 1/32);
	pds = movewindow(nmat,win,hop,'beat','pcdist1');

	load TotalMeasuresPrime

	alltotalmeasures(:,:,1) = ATMEMB_prime;
	alltotalmeasures(:,:,2) = RELa_prime;
	alltotalmeasures(:,:,3) = RELb_prime;
	alltotalmeasures(:,:,4) = RELc_prime;
	alltotalmeasures(:,:,5) = RECREL_prime;
	alltotalmeasures(:,:,6) = TpREL_prime;
	alltotalmeasures(:,:,7) = AvgSATSIM_prime;
	alltotalmeasures(:,:,8) = TSATSIM_prime;
    
    cs = str2num(get(handles.compset,'String'));

	[distance_vector classhis set_idx] = segment(pds,alltotalmeasures,cs);
	x = (1:length(distance_vector)).*hop;

	selectedmeasures(1) = get(handles.atmemb,'Value');
	selectedmeasures(2) = get(handles.rela,'Value');
	selectedmeasures(3) = get(handles.relb,'Value');
	selectedmeasures(4) = get(handles.relc,'Value');
	selectedmeasures(5) = get(handles.recrel,'Value');
	selectedmeasures(6) = get(handles.tprel,'Value');
	selectedmeasures(7) = get(handles.avgsatsim,'Value');
	selectedmeasures(8) = get(handles.tsatsim,'Value');

	global storedStructure;
	axes(handles.classvector);
	cla
	bar(storedStructure.cVtn);
	hold on;
	plot(classhis,'-r','LineWidth',2);
	xlim([1 351]); ylim([0 1]);

	axes(handles.distanceplot);
	cla;
	colours = {'-k';'-y';'-m';'-c';'-r';'-g';'-b';'-k';};
	measures_to_plot = find(selectedmeasures);
	for i = 1:length(measures_to_plot)
		dv = distance_vector(measures_to_plot(i),:);
		plot(x,dv,colours{measures_to_plot(i)});
		hold on;
	end
	global endtime;
	xlim([0 endtime])

	axes(handles.autocor);
	cla;
	for i = 1:length(measures_to_plot)
		acf = autocorr(distance_vector(measures_to_plot(i),:),size(distance_vector,2)-1);
		plot((1:length(acf)).*hop,acf,colours{measures_to_plot(i)});
		hold on;
	end
	xlim([0 endtime])

	axes(handles.crosscorrmat);
	cla;
	for i = 1:length(set_idx)
		for j = 1:length(set_idx)
			crosscorrmat(i,j) = alltotalmeasures(set_idx(i),set_idx(j),measures_to_plot(1));
		end
	end
	imagesc(crosscorrmat);
	colormap(gray);

function [distance_vector class_vector set_idx] = segment(pds,alltotalmeasures,comparison_set_idx)

	class_vector = zeros(1,351);
	distance_vector = [];

	for i = 1:size(pds,1)
		pc_set = find(pds(i,:))-1;
		prime_set = primeFormAB(pc_set);
		set_index = getSetIndex(prime_set);
		set_idx(i) = set_index;
		class_vector(set_index) = class_vector(set_index)+1;
		distance_vector(1,i) = alltotalmeasures(set_index,comparison_set_idx,1);
		distance_vector(2,i) = alltotalmeasures(set_index,comparison_set_idx,2);
		distance_vector(3,i) = alltotalmeasures(set_index,comparison_set_idx,3);
		distance_vector(4,i) = alltotalmeasures(set_index,comparison_set_idx,4);
		distance_vector(5,i) = alltotalmeasures(set_index,comparison_set_idx,5);
		distance_vector(6,i) = alltotalmeasures(set_index,comparison_set_idx,6);
		distance_vector(7,i) = alltotalmeasures(set_index,comparison_set_idx,7);
		distance_vector(8,i) = alltotalmeasures(set_index,comparison_set_idx,8);
	end
	class_vector = class_vector./sum(class_vector);

function set_index = getSetIndex(prime_set)
	global orderedtn
	for i = 1:size(orderedtn,1)
		x = unique(orderedtn(i,:));
		if isequal(prime_set,x)
			set_index = i;
			break;
		end
    end

% --- Executes on slider movement.
function windowsize_Callback(hObject, eventdata, handles)
% hObject    handle to windowsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function windowsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function hopsize_Callback(hObject, eventdata, handles)
% hObject    handle to hopsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function hopsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in atmemb.
function atmemb_Callback(hObject, eventdata, handles)
% hObject    handle to atmemb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of atmemb


% --- Executes on button press in recrel.
function recrel_Callback(hObject, eventdata, handles)
% hObject    handle to recrel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of recrel


% --- Executes on button press in rela.
function rela_Callback(hObject, eventdata, handles)
% hObject    handle to rela (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rela


% --- Executes on button press in tprel.
function tprel_Callback(hObject, eventdata, handles)
% hObject    handle to tprel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tprel


% --- Executes on button press in relb.
function relb_Callback(hObject, eventdata, handles)
% hObject    handle to relb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of relb


% --- Executes on button press in relc.
function relc_Callback(hObject, eventdata, handles)
% hObject    handle to relc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of relc


% --- Executes on button press in avgsatsim.
function avgsatsim_Callback(hObject, eventdata, handles)
% hObject    handle to avgsatsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of avgsatsim


% --- Executes on button press in tsatsim.
function tsatsim_Callback(hObject, eventdata, handles)
% hObject    handle to tsatsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tsatsim



function compset_Callback(hObject, eventdata, handles)
% hObject    handle to compset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compset as text
%        str2double(get(hObject,'String')) returns contents of compset as a double


% --- Executes during object creation, after setting all properties.
function compset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','276');


% --- Executes on button press in playfile.
function playfile_Callback(hObject, eventdata, handles)
% hObject    handle to playfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global nmat;
    playmidi(nmat);


% --- Executes on button press in class.
function class_Callback(hObject, eventdata, handles)
% hObject    handle to class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in card.
function card_Callback(hObject, eventdata, handles)
% hObject    handle to card (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
