function [bcntout, tcntout, Vcav, fout, KPout, Pinout, quenchtime, fnom, dfq] = BLmaster(VT, bphi, xbunch, bcnt, tcnt, phi0, RQ, qbunch, quench, llrfoff, LHe_temp, rfoff_flag, sim_type)
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
persistent LHCtrain Pold0 Vout Vtarget dvold inputP trev qflag
persistent tq Q0nc ttran trfoff
persistent Q0 Qe f0 df Kl
persistent tlat dlat cp ci Qa Pmax noiseamp

%%-------------------------------------------------------------------------
% Create and read in cavity and LLRF parameter files
%%-------------------------------------------------------------------------

if isempty(Q0)
    output = paramwrite('cavParam', sim_type);
    Q0 = output{1};
    Qe = output{2};
    f0 = output{3};
    df = output{4};
    Kl = output{5};
end

if isempty(tlat)
    output = paramwrite('LLRFParam', sim_type);
    tlat = output{1};
    dlat = output{2};
    cp = output{3};
    ci = output{4};
    Qa = output{5};
    Pmax = sqrt(2*output{6}*RQ*Qe);
    noiseamp = output{7};
end

%%-------------------------------------------------------------------------
% Create and read in data buffer
%%-------------------------------------------------------------------------

c = 299792458;
dV = xbunch*(2*pi*f0)^2/(2*c)*RQ*qbunch;

if bcnt == 1 && tcnt == 1
    [LHCtrain, Pold0, Vout, Vtarget, dvold, inputP, trev, qflag] = bufferwrite(VT, f0, Q0, Qe, phi0, tlat, ci, dV, bphi);
end

%%-------------------------------------------------------------------------
% Create and read in data buffer
%%-------------------------------------------------------------------------

if bcnt == 1 && tcnt == 1
    if quench == 1
        if isempty(tq)
            prompt = {};
            prompt{1} = 'Time of quench (us)';
            prompt{2} = 'Normal conducting Q0';
            prompt{3} = 'Transition decay time (us)';
            prompt{4} = 'Time of RF off (us)';
            answers = inputdlg(prompt,'Quench parameters needed',1,{'200','1e3','10','250'});
            
            tq = str2double(answers{1})*1e-6;
            Q0nc = str2double(answers{2});
            ttran = str2double(answers{3})*1e-6;
            trfoff = str2double(answers{4})*1e-6;
        end
    elseif quench == 0
        if isempty(tq)
            tq = 1;
            Q0nc = Q0;
            ttran = 1;
            trfoff = 1;
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

ttemp = tinterval(1) - 1/f0:1/f0:tinterval(2);
dfq = df*ones(1,length(ttemp));

if trfoff <= tinterval(1)
    if rfoff_flag == 1
        Pmaxin = exp(-2*pi*f0*(ttemp - trfoff)/(2*Qa));
        rfoff = ones(size(ttemp));
    else
        Pmaxin = ones(size(ttemp));
        rfoff = zeros(size(ttemp));
    end
    
    if LHe_temp <= 2.17
        dfq = dfq + 100;
    else
        dfq = dfq + 4000;
    end
elseif trfoff <= tinterval(2)
    [~, tindex] = min(abs(ttemp - trfoff));
    
    if rfoff_flag == 1
        Pmaxin(tindex:end) = exp(-2*pi*f0*(ttemp(tindex:end) - trfoff)/(2*Qa));
        rfoff(tindex:end) = 1;
    else
        Pmaxin = ones(size(ttemp));
        rfoff = zeros(size(ttemp));
    end
    
    if LHe_temp <= 2.17
        dfq = dfq + 100;
    else
        dfq = dfq + 4000;
    end
else
    Pmaxin = ones(size(ttemp));
    rfoff = zeros(size(ttemp));
end

Vcav = RKcav(Q0int, Qeint, f0, dfint, tinterval, Pin.*Pmaxin, dPin0, d2Pin0, Vinit, bphi, dV*qflag(bcnt), phi0, Kl, dfq, Vtarget);

%%-------------------------------------------------------------------------
% Perform LLRF calculations
%%-------------------------------------------------------------------------

if trfoff <= tinterval(1)
    fout = f0 + dfint(2:end) + dfq(2:end) - Kl*(abs(Vcav).^2 - abs(Vtarget)^2)/1e12;
elseif trfoff <= tinterval(2)
    fout = f0 + dfint(2:end) + dfq(2:end) - Kl*(abs(Vcav).^2 - abs(Vtarget)^2)/1e12;
else
    fout = f0 + dfint(2:end) + dfq(2:end) - Kl*(abs(Vcav).^2 - abs(Vtarget)^2)/1e12;
end

delV = LLRFinputs(Vout, f0);

[dvold, Vamp, Pinout] = LLRF(Vcav, Vtarget, dvold, f0, cp, ci, Qa, delV, Pmax, Pold0, dlat, noiseamp, rfoff, llrfoff);

KPout = Vamp.^2./(2*RQ*Qe);

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
quenchtime = tq;
fnom = f0;
end