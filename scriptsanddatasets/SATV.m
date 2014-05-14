function satv = SATV(primex, nn)

	load allemb
	mm = minmax(size(primex, 2), nn, allemb)
	ncvX = nCV(primex, nn);

	satv = [];

	for i = 1:size(mm, 2)
		max_minus = abs(mm(1,i)-ncvX(i));
		min_plus = abs(mm(2,i)-ncvX(i));

		if max_minus <= min_plus
			satv(1,i) = 1;
			satv(2,i) = max_minus;
			satv(3,i) = min_plus;
		else
			satv(1,i) = 0;
			satv(2,i) = min_plus;
			satv(3,i) = max_minus;
		end
	end

function mm = minmax(n,nn,allemb)

	%primeor = dlmread('protoprimeOrdered.txt');
	top = [1 7 26 69 135 215 281 324 343 349 350 351];

	if n == 1
		ivs = allemb(1,top(nn-1)+1:top(nn));
	else
		ivs = allemb((top(n-1)+1):top(n),(top(nn-1)+1):top(nn));
	end

	%ivs = [];
	%for i = (top(n-1)+1):top(n)
	%	a = unique(primeor(i,:));
	%	ivs(end+1,:) = nCV(a,nn);
	%end

	mm = [];
	for i = 1:size(ivs, 2)
		mm(1,i) = max(ivs(:,i));
		mm(2,i) = min(ivs(:,i));
	end

