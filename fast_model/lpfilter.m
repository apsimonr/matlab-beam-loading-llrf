function yout = lpfilter(yin, cutoff, yold)

yout = zeros(size(yin));

for i = 1:length(yin)
    yout(i) = cutoff*yin(i) + (1 - cutoff)*yold;
    yold = yout(i);
end