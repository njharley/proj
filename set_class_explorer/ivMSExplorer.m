function varargout = ivMSExplorer(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ivMSExplorer_OpeningFcn, ...
                   'gui_OutputFcn',  @ivMSExplorer_OutputFcn, ...
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


function ivMSExplorer_OpeningFcn(hObject,eventdata,handles,varargin)
handles.minres = 0.5;
handles.nscales = 30;
handles.rel = 171;
handles.isrel = 0;
handles.cardinality = [1 1 1 1 1 1 1 1 1 1 1 1];
handles.classtype = 'iv';
handles.primeallowed = 1:223;
handles.numcolors = 128;
handles.sonx = 152;
handles.sony = 50;
setappdata(0,'sonselx',152)
setappdata(0,'sonsely',50);
handles.output = hObject;
guidata(hObject, handles);
axes(handles.PianoRollPlot); axis off;
axes(handles.CursorSegmentPlot); axis off;
axes(handles.ClassVectorPlot); axis off;
axes(handles.ClassScapePlot); axis off;
axes(handles.ClassMatrixPlot); axis off;


function varargout = ivMSExplorer_OutputFcn(hObject,eventdata,handles) 
varargout{1} = handles.output;


function LoadButton_Callback(hObject,eventdata,handles)
[FileName Path]=uigetfile({'*.mid'},'Load MIDI file');
if isequal(FileName,0), return;
else
    FileExt = FileName(end-3:end);
    if FileExt == '.mid'
        nmat = readmidi(strcat(Path,FileName));
        totaldur = midiLength(nmat);
        bpm = gettempo(nmat);
        minres = max(0.5,handles.minres);
        set(handles.MinRes, 'String', sprintf('%1.1f',minres));
        nscales = min(30,handles.nscales);
        set(handles.NumScales, 'String', sprintf('%1.0f',nscales));
        handles.minres = minres;
        handles.nmat = nmat;
        handles.totaldur = totaldur;
        handles.bpm = bpm;
    end
    guidata(hObject,handles);
    VisualizePianoRoll(handles);
    Compute(hObject,handles);
end


function ComputeButton_Callback(hObject,eventdata,handles)
Compute(hObject,handles);


function Compute(hObject,handles)
setappdata(0,'sonselx',152);
setappdata(0,'sonsely',50);
nmat = handles.nmat;
nmat = dropmidich(nmat,10);
nmat(:,3) = 1;
nmat(:,4) = mod(nmat(:,4),12)+60;
nmat = unique(nmat,'rows');
minres = handles.minres;
totaldur = handles.totaldur;
nscales = handles.nscales;
logbase = 2^(log2(totaldur-minres)/(nscales-1));
r = swPolicyMidi(nmat,minres,logbase);
w = msSlidingWindowMidi(nmat,r);
pcs = msPitchClassSet(nmat,w);
load pcsetdata;
[f c] = size(pcs);
x = round(c/2);
y = round(f/2);
handles.scapex = x;
handles.scapey = y;
setappdata(0,'pcsx',x);
setappdata(0,'pcsy',y);
classmtxiv = zeros(200,c);
classmtxtni = zeros(223,c);
classmtxtn = zeros(351,c);
for i = 1:f
    for j = 1:c
        idx = ceil(w(i,j,1)/minres)+1:floor(w(i,j,2)/minres);
        classmtxiv(idxiv(pcs(i,j)+1),idx) = 1;
        classmtxtni(idxtni(pcs(i,j)+1),idx) = 1;
        classmtxtn(idxtn(pcs(i,j)+1),idx) = 1;
    end
end
classveciv = sum(classmtxiv,2)*100/c;
classvectni = sum(classmtxtni,2)*100/c;
classvectn = sum(classmtxtn,2)*100/c;
handles.classmtxiv = classmtxiv;
handles.classmtxtni = classmtxtni;
handles.classmtxtn = classmtxtn;
handles.classveciv = classveciv;
handles.classvectni = classvectni;
handles.classvectn = classvectn;
handles.r = r;
handles.w = w;
handles.pcs = pcs;
handles.idxiv = idxiv;
handles.iv = iv;
handles.pcschar = pcschar;
handles.orderediv = orderediv;
handles.primeform = primeform;
handles.idxtni = idxtni;
handles.orderedtni = orderedtni;
handles.idxtn = idxtn;
handles.orderedtn = orderedtn;
handles.classtni = classtni;
handles.reltni = reltni;
handles.reltn = reltn;
handles.iv2tni = iv2tni;
handles.iv2tn = iv2tn;
handles.tni2iv = tni2iv;
handles.tni2tn = tni2tn;
handles.tn2iv = tn2iv;
handles.tn2tni = tn2tni;
handles.classiv = classiv;
handles.classtn = classtn;
handles.card = card;
handles.output = hObject;
set(handles.ForteTextScape,'String','');
set(handles.PCTextScape,'String','');
set(handles.IVTextScape,'String','');
set(handles.TimescaleText,'String','');
guidata(hObject,handles);
VisualizeCursorSegment(hObject,handles);
VisualizeSetscape(hObject,handles);
VisualizeClassmtx(hObject,handles);
VisualizeClassvec(hObject,handles);


function VisualizeSetscape(hObject,handles)
minres = handles.minres;
pcs = handles.pcs;
rel = handles.rel;
isrel = handles.isrel;
numcolors = handles.numcolors;
[f c] = size(pcs);
im = zeros(f,c);
colormap(1-gray(numcolors));
classtype = handles.classtype;
if ~isrel
    switch classtype
        case 'iv'
            idxclass = handles.idxiv;
        case 'tni'
            idxclass = handles.idxtni;
        case 'tn'
            idxclass = handles.idxtn;
        otherwise
    end
    ivscape = idxclass(pcs+1);
    sonselx = handles.sonx;
    [x,y] = find(ivscape == sonselx);
    for i = 1:length(x)
        im(x(i),y(i)) = 1+numcolors;
    end
    axes(handles.ClassScapePlot);
    xax = linspace(minres,minres*c,c);
    yax = [];
    image(xax,yax,im);
else
    switch classtype
        case 'iv'
            idxclass = handles.idxiv;
        case 'tni'
            idxclass = handles.idxtni;
        case 'tn'
            idxclass = handles.idxtn;
        otherwise
    end
    idxtn = handles.idxtn;
    primeallowed = handles.primeallowed;
    reltn = handles.reltn;
    for i = 1:f
        for j = 1:c
            pidx = idxclass(pcs(i,j)+1);
            if find(pidx==primeallowed)
                im(i,j) = 1+round(numcolors*reltn(idxtn(pcs(i,j)+1),rel));
            end
        end
    end
    axes(handles.ClassScapePlot);
    xax = linspace(minres,minres*c,c);
    yax = [];
    image(xax,yax,im);
end
set(gca,'YDir','normal');
axis([minres minres*c minres f+minres]);
set(gca,'ytick',[],'yticklabel',{});
VisualizeSetScapeCross(hObject,handles);


function VisualizeSetScapeCross(hObject,handles)
axes(handles.ClassScapePlot);
hold on;
minres = handles.minres;
x = round(handles.scapex*minres);
y = handles.scapey;
h = plot(x,y,'r+','MarkerSize',16);
handles = draggable(h,hObject,handles,@DragSelectedFrame);
hold off;
%---
pcs = handles.pcs;
pcschar = handles.pcschar;
iv = handles.iv;
idxtni = handles.idxtn;
classtn = handles.classtn;
pcstemp = pcs(y,x)+1;
iv = iv(pcstemp,:);
if idxtni(pcstemp) ~= 0
    fortemp = classtn{idxtni(pcstemp)}(2:end-1);
    set(handles.ForteTextScape,'String',fortemp);
else
    idxtni(pcstemp)
end
set(handles.PCTextScape,'String',sprintf('%s',pcschar(pcstemp,:)));
set(handles.IVTextScape,'String',sprintf('%d %d %d %d %d %d',iv(1),iv(2),iv(3),iv(4),iv(5),iv(6)));
prime = handles.primeform;
prime = prime{pcstemp};
card = handles.card;
card = card(pcstemp);
if card
    s = num2str(prime(1));
    for i = 2:card
        s = sprintf('%s,%s',s,num2str(prime(i)));
    end
else
    s = [];
end
set(handles.PrimeTextScape,'String',s);
%---
guidata(hObject,handles);


function VisualizeClassmtx(hObject,handles)
classtype = handles.classtype;
switch classtype
    case 'iv'
        classmtx = handles.classmtxiv;
        top = 200;
    case 'tni'
        classmtx = handles.classmtxtni;
        top = 223;
    case 'tn'
        classmtx = handles.classmtxtn;
        top = 351;
    otherwise
end
numcolors = handles.numcolors;
c = size(classmtx,2);
classmtx = classmtx*numcolors/3;
sonselx = handles.sonx;
if find(classmtx(sonselx,:))
    classmtx(max(1,sonselx-1),:) = classmtx(sonselx,:)*3;
    classmtx(sonselx,:) = classmtx(sonselx,:)*3;
    classmtx(min(top,sonselx+1),:) = classmtx(sonselx,:)*3;
else
    classmtx(sonselx,:) = ones(1,c)*numcolors/2;
end
axes(handles.ClassMatrixPlot);
colormap(1-gray(numcolors));
image(classmtx);
set(gca,'ydir','normal');
set(gca,'xtick',[],'xticklabel',{});
set(gca,'ytick',[],'yticklabel',{});


function VisualizeClassvec(hObject,handles)
classtype = handles.classtype;
switch classtype
    case 'iv'
        classvec = handles.classveciv;
        axes(handles.ClassVectorPlot);
        bar(classvec,'k');
        vline([8 20 48 83 118 153 181 193 199],'b');
        axis([1 200 0 100]);
    case 'tni'
        classvec = handles.classvectni;
        axes(handles.ClassVectorPlot);
        bar(classvec,'k');
        vline([8 20 49 87 137 175 204 216 222],'b');
        axis([1 223 0 100]);
    case 'tn'
        classvec = handles.classvectn;
        axes(handles.ClassVectorPlot);
        bar(classvec,'k');
        vline([8 27 70 136 216 282 325 344 350],'b');
        axis([1 351 0 100]);
    otherwise
end
set(gca,'xtick',[],'xticklabel',{});
set(gca,'ytick',[],'yticklabel',{});
VisualizeClassvecCross(hObject,handles);


function VisualizeClassvecCross(hObject,handles)
axes(handles.ClassVectorPlot);
hold on;
x = handles.sonx;
y = handles.sony;
h = plot(x,y,'r+','MarkerSize',16);
handles = draggable(h,hObject,handles,@DragSelectedSon,'endfcn',@DragSelectedSonEnd);
hold off;
%---
classtype = getClasstype(handles);
iv = handles.orderediv;
orderedtn = handles.orderedtn;
switch classtype
    case 'iv'
        iv = iv(x,:);
        classiv = handles.classiv;
        fortemp = classiv{x}(2:end-1);
        iv2tn = handles.iv2tn;
        prime = orderedtn(iv2tn(x),:);
    case 'tni'
        tni2iv = handles.tni2iv;
        iv = iv(tni2iv(x),:);
        classtni = handles.classtni;
        fortemp = classtni{x}(2:end-1);
        tni2tn = handles.tni2tn;
        prime = orderedtn(tni2tn(x),:);
    case 'tn'
        tn2iv = handles.tn2iv;
        iv = iv(tn2iv(x),:);
        classtn = handles.classtn;
        fortemp = classtn{x}(2:end-1);
        prime = orderedtn(x,:);
    otherwise
end
set(handles.IVText,'String',sprintf('%d %d %d %d %d %d',iv(1),iv(2),iv(3),iv(4),iv(5),iv(6)));
set(handles.ForteText,'String',fortemp);
card = length(unique(prime));
if card
    s = num2str(prime(1));
    for i = 2:card
        s = sprintf('%s,%s',s,num2str(prime(i)));
    end
else
    s = [];
end
set(handles.PrimeTextClass,'String',s);
%---
guidata(hObject,handles);


function VisualizePianoRoll(handles)
axes(handles.PianoRollPlot);
cla;
if ~isempty(handles.nmat)
    nmat = handles.nmat;
    pianoroll(nmat);
end


function VisualizeCursorSegment(hObject,handles)
x = handles.scapex;
y = handles.scapey;
w = handles.w;
totaldur = handles.totaldur;
axes(handles.CursorSegmentPlot);
cla;
if w(y,x,2)-w(y,x,1) ~= 0
    fill([w(y,x,1) w(y,x,2) w(y,x,2) w(y,x,1)],[0 0 1 1],[0.5 0.5 0.5]);
end
axis([0 totaldur 0 1]); axis off;
handles.sonx = getappdata(0,'sonselx');
handles.sony = getappdata(0,'sonsely');
guidata(hObject,handles);


function MinRes_Callback(hObject,eventdata,handles)
handles.minres = str2double(get(hObject,'String'));
guidata(hObject,handles);


function MinRes_CreateFcn(hObject,eventdata,handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function NumScales_Callback(hObject,eventdata,handles)
handles.nscales = str2double(get(hObject,'String'));
guidata(hObject,handles);


function NumScales_CreateFcn(hObject,eventdata,handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function RELToggle_Callback(hObject,eventdata,handles)
handles.isrel = get(hObject,'Value');
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function PlayClipButton_Callback(hObject,eventdata,handles)
w = handles.w;
nmat = handles.nmat;
x = handles.scapex;
y = handles.scapey;
nmclip = midiWindow(nmat,w(y,x,1),w(y,x,2));
bpm = handles.bpm;
minsec = min(nmclip(:,1));
minbeat = min(nmclip(:,6));
nmclip(:,1) = nmclip(:,1) - minsec;
nmclip(:,6) = nmclip(:,6) - minbeat;
playmidi(nmclip,bpm);


function CardToggle12_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,12) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);

function CardToggle11_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,11) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);

