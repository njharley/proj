function membn = MEMBn(primex,primey,n)

cardx = size(primex, 2);
cardy = size(primey, 2);

if cardx<1 || cardx>12
    error('X out of cardinality range (1-12)'); return
end

if cardy<1 || cardy>12
    error('Y out of cardinality range (1-12)'); return
end

if n<1 || n>12 
  error('n out of cardinality range (1-12)'); return
end

if n>cardx || n> cardy
   error('n must be smaller than X and Y'); return
end

membn = 0;
primeor = dlmread('protoprimeOrdered.txt');
top = [1 7 26 69 135 215 281 324 343 349 350 351];
A =  primeor((top(n-1)+1):top(n),:);
for i = 1:size(A,1)
    a = unique(A(i,:));
    embAX = EMB(a,primex); 
    embAY = EMB(a,primey);
    if embAX ~= 0 && embAY ~= 0
        membn = membn + embAX + embAY;
    end
end
