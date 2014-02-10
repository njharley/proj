function recrelxy = recrel(primex, primey)

	cardx = length(primex);
	cardy = length(primey);

	if cardx == cardy
		nmax = cardx-1
	else
		nmax = min(cardx, cardy)
	end

	recrelxy = [];

	for n = 2:nmax
		n
		recrelxy(end+1) = branchn(primex, primey, n)
	end

function r = branchn(x, y, n)
	if n == 1
		r = 0;
		return;
	end

	r = preln(x, y, n)
	[notmembx notmemby] = notmemb(x, y, n);

	if isempty(notmembx) || isempty(notmemby)
		return;
	end

	for i = 1:size(notmembx, 1)
		for j = 1:size(notmemby, 1)
			a = unique(notmembx(i,:));
			b = unique(notmemby(j,:));
			r = branchn(a, b, n-1)
		end
	end