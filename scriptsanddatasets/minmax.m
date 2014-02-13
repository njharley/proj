function mm = minmax(n,nn)

	primeor = dlmread('protoprimeOrdered.txt');
	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	ivs = [];
	for i = (top(n-1)+1):top(n)
		a = unique(primeor(i,:));
		ivs(end+1,:) = ncv(a,nn);
	end

	mm = [];
	for i = 1:size(ivs, 2)
		mm(1,i) = max(ivs(:,i));
		mm(2,i) = min(ivs(:,i));
	end

