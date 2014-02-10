% returns the n-sized entries from primeor which are not mutally embedded in x and y

function [notinx notiny] = notmemb(primex,primey,n)

cardx = size(primex, 2);
cardy = size(primey, 2);

membn = 0;
primeor = dlmread('protoprimeOrdered.txt');
top = [1 7 26 69 135 215 281 324 343 349 350 351];

notinx = [];
notiny = [];

for i = top(n-1)+1:top(n)
    a = unique(primeor(i,:));
    embAX = emb(a,primex); 
    embAY = emb(a,primey);
    if embAX == 0 && embAY > 0
        notinx(end+1,:) = primeor(i,:);
    end
    if embAX > 0 && embAY == 0
    	notiny(end+1,:) = primeor(i,:);
    end
end