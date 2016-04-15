function [xpos, bphi] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout)

if connect == 1
    tcpport = tcpip(hostname, portnum, 'NetworkRole', 'server');
    tcpport.OutputBufferSize = outbuffersize;
    tcpport.InputBufferSize = inbuffersize;
    fopen(tcpport);
end

% send data to SixTrack manager
% string format:
% bunchnum <bunch#> <turn#> <Vcav> <cavPhi> <freq>
fwrite(tcpport,sprintf('bunchnum %12.10g %12.10g %12.10g\n', dataout(1), dataout(2), dataout(3)));

% receive data from SixTrack manager
% string format:
% bunchnum <bunch#> <turn#> <x-position> <beam-phi>
datain = fscanf(tcpport);

if isempty(datain)
    disp('no data sent');
    xpos = 0;
    bphi = 0;
else
    temp = strsplit(datain);
    xpos = str2double(temp(4));
    bphi = str2double(temp(5)) + 90; %in degrees phased to maximum real voltage
end

if connect == -1
    fclose(tcpport);
end