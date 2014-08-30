function correlate_all()

	load TotalMeasuresPrime

	alltables(:,:,1) = ATMEMB_prime;
	alltables(:,:,2) = RELa_prime;
	alltables(:,:,3) = RELb_prime;
	alltables(:,:,4) = RELc_prime;
	alltables(:,:,5) = RECREL_prime;
	alltables(:,:,6) = TpREL_prime;
	alltables(:,:,7) = AvgSATSIM_prime;
	alltables(:,:,8) = TSATSIM_prime;

	for i = 1:size(alltables,3)
		for j = 1:size(alltables,3)
			measureA = alltables(:,:,i);
			measureB = alltables(:,:,j);

			A = [];
			B = [];
			for k = 1:size(measureA,1)-1
				for l = k+1:size(measureA,2)
					A(end+1) = measureA(k,l);
					B(end+1) = measureB(k,l);
				end
			end

			c = corrcoef(A',B');
			correlations(i,j) = c(1,2);
		end
	end
	figure();
	imagesc(correlations); caxis([0 1]);

	aux=(1:8);
	set(gca,'xtick',aux);
	set(gca,'ytick',aux);
	labels = {'ATMEMB';'RELa';'RELb';'RELc';'RECREL';'TpREL';'AvgSATSIM';'TSATSIM'};
	set(gca,'XTickLabel',labels);
	set(gca,'YTickLabel',labels);
	axis square
	title('Measure Correlation')
	c = colorbar;
	title(c,'Correlation')