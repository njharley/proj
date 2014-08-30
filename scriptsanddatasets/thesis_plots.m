function thesis_plots()

	% PLOTS...
	% ATMEMB AND AVGSATSIM CHORD COMPARISONS
	% ABS DIF BETWEEN TABLES
	chord_tables();

	% PLOTS...
	% THE CORRELATION BETWEEN ALL VALUES OF
	% ALL MEASURE
	correlate_all();

function table = chord_tables()

	load TotalMeasuresPrime%load TotalMeasuresPrime
	forteNames = textread('forteNamesAB.txt','%s');

	scs = [25 24 23 26 66 57 64 65 67 176 276 272];
	chord_labels = {'Maj';'Min';'Dim';'Aug';'7';'Maj7';'Min7';'hDim7';'Dim7';'V7-I';'Diat';'HMin';};
	sc_labels = forteNames(scs);
	table1 = ATMEMB_prime(scs,scs);
	table2 = AvgSATSIM_prime(scs, scs);
	table3 = RELa_prime(scs,scs);
	table4 = RELb_prime(scs,scs);
	table5 = RELc_prime(scs,scs);
	table6 = RECREL_prime(scs,scs);
	table7 = TpREL_prime(scs,scs);
	table8 = TSATSIM_prime(scs,scs);
	%{
	figure()
	imagesc(table1); caxis([0 100]);
	figure()
	imagesc(table2);caxis([0 100]);
	figure()
	imagesc(table3);caxis([0 100]);
	figure()
	imagesc(table4);caxis([0 100]);
	figure()
	imagesc(table5);caxis([0 100]);
	figure()
	imagesc(table6);caxis([0 100]);
	figure()
	imagesc(table7);caxis([0 100]);
	figure()
	imagesc(table8);caxis([0 100]);
	%}

	absdiff = abs(table1-table2);
	

	figure(); imagesc(table1);
	aux=(1:length(scs)); set(gca,'xtick',aux); set(gca,'ytick',aux);
	set(gca,'XTickLabel',sc_labels,'FontSize',14);
	set(gca,'YTickLabel',chord_labels,'FontSize',14);
	xlabel('Set-Class','FontSize',14); 
	ylabel('Chord Type','FontSize',14); 
	title('Chord Comparisons','FontSize',20);
	c = colorbar; caxis([0 100]); colormap(gray);
	ylabel(colorbar, 'ATMEMB-prime Distance','FontSize',14);	
	axis square;
	
	figure(); imagesc(table2);
	aux=(1:length(scs)); set(gca,'xtick',aux); set(gca,'ytick',aux);
	set(gca,'XTickLabel',sc_labels,'FontSize',14);
	set(gca,'YTickLabel',chord_labels,'FontSize',14);
	xlabel('Set-Class','FontSize',14); 
	ylabel('Chord Type','FontSize',14); 
	title('Chord Comparisons','FontSize',20);
	c = colorbar; caxis([0 100]); colormap(gray);
	ylabel(colorbar, 'AvgSATSIM-prime Distance','FontSize',14);	
	axis square;

	figure();
	imagesc(absdiff)
	aux=(1:length(scs)); set(gca,'xtick',aux); set(gca,'ytick',aux);
	set(gca,'XTickLabel',sc_labels,'FontSize',14);
	set(gca,'YTickLabel',chord_labels,'FontSize',14);
	xlabel('Set-Class','FontSize',14); 
	ylabel('Chord Type','FontSize',14); 
	title('Measure Comparison','FontSize',21);
	c = colorbar; caxis([0 100]); colormap(gray);
	ylabel(colorbar, '|ATMEMB-prime - AvgSATSIM-prime|','FontSize',14);	
	axis square;

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

	aux=(1:8); set(gca,'xtick',aux); set(gca,'ytick',aux);
	labels = {'ATMEMB';'RELa';'RELb';'RELc';'RECREL';'TpREL';'AvgSATSIM';'TSATSIM'};
	set(gca,'XTickLabel',labels,'FontSize',14);
	set(gca,'YTickLabel',labels,'FontSize',14);
	axis square
	title('Measure Correlation','FontSize',20);
	c = colorbar;
	ylabel(colorbar, 'Correlation','FontSize',14);
	
