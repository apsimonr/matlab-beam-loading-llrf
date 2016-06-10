close all;
clear all; %#ok<CLSCR>
clc;

%% initial parameters
VT = 3e6;
bcnt = 1;
tcnt = 1;
nturns = 20;
phi0 = 90;
RQ = 150;
qbunch = 18.4e-9;
quench = 0;
fcav = 4e8;
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
[xout, bphiout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout);

%% run for other bunches
for i = 1:2808*nturns - 1
    [bcntout, tcntout, Vcav, fout, ~] = BLmaster(VT, bphiout, xout, bcnt, tcnt, phi0, RQ, qbunch, quench);
    
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
        [xout, bphiout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout);
    else
        connect = -1;
        dataout = [abs(Vcav(end)), phase(Vcav(end)) - 90, fout(end)];
        [xout, bphiout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout);
    end
end