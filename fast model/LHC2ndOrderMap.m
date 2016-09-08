function [xout, xnomout] = LHC2ndOrderMap(xin, cavnum, pxcav, pxideal, pzcav, pzideal, bcnt, tcnt, norder)

persistent R T crabind signs%#ok<PSET>

if bcnt == 1 && tcnt == 1
    load('sector_maps');
    
    L1 = R{crabind(1) + 1}(1,2);
    L2 = R{crabind(2) + 1}(1,2);
    M = R{mod(crabind(5) - 1, length(R)) + 1}*R{mod(crabind(4), length(R)) + 1};
    
    b = (M(1,1) - M(2,2))/2 + sqrt(((M(1,1) - M(2,2))/2)^2 + 1);
    a = -1 + (2*(L1 + L2)*(b - M(1,1)))/(L1*M(1,1) + 2*M(1,2) - L1*b);
    
    signs = [1, 1, a, a, a*b, a*b, b, b, 1, 1, a, a, a*b, a*b, b, b];
    disp(signs);
end

cav = [13, 14, 15, 16, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
xnom = xin;

for n = 1 : length(R)
    ind1 = mod(crabind(1) + n - 2, length(R)) + 1;
    ind2 = mod(ind1, length(R)) + 1;
    
    if min(abs(crabind - ind1)) == 0
        [~, ind3] = min(abs(crabind - ind1));
        
        if min(abs(cavnum - cav(ind3))) == 0
            xin(2,:) = xin(2,:) + signs(ind3)*pxcav;
            xin(6,:) = xin(6,:) + signs(ind3)*pzcav;
        else
            xin(2,:) = xin(2,:) + signs(ind3)*pxideal;
            xin(6,:) = xin(6,:) + signs(ind3)*pzideal;
        end
        xnom(2,:) = xnom(2,:) + signs(ind3)*pxideal;
        xnom(6,:) = xnom(6,:) + signs(ind3)*pzideal;
    end
    
    x1temp = R{ind2}*xin;
    x2temp = R{ind2}*xnom;
    nl = zeros(size(xin));
    nl1 = zeros(size(xnom));
    
    if norder == 2
        for i = 1 : 5
            for j = 1 : 4
                for k = 1 : j
                    if j == k
                        nl(i,:) = nl(i,:) + T{ind2}(i,j,k)*xin(j,:).*xin(k,:);
                        nl1(i,:) = nl1(i,:) + T{ind2}(i,j,k)*xnom(j,:).*xnom(k,:);
                    else
                        nl(i,:) = nl(i,:) + 2*T{ind2}(i,j,k)*xin(j,:).*xin(k,:);
                        nl1(i,:) = nl1(i,:) + 2*T{ind2}(i,j,k)*xnom(j,:).*xnom(k,:);
                    end
                end
            end
            
            for j = 1 : 4
                nl(i,:) = nl(i,:) + 2*T{ind2}(i,6,j)*xin(6,:).*xin(j,:);
                nl1(i,:) = nl1(i,:) + 2*T{ind2}(i,6,j)*xnom(6,:).*xnom(j,:);
            end
            
            nl(i,:) = nl(i,:) + T{ind2}(i,6,6)*xin(6,:).*xin(6,:);
            nl1(i,:) = nl1(i,:) + T{ind2}(i,6,6)*xnom(6,:).*xnom(6,:);
            
        end
    end
    
    xin = x1temp + nl;
    xnom = x2temp + nl1;
end

xout = xin';
xnomout = xnom';