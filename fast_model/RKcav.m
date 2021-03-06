function Vcav = RKcav(Q0, Qe, f0, dfint, tinterval, Pin0, dPin0, d2Pin0, Vinit, bphi, dV, phi0, Kl, df, Vtarget)
%% Parameter definitions
%%-------------------------------------------------------------------------
% Q0: Q0 of the cavity
%
% Qe: External Q of the cavity
%
% f0: Natural frequency of the cavity
%
% df: Any frequency shift of the cavity due to microphonics etc
%     length should be either 1 or nsteps
%
% tinterval: [tmin tmax]
%
% Pin: Power flow into the cavity from LLRF system (complex number)
%      length should be either 1 or nsteps
%
% A0: Initial cavity voltage (complex number)
%
% bphi: Phase of the bunch wrt peak transverse voltage (in degrees)
%
% dV: change in cavity voltage due to bunch
%
%%-------------------------------------------------------------------------

% create all required input parameters
QL = 1./(1./Q0 + 1./Qe);
w0 = 2*pi*f0;

dt = 1/f0;
nsteps = round(abs(tinterval(2) - tinterval(1))/dt) + 1;

Vcav = zeros(1,nsteps);

if length(dfint) == 1
    w = 2*pi*dfint*ones(size(QL)) + w0 + 2*pi*df;
elseif length(dfint) == length(QL)
    w = 2*pi*dfint + w0 + 2*pi*df;
else
    disp('WARNING: length of frequency should be 1 or nsteps');
    w = 2*pi*dfint(1)*ones(size(QL)) + w0 + 2*pi*df;
end

dw = diff(w)/dt;
    
% Define the equations of motion for the envelope equations
Ar_dot = @(p, dp, wi, a, Qet, QLt) w0*((real(p) - imag(dp)/wi)/Qet - (1 + w0^2/wi^2)*real(a)/(4*QLt) + ((w0^2 - wi^2)/(2*w0*wi)*imag(a)));
Ai_dot = @(p, dp, wi, a, Qet, QLt) w0*((imag(p) + real(dp)/wi)/Qet - (1 + w0^2/wi^2)*imag(a)/(4*QLt) - ((w0^2 - wi^2)/(2*w0*wi)*real(a)));

for i = 0:nsteps - 1
    if i == 0
        
        ptemp = Pin0(i+1);
        dptemp = dPin0(i+1);
        atemp = Vinit;
        wtemp = w(i+1) - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+1);
        QLtemp = QL(i+1);
        k0 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L0 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        ptemp = Pin0(i+1) + dPin0(i+1)*dt/2;
        dptemp = dPin0(i+1) + d2Pin0(i+1)*dt/2;
        atemp = Vinit + (k0 + 1i*L0)/2;
        wtemp = w(i+1) + dw(i+1)*dt/2 - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+1) + diff(Qe(i+1:i+2))/2;
        QLtemp = QL(i+1) + diff(QL(i+1:i+2))/2;
        k1 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L1 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        ptemp = Pin0(i+1) + dPin0(i+1)*dt/2;
        dptemp = Pin0(i+1) + d2Pin0(i+1)*dt/2;
        atemp = Vinit + (k1 + 1i*L1)/2;
        wtemp = w(i+1) + dw(i+1)*dt/2 - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+1) + diff(Qe(i+1:i+2))/2;
        QLtemp = QL(i+1) + diff(QL(i+1:i+2))/2;
        k2 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L2 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        ptemp = Pin0(i+2);
        dptemp = dPin0(i+2);
        atemp = Vinit + k2 + 1i*L2;
        wtemp = w(i+2) - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+2);
        QLtemp = QL(i+2);
        k3 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L3 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        Vcav(i+1) = Vinit + ((k0 + 2*k1 + 2*k2 + k3) + 1i*(L0 + 2*L1 + 2*L2 + L3))/6 + dV*exp(1i*(bphi + phi0)*pi/180);
    else
        
        ptemp = Pin0(i+1);
        dptemp = dPin0(i+1);
        atemp = Vcav(i);
        wtemp = w(i+1) - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+1);
        QLtemp = QL(i+1);
        k0 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L0 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        ptemp = Pin0(i+1) + dPin0(i+1)*dt/2;
        dptemp = dPin0(i+1) + d2Pin0(i+1)*dt/2;
        atemp = Vcav(i) + (k0 + 1i*L0)/2;
        wtemp = w(i+1) + dw(i+1)*dt/2 - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+1) + diff(Qe(i+1:i+2))/2;
        QLtemp = QL(i+1) + diff(QL(i+1:i+2))/2;
        k1 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L1 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        ptemp = Pin0(i+1) + dPin0(i+1)*dt/2;
        dptemp = dPin0(i+1) + d2Pin0(i+1)*dt/2;
        atemp = Vcav(i) + (k1 + 1i*L1)/2;
        wtemp = w(i+1) + dw(i+1)*dt/2 - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+1) + diff(Qe(i+1:i+2))/2;
        QLtemp = QL(i+1) + diff(QL(i+1:i+2))/2;
        k2 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L2 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        ptemp = Pin0(i+2);
        dptemp = dPin0(i+2);
        atemp = Vcav(i) + k2 + 1i*L2;
        wtemp = w(i+2) - Kl*(abs(atemp)^2 - abs(Vtarget)^2)/1e12;
        Qetemp = Qe(i+2);
        QLtemp = QL(i+2);
        k3 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        L3 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp, Qetemp, QLtemp);
        
        Vcav(i+1) = Vcav(i) + ((k0 + 2*k1 + 2*k2 + k3) + 1i*(L0 + 2*L1 + 2*L2 + L3))/6;
    end
end