function CardToggle10_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,10) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle9_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,9) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle8_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,8) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle7_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,7) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle6_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,6) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle5_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,5) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle4_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,4) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle3_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,3) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle2_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,2) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggle1_Callback(hObject,eventdata,handles)
card = handles.cardinality;
cardtmp = get(hObject,'Value');
card(1,1) = cardtmp;
if cardtmp == 0
    set(handles.CardToggleAll,'Value',0);
end
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function CardToggleAll_Callback(hObject,eventdata,handles)
cardtmp = get(hObject,'Value');
card(1,1:12) = cardtmp;
set(handles.CardToggle1,'Value',cardtmp);
set(handles.CardToggle2,'Value',cardtmp);
set(handles.CardToggle3,'Value',cardtmp);
set(handles.CardToggle4,'Value',cardtmp);
set(handles.CardToggle5,'Value',cardtmp);
set(handles.CardToggle6,'Value',cardtmp);
set(handles.CardToggle7,'Value',cardtmp);
set(handles.CardToggle8,'Value',cardtmp);
set(handles.CardToggle9,'Value',cardtmp);
set(handles.CardToggle10,'Value',cardtmp);
set(handles.CardToggle11,'Value',cardtmp);
set(handles.CardToggle12,'Value',cardtmp);
idxtni = handles.idxtni;
classtype = handles.classtype;
primeallowed = computePrimeAllowed(card,classtype);
handles.cardinality = card;
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);


