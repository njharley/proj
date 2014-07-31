function draftplots()

	load wtc_mat/Wtci-01-C-a.mat

	nmat = readmidi('wtc_midi/Wtci-01-C-a.mid');
	tempo = gettempo(nmat);

	figure()
	pianoroll(nmat,'name','beat')

	cM = cMtn;
	cV = cVtn;

	figure()
	for i = 1:size(cM,1)
		lines = cM{i};
		for j = 1:size(lines,1)
			x = lines(j,:);
			%x = (x./4)-(1/4)+1;
			if isempty(x) break;
			else
				x = x.*tempo/60;
				x = x./4;
				x = x - 1/4;
				x = x+1;
				y = [i i];
				plot(x,y,'-b');
				hold on;
			end
		end
	end
	set(gca,'xtick',1:4:36);
	title('Wtci-01-C-a Class-Matrix');
	xlabel('Time (Bars)'); ylabel('Set Class');
	set(gca,'ytick',[25 176 276]); set(gca,'YTickLabel',{'3-11B';'6-Z25A';'7-35';});
	grid on;
	ylim([1 351]);
	xlim([1 36]);

	figure();
	bar(cV); xlim([1 351]); ylim([0 1]);
	set(gca,'xtick',[25 176 276]); set(gca,'XTickLabel',{'3-11B';'6-Z25A';'7-35';});
	grid on; xlabel('Set Class'); ylabel('Proportional Activation Time'); title('Class-Vector');

	[sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calcscsegsize(pcs,w,tempo);
	
	figure(); bar(1:351,sc_seg_size_avg); 
	xlim([1 351]); ylim([0 30]);
	hold on;
	h=errorbar(1:351,sc_seg_size_avg,sc_seg_size_std,'r'); 
	set(h,'linestyle','none'); errorbar_tick(h, 500); 
	set(gca,'xtick',[25 176 276]); set(gca,'XTickLabel',{'3-11B';'6-Z25A';'7-35';});
	set(gca,'ytick',[2 4 6 8 10 12 14 16 18 20 22 24 26 28 30]);
	xlabel('Set Class'); ylabel('Average Segment Length (Beats)');
	grid on;

	figure(); bar(1:12,card_seg_size_avg);
	ylim([0 30]); xlim([0 13]); 
	hold on;
	h=errorbar(1:12,card_seg_size_avg,card_seg_size_std,'r'); 
	set(h,'linestyle','none'); errorbar_tick(h, 500);
	set(gca,'xtick',1:12);
	set(gca,'ytick',[2 4 6 8 10 12 14 16 18 20 22 24 26 28 30]);
	xlabel('Cardinality Class'); ylabel('Average Segment Length (Beats)');
	grid on;

	win = 2;
	hop = 1;

	[distance_plot class_hist no_segs crosscorrmat] = segment_midi(nmat,25,win,hop);
	x = ((1:length(distance_plot)).*hop/4-hop/4+1);

	figure();
	bar(cV); xlim([1 351]); ylim([0 1]);
	hold on; plot(class_hist,'-r','LineWidth',2);
	set(gca,'xtick',[25 176 276]); set(gca,'XTickLabel',{'3-11B';'6-Z25A';'7-35';});
	grid on; xlabel('Set Class'); ylabel('Proportional Activation Time'); 
	legend('Class-vector','SC contents of sliding window');

	figure();
	plot(x,distance_plot); ylim([0 100]); xlim([1 36]);
	set(gca,'xtick',[1:4:36]); grid on;
	xlabel('Bar'); ylabel('Distance'); title('Distance Plot');

	acf = autocorr(distance_plot,length(distance_plot)-1);
	figure(); plot(((1:length(acf)).*hop/4-hop/4+1),acf);
	xlim([1 36]); set(gca,'xtick',[1:4:36]); grid on;
	xlabel('Bar'); ylabel('Autocorrelation'); title('Autocorrelation');

	figure(); imagesc(crosscorrmat); 
	colorbar; caxis([0 100]); colormap(gray); axis square;
	set(gca,'xtick',1:16:140); set(gca,'XTickLabel',1:4:36);
	set(gca,'ytick',1:16:140); set(gca,'YTickLabel',1:4:36);
	title('Self-Similarity Matrix'); xlabel('Bar'); ylabel('Bar');



function [distance_plot class_hist no_segs crosscorrmat] = segment_midi(nmat,comparison_set_idx,win,hop)
	load TotalMeasuresPrime

	qnmat = quantize(nmat, 1/32, 1/32, 1/32);
	pds = movewindow(qnmat,win,hop,'beat','pcdist1');

	class_hist = zeros(1,351);

	for i = 1:size(pds,1)
		pc_set = find(pds(i,:))-1;
		prime_set = primeFormAB(pc_set);
		set_index = getSetIndex(prime_set);
		set_idx(i) = set_index;
		global endtime
		global tempo
		if i ~= 1 
			if set_idx(i) == set_idx(i-1)
				class_hist(set_index) = class_hist(set_index)+hop;
			else
				class_hist(set_index) = class_hist(set_index)+win;
			end
		end
		distance_plot(i) = ATMEMB_prime(set_index,comparison_set_idx);
	end
	class_hist = class_hist./140;
	no_segs = size(pds,1);

	for i = 1:length(set_idx)
		for j = 1:length(set_idx)
			crosscorrmat(i,j) = ATMEMB_prime(set_idx(i),set_idx(j));
		end
	end

function set_index = getSetIndex(prime_set)
	load pcsetdata
	for i = 1:size(orderedtn,1)
		x = unique(orderedtn(i,:));
		if isequal(prime_set,x)
			set_index = i;
			break;
		end
    end

function [sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calcscsegsize(pcs,w,tempo)

	load pcsetdata;
	pc_sets = pcs+1;
	tn_scs = idxtn(pc_sets);

	seg_sizes = (w(:,2)-w(:,1)).*tempo/60;

	for i = 1:351
		isegs = find(tn_scs==i);
		sc_seg_size_avg(i) = mean(seg_sizes(isegs));
		sc_seg_size_std(i) = std(seg_sizes(isegs));
	end

	set_card = card(pc_sets);
	for i = 1:12
		isegs = find(set_card==i);
		card_seg_size_avg(i) = mean(seg_sizes(isegs));
		card_seg_size_std(i) = std(seg_sizes(isegs));
	end




