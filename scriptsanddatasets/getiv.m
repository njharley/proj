function ivx = getiv(prime)

primebin = zeros(1,12);
primebin(prime+1) = 1;
primeor = dlmread('protoprimeOrdered.txt');
tnindex = 0;

for i = 1:size(primeor,1)
    loc = unique(primeor(i,:))+1;     % remove zeros and add 1 to indicate indices for primeorbin
    primeorbin = zeros(1,12);         % initialize 12D pc vector
    primeorbin(loc) = 1;              % create 12D pc vector of primeor    
    if isequal(primebin&primeorbin,primeorbin)
       tnindex = i;
    end
end

load pcsetdata.mat
ivindex = tn2iv(tnindex, :);
ivx = orderediv(ivindex,:);
