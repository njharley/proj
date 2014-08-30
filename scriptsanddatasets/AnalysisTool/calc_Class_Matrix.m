function class_matrix = calc_Class_Matrix(windows,setclass)

	cm = {[]};

	for i = 1:351
		cm{i} = windows(find(setclass==i),:);
	end

	for i = 1:length(cm);
		if isempty(cm{i})
			class_matrix{i} = [];
		else
			w = cm{i};

			cmw = [];
			cmw(end+1,:) = w(1,:);

			for j = 2:size(w,1)

				if w(j,1) > cmw(end,2)
					cmw(end+1,:) = w(j,:);
				else
					if w(j,2) > cmw(end,2)
						cmw(end,2) = w(j,2);
					end
				end
			end
			class_matrix{i} = cmw;
		end
	end
