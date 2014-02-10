function tprelnxy = tpreln(primex, primey)
	cardx = length(primex);
	cardy = length(primey);

	if cardx == cardy
		nmax = cardx-1;
	else
		nmax = min(cardx, cardy);
	end

	prelnxy = [];

	for i = 2:nmax
		prelnxy(end+1) = preln(primex, primey, i);
	end

	tprelnxy = mean(prelnxy);