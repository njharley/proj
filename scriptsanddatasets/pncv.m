% returns castrens nC%vector given a an nCvector

function pncv = pncv(ncv)
	hncv = sum(ncv);
	for i = 1:length(ncv)
		if ncv(i) == 0 
			pncv(i) = 0;
		else 
			pncv(i) = ncv(i)/hncv;
		end
	end
	pncv = round(pncv*100);

