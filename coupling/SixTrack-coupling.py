#! /usr/bin/env python

import os

# Configuration
Nturns = 20
Nbunches = 10

BDEX_writePipe_name = "/tmp/BDEX1" #For writing particles to SixTrack
BDEX_readPipe_name = "/tmp/BDEX2"  #For reading particles from SixTrack

DYNK_writePipe_name = "/tmp/DYNK1" #For writing particles to SixTrack
DYNK_readPipe_name =  "/tmp/DYNK2"  #For reading particles from SixTrack


LLRFsim_host = "127.0.0.1"
LLRFsim_port = 4012


bunches = []
class Bunch:
    particles        = None # x, xp, y, yp, z, E
    particles_string = None
    
    def __init__(self):
        self.particles = []
        self.particles_strings = []

    def makeParticlesFromStrings(self):
        pass
    def makeStringsFromParticles(self):
        pass
    
    def get_average_x(self):
        pass

    def get_average_phase(self):
        pass

    def get_Nparticles(self):
        pass
    
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
        pass
    
    def writeParticlesBDEX(cls,pipe):
        pass

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

#Open PIPEFUN pipes
print "Opening", DYNK_writePipe_name, "for writing"
DYNK_writePipe = open(DYNK_writePipe_name,'w')
print "Opening", DYNK_readPipe_name, "for reading"
DYNK_readPipe = open(DYNK_readPipe_name,'r')


#Open LLRFsim TCP/IP connection

for turn in xrange(Nturns):
    for bunchNum in xrange(Nbunches):
        sixTurn = (turn+1)*(bunchNum+1)

        #Update cavity parameters
        # TODO
        
        #Bunch swapping at IP1
        if sixTurn == 1:
            #Discard inital bunch
            bunch_discard = Bunch.loadParticlesBDEX(BDEX_readPipe)
            print "Discarded bunch:",  bunch_discard

            #Write bunch 1 to SixTrack
            bunches[bunchNum].writeParticlesBDEX(BDEX_writePipe)
        elif bunchNum == 1:
            #Wrap around the bunchNum
            bunches[-1].loadParticlesBDEX(BDEX_readPipe)
            bunches[1].writeParticlesBDEX(BDEX_writePipe)
        else:
            bunches[-1].loadParticlesBDEX(BDEX_readPipe)
            bunches[1].writeParticlesBDEX(BDEX_writePipe)
            
        #Read bunch parameters at cavity
        # TODO
