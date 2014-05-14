function allsatsim = calcallsatsim()

	load allsatv
	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	allsatsim = [];
	alltsatsim = [];
	allavgstsm = [];
	for x = 1:351
		cx = top;
		cx(end+1) = x;
		cx = sort(cx);
		cardx = find(cx==x);		

		for y = x:351
			cy = top;
			cy(end+1) = y;
			cy = sort(cy);
			cardy = find(cy==y);

			nmax = min(cardx(1),cardy(1))-1;

			if nmax == 1
				nmax = 2;
			end
			if nmax == 0
				nmax == 2;
			end

			satsimn = [];
			num = [];
			denom = [];
			for n = 2:nmax
				satvXn = allsatv(x,top(n-1):top(n)-1,:);
				satvYn = allsatv(y,top(n-1):top(n)-1,:);
				row = Row(satvXn,satvYn);
				[nu de] = STSM(satvXn,satvYn,row);
				num(end+1) = nu;
				denom(end+1) = de;
				satsimn(end+1) = nu/de;
			end
			avgstsm = mean(satsimn);
			tsatsim = sum(num)/sum(denom);
			allavgstsm(x,y) = avgstsm;
			alltsatsim(x,y) = tsatsim;
		end
	end

	allsatsim(:,:,1) = allavgstsm;
	allsatsim(:,:,2) = alltsatsim;

function [nu de] = STSM(satvX,satvY,row)
	num = [];
	denom = [];
	for n = 1:size(satvX,2)
		num(n) = abs(satvX(:,n,1)-satvY(:,n,row(n))) + abs(satvY(:,n,1)-satvX(:,n,row(n)));
		denom(n) = abs(satvX(:,n,1)+satvX(:,n,2)) + abs(satvY(:,n,1)+satvY(:,n,2));
	end

	nu = sum(num);
	de = sum(denom);

function row = Row(satvX, satvY)

	row = [];
	for n = 1:size(satvX,2)
		if satvX(1,n,3) == satvY(1,n,3)
			row(n) = 1;
		else
			row(n) = 2;
		end
	end

function allsatv = getallsatv()

	[allmaxminus allminplus] = getmmmp;

	allsatv = []

	for i = 1:size(allmaxminus,1)
		for j = 1:size(allmaxminus,2)
			if allmaxminus(i,j) <= allminplus(i,j)
				allsatv(i,j,1) = allmaxminus(i,j);
				allsatv(i,j,2) = allminplus(i,j);
				allsatv(i,j,3) = 1;
			else
				allsatv(i,j,2) = allmaxminus(i,j);
				allsatv(i,j,1) = allminplus(i,j);
				allsatv(i,j,3) = 0;
			end
		end
	end

	%save allsatv.mat allsatv

function [allmaxminus allminplus] = getmmmp()

	load allemb

	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	[allmax allmin] = getallmaxmin(allemb)

	allmaxminus = [];
	allminplus = [];
	for n = 1:351
		z = top;
		z(end+1) = n;
		z = sort(z);
		card = find(z==n);
		amm = [];
		amp = [];
		for i = 2:12
			ncv = allemb(n,top(i-1)+1:top(i));
			mm = abs(allmax(card(1),top(i-1):top(i)-1)-ncv);
			mp = abs(allmin(card(1),top(i-1):top(i)-1)-ncv);
			amm = [amm mm];
			amp = [amp mp];
		end
		allmaxminus(end+1,:) = amm;
		allminplus(end+1,:) = amp;
	end


function [allmax allmin] = getallmaxmin(allemb)

	allmin = [];
	allmax = [];
	for n = 1:12
		a = [];
		b = [];
		for nn = 2:12
			[mn mx] = minmax(n,nn,allemb);
			a = [a mn];
			b = [b mx];
		end
		allmin(n,:) = a;
		allmax(n,:) = b;
	end

function [mn mx] = minmax(n,nn,allemb)

	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	mn = [];
	mx = [];

	if n == 1
		ivs = allemb(1,top(nn-1)+1:top(nn));
	else
		ivs = allemb((top(n-1)+1):top(n),(top(nn-1)+1):top(nn));
	end

	mm = [];
	for i = 1:size(ivs, 2)
		mx(i) = max(ivs(:,i));
		mn(i) = min(ivs(:,i));
	end