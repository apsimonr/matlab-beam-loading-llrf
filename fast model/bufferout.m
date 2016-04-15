function[Pold0, Vout, inputP] = bufferout(Vamp, Vcav, inputP)

Pold0 = Vamp(end);
Vout = Vcav;







inputP = circshift(inputP', [-(length(Vamp) - 2), 0])';
inputP(length(inputP) - length(Vamp) + 1:length(inputP)) = Vamp;








% temp1 = inputP(length(Vamp) - 1:end);
% 
% inputP = zeros(size(inputP));
% inputP(1:length(temp1)) = temp1;
% inputP(length(temp1) + 1:length(temp1) + length(Vamp)) = Vamp;

end