close all;
clear all;

% Read in sector map information for HL-LHC
userpath('C:\Users\Robert\Desktop\backup\Box Sync\Projects\nonlinear_dynamics\matlab');

ncolumns = 1 + 6^2 + 6^3;

filename = 'HLLHC_sector_map.txt';
fid = fopen(filename);

fgetl(fid);

formatSpec = ' %s ';

for i = 1:ncolumns - 1
    formatSpec = [formatSpec '%f ']; %#ok<AGROW>
end

data = textscan(fid, formatSpec);
fclose(fid);

% Convert data into R matrix and T tensor
R = cell(1,length(data{1}));
T = cell(1,length(data{1}));

Rtemp = zeros(6,6);
Ttemp = zeros(6,6,6);

for i = 1 : length(data{1})
    for j = 1 : 6^2
        ind1 = mod(j-1,6) + 1;
        ind2 = floor((j-1)/6) + 1;
        
        Rtemp(ind1, ind2) = data{j + 1}(i);
    end
    R{i} = Rtemp;
    Rtemp = zeros(6,6);
end

for i = 1 : length(data{1})
    for j = 1 : 6^3
        ind1 = mod(j-1,6) + 1;
        ind2 = mod(floor((j-1)/6),6) + 1;
        ind3 = floor((j-1)/36) + 1;
        
        Ttemp(ind1, ind2, ind3) = data{j + 37}(i);
    end
    T{i} = Ttemp;
    Ttemp = zeros(6,6,6);
end

% Determine which rows correspond to each crab cavity to get relevant
% information for transfer map

crabnames = {'ACFCA.AR1.B1' 'ACFCA.BR1.B1' 'ACFCA.CR1.B1' 'ACFCA.DR1.B1'...
    'ACFCA.DL5.B1' 'ACFCA.CL5.B1' 'ACFCA.BL5.B1' 'ACFCA.AL5.B1'...
    'ACFCA.AR5.B1' 'ACFCA.BR5.B1' 'ACFCA.CR5.B1' 'ACFCA.DR5.B1'...
    'ACFCA.DL1.B1' 'ACFCA.CL1.B1' 'ACFCA.BL1.B1' 'ACFCA.AL1.B1'};

crabind = zeros(size(crabnames));

for i = 1 :length(crabnames)
    for j = 1 : length(data{1})
        if strcmp(data{1}(j), crabnames{i}) == 1
            crabind(i) = j;
        end
    end
end

% Set first index to be crab 13 for convenience
crabind = circshift(crabind',4)';

save('sector_maps', 'R', 'T', 'crabind');