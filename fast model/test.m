close all;
clear all;
clc;
% profile on;

VT = 3e6;
bcnt = 1;
tcnt = 1;
nturns = 60;
phi0 = 90;
RQ = 150;
qbunch = 18.4e-9;
quench = 0;

xout = 1e-4*ones(1,2808*nturns);
bphiout = zeros(1,2808*nturns);
tturn =zeros(1,nturns);

if exist('cavParam.mat','file') == 2
    delete('cavParam.mat');
end

if exist('LLRFParam.mat','file') == 2
    delete('LLRFParam.mat');
end

if exist('quenchQ.mat','file') == 2
    delete('quenchQ.mat');
end

Vcavout = zeros(1,35640*nturns);
Vampout = zeros(1,35640*nturns);
ind = 0;

tic;

for i = 1:2808*nturns
    [bcntout, tcntout, Vcav, fout, Vamp]= BLmaster(VT, bphiout(i), xout(i), bcnt, tcnt, phi0, RQ, qbunch, quench);
    
    if tcnt ~= tcntout
        disp(tcntout);
        tturn(tcnt) = toc;
    end
    
    if mod(bcntout,72) == 0
        disp(bcntout);
    end
    
    bcnt = bcntout;
    tcnt = tcntout;
    Vcavout(ind+1:ind+length(Vcav)) = Vcav;
    Vampout(ind+1:ind+length(Vamp)) = Vamp;
    ind = ind + length(Vcav);
end

tturn(nturns) = toc;
disp(tturn(nturns));

figure();
plot(real(Vcavout));

figure();
plot(imag(Vcavout));

figure();
plot(abs(Vcavout));

figure();
plot(phase(Vcavout)*180/pi-90);

figure();
plot(tturn);

figure();
plot(imag(Vampout));

% profile viewer;