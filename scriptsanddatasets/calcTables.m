function table = calcTables()

	load TotalMeasuresPrime
	sets = [25 24 23 26 22 22 57 64 65 66 67 55 56 59 46 64 57 51 61 129 116 117 130 192 276 322];
	table = [];
	for i = 1:length(sets)
		for j = i:length(sets)
			table(i,j) = RELa_prime(sets(i),sets(j));
			%table2(i,j) = RELb_prime(sets(i),sets(j));
			%table3(i,j) = RELc_prime(sets(i),sets(j));
		end
	end

	size(table)
	labels = {'maj';'min';'dim';'aug';'sus4';'sus2';'maj7';'min7';'hdim7';'7';'dim7';'min(7)';'aug(7)';'maj(7)';'min(9)';'maj6';'min6';'sus4(7)';'sus4(b7)';'9';'maj9';'min9';'pent';'whole';'diat';'-';};

	length(sets)
	length(labels)
	figure()
	pcolor(table)
	aux=(1:26);
	set(gca,'xtick',aux);
	set(gca,'ytick',aux);
	%set(gca,'XTickLabel',{'3-11B';'3-11A';'3-10';'3-12';'3-9';'3-9';'4-20';'4-26';'4-27A';'4-27B';'4-28';'4-19A';'4-19B';'4-22A';'4-14A';'4-26';'4-20';'4-16B';'4-23';'5-34';'5-27A';'5-27B';'5-35';'6-35';'7-35';'8-28';});
	set(gca,'XTickLabel',labels);
	set(gca,'YTickLabel',labels);

	

	xlabel('Set-Class'); ylabel('Set-Class'); title('Chord Similarity (REL Distance)');
	h = colorbar;
	title(h,'Distance')
