function openFiles()


	book = 'i';
	number = '01-C';
	prelude_or_fugue = 'a';

	filename = ['wtc_midi/Wtc' book '-' number '-' prelude_or_fugue '.mid']

	nmat = readmidi(filename);
	qnmat = quantize(nmat, 1/32, 1/32, 1/32);
	pds = movewindow(qnmat,win,hop,'beat','pcdist1');