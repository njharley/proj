% returns %RELn of given x, y and n

function prelnxy = preln(primex, primey, n)

	ncvx = ncv(primex, n); % nCVs
	ncvy = ncv(primey, n);

	ncpvx = pncv(ncvx); % convert nCVs into nC%Vs
	ncpvy = pncv(ncvy);

	dfvc = dv(ncpvx, ncpvy); % get difference vector
	prelnxy = sum(dfvc); % card of vector
	prelnxy = prelnxy/2; % divide by two