function si = si(primex, primey)

	icvX = nCV(primex, 2)
	icvY = nCV(primey, 2)
	
	cardicvX = sum(icvX)
	cardicvY = sum(icvY)
	
	dvXY = abs(icvX-icvY)
	

	sum(dvXY)


	for i = 1:6
		a = icvX(i)/sum(icvX);
		b = icvY(i)/sum(icvY);

		c(i) = abs(a-b);
	end
	c
	si = sum(c);
