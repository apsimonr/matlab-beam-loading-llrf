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
        prompt{4} = 'Frequency bandwidth (MHz)';
        answers = inputdlg(prompt,'Cavity parameters needed',1,{'1e9','3e6','400','0'});
        
        Q0 = str2double(answers{1});
        Qe = str2double(answers{2});
        f0 = str2double(answers{3})*1e6;
        df = str2double(answers{4})*1e6;
        
        output = {Q0, Qe, f0, df};
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
        prompt{2} = 'LPF factor [0-1]';
        prompt{3} = 'Proportional controller relative gain (I)';
        prompt{4} = 'Proportional controller relative gain (Q)';
        prompt{5} = 'Integral controller relative gain (I)';
        prompt{6} = 'Integral controller crelative gain (Q)';
        prompt{7} = 'Amplifier Q-factor';
        prompt{8} = 'Maximum RF Voltage [MV]';
        answers = inputdlg(prompt,'Cavity parameters needed',1,{'1000','0.1','1e-5','1e-5','1e-5','1e-5','400','10'});
        
        tlat = str2double(answers{1})*1e-9;
        lpff = str2double(answers{2});
        cp = str2double(answers{3}) + 1i*str2double(answers{4});
        ci = str2double(answers{5}) + 1i*str2double(answers{6});
        Qa = str2double(answers{7});
        Pmax = str2double(answers{8})*1e6;
        
        output = {tlat, lpff, cp, ci, Qa, Pmax};
    end
end
end