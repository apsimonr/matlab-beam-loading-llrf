close all;
clear all;
clc;
% profile on;

VT = 3e6;
bcnt = 1;
tcnt = 1;
nturns = 20;
phi0 = 90;
RQ = 150;
qbunch = 18.4e-9;
quench = 1;
beamenergy = 7e12;

llrfoff = 0;

xamp = 0;%1e-4;
bphiamp = 0;%0.1;
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
freqout = zeros(1,35640*nturns);
Vampout = zeros(1,35640*nturns);
xpos = zeros(1,2808*nturns);
zpos = zeros(1,2808*nturns);
xpos1 = zeros(1,2808*nturns);
zpos1 = zeros(1,2808*nturns);
xpos2 = zeros(1,2808*nturns);
zpos2 = zeros(1,2808*nturns);
Pin = zeros(1,35640*nturns);
ind = 0;
ipnum = 1;
cavnum = [13, 14];

tic;

[trev, LHCtrain, tabort, qflag] = LHCbunchTrain(1, 1e-6, 4e8);

[maps, signs] = LHCmap(ipnum);
zamp = bphiamp*3e8/(360*4e8);
dz = 90*3e8/(360*4e8);
xvector = [xamp; 0; 0; 0; zamp; 0];
vecstore(1,:,:) = [xvector(1)*ones(1,2808);...
    xvector(2)*ones(1,2808);...
    xvector(3)*ones(1,2808);...
    xvector(4)*ones(1,2808);...
    (xvector(5) - dz)*ones(1,2808);...
    xvector(6)*ones(1,2808)];

vecstore(2,:,:) = [xvector(1)*ones(1,2808);...
    xvector(2)*ones(1,2808);...
    xvector(3)*ones(1,2808);...
    xvector(4)*ones(1,2808);...
    xvector(5)*ones(1,2808);...
    xvector(6)*ones(1,2808)];

vecstore(3,:,:) = [xvector(1)*ones(1,2808);...
    xvector(2)*ones(1,2808);...
    xvector(3)*ones(1,2808);...
    xvector(4)*ones(1,2808);...
    (xvector(5) + dz)*ones(1,2808);...
    xvector(6)*ones(1,2808)];

