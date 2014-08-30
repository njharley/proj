function distance_TS = get_Distance_TS(sc_TS, measure, comparison_set)

	for i = 1:length(sc_TS)
		distance_TS(i) = measure(sc_TS(i),comparison_set);
	end