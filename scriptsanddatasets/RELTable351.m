function reltable351 = RELTable351(prime)
% Computes REL(X,prime) for all 348+3 primes (Forte's + A/B + trivial)

primeor = dlmread('protoprimeOrdered.txt');
reltable351 = zeros(351,1); % memory allocation
for i = 1:351
    primei = unique(primeor(i,:));
    primei
    prime
    reltable351(i) = rel(primei,prime);
end
