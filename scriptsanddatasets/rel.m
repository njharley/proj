function relxy = rel(primex,primey)

% computes Lewin's REL between two set-classes, given as their primes, 1 x card vectors (0-11)
% Martorell, A. (2012) - Music Technology Group, Universitat Pompeu Fabra (Barcelona)

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
sub = zeros(1,351);
primebin = zeros(1,12);
primebin(prime+1) = 1;
primeor = dlmread('protoprimeOrdered.txt');
top = [1 7 26 69 135 215 281 324 343 349 350 351];
for i = 1:top(card)
    loc = unique(primeor(i,:))+1;
    primeorbin = zeros(1,12);
    primeorbin(loc) = 1; 
    % ring shift primeorbin and count inclusion matches
    for j = 0:11
         m(j+1,:) = circshift(primeorbin,[0 j]);
    end
    m = unique(m,'rows'); % to eliminate doubling tritones in primeorbin
    count = 0;
    for j = 1:size(m,1)
        if isequal(primebin&m(j,:),m(j,:))
            count = count+1;
        end
    end
    sub(i) = count;
end


