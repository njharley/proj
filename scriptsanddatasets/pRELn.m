% returns %RELn of given x, y and n
% CASTREN, 1994

function [wdvt prelnxy] = pRELn(primex, primey, n)

	pncvx = pnCV(primex, n);
	pncvy = pnCV(primey, n);

	[dvxy dvyx] = Asymmetric_DV(pncvx, pncvy); 	% get castrens 2 asymmetric difference vectors
	
	prelnxy = sum(dvxy) + sum(dvyx); 			% card of vector
	prelnxy = prelnxy/2; 						% divide by two

	%%% output the WDV 
	[wdvt(1,:) wdvt(2,:)] = Weighted_DV(dvxy, dvyx);

	%wdvt = wdvyx+wdvxy;

% COMPUTES THE SUBSET CLASS PERCENTAGE VECTOR 
function pncv = pnCV(primex, n)

	subset_vector = nCV(primex, n);

	hncv = sum(subset_vector);
	for i = 1:length(subset_vector)
		if subset_vector(i) == 0 
			pncv(i) = 0;
		else 
			pncv(i) = subset_vector(i)/hncv;
		end
	end
	pncv = round(pncv*100);

% COMPUTES THE WEIGHTED DIFFERENCE VECTOR
function [wdvxy wdvyx] = Weighted_DV(dvxy, dvyx)
	
	wdvxy = (dvxy/sum(dvxy))*100;
	wdvxy(isnan(wdvxy)) = 0; 
	wdvyx = (dvyx/sum(dvyx))*100;
	wdvyx(isnan(wdvyx)) = 0;

% RETURNS THE ASYMMETRIC DIFFERENCE VECTOR
function [dvxy dvyx] = Asymmetric_DV(primex, primey)

	dvxy = primex - primey;
	dvyx = primey - primex;

	dvxy = asym(dvxy);
	dvyx = asym(dvyx);

function asymdv = asym(dv)
	asymdv = [];
	for i = 1:length(dv)
		if dv(i) < 0
			asymdv(i) = 0;
		else
			asymdv(i) = dv(i);
		end
	end