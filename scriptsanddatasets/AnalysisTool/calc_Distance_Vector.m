function [dv] = calc_Distance_Vector(scs_win, measures, comparison_set)

	for i = 1:length(scs_win)
		dv(:,i) = measures(scs_win(i),comparison_set,:);
	end