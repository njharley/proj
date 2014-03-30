function rr = RECREL(primex, primey)

	% ESTABLISH NMAX
	cardx = length(primex);
	cardy = length(primey);

	if cardx == cardy
		nmax = cardx-1;
	else
		nmax = min(cardx, cardy);
	end
	
	if nmax == 1
		nmax = 2;
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% CREATE DATA STRUCTURE TO CONTAIN %REL VALUES %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	branch = struct([]);
	for i = 1:nmax-1
		branch(i).n = i+1;
		for j = 1:nmax-1
			branch(i).(['level' num2str(j)]) = [];
			branch(i).(['level' num2str(j+1) 'group_size']) = [];
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

	no_of_levels = nmax-1;
	b=[];

	for i = 1:length(branch)
		for j = 0:no_of_levels-2
			branch(i) = getGroupAverages(branch(i), no_of_levels-j);
		end
		b(end+1) = branch(i).level1;
	end
	rr =  mean(b); % RECREL IS AVERAGE OF BRANCH VALUES

function branch = getGroupAverages(branch, level_number)

	values = branch.(['level' num2str(level_number)]);

	if isempty(values)
		return
	end

	groups = branch.(['level' num2str(level_number) 'group_size']);

	point = 1;
	averages = [];
	for i = 1:length(groups)
		test_group = values(point:point+groups(i)-1);
		point = point+groups(i);
		averages(end+1) = sum(test_group);
	end

	branch.(['level' num2str(level_number)]) = averages;
	branch.(['level' num2str(level_number-1)]) = branch.(['level' num2str(level_number-1)]).*averages./100;



function branch = branchn(x, y, n, branch_number, level_number, branch, weight)
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% FUNCTION COMPUTES ALL THE LEVELS OF A BRANCH %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	sprintf('Branch %d Level %d', branch_number, level_number)

	if n == 1
		%sprintf('n = 1. Cannot do %REL with n<2.')
		return
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% CALCULATE %REL FOR CURRENT BRANCH AND LEVEL %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[wdvt prelnxy] = pRELn(x,y,n);
	% INSERT WEIGHTED %REL INTO STRUCT
	[branch(branch_number-1).(['level' num2str(level_number)])(end+1)] = prelnxy*(weight/100);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%% COMPARE NON-MUTUALLY EMBEDDED SUBSETS %%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

	if n == 2
		%sprintf('No further comparisons required')
		return
	else

		[notmemby notmembx wdvx_index wdvy_index] = ccGroup(x, y, n);
		group_size = size(wdvx_index, 2) * size(wdvy_index, 2);
		[branch(branch_number-1).(['level' num2str(level_number+1) 'group_size'])(end+1)] = group_size;
		

		if isempty(notmembx) || isempty(notmemby)
			%sprintf('No further subsets to compare...')
			return
		end

		for i = 1:size(notmembx, 1)
			for j = 1:size(notmemby, 1)

				wdvx = wdvt(1,wdvx_index(i));
				wdvy = wdvt(2,wdvy_index(j));

				% CALCULATE THE WEIGHT (FROM BUCHLER)	
				weight = (wdvx*wdvy)/100;

				a = unique(notmembx(i,:));
				b = unique(notmemby(j,:));

				% RECURSIVE CALL TO BRANCHN TO ENTER LOWER LEVEL
				branch = branchn(a, b, n-1, branch_number, level_number+1, branch, weight);
			end
		end
	end

% RETURNS THE N-SIZED SETS WHICH 
% ARE IN ONLY ONE OF primex OR primey 
function [notinx notiny wdvx_index wdvy_index] = notmemb(primex,primey,n)

    cardx = size(primex, 2);
    cardy = size(primey, 2);

    membn = 0;
    primeor = dlmread('protoprimeOrdered.txt');
    top = [1 7 26 69 135 215 281 324 343 349 350 351];

    notinx = [];
    notiny = [];
    wdvx_index = [];
    wdvy_index = [];

    for i = top(n-1)+1:top(n)

        %%% GO THROUGH ALL THE PRIMES OF SIZE N

        a = unique(primeor(i,:));
        embAX = EMB(a,primex); 
        embAY = EMB(a,primey);

        %%% IF A PRIME IS IN ONLY ONE OF THE SETS
        %%% APPEND TO THE notinx/notiny
        %%% ALSO RECORD ITS DV INDEX

        if embAX == 0 && embAY > 0
            notinx(end+1,:) = primeor(i,:);
            wdvx_index(end+1) = i-(top(n-1)); 
        end

        if embAX > 0 && embAY == 0
    	   notiny(end+1,:) = primeor(i,:);
    	   wdvy_index(end+1) = i-(top(n-1));
        end
    end