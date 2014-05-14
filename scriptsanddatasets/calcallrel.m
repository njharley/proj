function allRELTable = calcAllREL()

	global allemb
	load allemb

	for i = 1:351
		for j = i:351
			[allRELTable(i,j,1) allRELTable(i,j,2) AllRELTable(i,j,3)] = getRELValue(i,j);
		end
	end

function [a b c] = getRELValue(x,y)

	global allemb
	subxa = allemb(x,2:351);
	subxb = allemb(x,:);
	subxc = [allemb(x,2:7) allemb(x,:)];

	subya = allemb(y,2:351);
	subyb = allemb(y,:);
	subyc = [allemb(y,2:7) allemb(y,:)];

	numa = sum(sqrt(subxa.*subya));
	denoma = sqrt(sum(subxa)*sum(subya));
	a = numa/denoma;

	numb = sum(sqrt(subxb.*subyb));
	denomb = sqrt(sum(subxb)*sum(subyb));
	b = numb/denomb;

	numc = sum(sqrt(subxc.*subyc));
	denomc = sqrt(sum(subxc)*sum(subyc));
	c = numc/denomc;

