# Coupling to external programs

To connect the LLRF simulation code to an external program, run the script "SixTrackInterface.m".
This open localhost:port 4012 over TCP/IP, waiting for a connection.

To test the connection, simply run `ncat localhost 4012`.
The server (i.e. the Matlab program) then sends the string `bunchnum      3000000           90    400000000` over the connection, then waits for a reply (within a certain timeout).
The meaning of the string is `% bunchnum <bunch#> <turn#> <Vcav> <cavPhi> <freq>` -- TODO: the data actually being sent is the initial `VT phi0 fcav`.
If nothing is recieved within a few seconds after the connection has been established, it times out (or writes "no data sent"?).

After starting, the matlab program starts a couple of GUI dialogs.
TODO: Describe these!

The expected input is `% bunchnum <bunch#> <turn#> <x-position> <beam-phi>`.
