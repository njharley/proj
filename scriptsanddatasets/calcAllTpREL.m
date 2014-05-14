function alltprel = calcAllTpREL()

	global nCpVs
	load cpvs.mat

	global top
	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	for i = 1:351
		for j = i:351
			alltprel(i,j) = calcTpREL(i,j);
		end
	end

	%calcTpREL(70,100)

function tprel = calcTpREL(x,y)

	cardx = getCard(x);
	cardy = getCard(y);

	%% get nmax
	if cardx == cardy
		nmax = cardx-1;
	else
		nmax = min(cardx, cardy);
	end
	if nmax == 1
		nmax = 2;
	end

	values = [];
	for n = 2:nmax
		values(end+1) = calcRELn(x,y,n);
	end

	tprel = round(mean(values));

function reln = calcRELn(x,y,n)

	global nCpVs

	ncpvX = nCpVs{n}(x,:);
	ncpvY = nCpVs{n}(y,:);

	dv = getDV(ncpvX,ncpvY);
	reln = (sum(dv(1,:)+dv(2,:))/2);

function dv = getDV(x, y)
	dv(1,:) = x-y;
	dv(2,:) = y-x;
	dv(find(dv<0))=0;

function card = getCard(x)
	%% calculate cardinalities
	global top;
	z = top;
	z(end+1) = x;
	z = sort(z);
	card = find(z==x);