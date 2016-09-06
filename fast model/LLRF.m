function [voldout, dvoldout, Vamp, Pin0] = LLRF(Vcav, Vtarget, lpff, vold, dvold, f0, cp, ci, Qa, delV, Pmax, Pold0, dlat, noiseamp, rfoff, llrfoff)

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

Vlpf = lpfilter(Vcav, lpff, vold);

VI = real(Vlpf).*(1 + noiseamp*randn(size(Vlpf))) + 200*randn(size(Vlpf));
VQ = imag(Vlpf).*(1 + noiseamp*randn(size(Vlpf))) + 200*randn(size(Vlpf));
voldout = Vlpf(end)*(1 + noiseamp*randn(1,1));

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
    mag = abs(temp);
    phi = phase(temp);
    if mag > Pmax(i)
        PI(i) = Pmax(i)*cos(phi);
        PQ(i) = Pmax(i)*sin(phi);
    else
        PI(i) = real(temp);
        PQ(i) = imag(temp);
    end
    
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