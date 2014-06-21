function comps = compareTables()

	load chordTables

	alltables(:,:,1) = chordsATMEMB;
	alltables(:,:,2) = chordsRELa;
	alltables(:,:,3) = chordsRELb;
	alltables(:,:,4) = chordsRELc;
	alltables(:,:,5) = chordsRECREL;
	alltables(:,:,6) = chordsTpREL;
	alltables(:,:,7) = chordsAvgSATSIM;
	alltables(:,:,8) = chordsTSATSIM;

	figure();
	plt = 0;
	for i = 1:size(alltables,3)
		for j = 1:size(alltables,3)
			plt = plt+1;

			allcomp(:,:,i,j) = abs(alltables(:,:,i)-alltables(:,:,j));

			[x y] = getxandy(alltables(:,:,i),alltables(:,:,j));
			%x = alltables(:,:,i);
			%y = alltables(:,:,j);
			%c = corrcoef(x(:),y(:));
			c = corrcoef(x',y');
			cor(i,j) = c(1,2); 

			plotcomp(allcomp(:,:,i,j),plt);
		end
	end

	plotcor(cor);

function plotcor(cor)
	figure();
	imagesc(cor); caxis([0.7 1]);

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

function [x y] = getxandy(xtable,ytable)

	x = [];
	y = [];
	for i = 1:size(xtable,1)-1
		for j = i+1:size(xtable,2)
			x(end+1) = xtable(i,j);
			y(end+1) = ytable(i,j);
		end
	end

function plotcomp(allcomp,plt)

	labels = {'ATMEMB';'RELa';'RELb';'RELc';'RECREL';'TpREL';'AvgSATSIM';'TSATSIM'};
	yaxisnumbers = [1 9 17 25 33 41 49 57];
	xaxisnumbers = [57 58 59 60 61 62 63 64];
	subplot(8,8,plt);
	imagesc(allcomp');
	caxis([0 100]);
	set(gca,'YTick',[]);
	set(gca,'XTick',[]);
	%axis off
	for i = 1:length(yaxisnumbers)
		if plt == yaxisnumbers(i)
			ylabel(labels(i));
			break;
		end
	end
	for i = 1:length(xaxisnumbers)
		if plt == xaxisnumbers(i)
			xlabel(labels(i));
			break;
		end
	end



