function quenchCav(Q0, Qe, tglobal, f0)

prompt = {};
prompt{1} = 'Time of quench (ns)';
prompt{2} = 'Normal conducting Q0';
prompt{3} = 'Transition decay time (ns)';
answers = inputdlg(prompt,'Quench parameters needed',1,{'1000','1e3','1e5'});

tq = str2double(answers{1})*1e-9;
Q0nc = str2double(answers{2});
ttran = str2double(answers{3})*1e-9;

Q0out = zeros(size(tglobal));
Qeout = Qe*ones(size(tglobal));

[~, tind] = min(abs(tglobal - tq));

Q0out(1:tind) = Q0;
Q0out(tind + 1 : end) = Q0 - (Q0 - Q0nc)*(1 - exp(-(tglobal(tind + 1 : end) - tq)/ttran));

dfout = f0*sqrt(1 - 1./Q0out.^2) - f0;

save('quenchQ.mat', 'Q0out', 'Qeout', 'dfout');
end