function names = cadence_table()

	load pcsetdata
	forteNames = textread('forteNamesAB.txt','%s');
	%orderedtn = dlmread('protoprimeOrdered.txt');
%{
	24/25 0
	23 0
	65 10
	67 0
	66 4
%}
	chords_num = {'I';'i';'ii';'ii7';'iio';'ii07';'IV';'iv';'V';'V7';'bVI';'vi';'viio';'vii07';'viiO7';};
	sets = [25 24 25 66 23 65 25 24 25 66 25 24 23 65 67];
	offsets = [0 0 0 4 0 10 0 0 0 4 0 0 0 10 0];
	offsets2 = [0 0 2 2 2 2 5 5 7 7 8 9 11 11 11];


	for i = 1:15
		for j =1:15
			set_idx1 = sets(i);
			set_class1 = unique(orderedtn(set_idx1,:));
			pcs1 = set_class1+offsets(i)+offsets2(i);

			set_idx2 = sets(j);
			set_class2 = unique(orderedtn(set_idx2,:));
			pcs2 = set_class2+offsets(j)+offsets2(j);

			super_set = [pcs1 pcs2];
			super_class = primeFormAB(unique(sort(mod(super_set,12))));

			%prime_form = primeFormAB(super_class)

			primeor = zeros(1,12);
			primeor(super_class+1) = 1;
			primeor = fliplr(primeor);

			bi = bi2de(primeor);

			set_class = idxtn(bi+1);
			names(i,j) = forteNames(set_class);
		end
	end

	n = chords_num;


	%names