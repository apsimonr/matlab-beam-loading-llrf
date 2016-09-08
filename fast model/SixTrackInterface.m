close all;
clear all; %#ok<CLSCR>
clc;

%% initial parameters
sim_type = 0; % LH-LHC or KEKB-like cavity
LHe_temp = 2; % helium temperature, choose 2K or 4K

if sim_type == 0
    % HL-LHC crab cavity
    VT = 3e6;
    RQ = 400;
elseif sim_type == 1;
    % KEKB crab cavity
    VT = 1e6;
    RQ = 50;
end

fcav = 4e8;
phi0 = 90;
llrfoff = 0;
rfoff_flag = 0; % turn off the RF when quench is detected

llrf_lat = 2e-6; % low level RF latency

[trev, LHCtrain, ~, qflag] = LHCbunchTrain(1, llrf_lat, fcav);

qbunch = 18.4e-9;
quench = 0;

qjit = 0.01;

qoutput = qbunch*(1 + qjit*randn(size(qflag)));

bcnt = 1;
tcnt = 1;
nturns = 40;
delfiles = 0;

%% delete parameter files if required
if exist('cavParam.mat','file') == 2 && delfiles == 1
    delete('cavParam.mat');
end

if exist('LLRFParam.mat','file') == 2 && delfiles == 1
    delete('LLRFParam.mat');
end

if exist('quenchQ.mat','file') == 2 && delfiles == 1
    delete('quenchQ.mat');
end

%% setup TCP IP protocol
hostname = '0.0.0.0';
portnum = 4012;
outbuffersize = 512;
inbuffersize = 512;
connect = 1;

dataout = [VT, phi0, fcav];
[xout, bphiout, qout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout, LHCtrain, qflag);

%% run for other bunches
for i = 1:length(qflag)*nturns - 1
%     [bcntout, tcntout, Vcav, fout, ~] = BLmaster(VT, bphiout, xout, bcnt, tcnt, phi0, RQ, qbunch, quench);
    [bcntout, tcntout, Vcav, fout, ~, ~, ~, ~, ~] = BLmaster(VT, bphiout, xout, bcnt, tcnt, phi0, RQ, qbunch*qout, quench, llRFoff, LHe_temp, rfoff_flag);
    
    if tcnt ~= tcntout
        disp(tcntout);
    end
    
    if mod(bcntout,72) == 0
        disp(bcntout);
    end
    
    bcnt = bcntout;
    tcnt = tcntout;
    
    if i < 2808*nturns - 1
        connect = 0;
        dataout = [abs(Vcav(end)), phase(Vcav(end)) - 90, fout(end)];
        [xout, bphiout, qout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout, 0, 0);
    else
        connect = -1;
        dataout = [abs(Vcav(end)), phase(Vcav(end)) - 90, fout(end)];
        [xout, bphiout, qout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout, 0, 0);
    end
end