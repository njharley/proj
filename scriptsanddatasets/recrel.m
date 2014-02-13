	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%% COMPUTES RECREL BASED  %%%%%%%%%%%%
	%%%%%%%%%%%% ON BUCHLER DESCRIPTION %%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function rr = recrel(primex, primey)

	cardx = length(primex);
	cardy = length(primey);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%% FIND nmax (FROM KUUSI) %%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if cardx == cardy
		nmax = cardx-1
	else
		nmax = min(cardx, cardy)
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% CREATE DATA STRUCTURE TO CONTAIN %REL VALUES %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	branch = struct([]);
	for i = 1:nmax-1
		branch(i).n = i+1;
		for j = 1:nmax-1
			branch(i).(['level' num2str(j)]) = [];
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%% COMPUTE EACH BRANCH %%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	for n = 2:nmax
		branch_number = n;
		level_number = 1;
		weight = 100; 
		sprintf('Starting branch %d', branch_number)
		branch = branchn(primex, primey, n, branch_number, level_number, branch, weight);
		sprintf('Finished branch %d', branch_number)
	end

	recrelxy = [];

	for i = 1:nmax-1
		for j = 1:nmax-1
			recrelxy(i,j) = sum(branch(i).(['level' num2str(j)]));
		end
	end

	b = []; % CREATE VALUES FOR EACH BRANCH

	for i = 1:size(recrelxy, 1)
		b(i) = prod(recrelxy(i,:));
	end

	rr = mean(b); % RECREL IS AVERAGE OF BRANCH VALUES

	

function branch = branchn(x, y, n, branch_number, level_number, branch, weight)
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% FUNCTION COMPUTES ALL THE LEVELS OF A BRANCH %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	sprintf('Branch %d Level %d', branch_number, level_number)

	if n == 1
		sprintf('n = 1. Cannot do %REL with n<2.')
		return
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% CALCULATE %REL FOR CURRENT BRANCH AND LEVEL %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[wdvt prelnxy] = preln(x,y,n);
	% INSERT WEIGHTED %REL INTO STRUCT
	[branch(branch_number-1).(['level' num2str(level_number)])(end+1)] = prelnxy*(weight/100);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%% COMPARE NON-MUTUALLY EMBEDDED SUBSETS %%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

	if n == 2
		sprintf('No further comparisons required')
		return
	else

		[notmembx notmemby wdvx_index wdvy_index] = notmemb(x, y, n); 

		if isempty(notmembx) || isempty(notmemby)
			sprintf('No further subsets to compare...')
			return
		end

		for i = 1:size(notmembx, 1)
			for j = 1:size(notmemby, 1)

				wdvx = wdvt(wdvx_index(i));
				wdvy = wdvt(wdvy_index(j));

				% CALCULATE THE WEIGHT (FROM BUCHLER)	
				weight = (wdvx*wdvy)/100;

				a = unique(notmembx(i,:));
				b = unique(notmemby(j,:));

				% RECURSIVE CALL TO BRANCHN TO ENTER LOWER LEVEL
				branch = branchn(a, b, n-1, branch_number, level_number+1, branch, weight);
			end
		end
	end