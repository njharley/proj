% returns the inclusion vector of n-sized subsets in primex

function nCv = ncv(primex, n)

cardx = length(primex);

if n>cardx
	error('n-sized sets are too large to be embedded'); return
end

nCv = [];

primeor = dlmread('protoprimeOrdered.txt');
top = [1 7 26 69 135 215 281 324 343 349 350 351];

A =  primeor((top(n-1)+1):top(n),:); % all primes of size n

for i = 1:size(A,1)
    a = unique(A(i,:));
    nCv(i) = emb(a,primex); 
end