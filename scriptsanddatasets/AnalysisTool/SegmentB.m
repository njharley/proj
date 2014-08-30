function [windows setclass] = SegmentB(nmat, win, hop, idxtn, total_duration)

	win_onset = 0;
	idx = 1;
	while win_onset + win <= total_duration

		windows(idx,1) = win_onset;
		windows(idx,2) = win_onset+win;

		w_nmat = midiWindow(nmat,win_onset,win_onset+win,'beat');

		if ~isempty(w_nmat)
			pds(idx,:) = pcdist1(w_nmat);
		else 
			pds(idx,:) = [0 0 0 0 0 0 0 0 0 0 0 0];
		end
		
		win_onset = win_onset+hop;
		idx = idx+1;

	end

	for i = 1:size(pds,1)
		setclass(i) = get_Set_Class_Index(pds(i,:),idxtn);
	end