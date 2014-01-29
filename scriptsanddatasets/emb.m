function embxy = emb(primex, primey)

primexbin = zeros(1,12);
primeybin = zeros(1,12);

primexbin(primex+1) = 1;
primeybin(primey+1) = 1;

for i = 0:11
    m(i+1,:) = circshift(primexbin, [0 i]);
end

m = unique(m, 'rows');
emb = 0;
for i = 1:size(m,1)
    if isequal(primeybin&m(i,:),m(i,:))
	emb = emb+1;
    end
end
