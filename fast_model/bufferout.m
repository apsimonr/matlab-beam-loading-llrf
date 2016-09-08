function[Pold0, Vout, inputP] = bufferout(Vamp, Vcav, inputP)

Pold0 = Vamp(end);
Vout = Vcav;

inputP = circshift(inputP', [-(length(Vamp) - 2), 0])';
inputP(length(inputP) - length(Vamp) + 1:length(inputP)) = Vamp;
end