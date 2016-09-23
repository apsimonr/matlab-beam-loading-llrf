function [dvoldout, Vamp, Pin0] = LLRF(Vcav, Vtarget, dvold, f0, cp, ci, Qa, delV, Pmax, Pold0, dlat, sig2noise, rfoff, llrfoff)

persistent inddlat Pinout1 Pinout2

ndlat = round(dlat*f0);

if isempty(inddlat)
    inddlat = 1;
end

if isempty(Pinout1)
    Pinout1 = Pold0;
else
    Pinout1 = Pinout2;
end

if isempty(Pinout2)
    Pinout2 = Pold0;
end

Pin0 = zeros(1,length(Vcav) + 1);
Pin0(1) = Pinout1;

%%-------------------------------------------------------------------------
% Digital LPF on I and Q measurements
%%-------------------------------------------------------------------------
VI = real(Vcav) + abs(Vtarget)/sig2noise*randn(size(Vcav));
VQ = imag(Vcav) + abs(Vtarget)/sig2noise*randn(size(Vcav));

%%-------------------------------------------------------------------------
% Calculate changes to klystron power to correct for beam loading
%%-------------------------------------------------------------------------

PI = zeros(size(Vcav));
PQ = zeros(size(Vcav));

for i = 1:length(Vcav)
    if rfoff(i) == 0 && llrfoff == 0
        Idv = real(Vtarget) - VI(i);
        Qdv = imag(Vtarget) - VQ(i);
    else
        Idv = 0;
        Qdv = 0;
        delV(i) = 0;
    end
    
    dvold = Idv + 1i*Qdv + dvold;
    
    temp = real(cp)*Idv + real(ci)*real(dvold) + 1i*(imag(cp)*Qdv + imag(ci)*imag(dvold));
    PI(i) = real(temp);
    PQ(i) = imag(temp);
    
    if inddlat == ndlat
        Pinout2 = PI(i) + 1i*PQ(i);
        Pinout1 = Pinout2;
        inddlat = 1;
        Pin0(i+1) = Pinout2;
    else
        inddlat = inddlat + 1;
        Pin0(i+1) = Pinout1;
    end
end

dvoldout = dvold;

Vamp = RKamp(Qa, f0, Pin0, delV, Pold0);

for i = 1:length(Vamp)
    if abs(Vamp(i)) > Pmax
        Vamp(i) = Pmax*sign(Vamp(i));
    end
    if rfoff(i) == 1
        Vamp(i) = 0;
    end
end
        