

threeNoteChords = 0:3;
threeNoteChords = dec2bin(threeNoteChords);
threeNoteChords = threeNoteChords-48;

chords = {[]};
for i = 1:size(threeNoteChords,1)
	ch = [];
	ch(end+1) = 0;
	for j= 1:size(threeNoteChords,2)
		if threeNoteChords(i,j) == 0
			interval = 3;
		else
			interval = 4;
		end
		ch(end+1) = ch(end)+interval;
	end
	chords{i} = ch;
end

fourNoteChords = 0:7;
fourNoteChords = dec2bin(fourNoteChords);
fourNoteChords = fourNoteChords-48;

for i = 1:size(fourNoteChords,1)
	ch = [];
	ch(end+1) = 0;
	for j= 1:size(fourNoteChords,2)
		if fourNoteChords(i,j) == 0
			interval = 3;
		else
			interval = 4;
		end
		ch(end+1) = ch(end)+interval;
	end
	chords{end+1} = ch;
end

fiveNoteChords = 0:15;
fiveNoteChords = dec2bin(fiveNoteChords);
fiveNoteChords = fiveNoteChords-48;

for i = 1:size(fiveNoteChords,1)
	ch = [];
	ch(end+1) = 0;
	for j= 1:size(fiveNoteChords,2)
		if fiveNoteChords(i,j) == 0
			interval = 3;
		else
			interval = 4;
		end
		ch(end+1) = ch(end)+interval;
	end
	chords{end+1} = ch;
end

sixNoteChords = 0:31;
sixNoteChords = dec2bin(sixNoteChords);
sixNoteChords = sixNoteChords-48;

for i = 1:size(sixNoteChords,1)
	ch = [];
	ch(end+1) = 0;
	for j= 1:size(sixNoteChords,2)
		if sixNoteChords(i,j) == 0
			interval = 3;
		else
			interval = 4;
		end
		ch(end+1) = ch(end)+interval;
	end
	chords{end+1} = ch;
end

sevenNoteChords = 0:63;
sevenNoteChords = dec2bin(sevenNoteChords);
sevenNoteChords = sevenNoteChords-48;

for i = 1:size(sevenNoteChords,1)
	ch = [];
	ch(end+1) = 0;
	for j= 1:size(sevenNoteChords,2)
		if sevenNoteChords(i,j) == 0
			interval = 3;
		else
			interval = 4;
		end
		ch(end+1) = ch(end)+interval;
	end
	chords{end+1} = ch;
end
load pcsetdata

for i = 1:length(chords)
	ch = chords{i};
	cardinality(i) = length(ch);
	pcset = sort(unique(mod(ch,12)));
	b = zeros(1,12);
	b(pcset+1) = 1;
	b = fliplr(b);
	idx = idxtn(bi2de(b)+1);
	tnIdx(i) = idx;
	tnSC{i} = unique(orderedtn(idx,:));
	scName{i} = classtn{idx};
end	

for i = 1:length(chords)
	ch = chords{i};
	labels = {};
	for j = 1:length(ch)
		switch ch(j)
		case 0
			l = 'Root';
		case 1
			l = 'm2';
		case 2
			l = 'M2';
		case 3
			l = 'm3';
		case 4
			l = 'M3';
		case 5
			l = '4';
		case 6
			l = 'b5';
		case 7
			l = '5';
		case 8
			l = 'aug5';
		case 9
			l = '6';
		case 10
			l = 'b7';
		case 11
			l = '7';
		case 12
			l = 'oct1';
		case 13
			l = 'b9';
		case 14
			l = '9';
		case 15
			l = '#9';
		case 16
			l = 'b11';
		case 17
			l = '11';
		case 18
			l = '#11';
		case 19
			l = '12';
		case 20
			l = 'b13';
		case 21
			l = '13';
		case 22
			l = 'm14';
		case 23
			l = 'M14';
		case 24
			l = 'oct2';
		end
		labels{j} = l;
	end
	chord_labels{i} = labels;
end
