scale_names = textread('ScaleNames.txt','%s');
scale_number = 1:length(scale_names);

number_of_modes = [7 7 7 7 7 7 7 7 2 1 2 5 1];

mode_names = textread('ModeNames.txt','%s');
mode_number = 1:length(mode_names);

mode2scale = [];
for i = 1:length(number_of_modes)
	for j = 1:number_of_modes(i)
		mode2scale(end+1) = scale_number(i);
	end
end

first_grade_modes = textread('FirstGradeModes.txt','%s');

modes = struct([]);

md = 0;
for i = 1:length(number_of_modes)
	for j = 1:number_of_modes(i)
		md = md+1;
		modes(md).scale_name = scale_names(i);
		modes(md).mode_name = mode_names(md);
		first_grade_structure = first_grade_modes{i}-48;
		modes(md).structure = circshift(first_grade_structure,[0 -j+1]);
		m = zeros(size(modes(md).structure));
		for ii = 2:length(modes(md).structure)
			m(ii) = m(ii-1)+modes(md).structure(ii-1);
		end
		modes(md).integer = m;
		b = zeros([0 12]);
		b(m+1) = 1;
		modes(md).binary = b;
		modes(md).setClass = primeFormAB(m);
		modes(md).basicTraid = m([1 3 5]);

		try
			modes(md).seventh = m(7);
		catch
			modes(md).seventh = [];
		end

		try
			modes(md).ninth = m(2)+12;
		catch
			modes(md).ninth = [];
		end

		try
			modes(md).eleventh = m(4)+12;
		catch
			modes(md).eleventh = [];
		end

		try
			modes(md).thirteenth = m(6)+12;
		catch
			modes(md).thirteenth = [];
		end
	end
end

chords = struct([]);
c = 1;
for i = 1:2
	chords(c).scale = modes(i).scale_name;
	chords(c).mode = modes(i).mode_name;
	bt = modes(i).basicTraid;

	extensions(1) = modes(i).seventh;
	extensions(2) = modes(i).ninth;
	extensions(3) = modes(i).eleventh;
	extensions(4) = modes(i).thirteenth;

	% extended chords
	for j = 1:16
		e = (de2bi(j-1,4));
		ext = extensions(find(e));
		chords(c).integer = [bt ext];
		c = c+1;
	end
end







