function ss = SATSIM(primex, primey, nn)

	% CALCULATE SATURATION VECTOR
	satvX = SATV(primex, nn)
	satvY = SATV(primey, nn)
	
	row = Row(satvX, satvY);
	num = [];
	denom = [];

	for n = 1:size(satvX,2)
		num(n) = abs(satvX(2,n)-satvY(row(n),n)) + abs(satvY(2,n)-satvX(row(n),n));
		denom(n) = abs(satvX(2,n)+satvX(3,n)) + abs(satvY(2,n)+satvY(3,n));
	end
	num
	denom
	ss = sum(num)/sum(denom);

function row = Row(satvX, satvY)

	row = [];
	for n = 1:size(satvX,2)
		if satvX(1,n) == satvY(1,n)
			row(n) = 2;
		else
			row(n) = 3;
		end
	end