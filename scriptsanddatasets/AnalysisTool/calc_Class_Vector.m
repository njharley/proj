function class_vector = calc_Class_Vector(class_matrix,duration_beats)

	for i = 1:length(class_matrix)

		w = class_matrix{i};

		if isempty(w)
			class_vector(i) = 0;
		else
			c = w(:,2)-w(:,1);
			class_vector(i) = sum(c)/duration_beats;
		end
	end