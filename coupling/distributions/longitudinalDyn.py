import numpy as np

class longitudinalHamiltonian:
    
    def __init__(self,machine="HL_coll"):
        self.mp = 0.938272046e9 #proton mass, eV/c^2
        self.e  = 1.60217657e-19 #C, electron charge
        self.c  = 2.99792485e8   #m/s, speed of light

        self.machine = machine

        self.h       = 35640    #RF harmonic number
        self.omegaRF = 400.8e6*np.pi*2    #Hz, omegaRF = h*omega0
        self.omega0  = self.omegaRF/self.h
        if machine == "LHC_coll":
            self.slip    = 3.225e-4 #Slip factor @ collission
            self.V       = 16e6     #V, RF voltage @ collission
        elif machine == "HL_coll":
            self.slip    = 3.467e-4 #Slip factor @ collission
            self.V       = 16e6     #V, RF voltage @ collissions
        else:
            print "ERROR"
            print "machine should be either 'LHC_coll' or 'HL_coll'"
            exit(1)

        self.beta    = 1.0      # Relativistic beta
        
        self.phiS    = 0.0      # Radians, synchronous RF phase
        
        self.E0      = 7e12     # Beam energy, eV
        self.p0      = np.sqrt(self.E0**2-self.mp**2) #Beam momentum, eV/c

    def calcH(self,DELTA,PHI):
        p = self.p0*(1.0+DELTA) #eV/c
        E = np.sqrt(p**2 + self.mp**2)
        
        DELTA_E = E/self.E0-1
        
        H1 = 0.5* self.omegaRF* self.slip*DELTA**2
        H2 = self.omega0*self.V/(2*np.pi*self.beta**2*E)*(np.cos(PHI)-np.cos(self.phiS)+(PHI-self.phiS)*np.sin(self.phiS))
        
        H = H1+H2
        return (H,H1,H2,DELTA_E)
        
    def makePlots(self):
        import matplotlib.pyplot as plt
  
        delta = np.linspace(-1e-3, 1e-3,200) #delta p / p
        phi   = np.linspace(-3*np.pi,1*np.pi,200)
        DELTA,PHI = np.meshgrid(delta,phi)
        
        (H,H1,H2,DELTA_E) = self.calcH(DELTA,PHI)
        
        def label(CB=True):
            plt.xlabel(r"$\phi$")
            plt.ylabel(r"$\Delta E/E$")
            if CB:
                plt.colorbar()
            
            plt.axvline(0.0,color='k',ls='--')
            plt.axvline(np.pi,color='k',ls='--')
            plt.axvline(-np.pi,color='k',ls='--')
            plt.axhline(0.0,color='k',ls='--')
            
        PHIp = PHI+np.pi #above transition energy

        plt.figure(1)
        plt.title("$H_1$")
        plt.pcolor(PHIp,DELTA_E,H1)
        label()
        plt.figure(2)
        plt.title("$H_2$")
        plt.pcolor(PHIp,DELTA_E,H2)
        label()
        plt.figure(3)
        plt.title("$H = H_1 + H_2$")
        plt.pcolor(PHIp,DELTA_E,H)
        label()
        plt.figure(4)
        plt.title("$H = H_1 + H_2$")
        plt.contour(PHIp,DELTA_E,H,40)
        plt.contour(PHIp,DELTA_E,H,levels=[0.0,-0.01], linewidths=5)
        label(False)

        #Now: Plot generated longitudinal distribution
        if self.machine=="LHC_coll":
            sigma_dE_E = 1.129e-4
            sigma_z    = 7.55e-2 #[m]
        elif self.machine=="HL_coll":
            sigma_dE_E = 1.13e-4
            sigma_z    = 7.55e-2 #[m]

        DEE,DZ = np.random.multivariate_normal((0.0,0.0),((sigma_dE_E**2,0.0),(0.0,sigma_z**2)),1000).T
        PHIZ = self.omegaRF*DZ/self.c/self.beta
        plt.scatter(PHIZ,DEE, marker='+')

        #plt.figure(5)
        #plt.hist(DEE,30,normed=True)
        #x = np.linspace(max(DEE),min(DEE))
        #plt.plot(x,np.exp(-x**2/(2*sigma_dE_E**2))/np.sqrt(2*np.pi)/sigma_dE_E)
        #plt.scatter(DZ,DEE)
        
        plt.show()

if __name__ == "__main__":
    Hclass = longitudinalHamiltonian("HL_coll")
    #Hclass = longitudinalHamiltonian("LHC_coll")
    Hclass.makePlots()
