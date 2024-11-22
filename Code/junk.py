#write a function that simulates a dirac delta through a gaussian, make it as narrow as possible and with amplitude 1 and plot it

import numpy as np
import matplotlib.pyplot as plt

#def dirac_delta(x):
#    return np.exp(-x**2)

#x = np.linspace(-10, 10, 1000)
#y = dirac_delta(x)

#plt.plot(x, y)
#plt.show()

#read the file no.txt and plot it. the file contains 3 columns, first is x and the other two are y1 and y2

data = np.loadtxt('../Data/dataPulsed007.txt')
x = data[:,0]
vi = data[:,1]
vo = data[:,2]


#thr = 0.9

#Hv = np.fft.fft(y2)/np.fft.fft(y1)




#Hv(abs(np.fft.realfft(y2))<thr)=np.nan
#x(abs(np.fft.realfft(y2))<thr)=np.nan


plt.plot(x, vi, label='vi')
plt.plot(x, vo, label='vo')
#plt.xlim(-0.001, 0.001)
plt.xlabel('Time (s)')
plt.ylabel('Amplitude [V]')
plt.title('Pulsed Signal - Original')
plt.grid(which='both', axis='both', linestyle='-.')
plt.legend()
plt.show()






