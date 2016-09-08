function [trev, LHCtrain, tabort, qflag] = LHCbunchTrain(ver, tlat, f0)
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
    
    tabort = trev - LHCtrain(end);
    
    if round(tabort*f0) > round(tlat*f0)
        nextra = ceil(round(tabort*f0)/(f0*tlat));
        
        LHCtraintemp = zeros(1,length(LHCtrain) + nextra - 1);
        LHCtraintemp(1:length(LHCtrain)) = LHCtrain;
        
        qflag = ones(1,length(LHCtrain) + nextra - 1);
        qflag(length(LHCtrain) + 1:end) = 0;
        
        for i = 1:nextra - 1
            LHCtraintemp(length(LHCtrain) + i) = LHCtrain(end) + i*tlat;
        end
        
        LHCtrain = LHCtraintemp;
    else
        qflag = ones(size(LHCtrain));
    end
    
    for i = 1:length(LHCtrain) - 1
        tspace = LHCtrain(i + 1) - LHCtrain(i);
        if round(tspace*f0) > round(tlat*f0)
            nextra = ceil(round(tspace*f0)/(f0*tlat));
            
            qflagtemp = zeros(1,length(qflag) + nextra - 1);
            qflagtemp(1:i) = qflag(1:i);
            qflagtemp(i + nextra - 1:end) = qflag(i + 1:end);
            
            LHCtraintemp = zeros(1,length(LHCtrain) + nextra - 1);
            LHCtraintemp(1:i) = LHCtrain(1:i);
            LHCtraintemp(i + nextra - 1:end) = LHCtrain(i + 1:end);
            
            for j = 1:nextra - 1
                LHCtraintemp(i+j) = LHCtrain(i) + j*tlat;
            end
            
            LHCtrain = LHCtraintemp;
            qflag = qflagtemp;
        end
    end
else
    return
end
end