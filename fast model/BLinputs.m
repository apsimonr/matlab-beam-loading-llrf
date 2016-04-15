function [Pin, dPin0, d2Pin0, Vinit] = BLinputs(inputP, nsteps, Vout, f0)

Pin = inputP(3:nsteps+3);
dPin0 = diff(inputP(2:nsteps+3))*f0;
d2Pin0 = diff(diff(inputP(1:nsteps+3)))*f0^2;
Vinit = Vout(end);
end