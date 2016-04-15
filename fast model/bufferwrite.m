function[LHCtrain, Pold0, Vout, Vtarget, vold, dvold, inputP, trev] = bufferwrite(VT, f0, Q0, Qe, phi0, tlat, ci)

[trev, LHCtrain] = LHCbunchTrain(1);

tabort = trev - LHCtrain(end);
Pamp = (Q0 + Qe)/(2*Q0)*VT*exp(1i*phi0*pi/180);
nsteps = round((tlat + tabort)*f0);
inputP = Pamp*ones(1,nsteps + 3);
Vout = VT*exp(1i*phi0*pi/180);
Vtarget = VT*exp(1i*phi0*pi/180);
vold = Vout;
if real(ci) == 0 && imag(ci) ~= 0
    dvold = 1i*imag(inputP(1))/imag(ci);
elseif real(ci) == 0 && imag(ci) == 0
    dvold = 0;
elseif real(ci) ~= 0 && imag(ci) == 0
    dvold = real(inputP(1))/real(ci);
else
    dvold = real(inputP(1))/real(ci) + 1i*imag(inputP(1))/imag(ci);
end
Pold0 = inputP(1);
end