function cardinality = getCardinality(handles)
cardinality(1,1) = get(handles.CardToggle1,'Value');
cardinality(1,2) = get(handles.CardToggle2,'Value');
cardinality(1,3) = get(handles.CardToggle3,'Value');
cardinality(1,4) = get(handles.CardToggle4,'Value');
cardinality(1,5) = get(handles.CardToggle5,'Value');
cardinality(1,6) = get(handles.CardToggle6,'Value');
cardinality(1,7) = get(handles.CardToggle7,'Value');
cardinality(1,8) = get(handles.CardToggle8,'Value');
cardinality(1,9) = get(handles.CardToggle9,'Value');
cardinality(1,10) = get(handles.CardToggle10,'Value');
cardinality(1,11) = get(handles.CardToggle11,'Value');
cardinality(1,12) = get(handles.CardToggle12,'Value');


function primeallowed = computePrimeAllowed(card,classtype)
switch classtype
    case 'iv'
        top = [1 7 19 47 82 117 152 180 192 198 199 200];
    case 'tni'
        top = [1 7 19 48 86 136 174 203 215 221 222 223];
    case 'tn'
        top = [1 7 26 69 135 215 281 324 343 349 350 351];
    otherwise
end
primeallowed = [];
if card(1,1)
    primeallowed = [1];
