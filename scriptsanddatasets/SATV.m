function satv = SATV(primex, nn)

	mm = minmax(size(primex, 2), nn);
	ncvX = ncv(primex, nn);

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



