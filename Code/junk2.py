import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

f, a, _, phi, _ = np.loadtxt('../Data/bodeData002.txt', unpack=True)

# a is gain
# c is phase

def tf(f, t1, ta, tb):
    w = 2*np.pi*f
    
    return 1j*w*t1 / ( (1+1j*w*ta) * (1+1j*w*tb) )

R1 = 100.28 * 1e3
R2 = 995.9
C1 = 109.9 * 1e-9
C2 = 54.03 * 1e-9

t1 = R1*C1
t2 = R2*C2

A = t1+t2+R1*C2

tb = 0.5 * ( A + np.sqrt( A**2 - 4*t1*t2) )
ta = t1*t2/tb

params = [t1, ta, tb]

'''
#popt, pcov = curve_fit(tf, f, a, p0=params)
popt, pcov = curve_fit(tf, f, a, p0=params, absolute_sigma=True)
'''


plt.loglog(f, a, 'or')
plt.loglog(f, np.abs( tf(f, *params ) ), '--k')
#plt.loglog(f, np.abs( tf(f, *popt ) ), '--b')
plt.grid()
plt.show()


'''

phi -= np.pi/2

plt.semilogx(f, phi, 'g')

plt.yticks([-np.pi,-np.pi/2,0,np.pi/2,np.pi])
#plt.yticklabels(["-180","-90","0","+90","+180"])
plt.ylabel("Phase [deg]", fontsize=15)
plt.show()

'''