end
for i = 2:12
    if card(1,i)
        primeallowed = [primeallowed top(i-1)+1:top(i)];
    end
end


function ClassIVToggle_Callback(hObject,eventdata,handles)
tmp = get(hObject,'Value');
if tmp == 0
    set(handles.ClassIVToggle,'Value',1);
end
classtype = handles.classtype;
sonx = handles.sonx;
switch classtype
    case 'tni'
        tni2iv = handles.tni2iv;
        sonx = tni2iv(sonx);
    case 'tn'
        tn2iv = handles.tn2iv;
        sonx = tn2iv(sonx);
    otherwise
end
classtype = 'iv';
set(handles.ClassTnIToggle,'Value',0);
set(handles.ClassTnToggle,'Value',0);
handles.classtype = classtype;
handles.sonx = sonx;
setappdata(0,'sonselx',sonx);
card = getCardinality(handles);
primeallowed = computePrimeAllowed(card,classtype);
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeClassvec(hObject,handles);
VisualizeSetscape(hObject,handles);
VisualizeClassmtx(hObject,handles);


function ClassTnIToggle_Callback(hObject,eventdata,handles)
tmp = get(hObject,'Value');
if tmp == 0
    set(handles.ClassTnIToggle,'Value',1);
end
classtype = handles.classtype;
sonx = handles.sonx;
switch classtype
    case 'iv'
        iv2tni = handles.iv2tni;
        sonx = iv2tni(sonx);
    case 'tn'
        tn2tni = handles.tn2tni;
        sonx = tn2tni(sonx);
    otherwise
