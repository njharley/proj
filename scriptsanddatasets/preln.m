% returns %RELn of given x, y and n

function [wdvt prelnxy] = preln(primex, primey, n)

	ncvx = ncv(primex, n); % nCVs
	ncvy = ncv(primey, n);

	pncvx = pncv(ncvx); % convert nCVs into nC%Vs
	pncvy = pncv(ncvy);

	[dvxy dvyx] = dv2(pncvx, pncvy); % get castrens 2 asymmetric difference vectors
	prelnxy = sum(dvxy) + sum(dvyx); % card of vector
	prelnxy = prelnxy/2; % divide by two

	%%% output the WDV 

	[wdvxy wdvyx] = wdv(dvxy, dvyx);
	wdvt = wdvyx+wdvxy;