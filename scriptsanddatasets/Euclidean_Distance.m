function ed = Euclidean_Distance(x,y)
	
	a = zeros(1,12);
	b = zeros(1,12);

	a(x+1) = 1
	b(y+1) = 1

	ed  = sqrt(sum((a - b).^2));