% returns castrens asymmetric differnce vectors

function [dvxy dvyx] = dv2(x, y)

	dvxy = [];
	dvyx = [];

	for i = 1:length(x)
		dvxy(i) = x(i)-y(i);
		dvyx(i) = y(i)-x(i);
	end

	dvxy = asym(dvxy);
	dvyx = asym(dvyx);

function asymdv = asym(dv)
	asymdv = [];
	for i = 1:length(dv)
		if dv(i) < 0
			asymdv(i) = 0;
		else
			asymdv(i) = dv(i);
		end
	end

