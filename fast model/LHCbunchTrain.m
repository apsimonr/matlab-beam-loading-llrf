function [trev, LHCtrain] = LHCbunchTrain(ver)
%%-------------------------------------------------------------------------
% ver: an integer to allow for other potential bunch train structures
%%-------------------------------------------------------------------------

if ver == 1
    bspace = 25e-9;
    PSspace = 8*bspace;
    SPSspace3 = 38*bspace;
    SPSspace4 = 39*bspace;
    LHCspace = 119*bspace;
    
    PStrain = zeros(1,72);
    SPStrain3 = zeros(1,3*72);
    SPStrain4 = zeros(1,4*72);
    LHCtrain = zeros(1,2808);
    
    %% PS bunch train
    for i = 1:length(PStrain)
        PStrain(i) = (i-1)*bspace;
    end
    
    
    %% SPS bunch trains
    SPStrain3(1:length(PStrain)) = PStrain;
    ttemp = max(SPStrain3) + PSspace + bspace;
    SPStrain3(length(PStrain) + 1:2*length(PStrain)) = PStrain + ttemp;
    ttemp = max(SPStrain3) + PSspace + bspace;
    SPStrain3(2*length(PStrain) + 1:3*length(PStrain)) = PStrain + ttemp;
    
    SPStrain4(1:3*length(PStrain)) = SPStrain3;
    ttemp = max(SPStrain4) + PSspace + bspace;
    SPStrain4(3*length(PStrain) + 1:4*length(PStrain)) = PStrain + ttemp;
    
    %% LHC bunch train
    ttemp = 0;
    indmin = 1;
    indmax = length(SPStrain3);
    % 1st supercycle
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain4);
    
    LHCtrain(indmin:indmax) = SPStrain4 + ttemp;
    ttemp = max(LHCtrain) + SPSspace4 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    % 2nd supercycle
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain4);
    
    LHCtrain(indmin:indmax) = SPStrain4 + ttemp;
    ttemp = max(LHCtrain) + SPSspace4 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    % 3rd supercycle
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain4);
    
    LHCtrain(indmin:indmax) = SPStrain4 + ttemp;
    ttemp = max(LHCtrain) + SPSspace4 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    % 4th supercycle
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    ttemp = max(LHCtrain) + SPSspace3 + bspace;
    indmin = indmax + 1;
    indmax = indmax + length(SPStrain3);
    
    LHCtrain(indmin:indmax) = SPStrain3 + ttemp;
    
    trev = LHCtrain(end) + LHCspace + bspace;
    
    save('LHCBunchTrain.mat','LHCtrain','trev');
else
    return
end
end