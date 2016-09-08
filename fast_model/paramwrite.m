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
        answers = inputdlg(prompt,'Cavity parameters needed',1,{'1e9','5e5','400','0','200'});
        
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
        prompt{3} = 'Proportional controller relative gain';
        prompt{4} = 'Integral controller relative gain';
        prompt{5} = 'Amplifier Q-factor';
        prompt{6} = 'Maximum klystron power [kW]';
        prompt{7} = 'signal to noise ratio';
%         answers = inputdlg(prompt,'Cavity parameters needed',1,{'2000', '25', '15.15','1.735e-6','400','80', '1000'});
        answers = inputdlg(prompt,'Cavity parameters needed',1,{'1000', '25', '30.3','3.47e-6','400','80', '1000'});
        
        tlat = str2double(answers{1})*1e-9;
        dlat = str2double(answers{2})*1e-9;
        cp = str2double(answers{3})*(1 + 1i);
        ci = str2double(answers{4})*(1 + 1i);
        Qa = str2double(answers{5});
        Pmax = str2double(answers{6})*1e3;
        noiseamp = str2double(answers{7});
        
        output = {tlat, dlat, cp, ci, Qa, Pmax, noiseamp};
    end
end
end