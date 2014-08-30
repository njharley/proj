function acf = calc_Autocorr(distance_vector)

	for i = 1:size(distance_vector,1)
		acf(i,:) = autocorr(distance_vector(i,:),size(distance_vector,2)-1);
	end






