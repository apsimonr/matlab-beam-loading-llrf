#! /usr/bin/env python

import os
import math as m

# Configuration
Nturns = 20
Nbunches = 10

BDEX_writePipe_name = "/tmp/BDEX1" #For writing particles to SixTrack
BDEX_readPipe_name = "/tmp/BDEX2"  #For reading particles from SixTrack

DYNK_writePipe_name = "/tmp/DYNK1" #For writing element attributes to SixTrack
DYNK_readPipe_name =  "/tmp/DYNK2" #For selecting which element attributes to write to SixTrack


LLRFsim_online = False

LLRFsim_host = "127.0.0.1"
LLRFsim_port = 4012


bunches = []
class Bunch:
    particles         = None # x, xp, y, yp, z, E
    particles_strings = None #BDEX format: xv(1,j) yv(1,j) xv(2,j) yv(2,j) sigmv(j) ejv(j) ejfv(j) rvv(j) dpsv(j) oidpsv(j) dpsv1(j),nlostp(j)
    
    def __init__(self):
        self.particles = []
        self.particles_strings = []

    def makeParticlesFromStrings(self):
        "Convert the particles in the"
        pass
    def makeStringsFromParticles(self):
        pass
    
    def get_average_x(self):
        pass

    def get_average_phase(self):
        pass

    def get_Nparticles(self):
        assert len(self.particles) == len(self.particles_strings)
        return len(self.particles)
    
    @classmethod
    def loadParticlesFile(cls,fname):
        bunch = cls()
        
        ifile = open(fname,'r')
        for line in ifile.readlines():
            #Format: x, xp, y, yp, z, E
            ls = map(float,line.split())
            bunch.particles.append(ls)
        ifile.close()
        bunch.makeStringsFromParticles()
        return bunch

    @classmethod
    def loadParticlesBDEX(cls, pipe):
        rl = pipe.readline()
        assert rl.startswith("BDEX TURN")
        ls = rl.split()
        turn = int(ls[2])
        bez  = ls[3][4:]
        I    = int(ls[5])
        NAPX = int(ls[7])

        bunch = cls()
        for i in xrange(NAPX):
            bunch.particles_strings.append(pipe.readline()[:-1]) #Strip the newline
        bunch.makeParticlesFromStrings()

        return bunch
    
    def writeParticlesBDEX(self,pipe):
        pipe.write(str(self.get_Nparticles())+"\n")
        for p in self.particles_strings:
            pipe.write(p+"\n")
        pipe.flush()

# Initialize bunches array
print "Reading initial distributions..."
for i in xrange(1,Nbunches):
    bunchfile_name = os.path.join("distributions","init_dist_"+str(i)+".txt")
    if not os.path.isfile(bunchfile_name):
        print "Error when loading bunch",i
        print "File '"+bunchfile_name+"' not found."
        exit(1)
        
    bunches.append(Bunch.loadParticlesFile(bunchfile_name))
    print bunches[-1].particles
print "Done."

#Open BDEX pipes
print "Opening", BDEX_writePipe_name, "for writing"
BDEX_writePipe = open(BDEX_writePipe_name,'w')
print "Opening", BDEX_readPipe_name, "for reading"
BDEX_readPipe = open(BDEX_readPipe_name,'r')
BDEX_readPipe_line = BDEX_readPipe.readline()
print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
assert BDEX_readPipe_line == "BDEX-PIPE !******************!\n"

#Open PIPEFUN pipes
print "Opening", DYNK_writePipe_name, "for writing"
DYNK_writePipe = open(DYNK_writePipe_name,'w')
print "Opening", DYNK_readPipe_name, "for reading"
DYNK_readPipe = open(DYNK_readPipe_name,'r')

DYNK_readPipe_line = DYNK_readPipe.readline()
print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
assert DYNK_readPipe_line == "DYNKPIPE !******************!\n"
DYNK_readPipe_line = DYNK_readPipe.readline()
print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
assert DYNK_readPipe_line == "INIT ID=AR1_V for FUN=pipe_V1\n"
DYNK_readPipe_line = DYNK_readPipe.readline()
print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
assert DYNK_readPipe_line == "INIT ID=AR1_P for FUN=pipe_P1\n"


#Open LLRFsim TCP/IP connection
if LLRFsim_online:
    pass
LLRF_Vt = 3e6 #[V]
LLRF_phi = 90.0 #[deg]
LLRF_fcav = 4e8 #[Hz]

print "Starting tracking:"
for turn in xrange(Nturns):
    for bunchNum in xrange(Nbunches):
        sixTurn = (turn+1)*(bunchNum+1)
        print
        print "turn/bunchNum/sixTurn = ", turn, bunchNum,sixTurn
        
        #Read updated (or initial) cavity parameters from LLRFsim
        if LLRFsim_online:
            # TODO
            pass
        else:
            #Don't change LLRF_{Vt,phi,fcav}            
            pass
        
        #Send updated cavity parameters to SixTrack
        print "Updating voltage & phase using DYNK:"
        # Voltage:
        DYNK_readPipe_line = DYNK_readPipe.readline()
        print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
        assert DYNK_readPipe_line.startswith("GET ID=AR1_V TURN=")
        DYNK_readPipe_line_turn = int(DYNK_readPipe_line.split()[-1])
        assert DYNK_readPipe_line_turn == sixTurn
        DYNK_writePipe.write(str(LLRF_Vt/1e6)+"\n")
        DYNK_writePipe.flush()
        #Phase:
        DYNK_readPipe_line = DYNK_readPipe.readline()
        print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
        assert DYNK_readPipe_line.startswith("GET ID=AR1_P TURN=")
        DYNK_readPipe_line_turn = int(DYNK_readPipe_line.split()[-1])
        assert DYNK_readPipe_line_turn == sixTurn
        DYNK_writePipe.write(str((LLRF_phi-90)*m.pi/360.0)+"\n")
        DYNK_writePipe.flush()
        
        #SixTrack bunch swapping at IP1
        print "Swapping bunches!"
        if sixTurn == 1:
            #Discard inital bunch
            print "loading initial bunch"
            bunch_discard = Bunch.loadParticlesBDEX(BDEX_readPipe)
            print "Discarded bunch:",  bunch_discard

            #Write bunch 1 to SixTrack
            bunches[bunchNum].writeParticlesBDEX(BDEX_writePipe)

            #Confirm BDEX state OK and advance pipe
            BDEX_readPipe_line = BDEX_readPipe.readline()
            print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
            assert BDEX_readPipe_line == "BDEX TRACKING...\n"
        elif bunchNum == 1:
            #Wrap around the bunchNum
            bunches[-1].loadParticlesBDEX(BDEX_readPipe)
            bunches[1].writeParticlesBDEX(BDEX_writePipe)
        else:
            bunches[-1].loadParticlesBDEX(BDEX_readPipe)
            bunches[1].writeParticlesBDEX(BDEX_writePipe)
            
        #Read bunch parameters at cavity from SixTrack
        # TODO

        #Send bunch parameters at cavity to LLRFsim


#Close connections
BDEX_readPipe_line = BDEX_readPipe.read()
print "BDEX_readPipe_line: '" + BDEX_readPipe_line[:-1] + "'"
assert BDEX_readPipe_line == "CLOSEUNITS\n" #TODO: Write this in the SixTrack manual!

BDEX_writePipe.close()
BDEX_readPipe.close()
DYNK_writePipe.close()
DYNK_readPipe.close()
if LLRFsim_online:
    pass
