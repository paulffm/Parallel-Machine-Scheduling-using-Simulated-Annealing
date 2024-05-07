# Parallel Machine Scheduling using Simulated Annealing (NP-Hard)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/paulffm/Discrete-Time-Diffusion-Models-for-Discrete-Data/blob/main/LICENSE)

Goal: Minimal Energy consumption and minimial processing time
Properties: 
- different processing time for each job on each machine
- different sequence dependent setup time for each job on each machine
- different run on-time for each job on each machine 
- different release time for each job

<p align="center">
  <img src="scheduling_time.jpg"  alt="1" width = 560px height = 420px >
</p>

## Usage:
### costmain.m:

Die Simulation der Maschinenbelegung erfolgt in costmain. Dort werden zuerst die die Startparameter gesetzt:

MaxIt steht für die Iterationsanzahl
MaxIt2 steht für die Anzahl, wie oft eine neue Lösung pro Integration erzeugt und verglichen werden soll (m x n)
(Die Berechnungen wurden mit MaxIt=200-400 und MaxIt2=80 durchgeführt)

Mit b wird die Zielfunktion spezifiziert: Q=Z*b+(1-b)*E

Die Starttemperatur T0 und die Abkühlungsrate alpha sind abhängig von der gewählten Startfunktion. 
BSP: (Teilweise leichte Veränderungen bei verschiedenen Endgeräten) 
Für b=1: 	T0=105 alpha=0.8
Für b=0.95 	T0=100 alpha=0.8
Für b=0.8 	T0=100 alpha=0.8
Für b=0: 	T0=500 alpha=0.8

Danach wird mit genModel das Modell mit den angegeben Daten generiert. Anschließend wird eine Zufallslösung mit genSol erzeugt und dessen Verbrauch und Zykluszeit mit calcCost berechnet.

Darauf beginnt die eigentliche Optimierung mit SA. Die Startparameter und die Startlösung wird in die Funktion als Input gegeben. Dann wird aus aus der Startlösung mit genNeigbor eine neue Lösung generiert und diese hinsichtlich des Zielfunktionswertes mit der besten Lösung verglichen. Dies wird so lange wiederholt bis die maximale Iterationsanzahl erreicht ist.

Dann erfolgt eine weitere Abfrage:

Falls nur nach der Zykluszeit/Energieverbrauch minimiert wird und mehrere Maschinenbelegungspläne die gleiche minimale Zykluszeit/Energieverbrauch besitzen, dann berechnet die Funktion calcBestTimeandCost den Plan mit dem geringsten Energieverbrauch/Zykluszeit bei minimaler Zykluszeit/Energieverbrauch. 

Für andere Werte von b, wird lediglich die minimale Zielfunktion Q berechnet und die Diagramme der Belegung ausgegeben

### genModel.m:
In genModel sind die Daten des Belegungsproblems gespeichert. Mit Aufruf dieser Funktion wird ein struct Model erzeugt.

### genSol.m:
Hier wird die erste zulässige Lösung generiert. Dazu wird eine Matrix schedule und eine Matrix Order erzeugt. 

In schedule steht die Spaltenzahl für die den Auftrag und der Inhalt dieses Feldes für die Allokation der Maschine.
BSP: schedule=[2 4 3 ... 2 4 3]

Der 1. Auftrag ist auf Maschine 2 allokiert, der 2. Auftrag auf Maschine 4, der 3. Auftrag auf Maschine 3 und so weiter.

In order wird die Reihenfolge der Aufträge auf der Maschine spezifiziert.

BSP: order=[7 15 9 ... 19 11 14]
Auftrag 1 wird an 7. Stelle auf Maschine 2 allokiert, Auftrag 2 an 15. Stelle auf Maschine, Auftrag 3 an 9. Stelle auf Maschine 3 und so weiter.

Mit diesen beiden Matrizen wird nun eine neue Matrix L entwickelt. In dieser stehen nun alle Aufträge auf einer Maschine in der vorgegebenen Reihenfolge von Order. Anschließend werden aus L noch die Nullzeilen gestrichen und es wird ein Cell daraus gemacht, welches genauso wie schedule und order in Sol gespeichert werden.

### calcTarget.m:
In calctarget werden zuerst alle notwendigen Daten aus model und sol geholt. Dann wird der Wert der Zielfunktionswert über die Allokationsmatrix berechnet. 
Eine Maschine wird dabei erst angeschaltet, wenn der erste Auftrag auf dieser freigegeben ist und die Rüstzeit für den ersten Auftrag auf einer Maschine beträgt zur Vereinfachung 0.
Die berechneten Werte werden wieder in einem Struct gespeichert.

### simulatedannealing.m:
Zunächst wird durch genNeighbor aus der besten bisherigen Lösung eine neue Lösung erzeugt. Diese wird daraufhin hinsichtlich des Zielfunktionswertes mit der bisherigen besten Lösung verglichen. Falls die neue Lösung einen besseren Zielfunktionswert hat, wird diese als neue beste Lösung angenommen. Anschließend wird die Temperatur reduziert und der Vorgang so lange wiederholt, bis das Abbruchkriterium erreicht ist.

### genNeighbor.m:
In genNeighbor werden zur Erzeugung neuer Lösungen Swap- und Insertionmethoden auf die Matrix order und schedule angewandt.

### calcBestTimeandCost.m:
Falls mehrere Pläne, die gleiche minimale Zykluszeit/den minimalen
Verbrauch haben, findet die Funktion den Plan mit geringsten
Verbrauch/geringster Zeit. Dieser Belegungsplan wird anschließend als neuer Lösungsstruct gespeichert.

### plotLowestCTatminimalCT.m:
Vergleicht Zielfunktionswerte der alten besten Lösung und der neuen Lösung aus calcBestTimeandCost.m und plottet daraufhin die Lösung mit dem niedrigeren Wert.

### genPlotTime.m:
Plottet das Gantt-Diagramm anhand des Bearbeitungsbeginns und -ende jedes Auftrags. Die Rüstzeiten und die Zeiten in der eine Maschine auf Auftragsfreigabe wartet, sind die Abstände zwischen den "Blöcken" der einzelnen Aufträge.

### genPlotCost.m:
Plottet das Verbrauchsdiagramm des Maschinenbelegungsplans

Die Struktur des Simulated Annealing Algorithmus, sowie die Grundstruktur der Plots sind aus Heris, M. K. (2015): Parallel Machine Scheduling using Simulated Annealing, in: https://yarpiz.com/367/ypap107-parallel-machine-scheduling, Abgerufen am 07.01.2021. entnommen.