end
classtype = 'tni';
set(handles.ClassIVToggle,'Value',0);
set(handles.ClassTnToggle,'Value',0);
handles.classtype = classtype;
handles.sonx = sonx;
setappdata(0,'sonselx',sonx);
card = getCardinality(handles);
primeallowed = computePrimeAllowed(card,classtype);
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeClassvec(hObject,handles);
VisualizeSetscape(hObject,handles);
VisualizeClassmtx(hObject,handles);


function ClassTnToggle_Callback(hObject,eventdata,handles)
tmp = get(hObject,'Value');
if tmp == 0
    set(handles.ClassTnToggle,'Value',1);
end
classtype = handles.classtype;
sonx = handles.sonx;
switch classtype
    case 'iv'
        iv2tn = handles.iv2tn;
        sonx = iv2tn(sonx);
    case 'tni'
        tni2tn = handles.tni2tn;
        sonx = tni2tn(sonx);
    otherwise
end
classtype = 'tn';
set(handles.ClassIVToggle,'Value',0);
set(handles.ClassTnIToggle,'Value',0);
handles.classtype = classtype;
handles.sonx = sonx;
setappdata(0,'sonselx',sonx);
card = getCardinality(handles);
primeallowed = computePrimeAllowed(card,classtype);
handles.primeallowed = primeallowed;
guidata(hObject,handles);
VisualizeClassvec(hObject,handles);
VisualizeSetscape(hObject,handles);
VisualizeClassmtx(hObject,handles);


function classtype = getClasstype(handles)
if get(handles.ClassIVToggle,'Value'),classtype = 'iv'; end
if get(handles.ClassTnIToggle,'Value'),classtype = 'tni'; end
if get(handles.ClassTnToggle,'Value'),classtype = 'tn'; end


function DragSelectedSon(h,hObject,handles)
hObject = getappdata(h,'hObject');
handles = getappdata(h,'handles');
hx = get(h,'XData');
hy = get(h,'YData');
x = round(hx);
y = round(hy);
sonselx = x;
classtype = getClasstype(handles);
iv = handles.orderediv;
orderedtn = handles.orderedtn;
switch classtype
    case 'iv'
        iv = iv(sonselx,:);
        classiv = handles.classiv;
        fortemp = classiv{sonselx}(2:end-1);
        iv2tn = handles.iv2tn;
        handles.rel = iv2tn(sonselx);
        prime = orderedtn(iv2tn(sonselx),:);
    case 'tni'
        tni2iv = handles.tni2iv;
        iv = iv(tni2iv(sonselx),:);
        classtni = handles.classtni;
        fortemp = classtni{sonselx}(2:end-1);
        tni2tn = handles.tni2tn;
        handles.rel = tni2tn(sonselx);
        prime = orderedtn(tni2tn(sonselx),:);
    case 'tn'
        tn2iv = handles.tn2iv;
        iv = iv(tn2iv(sonselx),:);
        classtn = handles.classtn;
        fortemp = classtn{sonselx}(2:end-1);
        handles.rel = sonselx;
        prime = orderedtn(sonselx,:);
    otherwise
