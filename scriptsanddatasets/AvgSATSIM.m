function avgss = AvgSATSIM(primex, primey)
	
	cardx = size(primex, 2);
	cardy = size(primey, 2);
	nmax = min(cardx, cardy)-1;

	ss = [];

	for n = 2:nmax
		ss(n-1) = SATSIM(primex, primey, n);
	end

	avgss = mean(ss);