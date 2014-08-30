load ../pcsetdata
load cardtn
load ../TotalMeasuresPrime



nmat = readmidi('../wtc_midi/Wtci-01-C-a.mid');
%nmat = midiWindow(nmat,0,16,'beat');
nmat = quantize(nmat,1/16,1/16,1/16);

beats_per_bar = 4;
duration_beats = max(unique(nmat(:,1)+nmat(:,2)));
duration_bars = (duration_beats/beats_per_bar)+1;

win = 16;
hop = 16;

[windows_sys scs_sys] = SegmentA(nmat, idxtn);
[windows_win scs_win] = SegmentB(nmat, win, hop, idxtn, duration_beats);

[sc_seg_size_avg sc_seg_size_std card_seg_size_avg card_seg_size_std] = calc_Seg_Size(scs_sys, windows_sys, cardtn);

class_matrix_sys = calc_Class_Matrix(windows_sys, scs_sys);
class_vector_sys = calc_Class_Vector(class_matrix_sys, duration_beats);

class_matrix_win = calc_Class_Matrix(windows_win, scs_win);
class_vector_win = calc_Class_Vector(class_matrix_win, duration_beats);


comparison_set = 176;

selected_measures = [1 0 0 0 0 0 0 0];
measures = RECREL_prime;%AllTotalMeasures(:,:,find(selected_measures));
colours = {'-k';'-y';'-m';'-c';'-r';'-g';'-b';'-k';};

[dv] = calc_Distance_Vector(scs_win, measures, comparison_set, hop, beats_per_bar); size(dv);
[acf] = calc_Autocorr(dv); size(acf);
[dif] = calc_Diff(dv); size(dif);
[ssm] = calc_SSM(scs_win, measures(:,:,1));

bar_ticks = 1:4:duration_bars;
time = (((1:length(scs_win)).*hop)./beats_per_bar)+1;



figure(); 
subplot(3,1,1); plot(time, dv); xlim([1 duration_bars]); ylim([0 100]);
set(gca, 'XTick', bar_ticks); grid on;
subplot(3,1,2); plot(time,acf); xlim([1 duration_bars]);
set(gca, 'XTick', bar_ticks); grid on;
subplot(3,1,3); plot(time(1:end-1),dif); xlim([1 duration_bars]);
set(gca, 'XTick', bar_ticks); grid on;

figure();
cm_plot = newplot;
cm_plot = plot_Class_Matrix(class_matrix_sys,cm_plot,'b');
hold on;
cm_plot = plot_Class_Matrix(class_matrix_win,cm_plot,'-r');
ylim(cm_plot,[0 351]); xlim(cm_plot, [1 duration_bars])
set(cm_plot, 'XTick', bar_ticks); grid on;

figure();

cv_plot = newplot;
cv_plot = plot_Class_Vector(class_vector_sys,cv_plot);
hold on;
plot(class_vector_win,'r', 'linewidth',2)

figure()
subplot(2,1,1);
bar(sc_seg_size_avg);
hold on;
h=errorbar(1:351,sc_seg_size_avg,sc_seg_size_std,'r'); 
set(h,'linestyle','none'); errorbar_tick(h, 500); ylim([0 max(sc_seg_size_avg)]);
subplot(2,1,2);
bar(card_seg_size_avg);
hold on;
h=errorbar(1:12,card_seg_size_avg,card_seg_size_std,'r'); 
set(h,'linestyle','none'); errorbar_tick(h, 500); ylim([0 max(card_seg_size_avg)]);





