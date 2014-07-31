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
    title(handles.proll,'Pianoroll');
    axis off

  	[m,I] = max(nmat(:,1));
  	global endtime;
  	endtime = m+nmat(I,2);
 	%xlim([0 endtime]);

	cM = storedStructure.cMtn;
	cV = storedStructure.cVtn;

	axes(handles.classmatrix);
	for i = 1:size(cM,1)
		lines = cM{i};
		for j = 1:size(lines,1)
			x = lines(j,:).*(tempo/60)+1;
			x = (x./4)-(1/4)+1;
			if isempty(x) break;
			else
				y = [i i];
				plot(x,y,'-k')
				hold on;
			end
		end
	end
	title(handles.classmatrix,'Class-Matrix');
	xlim([1 endtime/4]);
	ylim([1 351]);
	%sets = [25 24 23 26 22 57 64 65 66 67 55 56 59 46 51 61 129 117 116 176 189 130 192 276 322];
	%set_labels = {'3-11B';'3-11A';'3-10';'3-12';'3-9';'4-20';'4-26';'4-27A';'4-27B';'4-28';'4-19A';'4-19B';'4-22A';'4-14A';'4-16B';'4-23';'5-34';'5-27B';'5-27A';'6-Z25A';'6-33B';'5-35';'6-35';'7-35';'8-28';};
	%sets_ordered = sort(sets);
	%for i = 1:length(sets_ordered)
	%	set_labels_ordered{i} = set_labels{find(sets==sets_ordered(i))};
	%end
	%set(handles.classmatrix,'xtick',1:4:140);
	%set(handles.classmatrix,'YTickLabel',1:35);

	axes(handles.classvector);
	title(handles.classvector,'Class-Vector');
	bar(cV);
	title(handles.classvector,'Class-Vector');
	xlim([1 351]);
	%set(handles.classmatrix,'xtick',sort(sets));
	%set(handles.classmatrix,'XTickLabel',sort(sets));

	global sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std
	[sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calcscsegsize(storedStructure.pcs,storedStructure.w, tempo);
	axes(handles.segment); cla;
	bar(1:351,sc_seg_size_avg,'k'); xlim([1 351]);
	hold on;
	h=errorbar(1:351,sc_seg_size_avg,sc_seg_size_std,'r'); 
	set(h,'linestyle','none'); errorbar_tick(h, 500); ylim([0 max(sc_seg_size_avg)]);

% --- Executes on slider movement.
function filterclass_Callback(hObject, eventdata, handles)
% hObject    handle to filterclass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

	lim = get(hObject,'Value');
	f = round(351*(1-lim));
	axes(handles.classvector);
	xlim([1 f]);
	axes(handles.classmatrix);
	ylim([1 f]);
	axes(handles.segment);
	xlim([1 f]);


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
	global win hop
	win = get(handles.windowsize,'Value')*20;
    set(handles.WindowSize,'String',['Window Size = ' num2str(win) 'beats']);
	hop = get(handles.hopsize,'Value')*20;
	set(handles.HopSize,'String',['Hop Size = ' num2str(hop) 'beats']);

	global orderedtn;
	load pcsetdata

	global nmat;
	qnmat = quantize(nmat, 1/32, 1/32, 1/32);
	pds = movewindow(qnmat,win,hop,'beat','pcdist1');

	load TotalMeasuresPrime

	alltotalmeasures(:,:,1) = ATMEMB_prime;
	alltotalmeasures(:,:,2) = RELa_prime;
	alltotalmeasures(:,:,3) = RELb_prime;
	alltotalmeasures(:,:,4) = RELc_prime;
	alltotalmeasures(:,:,5) = RECREL_prime;
	alltotalmeasures(:,:,6) = TpREL_prime;
	alltotalmeasures(:,:,7) = AvgSATSIM_prime;
	alltotalmeasures(:,:,8) = TSATSIM_prime;

	sets = [25 24 23 26 22 57 64 65 66 67 55 56 59 46 51 61 129 117 116 176 189 130 192 276 322];
	set_labels = {'3-11B';'3-11A';'3-10';'3-12';'3-9';'4-20';'4-26';'4-27A';'4-27B';'4-28';'4-19A';'4-19B';'4-22A';'4-14A';'4-16B';'4-23';'5-34';'5-27B';'5-27A';'6-Z25A';'6-33B';'5-35';'6-35';'7-35';'8-28';};

    cs = str2num(get(handles.compset,'String'));
    compsetplot(1,:) = alltotalmeasures(cs,sets,1);
    compsetplot(2,:) = alltotalmeasures(cs,sets,2);
	compsetplot(3,:) = alltotalmeasures(cs,sets,3);
	compsetplot(4,:) = alltotalmeasures(cs,sets,4);
	compsetplot(5,:) = alltotalmeasures(cs,sets,5);
	compsetplot(6,:) = alltotalmeasures(cs,sets,6);
	compsetplot(7,:) = alltotalmeasures(cs,sets,7);
	compsetplot(8,:) = alltotalmeasures(cs,sets,8);

	axes(handles.compsetplot);cla;
	imagesc(compsetplot); colormap(gray); colorbar; caxis([0 100]);
	labels_measures = {'ATMEMB';'RELa';'RELb';'RELc';'RECREL';'TpREL';'AvgSATSIM';'TSATSIM';};
	aux_measures=1:8;
	set(handles.compsetplot,'ytick',aux_measures);
	set(handles.compsetplot,'YTickLabel',labels_measures);
	set(handles.compsetplot,'xtick',1:25);
	set(handles.compsetplot,'XTickLabel',sets);

	[distance_vector classhis set_idx] = segment(pds,alltotalmeasures,cs);
	x = ((1:length(distance_vector)).*hop/4-hop/4+1);

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
	cla; 
	bar(storedStructure.cVtn);
	hold on;
	plot(classhis,'-r','LineWidth',2);
	xlim([1 351]); ylim([0 1]); title(handles.classvector,'Class-Vector');

	axes(handles.distanceplot);
	cla; grid on;
	colours = {'-k';'-y';'-m';'-c';'-r';'-g';'-b';'-k';};
	measures_to_plot = find(selectedmeasures);
	for i = 1:length(measures_to_plot)
		dv = distance_vector(measures_to_plot(i),:);
		plot(x,dv,colours{measures_to_plot(i)});
		hold on;
	end
	global endtime;
	xlim([1 endtime/4]);
	ylim([0 100]); 
	title(handles.distanceplot,'Distance Plot');

	axes(handles.autocor);
	cla; grid on;
	for i = 1:length(measures_to_plot)
		acf = autocorr(distance_vector(measures_to_plot(i),:),size(distance_vector,2)-1);
		plot(((1:length(acf)).*hop/4-hop/4+1),acf,colours{measures_to_plot(i)});
		hold on;
	end
	xlim([1 endtime/4]); 
	title(handles.autocor,'Autocorrelation');

	axes(handles.crosscorrmat);
	cla;
	for i = 1:length(set_idx)
		for j = 1:length(set_idx)
			crosscorrmat(i,j) = alltotalmeasures(set_idx(i),set_idx(j),measures_to_plot(1));
		end
	end
	imagesc(crosscorrmat); colorbar; caxis([0 100]);
	colormap(gray); title(handles.crosscorrmat,'Self Similarity Matrix');

function [distance_vector class_vector set_idx] = segment(pds,alltotalmeasures,comparison_set_idx)

	class_vector = zeros(1,351);
	distance_vector = [];

	for i = 1:size(pds,1)
		pc_set = find(pds(i,:))-1;
		prime_set = primeFormAB(pc_set);
		set_index = getSetIndex(prime_set);
		set_idx(i) = set_index;
		global endtime
		global win hop
		global tempo
		if i ~= 1 
			if set_idx(i) == set_idx(i-1)
				class_vector(set_index) = class_vector(set_index)+hop/(endtime*(tempo/60));
			else
				class_vector(set_index) = class_vector(set_index)+win/(endtime*(tempo/60));
			end
		end

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

	win = get(hObject,'Value')*20;
    set(handles.WindowSize,'String',['Window Size = ' num2str(win) 'beats']);

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
	
	hop = get(hObject,'Value')*20;
	set(handles.HopSize,'String',['Hop Size = ' num2str(hop) ' beats']);


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

function [sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calcscsegsize(pcs,w,tempo)

	load pcsetdata;
	pc_sets = pcs+1;
	tn_scs = idxtn(pc_sets);

	seg_sizes = (w(:,2)-w(:,1)).*tempo/60;

	for i = 1:351
		isegs = find(tn_scs==i);
		sc_seg_size_avg(i) = mean(seg_sizes(isegs));
		sc_seg_size_std(i) = std(seg_sizes(isegs));
	end

	set_card = card(pc_sets);
	for i = 1:12
		isegs = find(set_card==i);
		card_seg_size_avg(i) = mean(seg_sizes(isegs));
		card_seg_size_std(i) = std(seg_sizes(isegs));
	end



% --- Executes on slider movement.
function segscale_Callback(hObject, eventdata, handles)
% hObject    handle to segscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

	global endtime;
	f = round(1000*((endtime*(1-get(hObject,'Value'))))+1)/1000;
	axes(handles.segment);
	ylim([0 f]);


% --- Executes during object creation, after setting all properties.
function segscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in scbutton.
function scbutton_Callback(hObject, eventdata, handles)
% hObject    handle to scbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global sc_seg_size_avg sc_seg_size_std
	axes(handles.segment); cla;
	bar(1:351,sc_seg_size_avg,'k'); xlim([1 351]);
	hold on;
	h=errorbar(1:351,sc_seg_size_avg,sc_seg_size_std,'r'); 
	set(h,'linestyle','none'); errorbar_tick(h, 500); ylim([0 max(sc_seg_size_avg)]);
	xlabel('SC');


% --- Executes on button press in cardbutton.
function cardbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cardbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global card_seg_size_avg card_seg_size_std
	axes(handles.segment); cla;
	top = [1 7 26 69 135 215 281 324 343 349 350 351];
	bar(1:12,card_seg_size_avg,'k');
	xlabel('Cardinality'); 
	hold on;
	h=errorbar(1:12,card_seg_size_avg,card_seg_size_std,'r'); 
	set(h,'linestyle','none'); errorbar_tick(h, 500); 
	ylim([0 max(card_seg_size_avg)]); xlim([0 12]);