end
set(handles.IVText,'String',sprintf('%d %d %d %d %d %d',iv(1),iv(2),iv(3),iv(4),iv(5),iv(6)));
set(handles.ForteText,'String',fortemp);
set(handles.RELText,'STring',sprintf('REL(%s,*)',fortemp));
card = length(unique(prime));
if card
    s = num2str(prime(1));
    for i = 2:card
        s = sprintf('%s,%s',s,num2str(prime(i)));
    end
else
    s = [];
end
set(handles.PrimeTextClass,'String',s);
handles.isrel = get(handles.RELToggle,'Value');
handles.scapex = getappdata(0,'pcsx');
handles.scapey = getappdata(0,'pcsy');
card = getCardinality(handles);
primeallowed = computePrimeAllowed(card,classtype);
handles.primeallowed = primeallowed;
handles.cardinality = card;
handles.classtype = classtype;
handles.sonx = x;
handles.sony = y;
setappdata(0,'sonselx',x);
setappdata(0,'sonsely',y);
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);
VisualizeClassmtx(hObject,handles);
axes(get(h,'Parent'));


function DragSelectedSonEnd(h,hObject,handles)
hObject = getappdata(h,'hObject');
handles = getappdata(h,'handles');
hx = get(h,'XData');
hy = get(h,'YData');
x = round(hx);
y = round(hy);
sonselx = x;
iv = handles.orderediv;
classtype = getClasstype(handles);
iv = handles.orderediv;
orderedtn = handles.orderedtn;
switch classtype
    case 'iv'
        iv = iv(sonselx,:);
        classiv = handles.classiv;
        fortemp = classiv{sonselx}(2:end-1);
        iv2tn = handles.iv2tn;
        handles.rel = iv2tn(sonselx);
        prime = orderedtn(iv2tn(sonselx),:);
    case 'tni'
        tni2iv = handles.tni2iv;
        iv = iv(tni2iv(sonselx),:);
        classtni = handles.classtni;
        fortemp = classtni{sonselx}(2:end-1);
        tni2tn = handles.tni2tn;
        handles.rel = tni2tn(sonselx);
        prime = orderedtn(tni2tn(sonselx),:);
    case 'tn'
        tn2iv = handles.tn2iv;
        iv = iv(tn2iv(sonselx),:);
        classtn = handles.classtn;
        fortemp = classtn{sonselx}(2:end-1);
        handles.rel = sonselx;
        prime = orderedtn(sonselx,:);
    otherwise
end
set(handles.IVText,'String',sprintf('%d %d %d %d %d %d',iv(1),iv(2),iv(3),iv(4),iv(5),iv(6)));
set(handles.ForteText,'String',fortemp);
set(handles.RELText,'String',sprintf('REL(%s,*)',fortemp));
card = length(unique(prime));
if card
    s = num2str(prime(1));
    for i = 2:card
        s = sprintf('%s,%s',s,num2str(prime(i)));
    end
else
    s = [];
end
set(handles.PrimeTextClass,'String',s);
handles.isrel = get(handles.RELToggle,'Value');
handles.scapex = getappdata(0,'pcsx');
handles.scapey = getappdata(0,'pcsy');
card = getCardinality(handles);
primeallowed = computePrimeAllowed(card,classtype);
handles.primeallowed = primeallowed;
handles.cardinality = card;
handles.classtype = classtype;
handles.sonx = x;
handles.sony = y;
setappdata(0,'sonselx',x);
setappdata(0,'sonsely',y);
guidata(hObject,handles);
VisualizeSetscape(hObject,handles);
VisualizeClassmtx(hObject,handles);


function DragSelectedFrame(h,hObject,handles)
hObject = getappdata(h,'hObject');
handles = getappdata(h,'handles');
minres = handles.minres;
pcs = handles.pcs;
[f,c] = size(pcs);
pcschar = handles.pcschar;
iv = handles.iv;
idxtni = handles.idxtn;
classtn = handles.classtn;
hx = get(h,'XData');
hy = get(h,'YData');
x = round(hx/minres);
y = round(hy);
if x < 1, x = 1; end
if x > c, x = c; end
if y < 1, y = 1; end
if y > f, y = f; end
pcstemp = pcs(y,x)+1;
iv = iv(pcstemp,:);
if idxtni(pcstemp) ~= 0
    fortemp = classtn{idxtni(pcstemp)}(2:end-1);
    set(handles.ForteTextScape,'String',fortemp);
else
    idxtni(pcstemp)
