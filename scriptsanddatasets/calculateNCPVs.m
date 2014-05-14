function ncpvs = calculateNCPVs()

	primeor = dlmread('protoprimeOrdered.txt');
	ncpvs = [];
	for i = 1:size(primeor,1)
		x = unique(primeor(i,:));
		ncpv = [];
		for n = 2:12
			ncvX = nCV(x,n);
			ncpvX = (ncvX/sum(ncvX))*100;
			ncpv = [ncpv ncpvX];
		end
		ncpvs = [ncpvs; ncpv];
	end
	ncpvs = round(ncpvs.*1000);
	ncpvs(isnan(ncpvs)) = 0;
	
	save ncpvs.mat ncpvs