for i = 1:length(LHCtrain)*nturns
    ttemp = trev*(tcnt - 1) + LHCtrain(bcnt);
    
    if rem(i,2808) == 0
        indstore = 2808;
    else
        indstore = rem(i,2808);
    end
    
    xpos(i) = vecstore(2,1,indstore);
    zpos(i) = 360*4e8*vecstore(2,5,indstore)/3e8;
    
    xpos1(i) = vecstore(1,1,indstore);
    zpos1(i) = 360*4e8*vecstore(1,5,indstore)/3e8;
    
    xpos2(i) = vecstore(3,1,indstore);
    zpos2(i) = 360*4e8*vecstore(3,5,indstore)/3e8;
    
    
    xout = vecstore(2,1,indstore);
    bphiout = 2*pi*4e8*vecstore(2,5,indstore)/3e8;
    [bcntout, tcntout, Vcav, fout, Vamp, Pinout, tq]= BLmaster(VT, bphiout, xout, bcnt, tcnt, phi0, RQ, qbunch, quench, llrfoff);
    
    if min(abs(cavnum - 5)) == 0 || min(abs(cavnum - 13)) == 0
        vecstore(1,2,indstore) = vecstore(1,2,indstore) + signs(1)*real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(1,5,indstore)/3e8))/beamenergy;
        vecstore(1,6,indstore) = vecstore(1,6,indstore) + signs(1)*real(1i*vecstore(1,1,indstore)*2*pi*fout(1)/3e8*Vcav(1)*exp(1i*2*pi*4e8*vecstore(1,5,indstore)/3e8))/beamenergy;
        
        vecstore(2,2,indstore) = vecstore(2,2,indstore) + signs(1)*real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(2,5,indstore)/3e8))/beamenergy;
        vecstore(2,6,indstore) = vecstore(2,6,indstore) + signs(1)*real(1i*vecstore(2,1,indstore)*2*pi*fout(1)/3e8*Vcav(1)*exp(1i*2*pi*4e8*vecstore(2,5,indstore)/3e8))/beamenergy;
        
        vecstore(3,2,indstore) = vecstore(3,2,indstore) + signs(1)*real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(3,5,indstore)/3e8))/beamenergy;
        vecstore(3,6,indstore) = vecstore(3,6,indstore) + signs(1)*real(1i*vecstore(3,1,indstore)*2*pi*fout(1)/3e8*Vcav(1)*exp(1i*2*pi*4e8*vecstore(3,5,indstore)/3e8))/beamenergy;
    else
        vecstore(1,2,indstore) = vecstore(1,2,indstore) + signs(1)*real(VT*exp(1i*(2*pi*4e8*vecstore(1,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
        vecstore(1,6,indstore) = vecstore(1,6,indstore) + signs(1)*real(1i*vecstore(1,1,indstore)*2*pi*4e8/3e8*VT*exp(1i*(2*pi*4e8*vecstore(1,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
        
        vecstore(2,2,indstore) = vecstore(2,2,indstore) + signs(1)*real(VT*exp(1i*(2*pi*4e8*vecstore(2,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
        vecstore(2,6,indstore) = vecstore(2,6,indstore) + signs(1)*real(1i*vecstore(2,1,indstore)*2*pi*4e8/3e8*VT*exp(1i*(2*pi*4e8*vecstore(2,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
        
        vecstore(3,2,indstore) = vecstore(3,2,indstore) + signs(1)*real(VT*exp(1i*(2*pi*4e8*vecstore(3,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
        vecstore(3,6,indstore) = vecstore(3,6,indstore) + signs(1)*real(1i*vecstore(3,1,indstore)*2*pi*4e8/3e8*VT*exp(1i*(2*pi*4e8*vecstore(3,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
    end
    
    
    for indmap = 1:length(maps) - 1
        vecstore(1,:,indstore) = maps{indmap}*squeeze(vecstore(1,:,indstore))';
        vecstore(2,:,indstore) = maps{indmap}*squeeze(vecstore(2,:,indstore))';
        vecstore(3,:,indstore) = maps{indmap}*squeeze(vecstore(3,:,indstore))';
        
        if cavnum(1) < 5 || cavnum(1) > 12
            indcav = mod(indmap + 13,16);
            
            if indcav == 0
                indcav = 16;
            end
        else
            indcav = indmap + 5;
        end
        
        if min(abs(cavnum - indcav)) == 0
            vecstore(1,2,indstore) = vecstore(1,2,indstore) + signs(indmap + 1)*real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(1,5,indstore)/3e8))/beamenergy;
            vecstore(1,6,indstore) = vecstore(1,6,indstore) + signs(indmap + 1)*real(1i*vecstore(1,1,indstore)*2*pi*fout(1)/3e8*Vcav(1)*exp(1i*2*pi*4e8*vecstore(1,5,indstore)/3e8))/beamenergy;
            
            vecstore(2,2,indstore) = vecstore(2,2,indstore) + signs(indmap + 1)*real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(2,5,indstore)/3e8))/beamenergy;
            vecstore(2,6,indstore) = vecstore(2,6,indstore) + signs(indmap + 1)*real(1i*vecstore(2,1,indstore)*2*pi*fout(1)/3e8*Vcav(1)*exp(1i*2*pi*4e8*vecstore(2,5,indstore)/3e8))/beamenergy;
            
            vecstore(3,2,indstore) = vecstore(3,2,indstore) + signs(indmap + 1)*real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(3,5,indstore)/3e8))/beamenergy;
            vecstore(3,6,indstore) = vecstore(3,6,indstore) + signs(indmap + 1)*real(1i*vecstore(3,1,indstore)*2*pi*fout(1)/3e8*Vcav(1)*exp(1i*2*pi*4e8*vecstore(3,5,indstore)/3e8))/beamenergy;
        else
            vecstore(1,2,indstore) = vecstore(1,2,indstore) + signs(indmap + 1)*real(VT*exp(1i*(2*pi*4e8*vecstore(1,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
            vecstore(1,6,indstore) = vecstore(1,6,indstore) + signs(indmap + 1)*real(1i*vecstore(1,1,indstore)*2*pi*4e8/3e8*VT*exp(1i*(2*pi*4e8*vecstore(1,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
            
            vecstore(2,2,indstore) = vecstore(2,2,indstore) + signs(indmap + 1)*real(VT*exp(1i*(2*pi*4e8*vecstore(2,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
            vecstore(2,6,indstore) = vecstore(2,6,indstore) + signs(indmap + 1)*real(1i*vecstore(2,1,indstore)*2*pi*4e8/3e8*VT*exp(1i*(2*pi*4e8*vecstore(2,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
            
            vecstore(3,2,indstore) = vecstore(3,2,indstore) + signs(indmap + 1)*real(VT*exp(1i*(2*pi*4e8*vecstore(3,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
            vecstore(3,6,indstore) = vecstore(3,6,indstore) + signs(indmap + 1)*real(1i*vecstore(3,1,indstore)*2*pi*4e8/3e8*VT*exp(1i*(2*pi*4e8*vecstore(3,5,indstore)/3e8 + phi0*pi/180)))/beamenergy;
        end
    end
    
    vecstore(1,:,indstore) = maps{end}*squeeze(vecstore(1,:,indstore))';
    vecstore(2,:,indstore) = maps{end}*squeeze(vecstore(2,:,indstore))';
    vecstore(3,:,indstore) = maps{end}*squeeze(vecstore(3,:,indstore))';
    
    if tcnt ~= tcntout
        disp(tcntout);
        tturn(tcnt) = toc;
    end
    
    bcnt = bcntout;
    tcnt = tcntout;
    Vcavout(ind+1:ind+length(Vcav)) = Vcav;
    freqout(ind+1:ind+length(Vcav)) = fout;
    Vampout(ind+1:ind+length(Vamp)) = Vamp;
    Pin(ind+1:ind+length(Vamp)) = Pinout(2:end);
    ind = ind + length(Vcav);
end

time = linspace(0,trev*nturns - 2.5e-9,length(Vcavout));

tturn(nturns) = toc;
disp(tturn(nturns));

figure();
plot(time,real(Vcavout));
if quench == 1
    hold all;
    plot([tq tq], [max(real(Vcavout)) min(real(Vcavout))],'-k');
end
title('Re(Vcav) vs t');

figure();
plot(time,imag(Vcavout));
if quench == 1
    hold all;
    plot([tq tq], [max(imag(Vcavout)) min(imag(Vcavout))],'-k');
end
title('Im(Vcav) vs t');

figure();
plot(time,abs(Vcavout));
if quench == 1
    hold all;
    plot([tq tq], [max(abs(Vcavout)) min(abs(Vcavout))],'-k');
end
title('|Vcav| vs t');

figure();
plot(time,phase(Vcavout)*180/pi-90);
if quench == 1
    hold all;
    plot([tq tq], [max(phase(Vcavout)*180/pi-90) min(phase(Vcavout)*180/pi-90)],'-k');
end
title('Phi vs t');

figure();
plot(time,real(Vampout),'-b',time,real(Pin),'-r');
if quench == 1
    hold all;
    plot([tq tq], [max(real(Pin)) min(real(Pin))],'-k');
end
title('Re(Vamp) vs t');

figure();
plot(time,imag(Vampout),'-b',time,imag(Pin),'-r');
if quench == 1
    hold all;
    plot([tq tq], [max(imag(Pin)) min(imag(Pin))],'-k');
end
title('Im(Vamp) vs t');

figure();
plot(time,freqout - 4e8);
if quench == 1
    hold all;
    plot([tq tq], [max(freqout - 4e8) min(freqout - 4e8)],'-k');
end
title('df vs t');

figure();
plot(linspace(time(1),time(end),length(xpos)),xpos,'-b',linspace(time(1),time(end),length(xpos1)),xpos1,'-r',linspace(time(1),time(end),length(xpos2)),xpos2,'-g');
if quench == 1
    hold all;
    plot([tq tq], [max(xpos) min(xpos)],'-k');
end
title('xpos');

figure();
plot(linspace(time(1),time(end),length(zpos)),zpos,'-b',linspace(time(1),time(end),length(zpos1)),zpos1,'-r',linspace(time(1),time(end),length(zpos2)),zpos2,'-g');
if quench == 1
    hold all;
    plot([tq tq], [max(zpos) min(zpos)],'-k');
end
title('zpos');

disp('The RMS phase jitter is:');
disp(std(phase(Vcavout))*180/pi);
disp('The RMS amplitude jitter is:');
disp(std(abs(Vcavout)));


% profile viewer;