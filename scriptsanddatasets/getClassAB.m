function pcSetClassAB = getClassAB(forteNameAB)

	forteNamesAB = textread('forteNamesAB.txt', '%s');
	x = -1;
	for i = 1:length(forteNamesAB)
		if strcmp(forteNamesAB(i), forteNameAB)
			x = i;
		end
	end
	if x==-1
		error('Incorrect Forte Name'); return
	end
	
	primeor = dlmread('protoprimeOrdered.txt');
	pcSetClassAB = unique(primeor(x,:));