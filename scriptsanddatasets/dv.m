% returns the difference vector of x and y from isaacson

function dfvc = dv(x, y)
	dfvc = [];
	for i = 1:length(x)
		dfvc(i) = abs(x(i)-y(i));
	end

