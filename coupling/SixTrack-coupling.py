#! /usr/bin/env python

import os
import math as m
import numpy as np
import socket

# Configuration
Nturns = 10
Nbunches = 2808
#Nbunches = 10

BDEX_writePipe_name = "/tmp/BDEX1" #For writing particles to SixTrack
BDEX_readPipe_name = "/tmp/BDEX2"  #For reading particles from SixTrack

DYNK_writePipe_name = "/tmp/DYNK1" #For writing element attributes to SixTrack
DYNK_readPipe_name =  "/tmp/DYNK2" #For selecting which element attributes to write to SixTrack


LLRFsim_online = True

LLRFsim_host = "127.0.0.1"
LLRFsim_port = 4012

class Bunch:
    particles         = None # x, xp, y, yp, z, E (floating point numbers)
    particles_strings = None #BDEX format: xv(1,j) yv(1,j) xv(2,j) yv(2,j) sigmv(j) ejv(j) ejfv(j) rvv(j) dpsv(j) oidpsv(j) dpsv1(j), nlostp(j)
    
    def __init__(self):
        self.particles = []
        self.particles_strings = []

    def makeParticlesFromStrings(self):
        "Convert the particles in the self.particles_strings array to floating point numbers that can be processed by get_average_x etc."
        assert len(self.particles) == 0
        for ps in self.particles_strings:
            ps_split = ps.split()
            padd = (float(ps_split[0]), float(ps_split[1]), float(ps_split[2]), float(ps_split[3]), float(ps_split[4]), float(ps_split[5]))
            #padd = map(float,ps_split[: ....
            self.particles.append(padd)
            
    def makeStringsFromParticles(self):
        "Convert the particles in the self.particles array to strings which can be written to BDEX. This should only be done during initialization."

        assert len(self.particles_strings) == 0
        nlostp = 0
        pma = 938.276
        e0=7e6
        e0f=m.sqrt(e0**2-pma**2)
        for p in self.particles:
            ejv=p[5]
            ejfv = m.sqrt(ejv**2-pma**2)
            rvv = ejv*e0f/(e0*ejfv)
            dpsv = (ejfv-e0f)/e0f
            oidpsv = 1/(1+dpsv)
            dpsv1=dpsv*1e3*oidpsv
            nlostp+=1

            ps = ("%g "*11 + "%d") % (p[0],p[1], p[2],p[3], p[4], p[5], ejfv, rvv, dpsv, oidpsv, dpsv1, nlostp)
            self.particles_strings.append(ps)
            
    def get_average(self,idx):
        "idx: 0=X, 1=XP, 2=Y, 3=YP, 4=Z, 5=E"
        X = np.empty(self.get_Nparticles())
        for i in xrange(self.get_Nparticles()):
            X[i]=self.particles[i][idx]
        return np.average(X)

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
        assert rl.startswith("BDEX TURN"),"rl = '"+rl+"'"
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

class Bucket:
    bunch  = None # Bunch object or None (in case of empty bunch)
    deltaT = None # Time offset of bucket [ns]

    initialMacroParticles = 0
    
    def __init__(self, bunch, deltaT):
        self.bunch=bunch
        self.detaT=deltaT

        if self.bunch != None:
            self.initialMacroParticles=self.bunch.get_Nparticles()
    
    def get_Qnorm(self):
        if self.bunch != None:
            return float(self.bunch.get_Nparticles()) / float(self.initialMacroParticles)
        else:
            return 0.0

    def get_xMean(self):
        if self.bunch != None:
            return self.bunch.get_average(0)*1e-3 #[m]
        else:
            return 0.0
    def get_yMean(self):
        if self.bunch != None:
            return self.bunch.get_average(2)*1e-3 #[m]
        else:
            return 0.0
    def get_phiMean(self):
        if self.bunch != None:
            return self.bunch.get_average(4)/3e8*LLRF_fcav*360.0 #[m]
        else:
            return 0.0

# Initialize bunches array
print "Reading initial distributions..."
initial_bunches = []
for i in xrange(1,Nbunches+1): #Counting from 1, ending on Nbunches.
    bunchfile_name = os.path.join("distributions","init_dist_"+str(i)+".txt")
    if not os.path.isfile(bunchfile_name):
        print "Error when loading bunch",i
        print "File '"+bunchfile_name+"' not found."
        exit(1)
        
    initial_bunches.append(Bunch.loadParticlesFile(bunchfile_name))
    #print bunches[-1].particles
    print i, map(initial_bunches[-1].get_average, range(6))
print "Done."

