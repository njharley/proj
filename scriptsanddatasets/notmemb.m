% RETURNS THE N-SIZED SETS WHICH 
% IN ONLY ONE OF THE SETS 

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
    a = unique(primeor(i,:));
    embAX = emb(a,primex); 
    embAY = emb(a,primey);
    if embAX == 0 && embAY > 0
        notinx(end+1,:) = primeor(i,:);
        wdvx_index(end+1) = i-(top(n-1));
    end
    if embAX > 0 && embAY == 0
    	notiny(end+1,:) = primeor(i,:);
    	wdvy_index(end+1) = i-(top(n-1));
    end
end