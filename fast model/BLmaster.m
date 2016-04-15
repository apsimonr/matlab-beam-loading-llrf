function [bcntout, tcntout, Vcav, fout, Vamp] = BLmaster(VT, bphi, xbunch, bcnt, tcnt, phi0, RQ, qbunch, quench)
%% Parameter definitions
%%-------------------------------------------------------------------------
% VT: initial transverse voltage in the cavity [V]
%
% bphi: bunch phase wrt to peak transverse voltage [degrees]
%
% xbunch: the transverse offset of the bunch through the cavity [m]
%
% bcnt: bunch counter index
%
% tcnt: turn counter index
%
% nturns: number of turns for the whole simulation
%
% phi0: synchronous phase relative to peak transverse voltage [degrees]
%       90 degrees for crabbing mode
%
% RQ: transverse R/Q for the cavity
%
% qbunch: bunch charge [C]
%
% debug: flag to run code in debug mode or fast mode
%      **debug = 1: debug mode enabled
%      **debug = 0: debug mode disabled
%      warning: debug mode outputs all data for all rf timesteps and will
%      be significantly slower
%%-------------------------------------------------------------------------
persistent LHCtrain Pold0 Vout Vtarget vold dvold inputP trev
persistent tq Q0nc ttran
persistent Q0 Qe f0 df %#ok<PUSE>
persistent tlat lpff cp ci Qa Pmax

%%-------------------------------------------------------------------------
% Create and read in cavity and LLRF parameter files
%%-------------------------------------------------------------------------

if isempty(Q0)
    output = paramwrite('cavParam');
    Q0 = output{1};
    Qe = output{2};
    f0 = output{3};
    df = output{4};
end

if isempty(tlat)
    output = paramwrite('LLRFParam');
    tlat = output{1};
    lpff = output{2};
    cp = output{3};
    ci = output{4};
    Qa = output{5};
    Pmax = output{6};
end

% load('cavParam.mat');
% load('LLRFParam.mat');
% clear('ans');

%%-------------------------------------------------------------------------
% Create and read in data buffer
%%-------------------------------------------------------------------------
if bcnt == 1 && tcnt == 1
%     bufferwrite(VT, f0, Q0, Qe, phi0, nturns, tlat, ci);
[LHCtrain, Pold0, Vout, Vtarget, vold, dvold, inputP, trev] = bufferwrite(VT, f0, Q0, Qe, phi0, tlat, ci);
end

% load('buffer.mat');
% clear('ans');

%%-------------------------------------------------------------------------
% Create and read in data buffer
%%-------------------------------------------------------------------------

if bcnt == 1 && tcnt == 1
    if quench == 1
        if isempty(tq)
            prompt = {};
            prompt{1} = 'Time of quench (ns)';
            prompt{2} = 'Normal conducting Q0';
            prompt{3} = 'Transition decay time (ns)';
            answers = inputdlg(prompt,'Quench parameters needed',1,{'1000','1e3','1e5'});
            
            tq = str2double(answers{1})*1e-9;
            Q0nc = str2double(answers{2});
            ttran = str2double(answers{3})*1e-9;
        end
    elseif quench == 0
        if isempty(tq)
            tq = 1;
            Q0nc = Q0;
            ttran = 1;
        end
    end
end

%%-------------------------------------------------------------------------
% Perform beam loading calculations
%%-------------------------------------------------------------------------
if bcnt < length(LHCtrain)
    tinterval = [LHCtrain(bcnt) (LHCtrain(bcnt + 1) - 1/f0)] + (tcnt - 1)*trev;
elseif bcnt == length(LHCtrain)
    tinterval = [LHCtrain(bcnt) (trev - 1/f0)] + (tcnt - 1)*trev;
else
    warning('Bunch counter exceeds the number of bunches');
    return
end

nsteps = round(abs(tinterval(2) - tinterval(1))*f0) + 1;

[Q0int, Qeint, dfint] = quenchout(tq, ttran, tinterval, Q0, Q0nc, Qe, f0);
[Pin, dPin0, d2Pin0, Vinit] = BLinputs(inputP, nsteps, Vout, f0);

c = 299792458;
dV = xbunch*(2*pi*f0)^2/(2*c)*RQ*qbunch;

[Vcav] = RKcav(Q0int, Qeint, f0, dfint, tinterval, Pin, dPin0, d2Pin0, Vinit, bphi, dV, phi0);
clear('Q0int', 'Qeint');

%%-------------------------------------------------------------------------
% Perform LLRF calculations
%%-------------------------------------------------------------------------
[delV, delV2] = LLRFinputs(Vout, f0);

[vold, dvold, Vamp] = LLRF(Vcav, Vtarget, lpff, vold, dvold, f0, dfint, cp, ci, Qa, delV, delV2, Pmax, Pold0);
fout = f0 + dfint(end);

[Pold0, Vout, inputP] = bufferout(Vamp, Vcav, inputP);

if bcnt < length(LHCtrain)
    bcntout = bcnt + 1;
    tcntout = tcnt;
elseif bcnt == length(LHCtrain)
    bcntout = 1;
    tcntout = tcnt + 1;
else
    warning('Bunch counter exceeds the number of bunches');
    return
end
end