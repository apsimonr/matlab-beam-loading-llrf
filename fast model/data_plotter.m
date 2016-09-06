close all;
clear all;

% load all the data
load('LHC_4K');
load('LHC_2K');
load('KEK_4K');
load('KEK_2K');

load('LHC_4K_RFon');
load('LHC_2K_RFon');
load('KEK_4K_RFon');
load('KEK_2K_RFon');

load('LHC_4K_BLoff');
load('LHC_2K_BLoff');
load('KEK_4K_BLoff');
load('KEK_2K_BLoff');

load('LHC_4K_BLoff_RFon');
load('LHC_2K_BLoff_RFon');
load('KEK_4K_BLoff_RFon');
load('KEK_2K_BLoff_RFon');

time = time*1e3;
tq = 0.2; % in ms

% plot all the data as comparison
% Vcav components
figure();
subplot(2,2,1);
plot(time,real(Vcav_KEK_4K)/1e6,'-b',time,real(Vcav_LHC_4K)/1e6,'-r',[tq,tq],[-3,3.5],'-k');
title('LHe at 4K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('Re(Vcav) [MV]');
subplot(2,2,3);
plot(time,real(Vcav_KEK_2K)/1e6,'-b',time,real(Vcav_LHC_2K)/1e6,'-r',[tq,tq],[-0.15,0.01],'-k');
title('LHe at 2K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('Re(Vcav) [MV]');
subplot(2,2,2);
plot(time,imag(Vcav_KEK_4K)/1e6,'-b',time,imag(Vcav_LHC_4K)/1e6,'-r',[tq,tq],[-3,3.5],'-k');
title('LHe at 4K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('Im(Vcav) [MV]');
subplot(2,2,4);
plot(time,imag(Vcav_KEK_2K)/1e6,'-b',time,imag(Vcav_LHC_2K)/1e6,'-r',[tq,tq],[0,3.5],'-k');
title('LHe at 2K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('Im(Vcav) [MV]');

% Vcav amplitude and phase

phase_KEK_4K = mod(phase(Vcav_KEK_4K)*180/pi+90,360) - 180;
phase_KEK_2K = mod(phase(Vcav_KEK_2K)*180/pi+90,360) - 180;
phase_LHC_4K = mod(phase(Vcav_LHC_4K)*180/pi+90,360) - 180;
phase_LHC_2K = mod(phase(Vcav_LHC_2K)*180/pi+90,360) - 180;

figure();
subplot(2,2,1);
plot(time,abs(Vcav_KEK_4K)/1e6,'-b',time,abs(Vcav_LHC_4K)/1e6,'-r', [tq, tq], [3.5, 0], '-k');
title('LHe at 4K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('|Vcav| [MV]');
subplot(2,2,2);
plot(time,abs(Vcav_KEK_2K)/1e6,'-b',time,abs(Vcav_LHC_2K)/1e6,'-r', [tq, tq], [3.5, 0], '-k');
title('LHe at 2K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('|Vcav| [MV]');
subplot(2,2,3);
plot(time,phase_KEK_4K,'-b',time,phase_LHC_4K,'-r', [tq, tq], [180, -180], '-k');
title('LHe at 4K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('phase shift [deg]');
subplot(2,2,4);
plot(time,phase_KEK_2K,'-b',time,phase_LHC_2K,'-r', [tq, tq], [180, -180], '-k');
title('LHe at 2K');
legend('KEKB cavity', 'HL-LHC cavity', 'Quench starts');
xlabel('time [ms]');
ylabel('phase shift [deg]');

% normalised amplitude and phase
figure();
subplot(2,2,1);
plot(time,abs(Vcav_KEK_4K)/1e6,'-b',time,phase_KEK_4K/180,'-r', [tq, tq], [1.1, -1.1], '-k');
title('KEKB cavity, LHe at 4K');
legend('normalised amplitude', 'normalised phase', 'Quench starts');
xlabel('time [ms]');
ylabel('signal [A.U.]');
subplot(2,2,2);
plot(time,abs(Vcav_KEK_2K)/1e6,'-b',time,phase_KEK_2K/180,'-r', [tq, tq], [1.1, -1.1], '-k');
title('KEKB cavity, LHe at 2K');
legend('normalised amplitude', 'normalised phase', 'Quench starts');
xlabel('time [ms]');
ylabel('signal [A.U.]');
subplot(2,2,3);
plot(time,abs(Vcav_LHC_4K)/3e6,'-b',time,phase_LHC_4K/180,'-r', [tq, tq], [1.1, -1.1], '-k');
title('HL-LHC cavity, LHe at 4K');
legend('normalised amplitude', 'normalised phase', 'Quench starts');
xlabel('time [ms]');
ylabel('signal [A.U.]');
subplot(2,2,4);
plot(time,abs(Vcav_LHC_2K)/3e6,'-b',time,phase_LHC_2K/180,'-r', [tq, tq], [1.1, -1.1], '-k');
title('HL-LHC cavity, LHe at 2K');
legend('normalised amplitude', 'normalised phase', 'Quench starts');
xlabel('time [ms]');
ylabel('signal [A.U.]');

% x positions
figure();
subplot(2,2,1);
plot(linspace(time(1),time(end),length(xpos1_KEK_4K)), xpos1_KEK_4K*1e3, '-r',...
    linspace(time(1),time(end),length(xpos_KEK_4K)), xpos_KEK_4K*1e3, '-b',...
    linspace(time(1),time(end),length(xpos2_KEK_4K)), xpos2_KEK_4K*1e3, '-g');
title('KEKB cavity at 4K');
legend('x @ z = -\sigma_{z}', 'x @ z = 0', 'x @ z = \sigma_{z}');
xlabel('time [ms]');
ylabel('x position [mm]');
subplot(2,2,2);
plot(linspace(time(1),time(end),length(xpos1_KEK_2K)), xpos1_KEK_2K*1e3, '-r',...
    linspace(time(1),time(end),length(xpos_KEK_2K)), xpos_KEK_2K*1e3, '-b',...
    linspace(time(1),time(end),length(xpos2_KEK_2K)), xpos2_KEK_2K*1e3, '-g');
title('KEKB cavity at 2K');
legend('x @ z = -\sigma_{z}', 'x @ z = 0', 'x @ z = \sigma_{z}');
xlabel('time [ms]');
ylabel('x position [mm]');
subplot(2,2,3);
plot(linspace(time(1),time(end),length(xpos1_LHC_4K)), xpos1_LHC_4K*1e3, '-r',...
    linspace(time(1),time(end),length(xpos_LHC_4K)), xpos_LHC_4K*1e3, '-b',...
    linspace(time(1),time(end),length(xpos2_LHC_4K)), xpos2_LHC_4K*1e3, '-g');
title('HL-LHC cavity at 4K');
legend('x @ z = -\sigma_{z}', 'x @ z = 0', 'x @ z = \sigma_{z}');
xlabel('time [ms]');
ylabel('x position [mm]');
subplot(2,2,4);
plot(linspace(time(1),time(end),length(xpos1_LHC_2K)), xpos1_LHC_2K*1e3, '-r',...
    linspace(time(1),time(end),length(xpos_LHC_2K)), xpos_LHC_2K*1e3, '-b',...
    linspace(time(1),time(end),length(xpos2_LHC_2K)), xpos2_LHC_2K*1e3, '-g');
title('HL-LHC cavity at 2K');
legend('x @ z = -\sigma_{z}', 'x @ z = 0', 'x @ z = \sigma_{z}');
xlabel('time [ms]');
ylabel('x position [mm]');

% frequency shift
figure();
subplot(1,2,1);
plot(time,df_KEK_4K,'-b',time,df_LHC_4K,'-r');
title('LHe at 4K');
legend('KEKB cavity', 'HL-LHC cavity');
xlabel('time [ms]');
ylabel('frequency shift [Hz]');
subplot(1,2,2);
plot(time,df_KEK_2K,'-b',time,df_LHC_2K,'-r');
title('LHe at 2K');
legend('KEKB cavity', 'HL-LHC cavity');
xlabel('time [ms]');
ylabel('frequency shift [Hz]');

% try to produce comparision plots

% components of Vcav
figure();
subplot(2,2,1);
plot(time,real(Vcav_KEK_4K)/1e6,'-b',time,real(Vcav_KEK_4K_RFon)/1e6,'-r',time,real(Vcav_KEK_4K_BLoff)/1e6,'-g',time,real(Vcav_KEK_4K_BLoff_RFon)/1e6,'-k');
title('KEKB cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Re(Vcav) [MV]');
subplot(2,2,2);
plot(time,imag(Vcav_KEK_4K)/1e6,'-b',time,imag(Vcav_KEK_4K_RFon)/1e6,'-r',time,imag(Vcav_KEK_4K_BLoff)/1e6,'-g',time,imag(Vcav_KEK_4K_BLoff_RFon)/1e6,'-k');
title('KEKB cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Im(Vcav) [MV]');
subplot(2,2,3);
plot(time,real(Vcav_LHC_4K)/1e6,'-b',time,real(Vcav_LHC_4K_RFon)/1e6,'-r',time,real(Vcav_LHC_4K_BLoff)/1e6,'-g',time,real(Vcav_LHC_4K_BLoff_RFon)/1e6,'-k');
title('HL-LHC cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Re(Vcav) [MV]');
subplot(2,2,4);
plot(time,imag(Vcav_LHC_4K)/1e6,'-b',time,imag(Vcav_LHC_4K_RFon)/1e6,'-r',time,imag(Vcav_LHC_4K_BLoff)/1e6,'-g',time,imag(Vcav_LHC_4K_BLoff_RFon)/1e6,'-k');
title('HL-LHC cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Im(Vcav) [MV]');

phase_KEK_4K_RFon = mod(phase(Vcav_KEK_4K_RFon)*180/pi+90,360) - 180;
phase_KEK_2K_RFon = mod(phase(Vcav_KEK_2K_RFon)*180/pi+90,360) - 180;
phase_LHC_4K_RFon = mod(phase(Vcav_LHC_4K_RFon)*180/pi+90,360) - 180;
phase_LHC_2K_RFon = mod(phase(Vcav_LHC_2K_RFon)*180/pi+90,360) - 180;

phase_KEK_4K_BLoff = mod(phase(Vcav_KEK_4K_BLoff)*180/pi+90,360) - 180;
phase_KEK_2K_BLoff = mod(phase(Vcav_KEK_2K_BLoff)*180/pi+90,360) - 180;
phase_LHC_4K_BLoff = mod(phase(Vcav_LHC_4K_BLoff)*180/pi+90,360) - 180;
phase_LHC_2K_BLoff = mod(phase(Vcav_LHC_2K_BLoff)*180/pi+90,360) - 180;

phase_KEK_4K_BLoff_RFon = mod(phase(Vcav_KEK_4K_BLoff_RFon)*180/pi+90,360) - 180;
phase_KEK_2K_BLoff_RFon = mod(phase(Vcav_KEK_2K_BLoff_RFon)*180/pi+90,360) - 180;
phase_LHC_4K_BLoff_RFon = mod(phase(Vcav_LHC_4K_BLoff_RFon)*180/pi+90,360) - 180;
phase_LHC_2K_BLoff_RFon = mod(phase(Vcav_LHC_2K_BLoff_RFon)*180/pi+90,360) - 180;

figure();
subplot(2,2,1);
plot(time,abs(Vcav_KEK_4K)/1e6,'-b',time,abs(Vcav_KEK_4K_RFon)/1e6,'-r',time,abs(Vcav_KEK_4K_BLoff)/1e6,'-g',time,abs(Vcav_KEK_4K_BLoff_RFon)/1e6,'-k');
title('KEKB cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('|Vcav| [MV]');
subplot(2,2,2);
plot(time,phase_KEK_4K,'-b',time,phase_KEK_4K_RFon,'-r',time,phase_KEK_4K_BLoff,'-g',time,phase_KEK_4K_BLoff_RFon,'-k',time,phase_KEK_4K_BLoff,'-g');
title('KEKB cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('phase shift [deg]');
subplot(2,2,3);
plot(time,abs(Vcav_LHC_4K)/1e6,'-b',time,abs(Vcav_LHC_4K_RFon)/1e6,'-r',time,abs(Vcav_LHC_4K_BLoff)/1e6,'-g',time,abs(Vcav_LHC_4K_BLoff_RFon)/1e6,'-k');
title('HL-LHC cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('|Vcav| [MV]');
subplot(2,2,4);
plot(time,phase_LHC_4K,'-b',time,phase_LHC_4K_RFon,'-r',time,phase_LHC_4K_BLoff,'-g',time,phase_LHC_4K_BLoff_RFon,'-k',time,phase_LHC_4K_BLoff,'-g');
title('HL-LHC cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('phase shift [deg]');

figure();
subplot(2,2,1);
plot(time,real(Vcav_KEK_2K)/1e6,'-b',time,real(Vcav_KEK_2K_RFon)/1e6,'-r',time,real(Vcav_KEK_2K_BLoff)/1e6,'-g',time,real(Vcav_KEK_2K_BLoff_RFon)/1e6,'-k');
title('KEKB cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Re(Vcav) [MV]');
subplot(2,2,2);
plot(time,imag(Vcav_KEK_2K)/1e6,'-b',time,imag(Vcav_KEK_2K_RFon)/1e6,'-r',time,imag(Vcav_KEK_2K_BLoff)/1e6,'-g',time,imag(Vcav_KEK_2K_BLoff_RFon)/1e6,'-k');
title('KEKB cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Im(Vcav) [MV]');
subplot(2,2,3);
plot(time,real(Vcav_LHC_2K)/1e6,'-b',time,real(Vcav_LHC_2K_RFon)/1e6,'-r',time,real(Vcav_LHC_2K_BLoff)/1e6,'-g',time,real(Vcav_LHC_2K_BLoff_RFon)/1e6,'-k');
title('HL-LHC cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Re(Vcav) [MV]');
subplot(2,2,4);
plot(time,imag(Vcav_LHC_2K)/1e6,'-b',time,imag(Vcav_LHC_2K_RFon)/1e6,'-r',time,imag(Vcav_LHC_2K_BLoff)/1e6,'-g',time,imag(Vcav_LHC_2K_BLoff_RFon)/1e6,'-k');
title('HL-LHC cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('Im(Vcav) [MV]');

figure();
subplot(2,2,1);
plot(time,abs(Vcav_KEK_2K)/1e6,'-b',time,abs(Vcav_KEK_2K_RFon)/1e6,'-r',time,abs(Vcav_KEK_2K_BLoff)/1e6,'-g',time,abs(Vcav_KEK_2K_BLoff_RFon)/1e6,'-k');
title('KEKB cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('|Vcav| [MV]');
subplot(2,2,2);
plot(time,phase_KEK_2K,'-b',time,phase_KEK_2K_RFon,'-r',time,phase_KEK_2K_BLoff,'-g',time,phase_KEK_2K_BLoff_RFon,'-k',time,phase_KEK_2K_BLoff,'-g');
title('KEKB cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('phase shift [deg]');
subplot(2,2,3);
plot(time,abs(Vcav_LHC_2K)/1e6,'-b',time,abs(Vcav_LHC_2K_RFon)/1e6,'-r',time,abs(Vcav_LHC_2K_BLoff)/1e6,'-g',time,abs(Vcav_LHC_2K_BLoff_RFon)/1e6,'-k');
title('HL-LHC cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('|Vcav| [MV]');
subplot(2,2,4);
plot(time,phase_LHC_2K,'-b',time,phase_LHC_2K_RFon,'-r',time,phase_LHC_2K_BLoff,'-g',time,phase_LHC_2K_BLoff_RFon,'-k',time,phase_LHC_2K_BLoff,'-g');
title('HL-LHC cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('phase shift [deg]');

figure();
subplot(2,2,1);
plot(time,df_KEK_4K,'-b',time,df_KEK_4K_RFon,'-r',time,df_KEK_4K_BLoff,'-g',time,df_KEK_4K_BLoff_RFon,'-k');
title('KEKB cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('frequency shift [Hz]');
subplot(2,2,2);
plot(time,df_KEK_2K,'-b',time,df_KEK_2K_RFon,'-r',time,df_KEK_2K_BLoff,'-g',time,df_KEK_2K_BLoff_RFon,'-k');
title('KEKB cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('frequency shift [Hz]');
subplot(2,2,3);
plot(time,df_LHC_4K,'-b',time,df_LHC_4K_RFon,'-r',time,df_LHC_4K_BLoff,'-g',time,df_LHC_4K_BLoff_RFon,'-k');
title('HL-LHC cavity, LHe at 4K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('frequency shift [Hz]');
subplot(2,2,4);
plot(time,df_LHC_2K,'-b',time,df_LHC_2K_RFon,'-r',time,df_LHC_2K_BLoff,'-g',time,df_LHC_2K_BLoff_RFon,'-k');
title('HL-LHC cavity, LHe at 2K');
legend('RF off, BL on (nominal)', 'RF on, BL on', 'RF off, BL off', 'RF on, BL off');
xlabel('time [ms]');
ylabel('frequency shift [Hz]');