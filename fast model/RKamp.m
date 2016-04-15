function [Vamp] = RKamp(Qa, f0, df, Pin0, dPin0, d2Pin0, A0)
%% Parameter definitions
%%-------------------------------------------------------------------------
% Qa: Amplifier Q-factor
%
% f0: Natural frequency of the cavity
%
% df: Any frequency shift of the cavity due to microphonics etc
%     length should be either 1 or nsteps
%
% Pin: Power flow into the cavity from LLRF system (complex number)
%      length should be nsteps
%
% dPin0: Previous 2 derivatives of incoming power
%
% d2Pin0: Previous 2nd order derivative of incoming power
%
% A0: Initial cavity voltage (complex number)
%
%%-------------------------------------------------------------------------

% create all required input parameters
w0 = 2*pi*f0;

dt = 1/f0;
nsteps = length(Pin0) - 1;

Vamp = zeros(1,nsteps);
Vinit = A0;
Pin = Pin0(2:end);

if length(df) == 1
    w = 2*pi*df*ones(1,nsteps+1) + w0;
elseif length(df) == nsteps + 1
    w = 2*pi*df + w0;
else
    disp('WARNING: length of frequency should be 1 or nsteps');
    w = 2*pi*df(1)*ones(1,nsteps+1) + w0;
end

dw = [0 diff(w)/dt];

dPin = [dPin0(2) diff(Pin)/dt];
d2Pin = diff(dPin)/dt;
    
% Define the equations of motion for the envelope equations
Ar_dot = @(p, dp, wi, a) w0*((real(p) - imag(dp)/wi)/(2*Qa) - (1 + w0^2/wi^2)*real(a)/(4*Qa) + ((w0^2 - wi^2)/(2*w0*wi)*imag(a)));
Ai_dot = @(p, dp, wi, a) w0*((imag(p) + real(dp)/wi)/(2*Qa) - (1 + w0^2/wi^2)*imag(a)/(4*Qa) - ((w0^2 - wi^2)/(2*w0*wi)*real(a)));

for i = 0:nsteps - 1
    if i == 0
        ptemp = Pin0(i+1);
        dptemp = dPin0(1);
        wtemp = w(i+1);
        atemp = Vinit;
        k0 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L0 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        ptemp = Pin0(i+1) + dPin0(1)*dt/2;
        dptemp = dPin0(1) + d2Pin0*dt/2;
        wtemp = w(i+1) + dw(i+1)*dt/2;
        atemp = Vinit + (k0 + 1i*L0)/2;
        k1 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L1 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        ptemp = Pin0(i+1) + dPin0(1)*dt/2;
        dptemp = dPin0(1) + d2Pin0*dt/2;
        wtemp = w(i+1) + dw(i+1)*dt/2;
        atemp = Vinit + (k1 + 1i*L1)/2;
        k2 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L2 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        ptemp = Pin0(i+2);
        dptemp = dPin(i+1);
        wtemp = w(i+2);
        atemp = Vinit + k2 + 1i*L2;
        k3 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L3 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        Vamp(i+1) = Vinit + ((k0 + 2*k1 + 2*k2 + k3) + 1i*(L0 + 2*L1 + 2*L2 + L3))/6;
    else
        ptemp = Pin0(i+1);
        dptemp = dPin(i);
        wtemp = w(i+1);
        atemp = Vamp(i);
        k0 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L0 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        ptemp = Pin0(i+1) + dPin(i)*dt/2;
        dptemp = dPin(i) + d2Pin(i)*dt/2;
        wtemp = w(i+1) + dw(i+1)*dt/2;
        atemp = Vamp(i) + (k0 + 1i*L0)/2;
        k1 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L1 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        ptemp = Pin0(i+1) + dPin(i)*dt/2;
        dptemp = dPin(i) + d2Pin(i)*dt/2;
        wtemp = w(i+1) + dw(i)*dt/2;
        atemp = Vamp(i) + (k1 + 1i*L1)/2;
        k2 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L2 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        ptemp = Pin0(i+2);
        dptemp = dPin(i+1);
        wtemp = w(i+2);
        atemp = Vamp(i) + k2 + 1i*L2;
        k3 = dt*Ar_dot(ptemp, dptemp, wtemp, atemp);
        L3 = dt*Ai_dot(ptemp, dptemp, wtemp, atemp);
        
        Vamp(i+1) = Vamp(i) + ((k0 + 2*k1 + 2*k2 + k3) + 1i*(L0 + 2*L1 + 2*L2 + L3))/6;
    end
end
