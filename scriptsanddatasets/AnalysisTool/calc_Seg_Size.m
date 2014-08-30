function [sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calc_Seg_Size(scs,w,cardtn)

	seg_sizes = w(:,2)-w(:,1);

	for i = 1:351
		isegs = find(scs==i);
		if ~isempty(isegs)
			sc_seg_size_avg(i) = mean(seg_sizes(isegs));
			sc_seg_size_std(i) = std(seg_sizes(isegs));
		else
			sc_seg_size_avg(i) = 0;
			sc_seg_size_std(i) = 0;
		end
	end

	scs = scs(find(scs>0));
	seg_sizes = seg_sizes(find(scs>0));

	set_card = cardtn(scs);
	for i = 1:12
		isegs = find(set_card==i);
		if ~isempty(isegs)
			card_seg_size_avg(i) = mean(seg_sizes(isegs));
			card_seg_size_std(i) = std(seg_sizes(isegs));
		else
			card_seg_size_avg(i) = 0;
			card_seg_size_std(i) = 0;
		end
	end