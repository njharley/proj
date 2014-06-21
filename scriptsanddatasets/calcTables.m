function table = calcTables()

	load TotalMeasuresPrime
	%sets = [25 24 23 26 22 22 57 64 65 66 67 55 56 59 46 64 57 51 61 129 116 117 116 176 189 130 192 276 322];
	sets = [25 24 23 26 22 57 64 65 66 67 55 56 59 46 51 61 129 117 116 176 189 130 192 276 322];

	msr = TSATSIM_prime;

	table = [];
	for i = 1:length(sets)
		for j = i:length(sets)

			table(i,j) = msr(sets(i),sets(j));
			%table(j,i) = msr(sets(i),sets(j));

			%chordsRELa(i,j) = RELa_prime(sets(i),sets(j));
			%chordsRELb(i,j) = RELb_prime(sets(i),sets(j));
			%chordsRELc(i,j) = RELc_prime(sets(i),sets(j));
			%chordsATMEMB(i,j) = ATMEMB_prime(sets(i),sets(j));
			%chordsRECREL(i,j) = RECREL_prime(sets(i),sets(j));
			%chordsTpREL(i,j) = TpREL_prime(sets(i),sets(j));
			%chordsAvgSATSIM(i,j) = AvgSATSIM_prime(sets(i),sets(j));
			%chordsTSATSIM(i,j) = TSATSIM_prime(sets(i),sets(j));
		end
	end

	for i = 1:size(table,1)
		for j = i:size(table,2)
			table(j,i) = table(i,j);
		end
	end

	%save chordTABLES.mat chordsRELa chordsRELb chordsRELc chordsRECREL chordsATMEMB chordsTpREL chordsAvgSATSIM chordsTSATSIM

	%labels = {'maj';'min';'dim';'aug';'sus4/sus2';'maj7/min6';'min7/maj6';'hdim7';'7';'dim7';'min(7)';'aug(7)';'maj(7)';'min(9)';'sus4(7)';'sus4(b7)';'9';'maj9';'min9';'V-I';'V7-I';'V-IV';'pent';'whole';'diat';'oct';};
	labels = {'ma';'mi';'d';'au';'s';'ma7';'mi7';'hd7';'7';'d7';'mi(7)';'a(7)';'ma(7)';'mi(9)';'s4(7)';'s4(b7)';'9';'mi9';'V/I';'V7/I';'V/IV';'pnt';'whl';'dia';'oct';};

	%length(sets)
	%length(labels)
	figure()
	imagesc(table')
	aux=(1:29);
	set(gca,'xtick',aux);
	set(gca,'ytick',aux);
	%set(gca,'XTickLabel',{'3-11B';'3-11A';'3-10';'3-12';'3-9';'3-9';'4-20';'4-26';'4-27A';'4-27B';'4-28';'4-19A';'4-19B';'4-22A';'4-14A';'4-26';'4-20';'4-16B';'4-23';'5-34';'5-27A';'5-27B';'5-35';'6-35';'7-35';'8-28';});
	set(gca,'XTickLabel',labels);
	set(gca,'YTickLabel',labels);
	xlabel('Set-Class'); ylabel('Set-Class'); title('TSATSIM Distance');
	c = colorbar;
	title(c,'Distance')
	grid