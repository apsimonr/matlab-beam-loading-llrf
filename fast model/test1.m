close all;
clear all;
clc;
% profile on;

VT = 3e6;
bcnt = 1;
tcnt = 1;
nturns = 1;
phi0 = 90;
RQ = 400;
qbunch = 18.4e-9;
quench = 0;
beamenergy = 7e12;%8e9;%

llRFon = 0;
LHe_temp = 2;
rfoff_flag = 0;

xamp = 0;%-1e-4;%1e-4;
xjit = 1e-5;
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
debugout = zeros(1,35640*nturns);
ind = 0;
cavnum = 13;
norder = 2;

tic;

[trev, LHCtrain, ~, qflag] = LHCbunchTrain(1, 1e-6, 4e8);

zamp = bphiamp*3e8/(360*4e8);
dz = 18*3e8/(360*4e8);
xvector = [xamp; 0; 0; 0; zamp; 0];
vecstore(1,:,:) = [xvector(1) + xjit*randn(1,2808);...
    xvector(2)*ones(1,2808);...
    xvector(3)*ones(1,2808);...
    xvector(4)*ones(1,2808);...
    xvector(5)*(1 + 0.01*randn(1,2808)) - dz;...
    xvector(6)*ones(1,2808)];

vecstore(2,:,:) = [xvector(1) + xjit*randn(1,2808);...
    xvector(2)*ones(1,2808);...
    xvector(3)*ones(1,2808);...
    xvector(4)*ones(1,2808);...
    xvector(5)*(1 + 0.01*randn(1,2808));...
    xvector(6)*ones(1,2808)];
vecstore(3,:,:) = [xvector(1) + xjit*randn(1,2808);...
    xvector(2)*ones(1,2808);...
    xvector(3)*ones(1,2808);...
    xvector(4)*ones(1,2808);...
    xvector(5)*(1 + 0.01*randn(1,2808)) + dz;...
    xvector(6)*ones(1,2808)];

xnom = vecstore;

qflag1(1, :) = qflag;
qflag1(2, :) = qflag;
qflag1(3, :) = qflag;

indout = 1;

