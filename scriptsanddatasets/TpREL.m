% Computes Castren's Total %RELn similarity measure 
% Nicholas Harley (2014) - Music Technology Group, Universitat Pompeu Fabra (Barcelona)

function tprelxy = TpREL(primex, primey)
	cardx = length(primex);
	cardy = length(primey);

	if cardx == cardy
		nmax = cardx-1;
	else
		nmax = min(cardx, cardy);
	end

	prelnxy = [];

	for n = 2:nmax
		[wdv prelnxy(end+1)] = pRELn(primex, primey, n);
	end

	prelnxy

	tprelxy = round(mean(prelnxy));