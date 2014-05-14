function allatmemb = clacallatmemb()

	primeor = dlmread('protoprimeOrdered.txt');

	allatmemb = [];
	for i = 1:351
		x = unique(primeor(i,:));
		for j = i:351
			y = unique(primeor(j,:));
			allatmemb(i,j) = ATMEMB(x,y);
		end
	end

