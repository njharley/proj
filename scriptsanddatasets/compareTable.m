function allcomp = compareTable()

	load chordTables

	alltables(:,:,1) = chordsATMEMB;
	alltables(:,:,2) = chordsRELa;
	alltables(:,:,3) = chordsRELb;
	alltables(:,:,4) = chordsRELc;
	alltables(:,:,5) = chordsRECREL;
	alltables(:,:,6) = chordsTpREL;
	alltables(:,:,7) = chordsAvgSATSIM;
	alltables(:,:,8) = chordsTSATSIM;

	plt = 0;
	for i = 1:size(alltables,3)
		for j = 1:size(alltables,3)
			plt = plt+1;
			allcomp(:,:,i,j) = abs(alltables(:,:,i)-alltables(:,:,j));
		end
	end

	for i=1:size(alltables,3)
		for j = 1:size(alltables,3)
			plotComp(allcomp(:,:,i,j));
		end
	end

function plotComp(table)

	labels = {'ma';'mi';'d';'au';'s';'ma7';'mi7';'hd7';'7';'d7';'mi(7)';'a(7)';'ma(7)';'mi(9)';'s4(7)';'s4(b7)';'9';'mi9';'V/I';'V7/I';'V/IV';'pnt';'whl';'dia';'oct';};
	figure()
	imagesc(table'); caxis([0 100]);
	aux=(1:length(labels));
	set(gca,'xtick',aux);
	set(gca,'ytick',aux);
	%set(gca,'XTickLabel',{'3-11B';'3-11A';'3-10';'3-12';'3-9';'3-9';'4-20';'4-26';'4-27A';'4-27B';'4-28';'4-19A';'4-19B';'4-22A';'4-14A';'4-26';'4-20';'4-16B';'4-23';'5-34';'5-27A';'5-27B';'5-35';'6-35';'7-35';'8-28';});
	set(gca,'XTickLabel',labels);
	set(gca,'YTickLabel',labels);
	xlabel('Set-Class'); ylabel('Set-Class'); title('TSATSIM Distance');
	c = colorbar;
	title(c,'Distance')
	grid