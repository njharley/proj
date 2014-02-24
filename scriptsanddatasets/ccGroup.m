function [notinx notiny wdvx_index wdvy_index] = ccGroup(primex,primey,n)

	pncvx = pnCV(primex, n);
	pncvy = pnCV(primey, n);

	[dv(1,:) dv(2,:)] = Asymmetric_DV(pncvx, pncvy);

	wdvx_index = find(dv(1,:));
	wdvy_index = find(dv(2,:));

	primeor = dlmread('protoprimeOrdered.txt');
    top = [1 7 26 69 135 215 281 324 343 349 350 351];

    a = primeor(top(n-1)+1:top(n),:);

	difference_group_x = a(wdvx_index,:);
	difference_group_y = a(wdvy_index,:);

	notinx = difference_group_y;
	notiny = difference_group_x;

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
	wdvyx = (dvyx/sum(dvyx))*100;

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