for i = 1:length(LHCtrain)*nturns
    ttemp = trev*(tcnt - 1) + LHCtrain(bcnt);
    
    indstore = mod(i - 1, length(LHCtrain)) + 1;
    
    if qflag(indstore) == 1
        if qflag1(1,indstore) == 1
            xpos1(indout) = vecstore(1,1,indstore) - xnom(1,1,indstore);
            zpos1(indout) = 360*4e8*(vecstore(1,5,indstore) - xnom(1,5,indstore))/3e8;
        else
            xpos1(indout) = 0;
            zpos1(indout) = 0;
        end
        
        if qflag1(2,indstore) == 1
            xpos(indout) = vecstore(2,1,indstore) - xnom(2,1,indstore);
            zpos(indout) = 360*4e8*(vecstore(2,5,indstore) - xnom(2,5,indstore))/3e8;
            
            xout = vecstore(2,1,indstore);
            bphiout = 2*pi*4e8*vecstore(2,5,indstore)/3e8;
            indout = indout + 1;
        else
            xpos(indout) = 0;
            zpos(indout) = 0;
        end
        
        if qflag1(3,indstore) == 1
            xpos2(indout) = vecstore(3,1,indstore) - xnom(3,1,indstore);
            zpos2(indout) = 360*4e8*(vecstore(3,5,indstore) - xnom(3,5,indstore))/3e8;
        else
            xpos2(indout) = 0;
            zpos2(indout) = 0;
        end
    end
    
    [bcntout, tcntout, Vcav, fout, Vamp, Pinout, tq, fnom, debug] = BLmaster(VT, bphiout, xout, bcnt, tcnt, phi0, RQ, qbunch*qflag1(2,indstore), quench, llRFon);
    
    if qflag1(2,indstore) == 1
        pxcav = real(Vcav(1)*exp(1i*2*pi*4e8*vecstore(:,5,indstore)'/3e8))/beamenergy;
        pxideal = real(VT*exp(1i*(2*pi*4e8*vecstore(:,5,indstore)'/3e8 + phi0*pi/180)))/beamenergy;
        
        pzcav = real(1i*vecstore(:,1,indstore)'*2*pi*fout(1)/3e8*Vcav(1).*exp(1i*2*pi*4e8*vecstore(:,5,indstore)'/3e8))/beamenergy;
        pzideal = real(1i*vecstore(:,1,indstore)'*2*pi*4e8/3e8*VT.*exp(1i*(2*pi*4e8*vecstore(:,5,indstore)'/3e8 + phi0*pi/180)))/beamenergy;
        
        [vecstore(:,:,indstore), xnom(:,:,indstore)] = LHC2ndOrderMap(squeeze(vecstore(:,:,indstore))', cavnum, pxcav, pxideal, pzcav, pzideal, bcnt, tcnt, norder);
        
        for counter = 1:length(vecstore(:, 1, 1))
            if abs(vecstore(counter, 1, indstore)) >= 0.02 || abs(vecstore(counter, 3, indstore)) >= 0.02
                vecstore(counter, :, indstore) = 0;
                qflag1(counter,indstore) = 0;
            elseif qflag1(counter,indstore) == 0
                vecstore(counter, :, indstore) = 0;
            end
        end
    end
    
    if tcnt ~= tcntout
        disp(tcntout);
        tturn(tcnt) = toc;
    end
    
    if mod(bcntout, 72) == 0
        disp(bcntout);
    end
    
    bcnt = bcntout;
    tcnt = tcntout;
    Vcavout(ind+1:ind+length(Vcav)) = Vcav;
    freqout(ind+1:ind+length(Vcav)) = fout;
    Vampout(ind+1:ind+length(Vamp)) = Vamp;
    Pin(ind+1:ind+length(Vamp)) = Pinout(2:end);
    debugout(ind+1:ind+length(Vamp)) = debug(2:end);
    ind = ind + length(Vcav);
end

time = linspace(0,trev*nturns - 25e-9,length(Vcavout));

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
plot(time,mod(phase(Vcavout)*180/pi+90,360) - 180);
if quench == 1
    hold all;
    plot([tq tq], [180 -180],'-k');
end
title('Phi vs t');

figure();
plot(time,abs(Vampout).^2/(2*RQ*5e5),'-b');%,time,abs(Pin).^2/(2*RQ*5e5),'-r');
% if quench == 1
%     hold all;
%     plot([tq tq], [max(abs(Pin).^2/(2*RQ*5e5)) min(abs(Pin).^2/(2*RQ*5e5))],'-k');
% end
title('|Pamp| vs t');

figure();
plot(time,mod(phase(Vampout)*180/pi+90,360) - 180,'-b');%,time,mod(phase(Pin)*180/pi+90,360) - 180,'-r');
% if quench == 1
%     hold all;
%     plot([tq tq], [-180 180],'-k');
% end
title('Klystron phase vs t');

figure();
plot(time,freqout - fnom);
if quench == 1
    hold all;
    plot([tq tq], [max(freqout - freqout(1)) min(freqout - freqout(1))],'-k');
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

figure();
plot(time,abs(Vcavout)/VT,'-b',time,mod(phase(Vcavout)/pi + 1/2,2) - 1,'-r');

figure();
plot(debugout);

disp('The RMS phase jitter is:');
disp(std(phase(Vcavout))*180/pi);
disp('The RMS amplitude jitter is:');
disp(std(abs(Vcavout)));

quick_fudge = 0;

if quick_fudge == 1
    Vcav_KEK_4K_BLoff_RFon = Vcavout;
    Vamp_KEK_4K_BLoff_RFon = Vampout;
    df_KEK_4K_BLoff_RFon = freqout - fnom;
    xpos_KEK_4K_BLoff_RFon = xpos;
    xpos1_KEK_4K_BLoff_RFon = xpos1;
    xpos2_KEK_4K_BLoff_RFon = xpos2;
    zpos_KEK_4K_BLoff_RFon = zpos;
    delete('KEK_4K_BLoff_RFon.mat');
    save('KEK_4K_BLoff_RFon', 'Vcav_KEK_4K_BLoff_RFon', 'Vamp_KEK_4K_BLoff_RFon', 'df_KEK_4K_BLoff_RFon', 'xpos_KEK_4K_BLoff_RFon', 'xpos1_KEK_4K_BLoff_RFon', 'xpos2_KEK_4K_BLoff_RFon', 'zpos_KEK_4K_BLoff_RFon');
elseif quick_fudge == 2
    Vcav_KEK_2K_BLoff_RFon = Vcavout;
    Vamp_KEK_2K_BLoff_RFon = Vampout;
    df_KEK_2K_BLoff_RFon = freqout - fnom;
    xpos_KEK_2K_BLoff_RFon = xpos;
    xpos1_KEK_2K_BLoff_RFon = xpos1;
    xpos2_KEK_2K_BLoff_RFon = xpos2;
    zpos_KEK_2K_BLoff_RFon = zpos;
    delete('KEK_2K_BLoff_RFon.mat');
    save('KEK_2K_BLoff_RFon', 'Vcav_KEK_2K_BLoff_RFon', 'Vamp_KEK_2K_BLoff_RFon', 'df_KEK_2K_BLoff_RFon', 'xpos_KEK_2K_BLoff_RFon', 'xpos1_KEK_2K_BLoff_RFon', 'xpos2_KEK_2K_BLoff_RFon', 'zpos_KEK_2K_BLoff_RFon');
elseif quick_fudge == 3
    Vcav_LHC_4K_BLoff_RFon = Vcavout;
    Vamp_LHC_4K_BLoff_RFon = Vampout;
    df_LHC_4K_BLoff_RFon = freqout - fnom;
    xpos_LHC_4K_BLoff_RFon = xpos;
    xpos1_LHC_4K_BLoff_RFon = xpos1;
    xpos2_LHC_4K_BLoff_RFon = xpos2;
    zpos_LHC_4K_BLoff_RFon = zpos;
    delete('LHC_4K_BLoff_RFon.mat');
    save('LHC_4K_BLoff_RFon', 'Vcav_LHC_4K_BLoff_RFon', 'Vamp_LHC_4K_BLoff_RFon', 'df_LHC_4K_BLoff_RFon', 'xpos_LHC_4K_BLoff_RFon', 'xpos1_LHC_4K_BLoff_RFon', 'xpos2_LHC_4K_BLoff_RFon', 'zpos_LHC_4K_BLoff_RFon');
elseif quick_fudge == 4
    Vcav_LHC_2K_BLoff_RFon = Vcavout;
    Vamp_LHC_2K_BLoff_RFon = Vampout;
    df_LHC_2K_BLoff_RFon = freqout - fnom;
    xpos_LHC_2K_BLoff_RFon = xpos;
    xpos1_LHC_2K_BLoff_RFon = xpos1;
    xpos2_LHC_2K_BLoff_RFon = xpos2;
    zpos_LHC_2K_BLoff_RFon = zpos;
    delete('LHC_2K_BLoff_RFon.mat');
    save('LHC_2K_BLoff_RFon', 'Vcav_LHC_2K_BLoff_RFon', 'Vamp_LHC_2K_BLoff_RFon', 'df_LHC_2K_BLoff_RFon', 'xpos_LHC_2K_BLoff_RFon', 'xpos1_LHC_2K_BLoff_RFon', 'xpos2_LHC_2K_BLoff_RFon', 'zpos_LHC_2K_BLoff_RFon', 'time');
end


% profile viewer;