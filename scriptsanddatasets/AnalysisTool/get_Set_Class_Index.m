function set_class = get_Set_Class_Index(pds,idxtn)
	
	pcs = zeros(1,12);
	pcs(find(pds)) = 1;
	pcs = fliplr(pcs);
	pcset = bi2de(pcs);
	set_class = idxtn(pcset+1);