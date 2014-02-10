% returns the difference vector of x and y

function dfvc = dv(x, y)
	dfvc = [];
	for i = 1:length(x)
		dfvc(i) = abs(x(i)-y(i));
	end

