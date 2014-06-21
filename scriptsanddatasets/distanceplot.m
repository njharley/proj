function distanceplot()

	global orderedtn;
	load pcsetdata

	load TotalMeasuresPrime

	win = 8;
	hop = 8;

	sets = [24 66 116 130 176 189 276 316];
	set_names = {'3-11A';'4-27B';'5-27A';'5-35';'6-Z25A';'6-33B';'7-35';'8-23';};
	chord_names = {'Minor';'7';'V-I/IV-I';'Pent';'V7-I';'V-IV';'Diat';};
	points = [0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 272 288 304];
	sections_names = {'A';'A';'B';'B';'A';'A';'C';'D';'C';'D';'A';'A';'C*';'D*';'C*';'D*';'A';'A';'E';'F';};

	nmat = readmidi('hum1.mid');
	qnmat = quantize(nmat, 1/32, 1/32, 1/32);
	pds = movewindow(qnmat,win,hop,'beat','pcdist1');


	[distance_vector class_vector] = segment(pds,ATMEMB_prime,276);
	x = (1:length(distance_vector)).*hop;
	
	figure();
	
	subplot(3,1,1);title('class_vector');
	bar(class_vector);
	auxA=[24 176 276];
	set(gca,'xtick',sets);
	set(gca,'XTickLabel',set_names);
	
	subplot(3,1,2); title('Distance');
	plot(x,distance_vector);vline(points,'-r');
	set(gca,'xtick',points);
	set(gca,'XTickLabel',sections_names);

	subplot(3,1,3); title('Auto Correlation');
	acf = autocorr(distance_vector,length(distance_vector)-1);
	plot((1:length(acf)).*hop,acf);vline(points,'-r');
	set(gca,'xtick',points);
	set(gca,'XTickLabel',sections_names);

function [distance_vector class_vector] = segment(pds,MEASURE_prime,comparison_set_idx)

	class_vector = zeros(1,351);
	distance_vector = [];

	for i = 1:size(pds,1)
		pc_set = find(pds(i,:))-1;
		prime_set = primeFormAB(pc_set);
		set_index = getSetIndex(prime_set);
		class_vector(set_index) = class_vector(set_index)+1;
		distance_vector(end+1) = MEASURE_prime(set_index,comparison_set_idx);
	end

function set_index = getSetIndex(prime_set)

	global orderedtn
	for i = 1:size(orderedtn,1)
		x = unique(orderedtn(i,:));
		if isequal(prime_set,x)
			set_index = i;
			break;
		end
	end
