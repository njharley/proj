function sections = hum1script()

global orderedtn;
load pcsetdata
load TotalMeasuresPrime
primeor = dlmread('protoprimeOrdered.txt');

comparison_sets_idx = [24 25 116 176 276]

nmat = readmidi('hum1.mid'); 				% load file

qnmat = quantize(nmat, 1/32, 1/32, 1/32);

sections = segment(qnmat);


function sections = segment(qnmat)

points = [0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 272 288 304 334];
sections_names = {'A';'A';'B';'B';'A';'A';'C';'D';'C';'D';'A';'A';'C*';'D*';'C*';'D*';'A';'A';'E';'F';};
sections = struct([]);
for i = 2:size(points,2)
	sections(i-1).name = sections_names(i-1);
	sections(i-1).nmat = midiWindow(qnmat,points(i-1),points(i)-1,'beat');
	sections(i-1).pcdist = pcdist1(sections(i-1).nmat);
	sections(i-1).pcset = find(sections(i-1).pcdist)-1;
	sections(i-1).primePC = primeForm(sections(i-1).pcset);
	sections(i-1).scsA = {};
	pds = movewindow(sections(i-1).nmat,1,0.5,'beat','pcdist1');
	for j = 1:size(pds,1)
		pcs = find(pds(j,:))-1;
		primePC = primeFormAB(pcs);
		sections(i-1).scsA{j} = primePC;
		sections(i-1).scsiA(j) = getscidxs(primePC);
	end
	sections(i-1).scsB = {};
	pds = movewindow(sections(i-1).nmat,2,0.5,'beat','pcdist1');
	for j = 1:size(pds,1)
		pcs = find(pds(j,:))-1;
		primePC = primeFormAB(pcs);
		sections(i-1).scsB{j} = primePC;
		sections(i-1).scsiB(j) = getscidxs(primePC);

	end
	sections(i-1).scsC = {};
	pds = movewindow(sections(i-1).nmat,4,0.5,'beat','pcdist1');
	for j = 1:size(pds,1)
		pcs = find(pds(j,:))-1;
		primePC = primeFormAB(pcs);
		sections(i-1).scsC{j} = primePC;
		sections(i-1).scsiC(j) = getscidxs(primePC);
	end
end


function scidx = getscidxs(primePC)
	global orderedtn
	for i = 1:size(orderedtn,1)
		x = unique(orderedtn(i,:));
		if isequal(primePC,x)
			scidx = i;
			break;
		end
	end