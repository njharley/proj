% reuturns castrens weighted difference vector

function [wdvxy wdvyx] = wdv(dvxy, dvyx)
	wdvxy = (dvxy/sum(dvxy))*100;
	wdvyx = (dvyx/sum(dvyx))*100;