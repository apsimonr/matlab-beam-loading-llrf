function [Q0int, Qeint, dfint] = quenchout(tq, ttran, tinterval, Q0, Q0nc, Qe, f0)
ttemp = (tinterval(1) - 1/f0):1/f0:tinterval(2);

if tq <= tinterval(1)
    Q0int = Q0 - (Q0 - Q0nc)*(1 - exp(-((ttemp - tq)/ttran)));
elseif tq <= tinterval(2)
    Q0int = zeros(size(ttemp));
    [~, tindex] = min(abs(ttemp - tq));
    Q0int(1:tindex - 1) = Q0;
    Q0int(tindex:end) = Q0 - (Q0 - Q0nc)*(1 - exp(-((ttemp(tindex:end) - tq)/ttran)));
else
    Q0int = Q0*ones(size(ttemp));
end

Qeint = Qe*ones(size(Q0int));
QL = 1./(1./Qeint + 1./Q0int);
dfint = f0*sqrt(1 - 1./QL.^2) - f0;
end