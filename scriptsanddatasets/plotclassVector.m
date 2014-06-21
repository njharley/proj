function plotclassVector(cV)

	figure();
	bar(cV);

	sets = [24 66 116 130 176 189 276 316];
	set_names = {'3-11A';'4-27B';'5-27A';'5-35';'6-Z25A';'6-33B';'7-35';'8-23';};

	set(gca,'xtick',sets);
	set(gca,'XTickLabel',set_names);
	ylabel('% Time'); xlabel('Set-Class'); title('Class Vector');