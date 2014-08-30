function plot_Class_Matrix(class_matrix,colour,linewidth)

	for i = 1:size(class_matrix,2)

		lines = class_matrix{i};

		for j = 1:size(lines,1)
			x = lines(j,:);
			if isempty(x) break;
			else
				x = (x./4)+1;
				y = [i i];
				plot(x,y,colour,'linewidth',linewidth);
				hold on;
			end
		end
	end