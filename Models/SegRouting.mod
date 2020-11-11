reset;
param Nnodos;
#Nodos de la red:
set nodos = 1..Nnodos;
#Demandas:
set Demanda = {i in nodos,j in nodos};
#Demanda entre nodos:
param H{Demanda};
#Número de caminos:
param P;
#Caminos:
set PATH=1..P;
#Inicio camino:
param I_P{PATH};
#Fin camino:
param F_P{PATH};
#Links de la red:
set links within {nodos,nodos};
#Links camino:
param L_P{links,PATH};
#Nodos camino:
param N_P{nodos,PATH};
#Máximo número de labels:
param K;
#Capacidad aristas:
param C{links};

#Cantidad de la demanda D enviada por el camino p:
var x{Demanda,PATH} binary;
#Variable de balance:
var alpha>=0;

minimize Carga: alpha+sum{(i,j) in Demanda, p in PATH} x[i,j,p]/(sum{(i2,j2) in Demanda,p2 in PATH} 1)+(sum{(i1,j1) in links,(i2,j2) in Demanda,p in PATH: L_P[i1,j1,p]==1} x[i2,j2,p])/(sum{(i1,j1) in links} 1000);
subject to flujo{(i,j) in Demanda, e in nodos:H[i,j]>0}:sum{p in PATH:I_P[p]==e} x[i,j,p]-sum{p2 in PATH:F_P[p2]==e} x[i,j,p2] = if (e == i) then 1 else  if (e == j) then -1 else 0 ;
subject to _Labels{(i,j) in Demanda}: sum{p in PATH} x[i,j,p]<=K;
subject to capacit{(i1,j1) in links}: sum{(i2,j2) in Demanda,p in PATH:L_P[i1,j1,p]==1} H[i2,j2]*x[i2,j2,p]<=alpha*C[i1,j1];
subject to coherent{(i1,j1) in Demanda, (i2,j2) in Demanda, p in PATH: I_P[p]==i1 and F_P[p] == j1} : x[i1,j1,p] >=  x[i2,j2,p];