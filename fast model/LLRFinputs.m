function [delV, delV2] = LLRFinputs(Vout, f0)

if length(Vout) == 1
    delV = [0 0];
    delV2 = 0;
else
    delV = diff(Vout(end - 2: end));
    delV2 = diff(delV)*f0;
end
end