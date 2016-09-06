function output = paramwrite(filename)

if strcmp(filename, 'cavParam')
    prompt = {};
    prompt{1} = 'Do you wish to load cavity parameters from another workspace? [Yes/No]';
    answers = inputdlg(prompt,'cavParam.mat not found',1,{'No'});
    
    if strncmpi(answers{1},'y',1) == 1
        [FileName,PathName,FilterIndex] = uigetfile('*.mat','Select Matlab workspace');
        
        if FilterIndex == 0
            return
        end
        
        userpath(PathName)
        load(FileName);
    else
        prompt = {};
        prompt{1} = 'Q0';
        prompt{2} = 'Qe';
        prompt{3} = 'Resonant frequency (MHz)';
        prompt{4} = 'Frequency offset (MHz)';
        prompt{5} = 'Lorentz detuning factor (Hz/(MV/m)^2)';
        answers = inputdlg(prompt,'Cavity parameters needed',1,{'1e9','3e6','400','0','100'});
        
        Q0 = str2double(answers{1});
        Qe = str2double(answers{2});
        f0 = str2double(answers{3})*1e6;
        df = str2double(answers{4})*1e6;
        Kl = str2double(answers{5});
        
        output = {Q0, Qe, f0, df, Kl};
    end
elseif strcmp(filename, 'LLRFParam')
    prompt = {};
    prompt{1} = 'Do you wish to load LLRF parameters from another workspace? [Yes/No]';
    answers = inputdlg(prompt,'LLRFParam.mat not found',1,{'No'});
    
    if strncmpi(answers{1},'y',1) == 1
        [FileName,PathName,FilterIndex] = uigetfile('*.mat','Select Matlab workspace');
        
        if FilterIndex == 0
            return
        end
        
        userpath(PathName)
        load(FileName);
    else
        prompt = {};
        prompt{1} = 'Latency (ns)';
        prompt{2} = 'Digital refresh time (ns)';
        prompt{3} = 'LPF factor [0-1]';
        prompt{4} = 'Proportional controller relative gain';
        prompt{5} = 'Integral controller relative gain';
        prompt{6} = 'Amplifier Q-factor';
        prompt{7} = 'Maximum RF Voltage [MV]';
        prompt{8} = 'Fractional measurement noise [%]';
        answers = inputdlg(prompt,'Cavity parameters needed',1,{'1000', '1000', '0.1', '181.8','2.08e-5','80','10', '0.5'});
        
        tlat = str2double(answers{1})*1e-9;
        dlat = str2double(answers{2})*1e-9;
        lpff = str2double(answers{3});
        cp = str2double(answers{4}) + 1i*str2double(answers{4});
        ci = str2double(answers{5}) + 1i*str2double(answers{5});
        Qa = str2double(answers{6});
        Pmax = str2double(answers{7})*1e6;
        noiseamp = str2double(answers{8})/100;
        
        output = {tlat, dlat, lpff, cp, ci, Qa, Pmax, noiseamp};
    end
end
end