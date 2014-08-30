function varargout = AnalysisTool(varargin)
% ANALYSISTOOL MATLAB code for AnalysisTool.fig

% Last Modified by GUIDE v2.5 20-Aug-2014 17:36:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnalysisTool_OpeningFcn, ...
                   'gui_OutputFcn',  @AnalysisTool_OutputFcn, ...
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


% --- Executes just before AnalysisTool is made visible.
function AnalysisTool_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = AnalysisTool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in loadmidi.
function loadmidi_Callback(hObject, eventdata, handles)
    
%%%%
%%%% LOAD A MIDI FILE
%%%% 

    [FileName,PathName,FilterIndex] = uigetfile('.mid');

    % DISPLAY FILENAME
    set(handles.filename,'String',FileName);

    % READ MIDI FILE USING MIDITOOLBOX
    global nmat
    nmat = readmidi([PathName FileName]);
    %nmat(:,6:7) = nmat(:,1:2);
    nmat = quantize(nmat,1/16,1/16,1/16);
    nmat(:,6:7) = nmat(:,1:2);

    % LOAD GENERAL SET CLASS INFO
    global idxtn cardtn classtn
    load pcsetdata
    load cardtn

%%%%
%%%% CALCULATE BASIC TIME INFO IN BEATS AND BARS
%%%% 

    global duration_beats duration_bars beats_per_bar bar_ticks time_lims
    duration_beats = max(unique(nmat(:,1)+nmat(:,2)));
    beats_per_bar = 4;
    duration_bars = (duration_beats/beats_per_bar)+1;
    bar_ticks = 1:4:duration_bars;
    time_lims = [1 duration_bars];

%%%%
%%%% GET THE SYSTEMATIC SEGMENTATION DATA
%%%% 

    global windows_sys scs_sys
    try
        % TRY AND READ A META FILE...
        storedStructure = load([PathName FileName(1:strfind(FileName,'.')) 'mat']);
        windows_sys = storedStructure.windows_sys;
        scs_sys = storedStructure.scs_sys;
    catch
        % ELSE SEGMENT FROM NOTEMATRIX AND SAVE META FILE FOR NEXT TIME
        disp('Analysing... This can take some minutes')
        [windows_sys scs_sys] = SegmentA(nmat, idxtn);
        disp('Complete!')
        save([PathName FileName(1:strfind(FileName,'.')) 'mat'],'windows_sys','scs_sys');
    end

%%%%
%%%% CALCULATE GLOBAL CLASS MATRIX AND VECTOR
%%%% 

    global class_matrix_sys class_vector_sys
    class_matrix_sys = calc_Class_Matrix(windows_sys, scs_sys);
    class_vector_sys = calc_Class_Vector(class_matrix_sys, duration_beats);

%%%%
%%%% PLOT GLOBAL INFORMATION
%%%%

    global global_plots proll_plot cm_plot cv_plot

    global_plots = figure();
    figure(global_plots);

    % PIANOROLL
    proll_plot = subplot(6,1,1);
    pianoroll(nmat);
    set(gca,'XTick',[]); set(gca,'YTick',[]);
    ylabel('Pianoroll','FontSize',14);
    title(FileName,'FontSize',20);
    xlim([0 duration_beats]);

    global forteNames
    load forteNames
    [pks loc] = findpeaks(class_vector_sys(1:316));
    [pks_ordered I] = sort(pks);
    loc = fliplr(loc(I));
    sc_ticks = sort(loc(1:6));
    sc_labels = forteNames(sc_ticks);

    % CLASS MATRIX
    cm_plot = subplot(6,1,[2 3 4]);
    %pianoroll(nmat,'num','beat');
    plot_Class_Matrix(class_matrix_sys,'b',1);
    xlim(time_lims); ylim([0 351]); set(gca,'XTick',bar_ticks);
    set(gca,'YTick',sc_ticks);
    set(gca,'YTickLabel',sc_labels);
    ylabel('Class Matrix','FontSize',14);
    %xlabel('Time (Bars)','FontSize',15)

    % CLASS VECTOR
    cv_plot = subplot(6,1,[5 6]);
    bar(class_vector_sys);
    xlim([0 351]); ylim([0 1]); 
    set(gca,'XTick',sc_ticks);
    set(gca,'XTickLabel',sc_labels);
    ylabel('Class Vector','FontSize',14);

