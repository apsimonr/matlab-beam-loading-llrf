function delV = LLRFinputs(Vout, f0)

if length(Vout) == 1
    delV = [0 0];
else
    delV = diff(Vout(end - 2: end))*f0;
end
end