%%% REL CALCULATED THE WAY KUUSI DOES IT
%%% decrease 

function rel = RELc(primex, primey)

	load allemb
	subx = [allemb(primex,2:7) allemb(primex,:)];
	suby = [allemb(primey,2:7) allemb(primey,:)];

	num = sum(sqrt(subx.*suby));
	denom = sqrt(sum(subx)*sum(suby));
	rel = num/denom;



function getRELc(primex, primey)

	cardx = size(primex,2);
	cardy = size(primey,2);

	nmax = min(cardx,cardy);

	if nmax == 1
		nmax = 2
	end

	primeor = dlmread('protoprimeOrdered.txt');
	top = [1 7 26 69 135 215 281 324 343 349 350 351];
	A = primeor(1:top(nmax),:);
	
	num = 0;
	subx = [];
	suby = [];

	for i = 2:top(nmax)
		a = unique(A(i,:));
		subx(end+1) = EMB(a,primex);
		suby(end+1) = EMB(a,primey);
		num = num + sqrt(subx(end)*suby(end));
	end

	rel = num / sqrt(sum(subx)*sum(suby));