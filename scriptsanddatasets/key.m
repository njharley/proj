function key()

	m = {'ATMEMB','RELa','RELb','RELc','RECREL','TpREL','AvgSATSIM','TSATSIM'};
	m = fliplr(m);

	colours = {'-k';'-y';'-m';'-c';'-r';'-g';'-b';'-k';};

	figure()

	for i = 1:length(m)
		plot([0 1],[10-i 10-i],colours{i},'LineWidth',1);
		hold on;
	end

	title('Measure Colour Key','FontSize',19)
	ylim([1.5 9.5])
	set(gca,'YTick',2:9);
	set(gca,'YTickLabel',m,'FontSize',15);
	set(gca,'XTick',[]);