function allemb = getallemb()

	primeor = dlmread('protoprimeOrdered.txt');
	allemb = [];
	for i = 1:size(primeor,1)
		x = unique(primeor(i,:));
		for j = 1:size(primeor,1)
			y = unique(primeor(j,:));
			allemb(i,j) = EMB(y,x);
		end
	end
	save allemb.mat allemb
	