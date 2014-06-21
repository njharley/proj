function varargout = mygui2(varargin)
% MYGUI2 MATLAB code for mygui2.fig
%      MYGUI2, by itself, creates a new MYGUI2 or raises the existing
%      singleton*.
%
%      H = MYGUI2 returns the handle to a new MYGUI2 or the handle to
%      the existing singleton*.
%
%      MYGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYGUI2.M with the given input arguments.
%
%      MYGUI2('Property','Value',...) creates a new MYGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mygui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mygui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mygui2

% Last Modified by GUIDE v2.5 16-Jun-2014 23:25:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mygui2_OpeningFcn, ...
                   'gui_OutputFcn',  @mygui2_OutputFcn, ...
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


% --- Executes just before mygui2 is made visible.
function mygui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mygui2 (see VARARGIN)

% Choose default command line output for mygui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mygui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mygui2_OutputFcn(hObject, eventdata, handles) 
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

    global storedStructure;
    storedStructure = load(['wtc_mat/' filename]);

    global nmat;
    nmat = readmidi(['wtc_midi/' filename(1:strfind(filename,'.')) 'mid']);


% --- Executes on button press in getclassmatrix.
function getclassmatrix_Callback(hObject, eventdata, handles)
% hObject    handle to getclassmatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global storedStructure;
	cM = storedStructure.cMtn;

	axes(handles.classmatrix)

	for i = 1:size(cM,1)
		lines = cM{i};
		for j = 1:size(lines,1)
			x = lines(j,:);
			if isempty(x) break;
			else
				y = [i i];
				plot(x,y,'-k')
				hold on;
			end
		end
	end
	sets = [25 66 116 130 176 189 276 316];
	set_names = {'3-11B';'4-27B';'5-27A';'5-35';'6-Z25A';'6-33B';'7-35';'8-23';};
	set(gca,'ytick',sets);
	set(gca,'YTickLabel',set_names);
	ylabel('Set-Class'); xlabel('Time'); title('Class Matrix');


% --- Executes on button press in getclassvector.
function getclassvector_Callback(hObject, eventdata, handles)
% hObject    handle to getclassvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global storedStructure;
	cV = storedStructure.cVtn
	axes(handles.classvector)
	bar(cV);

	sets = [24 66 116 130 176 189 276 316];
	set_names = {'3-11A';'4-27B';'5-27A';'5-35';'6-Z25A';'6-33B';'7-35';'8-23';};

	set(gca,'xtick',sets);
	set(gca,'XTickLabel',set_names);
	ylabel('% Time'); xlabel('Set-Class'); title('Class Vector');


% --- Executes on button press in getdistanceplot.
function getdistanceplot_Callback(hObject, eventdata, handles)
% hObject    handle to getdistanceplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	win = 2%get(handles.win);
	hop = 2%get(handles.hop);

	global orderedtn;
	load pcsetdata

	global nmat;
	%qnmat = quantize(nmat, 1/32, 1/32, 1/32);
	pds = movewindow(nmat,win,hop,'sec','pcdist1');

	load TotalMeasuresPrime
	[distance_vector classhis] = segment(pds,ATMEMB_prime,276);
	x = (1:length(distance_vector)).*hop;

	axis(handles.distanceplot)
	plot(x,distance_vector)


function [distance_vector class_vector] = segment(pds,MEASURE_prime,comparison_set_idx)

	class_vector = zeros(1,351);
	distance_vector = [];

	for i = 1:size(pds,1)
		pc_set = find(pds(i,:))-1;
		prime_set = primeFormAB(pc_set);
		set_index = getSetIndex(prime_set);
		class_vector(set_index) = class_vector(set_index)+1;
		distance_vector(end+1) = MEASURE_prime(set_index,comparison_set_idx);
	end

function set_index = getSetIndex(prime_set)

	global orderedtn
	for i = 1:size(orderedtn,1)
		x = unique(orderedtn(i,:));
		if isequal(prime_set,x)
			set_index = i;
			break;
		end
	end
