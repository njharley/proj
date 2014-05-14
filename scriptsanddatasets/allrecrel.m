function allrecrel = allrecrel()

	primeor = dlmread('protoprimeOrdered.txt');
	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	allrecrel = [];
	for i = 1:215
		sprintf('Set Class %d', i)
		for j = i:215
			sprintf('with %d', j)
			allrecrel(i,j) = RECREL2(i,j);
		end
	end
	save allrecrel.mat allrecrel

