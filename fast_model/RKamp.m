function [Vamp] = RKamp(Qa, f0, Pin0, dPin0, A0)
%% Parameter definitions
%%-------------------------------------------------------------------------
% Qa: Amplifier Q-factor
%
% f0: Natural frequency of the cavity
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

dPin = [dPin0(2) diff(Pin)/dt];
    
% Define the equations of motion for the envelope equations
Ar_dot = @(p, a) w0/(2*Qa)*(real(p) - real(a));
Ai_dot = @(p, a) w0/(2*Qa)*(imag(p) - imag(a));

for i = 0:nsteps - 1
    if i == 0
        ptemp = Pin0(i+1);
        atemp = Vinit;
        k0 = dt*Ar_dot(ptemp, atemp);
        L0 = dt*Ai_dot(ptemp, atemp);
        
        ptemp = Pin0(i+1) + dPin0(1)*dt/2;
        atemp = Vinit + (k0 + 1i*L0)/2;
        k1 = dt*Ar_dot(ptemp, atemp);
        L1 = dt*Ai_dot(ptemp, atemp);
        
        ptemp = Pin0(i+1) + dPin0(1)*dt/2;
        atemp = Vinit + (k1 + 1i*L1)/2;
        k2 = dt*Ar_dot(ptemp, atemp);
        L2 = dt*Ai_dot(ptemp, atemp);
        
        ptemp = Pin0(i+2);
        atemp = Vinit + k2 + 1i*L2;
        k3 = dt*Ar_dot(ptemp, atemp);
        L3 = dt*Ai_dot(ptemp, atemp);
        
        Vamp(i+1) = Vinit + ((k0 + 2*k1 + 2*k2 + k3) + 1i*(L0 + 2*L1 + 2*L2 + L3))/6;
    else
        ptemp = Pin0(i+1);
        atemp = Vamp(i);
        k0 = dt*Ar_dot(ptemp, atemp);
        L0 = dt*Ai_dot(ptemp, atemp);
        
        ptemp = Pin0(i+1) + dPin(i)*dt/2;
        atemp = Vamp(i) + (k0 + 1i*L0)/2;
        k1 = dt*Ar_dot(ptemp, atemp);
        L1 = dt*Ai_dot(ptemp, atemp);
        
        ptemp = Pin0(i+1) + dPin(i)*dt/2;
        atemp = Vamp(i) + (k1 + 1i*L1)/2;
        k2 = dt*Ar_dot(ptemp, atemp);
        L2 = dt*Ai_dot(ptemp, atemp);
        
        ptemp = Pin0(i+2);
        atemp = Vamp(i) + k2 + 1i*L2;
        k3 = dt*Ar_dot(ptemp, atemp);
        L3 = dt*Ai_dot(ptemp, atemp);
        
        Vamp(i+1) = Vamp(i) + ((k0 + 2*k1 + 2*k2 + k3) + 1i*(L0 + 2*L1 + 2*L2 + L3))/6;
    end
end
