function tmembxy = TMEMB(primex, primey)

	tmembxy = 0;

	cardx = size(primex, 2);
	cardy = size(primey, 2);

	if cardx<1 || cardx>12
	    error('X out of cardinality range (1-12)'); return
	end

	if cardy<1 || cardy>12
	    error('Y out of cardinality range (1-12)'); return
	end

	if cardx>cardy
	  	nmax = cardy;
	else
		nmax = cardx;
	end

	for n = 2:nmax
	    membnxy = MEMBn(primex, primey, n);
	    tmembxy = tmembxy + membnxy;
	end
