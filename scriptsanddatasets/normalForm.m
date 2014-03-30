function nrml = normalForm(pcs)


	normal = sort(unique(pcs));
	normal0 = normal;
	normal0(end+1) = normal(1)+12;

	for i = 1:size(normal,2)
		span(i) = normal0(i+1)-normal0(i);
	end
	span;

	index = find(span==max(span));

	for i = 1:length(index)
		n = circshift(normal, [0 size(normal)-index(i)-1]);
		n = n - n(1);
	
		for i = 1:size(n,2)
			if n(i)<0
				n(i) = 12-abs(n(i));
			end
		end
		name = get_sc_name(n);
		if ~isempty(name) 
			nrml = n;
			break; 
		end
	end


function name = get_sc_name(sc)

	sc_names = textread('forteNamesAB.txt', '%s');
	primeor = dlmread('protoprimeOrdered.txt');
	name = {};
	for i = 1:size(primeor,1)
		if isequal(unique(primeor(i,:)),sc)
			name = sc_names{i};
		end
	end