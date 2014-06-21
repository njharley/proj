function [names class_vectors] = getclassvectors()

	allson = textread('allSonorities.txt','%s');

	pl = 1;

	for i = 1:20%14308
		names{i} = allson{pl};
		for j = 1:200
			x(j) = str2num(allson{pl+j,1});
		end
		class_vectors(i,:) = x;
		pl = pl+201;
	end

	figure();
	subplot(2,1,1);
	bar(class_vectors(1,1:152)); title(names(1)); axis([1 152 0 100])
	subplot(2,1,2);
	bar(class_vectors(2,1:152)); title(names(2)); axis([1 152 0 100])
	%class_vectors = [];
	%names{1}