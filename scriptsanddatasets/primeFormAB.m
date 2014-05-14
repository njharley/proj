function prime = primeFormAB(pcs)

	sc_names = textread('forteNamesAB.txt', '%s');
	primeor = dlmread('protoprimeOrdered.txt');
	name = {};

	normal = sort(unique(pcs));
	normal0 = normal;
	normal0(end+1) = normal(1)+12

	for i = 1:size(normal,2)
		span(i) = normal0(i+1)-normal0(i);
	end
	span

	index = find(span==max(span));

	for i = 1:length(index)
		m(i,:) = circshift(normal, [0 size(normal)-index(i)-1]);
	end
	m

	for i = 1:size(m,1)
		m(i,:) = m(i,:)-m(i,1);
	end
	m

	for i = 1:size(m,1)
		for j = 1:size(m,2)
			if m(i,j)<0
				m(i,j) = 12-abs(m(i,j));
			end
		end
	end
	m

	for i = size(m,1)
		mm = m(i,:);
		mm(end+1) = m(1)+12;
		for j = 1:size(m,2)
			spans(i,j) = mm(j+1)-mm(j);
		end
	end
	spans

	for i = 1:size(m,1)

		for j = 1:size(primeor,1)
			if isequal(unique(primeor(j,:)),m(i,:))
				name = sc_names{j};
				%idx = j
			end
		end

		if ~isempty(name) 
			prime = m(i,:);
			break; 
		end
	end