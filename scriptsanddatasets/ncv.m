% returns the inclusion vector of n-sized subsets in primex

function nCv = ncv(primex, n)

cardx = length(primex);

primeor = dlmread('protoprimeOrdered.txt');
top = [1 7 26 69 135 215 281 324 343 349 350 351];
A =  primeor((top(n-1)+1):top(n),:);

nCv = [];

for i = 1:size(A,1)
    a = unique(A(i,:));
    nCv(i) = emb(a,primex); 
end