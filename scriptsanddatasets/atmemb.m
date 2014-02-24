function atmembxy = ATMEMB(primex, primey)

cardx = size(primex, 2);
cardy = size(primey, 2);

if cardx<1 || cardx>12
    error('X out of cardinality range (1-12)'); return
end

if cardy<1 || cardy>12
    error('Y out of cardinality range (1-12)'); return
end

    atmembxy = (TMEMB(primex,primey))/((2^cardx)+(2^cardy)-(cardx + cardy + 2));
