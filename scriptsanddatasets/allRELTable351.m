function allreltable351 = allRELTable351

% computes REL(X,Y) for all set-classes (Forte's + trivial)
% output:
%   allreltable351 : 351x351 matrix of REL values
% Martorell, A. (2012) - Music Technology Group, Universitat Pompeu Fabra (Barcelona)

allreltable351 = zeros(351); % memory allocation
primeor = dlmread('protoprimeOrdered.txt');
for i = 1:351
    primei = unique(primeor(i,:));
    allreltable351(:,i) = RELTable351(primei);
end

save allreltable351.mat allreltable351