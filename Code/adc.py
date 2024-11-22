import tdwf
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt 
import numpy as np

# -[Configurazione Analog Discovery 2]-----------------------------------------
#   1. Connessiene con AD2
ad2 = tdwf.AD2()
#   2. Configurazione generatore di funzioni
wgen = tdwf.WaveGen(ad2.hdwf)
xv = np.linspace(-10,10,1001)
mydata = np.exp(-10*xv**2)
wgen.w1.config(ampl = 2, func=tdwf.funcCustom, data = mydata)
#wgen.w1.config(ampl = 2, func=tdwf.funcSine, freq = 1)
wgen.w1.freq = 30000
wgen.w2.freq = 1e3+0.1
wgen.w2.sync()
wgen.w1.start()
#   3. Configurazione oscilloscopio
scope = tdwf.Scope(ad2.hdwf)
scope.fs=100000
scope.npt=100000
scope.ch1.rng = 5
scope.ch2.rng = 5
scope.trig(True, level = 1, sour = tdwf.trigsrcCh1)

# -[Funzioni di gestione eventi]-----------------------------------------------
def on_close(event):
    global flag_run
    flag_run = False
def on_key(event):
    global flag_run
    global flag_acq
    if event.key == 'x':  # => export su file
        filename = input("Esporta dati su file: ")
        data = np.column_stack((scope.time.vals, scope.ch1.vals, scope.ch2.vals))
        if scope.npt > 8192:
            info =  f"Acquisizione Analog Discovery 2 - Lunga durata\ntime\tch1\tch2"
        else:
            info =  f"Acquisizione Analog Discovery 2\nTimestamp {scope.time.t0}\ntime\tch1\tch2"
        np.savetxt(filename, data, delimiter='\t', header=info)
    if event.key == ' ':  # => run/pausa misura
        flag_acq = not flag_acq
    if event.key == 'escape':  # => esci dalla misura
        flag_run = False

# -[Ciclo di misura]-----------------------------------------------------------
fig, ax = plt.subplots(figsize=(12,6))
fig.canvas.mpl_connect("close_event", on_close)
fig.canvas.mpl_connect('key_press_event', on_key)
flag_run = True
flag_acq = True
flag_first = True
while flag_run:
    if flag_acq: # l'acquisizione è attiva?
        scope.sample()
    # Visualizzazione
    if flag_first:
        flag_first = False
        hp1, = plt.plot(scope.time.vals, scope.ch1.vals, "-", label="Ch1", color="tab:orange")
        hp2, = plt.plot(scope.time.vals, scope.ch2.vals, "-", label="Ch2", color="tab:blue")
        plt.legend()
        plt.grid(True)
        plt.xlabel("Time [msec]", fontsize=15)
        plt.ylabel("Signal [V]", fontsize=15)
        plt.title("User interaction: x|space|escape")
        plt.tight_layout()
        plt.show(block = False)
    else:
        hp1.set_ydata(scope.ch1.vals)
        hp2.set_ydata(scope.ch2.vals)
        fig.canvas.draw()
        fig.canvas.flush_events()

plt.close(fig)
ad2.close()