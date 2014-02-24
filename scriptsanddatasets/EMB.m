function embxy = EMB(primex, primey)

	cardx = size(primex, 2);
	cardy = size(primey, 2);

	if cardx<1 || cardx>12
	    error('X out of cardinality range (1-12)'); return
	end

	if cardy<1 || cardy>12
	    error('Y out of cardinality range (1-12)'); return
	end

	if cardx > cardy
	    warning('x is too small to be embedded in y')
	    embxy = 0;
	else
		embxy = 0;
		primexbin = zeros(1,12);
		primeybin = zeros(1,12);

		primexbin(primex+1) = 1;
		primeybin(primey+1) = 1;

		for i = 0:11
	    	m(i+1,:) = circshift(primexbin, [0 i]);
		end

		m = unique(m, 'rows');
		for i = 1:size(m,1)
	    	if isequal(primeybin&m(i,:),m(i,:))
				embxy = embxy+1;
			end
		end
	end