#Open BDEX pipes
print "Opening", BDEX_writePipe_name, "for writing"
BDEX_writePipe = open(BDEX_writePipe_name,'w')
print "Opening", BDEX_readPipe_name, "for reading"
BDEX_readPipe = open(BDEX_readPipe_name,'r')
BDEX_readPipe_line = BDEX_readPipe.readline()
print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
assert BDEX_readPipe_line == "BDEX-PIPE !******************!\n", \
    "BDEX_readPipe_line='"+BDEX_readPipe_line+"'"

#Open PIPEFUN pipes
print "Opening", DYNK_writePipe_name, "for writing"
DYNK_writePipe = open(DYNK_writePipe_name,'w')
print "Opening", DYNK_readPipe_name, "for reading"
DYNK_readPipe = open(DYNK_readPipe_name,'r')

DYNK_readPipe_line = DYNK_readPipe.readline()
print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
assert DYNK_readPipe_line == "DYNKPIPE !******************!\n",\
    "DYNK_readPipe_line='"+DYNK_readPipe_line+"'"
DYNK_readPipe_line = DYNK_readPipe.readline()
print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
assert DYNK_readPipe_line == "INIT ID=AR1_V for FUN=pipe_V1\n"
DYNK_readPipe_line = DYNK_readPipe.readline()
print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
assert DYNK_readPipe_line == "INIT ID=AR1_P for FUN=pipe_P1\n"


#Open LLRFsim TCP/IP connection and fill the buckets array
buckets = []
if LLRFsim_online:
    LLRFsim_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    LLRFsim_socket.connect((LLRFsim_host, LLRFsim_port))
    LLRFsim_socket_file = LLRFsim_socket.makefile()
    #LLRFsim_recdata = LLRFsim_socket.recv(1024)
    LLRFsim_recdata = LLRFsim_socket_file.readline()
    print "Recieved from LLRFsim: '" + LLRFsim_recdata[:-1] + "'"
    assert LLRFsim_recdata.startswith("bunchinfo ")
    nBuckets = int(LLRFsim_recdata.split()[1])

    bunchIdx = 0
    for i in xrange(nBuckets):
        #LLRFsim_recdata = LLRFsim_socket.recv(1024)
        LLRFsim_recdata = LLRFsim_socket_file.readline()
        print "Recieved from LLRFsim: '" + LLRFsim_recdata[:-1] + "'", i, bunchIdx
        LLRFsim_recdata_split = LLRFsim_recdata.split()
        LLRFsim_recdata_deltaT = float(LLRFsim_recdata_split[0])
        LLRFsim_recdata_qFlag  = int(LLRFsim_recdata_split[1])
        if LLRFsim_recdata_qFlag == 0:
            #Empty bucket
            buckets.append(Bucket(None,LLRFsim_recdata_deltaT))
        else:
            assert bunchIdx <= Nbunches
            buckets.append(Bucket(initial_bunches[bunchIdx],LLRFsim_recdata_deltaT))
            bunchIdx += 1
            
    #LLRFsim_recdata = LLRFsim_socket.recv(1024)
    LLRFsim_recdata = LLRFsim_socket_file.readline()
    print "Recieved from LLRFsim: '" + LLRFsim_recdata[:-1] + "'"
    assert LLRFsim_recdata == "end of bunch info\n",\
        "LLRFsim_recdata='"+LLRFsim_recdata+"'"
    
else:
    nBuckets = 2*Nbunches
    bunchIdx = 0
    #Populate every 2nd bunch
    for i in xrange(nBuckets):
        if i % 2 == 0:
            assert bunchIdx <= Nbunches
            buckets.append(Bucket(initial_bunches[bunchIdx],(1/400.0e6)*i))
            bunchIdx += 1
        else:
            buckets.append(Bucket(None,(1/400.0e6)*i))
nBuckets=len(buckets)        
    
print "Starting tracking:"
sixTurn = 1
prevNonemptyBucket = None

