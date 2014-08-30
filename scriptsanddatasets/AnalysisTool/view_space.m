function view_space(class_vector_win, dist_measure, ref_set)

	[scs] = find(class_vector_win);%[24 25 57 66 176 276];
	ammount = class_vector_win(scs).*1000;
	load AllTotalMeasures
	load forteNames

	figure()
	for i = 1:size(alltotalmeasures,3)
		grd(i,:) = alltotalmeasures(ref_set,scs,i);
	end
	imagesc(grd); colormap(gray); caxis([0 100]); axis square;
	set(gca,'xtick',1:length(scs)); 
	set(gca,'XTickLabel',forteNames(scs),'FontSize',14);

	set(gca,'ytick',1:8);
	ylabels = {'ATMEMB';'RELa';'RELb';'RELc';'RECREL';'TpREL';'AvgSATSIM';'TSATSIM'};
	set(gca,'YTickLabel',ylabels,'FontSize',14);
	title('Ref Set: 3-11B','FontSize',20);
	c = colorbar; ylabel(colorbar, 'Distance','FontSize',14);

	dissim =  dist_measure(scs,scs);
	labels = forteNames(scs);

	tree = linkage(dissim,'average');
	c = cluster(tree,'maxclust',3);
	c

	opts = statset('Display','final');
	[Y,stress,disparities] = mdscale(dissim,2,'criterion','metricsstress','start','random','replicates',5,'Options',opts);


	figure();
	scatter(Y(:,1),Y(:,2),ammount,c,'fill');
	text( Y(:,1)+1, Y(:,2)+1, labels, 'FontSize', 14);
	grid on;
	title('Set Class Space (RELa-prime)','FontSize',19);
	%set(gca,'FontSize',14); 
	axis square;
	%set(gca,'YTickLabel','FontSize',15);

	stress
	figure();
	dendrogram(tree);