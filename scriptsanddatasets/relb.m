function relxy = relb(primex,primey)

% computes Lewin's REL between two set-classes, given as their primes, 1 x card vectors (0-11)
% Martorell, A. (2012) - Music Technology Group, Universitat Pompeu Fabra (Barcelona)
%% modified to add interval vector at the front of the subset vector

load pcsetdata.mat
subx = subrel(primex);
suby = subrel(primey);
num = 0;
top = max(find(subx>0,1,'last'),find(suby>0,1,'last'));
for i = 1:top
    num = num + sqrt(subx(i)*suby(i));
end
%num = dist(subx,suby');
relxy = num / sqrt(sum(subx)*sum(suby));
%-----------------------------------------------------
function sub = subrel(prime)

% computes SUB function from a set-class, given as its prime

card = size(prime,2);
if card<1 || card>12
    error('Out of cardinality range (1-12)'); return
end
% sub modified to include the interval vector on the front
sub = zeros(1,357);
sub(1:6) = nCV(prime,2);              % ncv(prime,2) returns the iv of prime (1,6)

primebin = zeros(1,12);
primebin(prime+1) = 1;                % 12D binary pc vector
primeor = dlmread('protoprimeOrdered.txt'); % primes with zero padding to 12
top = [1 7 26 69 135 215 281 324 343 349 350 351]; % row indicies of changes in cardinality
for i = 1:top(card)                   % for each prime form (row in primeor) up to the cardinality of the input set
    loc = unique(primeor(i,:))+1;     % remove zeros and add 1 to indicate indices for primeorbin
    primeorbin = zeros(1,12);         % initialize 12D pc vector
    primeorbin(loc) = 1;              % create 12D pc vector of primeor
    % ring shift primeorbin and count inclusion matches
    for j = 0:11                      % shift it 12 times for (shift 0 is itself)
         m(j+1,:) = circshift(primeorbin,[0 j]); % create row in m for each shifted primeorbin
    end
    m = unique(m,'rows');             % remove identicle rows to eliminate doubling tritones in primeorbin
    count = 0; 
    for j = 1:size(m,1)               % for each shift...
        if isequal(primebin&m(j,:),m(j,:)) % check if the primeorbin is equal to primebin
            count = count+1;          % count the number of 
        end
    end
    sub(i+6) = count;                 % start adding after the iv
end


