function Y = space()

	sets = [25 24 23 26 22 57 64 65 66 67 55 56 59 46 51 61 129 117 116 176 189 130 192 276 322];
	labels = {'maj';'min';'dim';'aug';'sus';'maj7';'min7';'hd7';'7';'dim7';'mi(7)';'aug(7)';'ma(7)';'mi(9)';'s4(7)';'s4(b7)';'9';'mi9';'V-I';'V7-I';'V-IV';'pent';'whole';'diat';'oct';};


	load chordTables

	dissim = chordsRECREL;
	dissim2 = chordsRELc;
	for i = 1:size(dissim,1)
		for j = i:size(dissim,2)
			dissim(j,i) = dissim(i,j);
			dissim2(j,i) = dissim2(i,j);
		end
	end
	figure()
	mds2(dissim,labels);
	%figure()
	%mds3(dissim,labels);

function mds3(dissim,l)

	opts = statset('Display','final');
	[Y,stress,disparities] = mdscale(dissim,3,'criterion','stress','start','random','replicates',5,'Options',opts);
	scatter3( Y(:,1), Y(:,2), Y(:,3) )
	text( Y(:,1)+2, Y(:,2)+2, Y(:,3)+2, l);
	stress

function mds2(dissim, l)

	opts = statset('Display','final');
	[Y,stress,disparities] = mdscale(dissim,2,'criterion','stress','start','random','replicates',5,'Options',opts);
	scatter( Y(:,1), Y(:,2))
	text( Y(:,1)+1, Y(:,2)+1, l);
	stress

