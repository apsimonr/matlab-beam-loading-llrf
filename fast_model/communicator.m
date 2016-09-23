function [xpos, bphi, qout] = communicator(hostname, portnum, outbuffersize, inbuffersize, connect, dataout, LHCtrain, qflag)

if connect == 1
    tcpport = tcpip(hostname, portnum, 'NetworkRole', 'server');
    tcpport.OutputBufferSize = outbuffersize;
    tcpport.InputBufferSize = inbuffersize;
    fopen(tcpport);
end

if length(LHCtrain) > 1
    % send train data to SixTrack manager
    % string format:
    % "bunch times: length = " <length(LHCtrain)>
    % for-loop values
    % "end of bunch time data"
    fwrite(tcpport,sprintf('%s %i\n', 'bunch info', length(LHCtrain)));
    
    for i = 1 : length(LHCtrain)
        fwrite(tcpport,sprintf('%12.10g %12.10g\n', LHCtrain(i), qflag(i)));
    end
    fwrite(tcpport,sprintf('%s\n', 'end of bunch info'));
end

% send data to SixTrack manager
% string format:
% bunchnum <bunch#> <turn#> <Vcav> <cavPhi> <freq>
fwrite(tcpport,sprintf('bunchnum %12.10g %12.10g %12.10g\n', dataout(1), dataout(2), dataout(3)));

% receive data from SixTrack manager
% string format:
% bunchnum <bunch#> <turn#> <x-position> <beam-phi> <particles_remaining>
datain = fscanf(tcpport);

if isempty(datain)
    disp('no data sent');
    xpos = 0;
    bphi = 0;
    qout = 0;
else
    temp = strsplit(datain);
    xpos = str2double(temp(4));
    bphi = str2double(temp(5)) + 90; %in degrees phased to maximum real voltage
    qout = str2double(temp(6));
end

if connect == -1
    fclose(tcpport);
end