end
set(handles.PCTextScape,'String',sprintf('%s',pcschar(pcstemp,:)));
set(handles.IVTextScape,'String',sprintf('%d %d %d %d %d %d',iv(1),iv(2),iv(3),iv(4),iv(5),iv(6)));
prime = handles.primeform;
prime = prime{pcstemp};
card = handles.card;
card = card(pcstemp);
if card
    s = num2str(prime(1));
    for i = 2:card
        s = sprintf('%s,%s',s,num2str(prime(i)));
    end
else
    s = [];
end
set(handles.PrimeTextScape,'String',s);
handles.scapex = x;
handles.scapey = y;
setappdata(0,'pcsx',x);
setappdata(0,'pcsy',y);
r = handles.r;
handles.isrel = get(handles.RELToggle,'Value');
handles.classtype = getClasstype(handles);
handles.sonx = getappdata(0,'sonselx');
handles.sony = getappdata(0,'sonsely');
guidata(hObject,handles);
VisualizeCursorSegment(hObject,handles);
set(handles.TimescaleText,'String',sprintf('Timescale: %3.1f sec.',r(y,1)));
axes(get(h,'Parent'));


% -----------------
% -----------------
% from MSMF toolbox
% -----------------
% -----------------


function dur = midiLength(nmat)
dur = max(nmat(:,6)+nmat(:,7))-min(nmat(:,6));


function r = swPolicyMidi(nmat,minres,logbase)
dur = midiLength(nmat);
ws = minres;
rc = 1;
r(rc,1) = ws;
r(rc,2) = minres;
ws = minres * 3;
while ws <= dur
    rc = rc+1;
    r(rc,1) = ws;
    r(rc,2) = minres;
    ws = ((ws-minres)*logbase)+minres;
end   


function w = msSlidingWindowMidi(nmat,r)
wtemp = slidingWindowMidi(nmat,1,r(1,1));
w = zeros(size(r,1),size(wtemp,1),2);
for i = 1:size(r,1)
    w(i,:,:) = slidingWindowMidi(nmat,r(i,1),r(i,2));
end


function w = slidingWindowMidi(nmat,ws,hs)
dur = midiLength(nmat);
zps = (ws-hs)/2;
pin = 0;
pend = dur;
wf = 1;
while pin < pend
    [maxi,imaxi] = max([pin-zps 0]);
    [mini,imini] = min([pin+hs+zps dur]);
    if (imaxi == 2 || imini == 2)
        w(wf,1:2) = [0 0];
    else
        w(wf,1:2) = [(pin-zps) (pin+hs+zps)];
    end
    wf = wf+1;
    pin = pin+hs;
end


function pcs = msPitchClassSet(nmat,w)
f = size(w,1);
c = size(w,2);
pcs = zeros(f,c);
for i = 1:f
    for j = 1:c
        if w(i,j,1) && w(i,j,2) == 0
            pcs(i,j) = 0;
        else
            nm = midiWindow(nmat,w(i,j,1),w(i,j,2));
            pcs(i,j) = bin2dec(num2str(midiPCdist(nm)>0));
        end
    end
end


function nm = midiWindow(nmat,mintime,maxtime)
if isempty(nmat), return; end
off_sec = nmat(:,6)+nmat(:,7);
if mintime == maxtime, nm = []; return; end
nm = nmat((mintime<=nmat(:,6) & nmat(:,6)<=maxtime) | (mintime<=off_sec & off_sec<=maxtime) | (mintime>nmat(:,6) & maxtime<off_sec),:);
on_beat = nm(:,1);
off_beat = nm(:,1)+nm(:,2);
on_sec = nm(:,6);
off_sec = nm(:,6)+nm(:,7);
bpm = gettempo(nmat);
nm(:,6) = max(mintime,nm(:,6));
nm(:,7) = min(off_sec-nm(:,6),maxtime-nm(:,6));
nm(:,1:2) = [bpm*nm(:,6)/60 bpm*nm(:,7)/60];
nm = nm(0<nm(:,2),:);


function pcd = midiPCdist(nmat)
if isempty(nmat), pcd = [0 0 0 0 0 0 0 0 0 0 0 0]; return; end
pc = mod(nmat(:,4),12)+1;
du = dur(nmat,'sec');
pcd = zeros(1,12);
for k=1:length(pc)
	pcd(pc(k)) = pcd(pc(k))+du(k);
end
pcd = pcd/sum(pcd+1e-12); 