for turn in xrange(Nturns):
    for bucketIdx in xrange(nBuckets):
        #sixTurn = bunchNum + turn*Nbunches + 1
        print
        #print "turn/bunchNum/sixTurn = ", turn, bunchNum,sixTurn
        print "turn/bucketIdx = ", turn, bucketIdx
        
        #Read updated (or initial) cavity parameters from LLRFsim
        if LLRFsim_online:
            #LLRFsim_recdata = LLRFsim_socket.recv(1024)
            LLRFsim_recdata = LLRFsim_socket_file.readline()
            print "Recieved from LLRFsim: '" + LLRFsim_recdata[:-1] + "'"
            assert LLRFsim_recdata.startswith("bunchnum"),\
                "LLRFsim_recdata='"+LLRFsim_recdata+"'"
            LLRFsim_recdata_split = LLRFsim_recdata.split()
            
            LLRF_Vt   = float(LLRFsim_recdata_split[1]) #[V]
            LLRF_phi  = float(LLRFsim_recdata_split[2]) #[deg]
            LLRF_fcav = float(LLRFsim_recdata_split[3]) #[Hz]
        else:
            #Don't change LLRF_{Vt,phi,fcav}
            LLRF_Vt   = 3e6  #[V]
            LLRF_phi  = 90.0 #[deg]
            LLRF_fcav = 4e8  #[Hz]

        if buckets[bucketIdx].bunch != None:
            
            #Send updated cavity parameters to SixTrack
            print "Updating voltage & phase using DYNK:"
            # Voltage:
            DYNK_readPipe_line = DYNK_readPipe.readline()
            print "DYNK_readPipe_line: '" + DYNK_readPipe_line[:-1] + "'"
            assert DYNK_readPipe_line.startswith("GET ID=AR1_V TURN=")
            DYNK_readPipe_line_turn = int(DYNK_readPipe_line.split()[-1])
            assert DYNK_readPipe_line_turn == sixTurn, str(DYNK_readPipe_line_turn)+" "+str(sixTurn)
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
                print "Discarded bunch:", map(bunch_discard.get_average, range(6))
                
                #Confirm BDEX state OK prepare to write
                BDEX_readPipe_line = BDEX_readPipe.readline()
                print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
                assert BDEX_readPipe_line == "BDEX WAITING...\n"
                
                #Write bunch 1 to SixTrack
                buckets[bucketIdx].bunch.writeParticlesBDEX(BDEX_writePipe)
                
                #Confirm BDEX state OK and advance pipe
                BDEX_readPipe_line = BDEX_readPipe.readline()
                print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
                assert BDEX_readPipe_line == "BDEX TRACKING...\n"
                                
            else:
                buckets[prevNonemptyBucket].bunch = Bunch.loadParticlesBDEX(BDEX_readPipe)
                print "Old bucket", prevNonemptyBucket,":", map(buckets[prevNonemptyBucket].bunch.get_average, range(6))
                
                #Confirm BDEX state OK prepare to write
                BDEX_readPipe_line = BDEX_readPipe.readline()
                print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
                assert BDEX_readPipe_line == "BDEX WAITING...\n",\
                    "BDEX_readPipe_line='"+BDEX_readPipe_line+"'"
            
                buckets[bucketIdx].bunch.writeParticlesBDEX(BDEX_writePipe)

                #Confirm BDEX state OK and advance pipe
                BDEX_readPipe_line = BDEX_readPipe.readline()
                print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
                assert BDEX_readPipe_line == "BDEX TRACKING...\n"
            #Done swapping!
            
            #Read bunch parameters at cavity from SixTrack
            tempBunch = Bunch.loadParticlesBDEX(BDEX_readPipe)
            
            #Confirm BDEX state OK prepare to write
            BDEX_readPipe_line = BDEX_readPipe.readline()
            print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
            assert BDEX_readPipe_line == "BDEX WAITING...\n"
            #Keep particle distribution
            BDEX_writePipe.write("-1\n")
            BDEX_writePipe.flush()
            #Confirm BDEX state OK and advance pipe
            BDEX_readPipe_line = BDEX_readPipe.readline()
            print "BDEX_readPipe_line: '"+BDEX_readPipe_line[:-1]+"'"
            assert BDEX_readPipe_line == "BDEX TRACKING...\n"

            sixTurn += 1
            prevNonemptyBucket = bucketIdx
            
            y_mean     = tempBunch.get_average(2)*1e-3                     #[m] # 0.0001 #[m]
            phi_mean   = tempBunch.get_average(4)/3e8*LLRF_fcav*360.0      #[deg]
            Q_fraction = float(tempBunch.get_Nparticles()) / float(buckets[bucketIdx].initialMacroParticles)
        else: #No bunch
            print "No bunch!"
            print turn, bucketIdx
            #exit(0)

            y_mean = 0.0
            phi_mean = 0.0
            Q_fraction = 0.0
            
        #Send bunch parameters at cavity to LLRFsim
        if LLRFsim_online:
            print "Sending bunch to LLRFsim..."
            LLRFsim_socket.send("bunchnum %d %d %g %g %g\n" % (0, turn+1, y_mean, phi_mean, Q_fraction) )
            print "Done."

#Close connections
BDEX_readPipe_line = BDEX_readPipe.read()
print "BDEX_readPipe_line: '" + BDEX_readPipe_line[:-1] + "'"
assert BDEX_readPipe_line == "CLOSEUNITS\n" #TODO: Write this in the SixTrack manual!

BDEX_writePipe.close()
BDEX_readPipe.close()
DYNK_writePipe.close()
DYNK_readPipe.close()
if LLRFsim_online:
    LLRFsim_socket.close()
