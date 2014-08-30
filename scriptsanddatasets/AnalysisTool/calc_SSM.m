function ssm = calc_SSM(scs_sli, measures)

	for i = 1:length(scs_sli)
		for j = 1:length(scs_sli)
			ssm(i,j) = measures(scs_sli(i),scs_sli(j));
		end
	end

