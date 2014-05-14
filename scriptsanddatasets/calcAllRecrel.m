function allrecrel = calcAllRecrel()
	
	global top
	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	global nCpVs
	load cpvs.mat %% load all nC%Vs
	
	global branches;
	branches = zeros(351,351,12,2);

	allrecrel = [];
	tic
	for i = 2:351
		disp(i)
		for j = i:351
			allrecrel(i,j) = getRecrelValue(i,j);
		end
	end
	toc
	save allrecrel.mat allrecrel

function rr = getRecrelValue(x,y)

	global branches

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

	%% calculate the value for each branch
	branchValues = [];
	for n = 2:nmax
		branchValues(end+1) = Branch(x,y,n,100);
	end

	%% take the mean of the branch values
	rr = round(mean(branchValues));

function value = Branch(x,y,n,weight)

	global branches

	if branches(x,y,n,1) == 1
		b = branches(x,y,n,2);
		value = b*weight/100;
		%disp('val found')
		return;
	end

	if branches(y,x,n,1) == 1
		b = branches(y,x,n,2);
		value = b*weight/100;
		%disp('value found')
		return;
	end

	global top
	global nCpVs

	ncpvX = nCpVs{n}(x,:);
	ncpvY = nCpVs{n}(y,:);

	dv = getDV(ncpvX,ncpvY);
	wDV = getWDV(dv);
	reln = (sum(dv(1,:)+dv(2,:))/2);
	if n < 3
		b = reln;
	else
		subGroup = getSubGroup(wDV, n);
		b = reln*(getSubValues(wDV, n, subGroup));
	end
	value = b*weight/100;
	branches(x,y,n,1) = 1;
	branches(y,x,n,1) = 1;
	branches(x,y,n,2) = b;
	branches(y,x,n,2) = b;

function value = getSubValues(wDV, n, subGroup)
	global top

	wghts = (wDV(1,subGroup(:,1)).*wDV(2,subGroup(:,2)))/100;

	subValues = [];
	for i = 1:length(wghts)
		subValues(end+1) = Branch(subGroup(i,1)+top(n-1),subGroup(i,2)+top(n-1), n-1, wghts(i));
	end
	
	value = sum(subValues)/100;

function subGroup = getSubGroup(wDV, n)
	x = find(wDV(1,:));
	y = find(wDV(2,:));
	subGroup = [];
	for i = 1:length(y)
		for j = 1:length(x)
			subGroup(end+1,:) = [x(j) y(i)];
		end
	end

function wDV = getWDV(dv)
	wDV(1,:) = dv(1,:)*(100/sum(dv(1,:)));
	wDV(2,:) = dv(2,:)*(100/sum(dv(2,:)));

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