% --- Executes on button press in showseginfo.
function showseginfo_Callback(hObject, eventdata, handles)
% hObject    handle to showseginfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%
%%%% CALCULATE SEGMENT LENGTH STATISTICS
%%%% 

    global windows_sys cardtn scs_sys forteNames
    [sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calc_Seg_Size(scs_sys, windows_sys, cardtn);
    
%%%%
%%%% PLOT SEGMENT LENGTH STATISTICS
%%%% 

    seginfo_fig = figure();
    sc_seg_size_plot = subplot(2,1,1);
    bar(sc_seg_size_avg);
    hold on;
    h=errorbar(1:351,sc_seg_size_avg,sc_seg_size_std,'r'); 
    set(h,'linestyle','none'); errorbar_tick(h, 500); 
    xlim([0 351]);
    ylim([0 16]);
    set(gca, 'XTick',[25 66 176 276])
    set(gca,'XTickLabel', forteNames([25 66 176 276]));
    title('Window Length Statistics','FontSize',20);
    xlabel('Set Class','FontSize',14);
    ylabel('Average Window Length (beats)','FontSize',14);
    grid on;

    card_seg_size_plot = subplot(2,1,2);
    bar(card_seg_size_avg);
    hold on;
    h=errorbar(1:12,card_seg_size_avg,card_seg_size_std,'r'); 
    set(h,'linestyle','none'); errorbar_tick(h, 500);
    ylim([0 16]);
    xlim([0.5 12.5]);
    xlabel('Cardinality Class','FontSize',14);
    ylabel('Average Window Length (beats)','FontSize',14);
    grid on;


% --- Executes on button press in visualise.
function visualise_Callback(hObject, eventdata, handles)
% hObject    handle to visualise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
%%%%
%%%% GET WINDOW AND HOPSIZE FROM USER
%%%% 

    global win hop
    win = get(handles.windowsizeslider,'Value')*20;
    %win = 2;
    set(handles.windowsize,'String',['Window Size = ' num2str(win) 'beats']);

    hop = get(handles.hopsizeslider,'Value')*20;
    %hop = 0.4;
    set(handles.hopsize,'String',['Hop Size = ' num2str(hop) 'beats']);

%%%%
%%%% GET COMPARISON SET FROM USER
%%%% 

    global classtn
    comparison_set = str2num(get(handles.compset,'String'));
    set(handles.fortename,'String',['Forte Name: ' classtn{comparison_set}]);

%%%%
%%%% SLIDING WINDOW SEGMENTATION
%%%% 

    global nmat idxtn duration_beats duration_bars
    [windows_win scs_win] = SegmentB(nmat, win, hop, idxtn, duration_beats);

%%%%
%%%% CALCULATE SLIDING WINDOW CLASS MATRIX AND VECTOR
%%%% 

    class_matrix_win = calc_Class_Matrix(windows_win, scs_win);
    class_vector_win = calc_Class_Vector(class_matrix_win, duration_beats);

%%%%
%%%% PLOT SLIDING WINDOW CM AND CV
%%%% 

    global global_plots cm_plot cv_plot
    figure(global_plots);
    axes(cm_plot); hold on;
    plot_Class_Matrix(class_matrix_win,'r',1.5);
    axes(cv_plot); hold on;
    plot(class_vector_win,'-r', 'linewidth',2);


%%%%
%%%% LOAD MEASURE VALUES
%%%% 

    load AllTotalMeasures

%%%%
%%%% GATHER MEASURES TO BE PLOTTED
%%%% 

    selectedmeasures(1) = get(handles.atmemb,'Value');
    selectedmeasures(2) = get(handles.rela,'Value');
    selectedmeasures(3) = get(handles.relb,'Value');
    selectedmeasures(4) = get(handles.relc,'Value');
    selectedmeasures(5) = get(handles.recrel,'Value');
    selectedmeasures(6) = get(handles.tprel,'Value');
    selectedmeasures(7) = get(handles.avgsatsim,'Value');
    selectedmeasures(8) = get(handles.tsatsim,'Value');

    measures_to_plot = alltotalmeasures(:,:,find(selectedmeasures));

    % GIVE EACH PLOT A DIFFERENT COLOUR
    colours = {'-k';'-y';'-m';'-c';'-r';'-g';'-b';'-k';};
    colours_to_plot = colours(find(selectedmeasures));

    % COMPUTE TIME SERIES
    [dv] = calc_Distance_Vector(scs_win, measures_to_plot, comparison_set);
    [acf] = calc_Autocorr(dv);
    [dif] = diff(dv,1,2);
    %[dif] = diff(dif,1,2);
    [ssm] = calc_SSM(scs_win, measures_to_plot(:,:,1));

    global beats_per_bar
    time_bars = (((((1:length(scs_win))-1).*hop)+win)./beats_per_bar)+1;

%%%%
%%%% PLOT TIME SERIES
%%%% 

    dist_fig = figure();
    figure(dist_fig);

    % PIANOROLL
    proll_plot = subplot(4,1,1);
    pianoroll(nmat,'num','beat');
    set(gca,'XTick',[]); set(gca,'YTick',[]);
    xlim([0 duration_beats]);
    title('BWV-846.mid','FontSize',20);
    ylabel('Pianoroll','FontSize',14);

    for i = 1:size(measures_to_plot,3)

        % DISTANCE VECTOR
        dv_plot = subplot(4,1,2);
        plot(time_bars,dv(i,:),colours_to_plot{i});
        hold on;

        % AUTOCORRELATION
        acf_plot = subplot(4,1,3);
        plot(time_bars,acf(i,:),colours_to_plot{i});
        hold on;

        % APPROXIMATE DIFFERENTIAL
        dif_plot = subplot(4,1,4);
        plot(time_bars(1:length(dif)),dif(i,:),colours_to_plot{i});
        hold on;
    end

%%%%
%%%% TIDY PLOTS
%%%% 

    global time_lims bar_ticks
    dv_plot = subplot(4,1,2); xlim(time_lims); ylim([0 100]); 
    set(gca,'XTick',bar_ticks); ylabel('Distance','FontSize',14); 
    title('Ref Set: 3-11A','FontSize',14); grid on;
    acf_plot = subplot(4,1,3); xlim(time_lims); 
    set(gca,'XTick',bar_ticks); ylabel('Autocorrelation','FontSize',14); grid on;
    dif_plot = subplot(4,1,4); xlim(time_lims); 
    set(gca,'XTick',bar_ticks); ylabel('Differential','FontSize',14); grid on;

%%%%
%%%% PLOT SELF SIMILARITY MATRIX
%%%% 

    ssm_fig = figure();
    ssm_plot = subplot(1,1,1);
    imagesc(ssm);
    %lbls = (1:4:36);
    %tks = (((lbls-1).*4)./hop);
    %lbls = (1:4:36)+(win/8);%-(hop/4);

    colorbar; caxis([0 100]); 
    colormap(gray); axis square;
    %set(gca,'xtick',time_bars); set(gca,'ytick',time_bars);
    set(gca,'xtick',(1:(16/hop):duration_beats)); set(gca,'XTickLabel',(1:4:duration_bars));
    set(gca,'ytick',(1:(16/hop):duration_beats)); set(gca,'YTickLabel',(1:4:duration_bars));
    %set(gca,'xtick',tks); set(gca,'XTickLabel',lbls);
    %set(gca,'ytick',tks); set(gca,'YTickLabel',lbls);
    title('BWV-846.mid','FontSize',20); xlabel('Time (bars)','FontSize',14); ylabel('Time (bars)','FontSize',14);
    ylabel(colorbar, 'ATMEMB-prime Distance','FontSize',14);

%%%%
%%%% PLOT SCS IN SPACE
%%%% 

    view_space(class_vector_win,measures_to_plot(:,:,1),comparison_set);

% --- Executes on slider movement.
function windowsizeslider_Callback(hObject, eventdata, handles)

    win = get(handles.windowsizeslider,'Value')*20;
    set(handles.windowsize,'String',['Window Size = ' num2str(win) 'beats']);

% --- Executes during object creation, after setting all properties.
function windowsizeslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowsizeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function hopsizeslider_Callback(hObject, eventdata, handles)

    hop = get(handles.hopsizeslider,'Value')*20;
    set(handles.hopsize,'String',['Hop Size = ' num2str(hop) 'beats']);


% --- Executes during object creation, after setting all properties.
function hopsizeslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsizeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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


% --- Executes on button press in relc.
function relc_Callback(hObject, eventdata, handles)
% hObject    handle to relc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of relc

function tsatsim_Callback(hObject, eventdata, handles)

function avgsatsim_Callback(hObject, eventdata, handles)

function tprel_Callback(hObject, eventdata, handles)

function recrel_Callback(hObject, eventdata, handles)

function relb_Callback(hObject, eventdata, handles)

function rela_Callback(hObject, eventdata, handles)

function atmemb_Callback(hObject, eventdata, handles)
