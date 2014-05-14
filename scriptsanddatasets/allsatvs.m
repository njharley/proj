function allsatvs()

	primeor = dlmread('protoprimeOrdered.txt');

	for i = 2:7
		x = unique(primeor(i,:));
		satvx = [];
		for n = 2:2
			satv = SATV(x,n);
			satvx = [satvx satv];
			allsatvrow(i,:) = satvx(1,:);
			allsatvmax(i,:) = satvx(2,:);
			allsatvmin(i,:) = satvx(3,:);
		end
	end

	allsatvrow
	allsatvmax
	allsatvmin
