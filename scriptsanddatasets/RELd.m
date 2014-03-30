%%% THE SAME AS relb BUT USING emb AND NCV (the way agustin did it)

function rel = RELd(primex, primey)

	cardx = size(primex,2);
	cardy = size(primey,2);

	nmax = min(cardx,cardy);

	primeor = dlmread('protoprimeOrdered.txt');
	top = [1 7 26 69 135 215 281 324 343 349 350 351];
	A = primeor(1:top(nmax),:);
	
	subx = [];
	suby = [];

	subx(1:6) = nCV(primex,2);
	suby(1:6) = nCV(primey,2);

	for i = 1:top(nmax)
		a = unique(A(i,:));
		subx(end+1) = EMB(a,primex);
		suby(end+1) = EMB(a,primey);
	end

	num = 0;
	top = max(find(subx>0,1,'last'),find(suby>0,1,'last'));
	for i = 1:top
    	num = num + sqrt(subx(i)*suby(i));
	end

	rel = num / sqrt(sum(subx)*sum(suby));