function allpncv = allpncv()

	top = [1 7 26 69 135 215 281 324 343 349 350 351];

%{
	load allemb.mat
	oneCVs = allemb(:,1);
	twoCVs = allemb(:,2:7);
	threeCVs = allemb(:,8:26);
	fourCVs = allemb(:,27:69);
	fiveCVs = allemb(:,70:135);
	sixCVs = allemb(:,136:215);
	sevenCVs = allemb(:,216:281);
	eightCVs = allemb(:,282:324);
	nineCVs = allemb(:,325:343);
	tenCVs = allemb(:,344:349);
	elevenCVs = allemb(:,350);
	twelveCVs = allemb(:,351);

	save allcvs.mat oneCVs twoCVs threeCVs fourCVs fiveCVs sixCVs sevenCVs eightCVs nineCVs tenCVs elevenCVs twelveCVs
%}
	nCpVs = {[]};
	load allcvs.mat
	for i = 1:size(oneCVs,1)
		oneCpVs(i,:) = oneCVs(i,:)*(100/sum(oneCVs(i,:)));
		oneCpVs(isnan(oneCpVs)) = 0;
		nCpVs{1} = oneCpVs;
	end

	for i = 1:size(twoCVs,1)
		twoCpVs(i,:) = twoCVs(i,:)*(100/sum(twoCVs(i,:)));
		twoCpVs(isnan(twoCpVs)) = 0;
		nCpVs{2} = twoCpVs;

	end

	for i = 1:size(threeCVs,1)
		threeCpVs(i,:) = threeCVs(i,:)*(100/sum(threeCVs(i,:)));
		threeCpVs(isnan(threeCpVs)) = 0;
		nCpVs{3} = threeCpVs;
	end

	for i = 1:size(fourCVs,1)
		fourCpVs(i,:) = fourCVs(i,:)*(100/sum(fourCVs(i,:)));
		fourCpVs(isnan(fourCpVs)) = 0;
		nCpVs{4} = fourCpVs;
	end

	for i = 1:size(fiveCVs,1)
		fiveCpVs(i,:) = fiveCVs(i,:)*(100/sum(fiveCVs(i,:)));
		fiveCpVs(isnan(fiveCpVs)) = 0;
		nCpVs{5} = fiveCpVs;
	end

	for i = 1:size(sixCVs,1)
		sixCpVs(i,:) = sixCVs(i,:)*(100/sum(sixCVs(i,:)));
		sixCpVs(isnan(sixCpVs)) = 0;
		nCpVs{6} = sixCpVs;
	end

	for i = 1:size(sevenCVs,1)
		sevenCpVs(i,:) = sevenCVs(i,:)*(100/sum(sevenCVs(i,:)));
		sevenCpVs(isnan(sevenCpVs)) = 0;
		nCpVs{7} = sevenCpVs;
	end

	for i = 1:size(eightCVs,1)
		eightCpVs(i,:) = eightCVs(i,:)*(100/sum(eightCVs(i,:)));
		eightCpVs(isnan(eightCpVs)) = 0;
		nCpVs{8} = eightCpVs;
	end

	for i = 1:size(nineCVs,1)
		nineCpVs(i,:) = nineCVs(i,:)*(100/sum(nineCVs(i,:)));
		nineCpVs(isnan(nineCpVs)) = 0;
		nCpVs{9} = nineCpVs;
	end

	for i = 1:size(tenCVs,1)
		tenCpVs(i,:) = tenCVs(i,:)*(100/sum(tenCVs(i,:)));
		tenCpVs(isnan(tenCpVs)) = 0;
		nCpVs{10} = tenCpVs;
	end

	for i = 1:size(elevenCVs,1)
		elevenCpVs(i,:) = elevenCVs(i,:)*(100/sum(elevenCVs(i,:)));
		elevenCpVs(isnan(elevenCpVs)) = 0;
		nCpVs{11} = elevenCpVs;
	end

	for i = 1:size(twelveCVs,1)
		twelveCpVs(i,:) = twelveCVs(i,:)*(100/sum(twelveCVs(i,:)));
		twelveCpVs(isnan(twelveCpVs)) = 0;
		nCpVs{12} = twelveCpVs;
	end

	save cpvs.mat nCpVs