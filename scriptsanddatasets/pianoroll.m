function pianoroll(nmat,varargin)

if isempty(nmat), return; end

nameformat='name';
timeformat='beats';
color='k';
velformat=[];
status=[];

% IF MULTIPLE CHANNELS
m=mchannels(nmat);
if length(m)>1
	for i=1:length(m),
		n=getmidich(nmat,m(i));
		p=pitch(n);
		proll(n,nameformat,timeformat,velformat,[0 0 0],'hold');
	end
else
		proll(nmat,nameformat,timeformat,velformat,color,status);
end

p=pitch(nmat);
on=onset(nmat,'sec');
off=on+dur(nmat,'sec');
totaldur=max(onset(nmat,'sec')+dur(nmat,'sec'));
box on;
%axis([0 totaldur min(p)-0.5 max(p)+0.5]);
axis([0 totaldur min(p)-0.5 max(p)+5]);
hold off;

%------------------------------

function proll(nmat,nameformat,timeformat,velformat,color,status)

on=onset(nmat,'sec');
off=on+dur(nmat,'sec');
totaldur=max(onset(nmat,'sec')+dur(nmat,'sec'));

p=pitch(nmat);
minimi = min(pitch(nmat));
maksimi = max(pitch(nmat));
			
hold on;
for k=1:length(on)
   h=fill([on(k) off(k) off(k) on(k)],[p(k)-0.5 p(k)-0.5 p(k)+0.5 p(k)+0.5 ],color);
end

%%%% AXIS
range = maksimi-minimi;
if range < 12; interval = 1;
	elseif range < 24;	interval = 2;
	elseif range < 36;	interval = 3;
	elseif range > 35;	interval = 5;
end


