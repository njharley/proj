function plotclassMatrix(cM)

	figure()
	for i = 1:276%size(cM,1)
		lines = cM{i};

		for j = 1:size(lines,1)
			x = lines(j,:);
			if isempty(x) break;
			else
				y = [i i];
				plot(x,y,'-k')
				hold on;
			end
		end
	end

	sets = [25 66 116 130 176 189 276 316];
	set_names = {'3-11B';'4-27B';'5-27A';'5-35';'6-Z25A';'6-33B';'7-35';'8-23';};

	set(gca,'ytick',sets);
	set(gca,'YTickLabel',set_names);
	ylabel('Set-Class'); xlabel('Time'); title('Class Matrix');