function[LHCtrain, Pold0, Vout, Vtarget, dvold, inputP, trev, qflag] = bufferwrite(VT, f0, Q0, Qe, phi0, tlat, ci, dV, bphi)

[trev, LHCtrain, ~, qflag] = LHCbunchTrain(1, tlat, f0);

QL = 1/(1/Q0 + 1/Qe);
dVcomp = dV*exp(1i*(bphi + phi0)*pi/180);
theta = 2*pi*f0*trev/length(LHCtrain)*(Q0 + Qe)/(2*Q0*Qe);

Pamp = Qe/(2*QL)*VT*exp(1i*phi0*pi/180) + Qe/(2*QL)*dVcomp/(1 - exp(theta));
nsteps = round(tlat*f0);
inputP = Pamp*ones(1,nsteps + 3);
Vout = VT*exp(1i*phi0*pi/180);
Vtarget = VT*exp(1i*phi0*pi/180);
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