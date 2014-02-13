function rel = REL(primex, primey)

	cardx = size(primex,2);
	cardy = size(primey,2);

	nmax = min(cardx,cardy);

	primeor = dlmread('protoprimeOrdered.txt');
	top = [1 7 26 69 135 215 281 324 343 349 350 351];
	A = primeor(1:top(nmax),:);
	
	num = [];
	subx = [];
	suby = [];

	for i = 2:top(nmax)
		a = unique(A(i,:));
		subx(end+1) = emb(a,primex);
		suby(end+1) = emb(a,primey);
		num(end+1) = sqrt(emb(a,primex)*emb(a,primey));
	end

	total_x = sum(subx);
	total_y = sum(suby);

	denom = sqrt(total_x*total_y);

	rel = sum(num)/denom;
