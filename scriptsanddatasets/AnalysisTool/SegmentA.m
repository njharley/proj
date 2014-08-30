function [windows setclass] = SegmentA(nmat, idxtn)

	% CALCULATE ONSETS AND OFFSETS
	onsets = nmat(:,1);
	offsets = onsets + nmat(:,2);

	% CREATE LIST OF UNIQUE CHANGES IN PITCH MATERIAL
	changes = sort(unique(cat(1,offsets,onsets)));

	w = [];

	% CREATE ALL POSSIBLE WINDOWS
	idx = 1;
	for i = 1:size(changes,1)-1
		for j = i+1:size(changes,1)
			windows(idx,1) = changes(i);
			windows(idx,2) = changes(j);
			idx = idx+1;
		end
	end


	% GET TN SET CLASS INDEXES FOR EACH WINDOW
	for i = 1:size(windows,1)
		w_nmat = midiWindow(nmat,windows(i,1),windows(i,2),'beat');
		if isempty(w_nmat)

			setclass(i) = 0;
		else

			w_pcdist = pcdist1(w_nmat);

			setclass(i) = get_Set_Class_Index(w_pcdist,idxtn);

		end
	end





