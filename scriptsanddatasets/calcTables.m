function table = calcTables()

	load TotalMeasuresPrime%load TotalMeasuresPrime
	forteNames = textread('forteNamesAB.txt','%s');
	
	%{
	maj 25
	min 24
	dim 23
	aug 26
	7 66
	maj7 57
	min7 64
	07 65
	O7 67
	V7-I 176
	Diatonic 276
	Harmonic Minor 272
	%}

	scs = [25 24 23 26 66 57 64 65 67 176 276 272];
	chord_labels = {'Maj';'Min';'Dim';'Aug';'7';'Maj7';'Min7';'07';'O7';'V7-I';'Diat';'HMin';};
	sc_labels = forteNames(scs);
	table = ATMEMB_prime(scs,scs);
	table2 = AvgSATSIM_prime(scs, scs);
	%{

	%sets = [25 24 23 26 22 22 57 64 65 66 67 55 56 59 46 64 57 51 61 129 116 117 116 176 189 130 192 276 322];
	sets = [25 24 23 26 22 57 64 65 66 67 55 56 59 46 51 61 129 117 116 176 189 130 192 276 322];

	msr = TSATSIM_prime;

	table = [];
	for i = 1:length(sets)
		for j = i:length(sets)

			table(i,j) = msr(sets(i),sets(j));
			%table(j,i) = msr(sets(i),sets(j));

			chordsRELa(i,j) = RELa_prime(sets(i),sets(j));
			chordsRELb(i,j) = RELb_prime(sets(i),sets(j));
			chordsRELc(i,j) = RELc_prime(sets(i),sets(j));
			chordsATMEMB(i,j) = ATMEMB_prime(sets(i),sets(j));
			chordsRECREL(i,j) = RECREL_prime(sets(i),sets(j));
			chordsTpREL(i,j) = TpREL_prime(sets(i),sets(j));
			chordsAvgSATSIM(i,j) = AvgSATSIM_prime(sets(i),sets(j));
			chordsTSATSIM(i,j) = TSATSIM_prime(sets(i),sets(j));

			chordsRELa(j,i) = RELa_prime(sets(i),sets(j));
			chordsRELb(j,i) = RELb_prime(sets(i),sets(j));
			chordsRELc(j,i) = RELc_prime(sets(i),sets(j));
			chordsATMEMB(j,i) = ATMEMB_prime(sets(i),sets(j));
			chordsRECREL(j,i) = RECREL_prime(sets(i),sets(j));
			chordsTpREL(j,i) = TpREL_prime(sets(i),sets(j));
			chordsAvgSATSIM(j,i) = AvgSATSIM_prime(sets(i),sets(j));
			chordsTSATSIM(j,i) = TSATSIM_prime(sets(i),sets(j));
		end
	end



	for i = 1:size(table,1)
		for j = i:size(table,2)
			table(j,i) = table(i,j);
		end
	end

	%save chordTABLES.mat chordsRELa chordsRELb chordsRELc chordsRECREL chordsATMEMB chordsTpREL chordsAvgSATSIM chordsTSATSIM

	%}
	%labels = {'maj';'min';'dim';'aug';'sus4/sus2';'maj7/min6';'min7/maj6';'hdim7';'7';'dim7';'min(7)';'aug(7)';'maj(7)';'min(9)';'sus4(7)';'sus4(b7)';'9';'maj9';'min9';'V-I';'V7-I';'V-IV';'pent';'whole';'diat';'oct';};
	%labels = {'ma';'mi';'d';'au';'s';'ma7';'mi7';'hd7';'7';'d7';'mi(7)';'a(7)';'ma(7)';'mi(9)';'s4(7)';'s4(b7)';'9';'mi9';'V/I';'V7/I';'V/IV';'pnt';'whl';'dia';'oct';};

	%length(sets)
	%length(labels)
	figure('Color', [.8 .8 .8]);	
	%subplot(1,2,1)
	imagesc(table)
	aux=(1:29);
	set(gca,'xtick',aux);
	set(gca,'ytick',aux);
	set(gca,'XTickLabel',sc_labels);
	set(gca,'YTickLabel',chord_labels);
	xlabel('Set-Class'); ylabel('Chord Type'); %title('TSATSIM Distance');
	c = colorbar; 
	caxis([0 100]); colormap(gray);
	axis square;
	ylabel(colorbar, 'Distance');
	figure();
	%subplot(1,2,2);
	imagesc(table2)
	aux=(1:29);
	set(gca,'xtick',aux);
	set(gca,'ytick',aux);
	set(gca,'XTickLabel',sc_labels);
	set(gca,'YTickLabel',chord_labels);
	xlabel('Set-Class'); ylabel('Chord Type'); %title('TSATSIM Distance');
	c = colorbar; caxis([0 100]); axis square;
	ylabel(colorbar, 'Distance');
	%title(c,'Distance'); 
	colormap(gray);

	