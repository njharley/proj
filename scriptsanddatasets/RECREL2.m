function rr = RECREL2(x,y)

	cardx = getCard(x)
	cardy = getCard(y)

	%% get nmax
	if cardx == cardy
		nmax = cardx-1;
	else
		nmax = min(cardx, cardy);
	end
	if nmax == 1
		nmax = 2;
	end

	nmax
	%% calculate the value for each branch
	branchValues = [];
	for n = 2:nmax
		disp('branch')
		disp(n)
		branchValues(end+1) = Branch(x,y,n,100);
	end

	%% take the mean of the branch values
	rr = round(mean(branchValues));

function value = Branch(x,y,n,weight)

	top = [1 7 26 69 135 215 281 324 343 349 350 351];
	bottom = [1 2 8 27 70 136 216 282 324 344 350 351];
	load cpvs.mat %% load all nC%Vs

	ncpvX = nCpVs{n}(x,:);
	ncpvY = nCpVs{n}(y,:);

	dv = getDV(ncpvX,ncpvY);
	wDV = getWDV(dv)
	reln = (sum(dv(1,:)+dv(2,:))/2)*weight/100;
	if n < 3
		value = reln;
	else
		subGroup = getSubGroup(wDV, n);
		value = reln*(getSubValues(wDV, n, top, subGroup));
	end
	value

function value = getSubValues(wDV, n, top, subGroup)
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
	top = [1 7 26 69 135 215 281 324 343 349 350 351];
	top(end+1) = x;
	top = sort(top);
	card = find(top==x);