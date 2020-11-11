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
#camino camino
param P_P{PATH,PATH};

#Cantidad de la demanda D enviada por el camino p:
var x{(i,j) in Demanda, p in PATH :I_P[p]==i and F_P[p]==j} binary;
#Variable de balance:
var alpha>=0;

minimize Carga: alpha+(sum{(i,j) in Demanda, p in PATH :I_P[p]==i and F_P[p]==j} x[i,j,p])/(sum{(i,j) in Demanda, p in PATH} 1)+(sum{(i1,j1) in links,(i2,j2) in Demanda,p in PATH: I_P[p]==i2 and F_P[p]==j2 and L_P[i1,j1,p]==1} x[i2,j2,p])/(sum{(i1,j1) in links} 1000);
subject to Camino_Entrada_Salida{(i,j) in Demanda : H[i,j] > 0 }:sum{p in PATH:I_P[p]==i and F_P[p]==j} x[i,j,p]=1;
subject to capacit{(i1,j1) in links}: sum{(i2,j2) in Demanda,p in PATH:  I_P[p]==i2 and F_P[p]==j2 and L_P[i1,j1,p]==1} H[i2,j2] * x[i2,j2,p]<=alpha*C[i1,j1];
subject to contenido{(i1,j1) in Demanda, (i2,j2) in Demanda,p1 in PATH, p2 in PATH:j1==j2 and P_P[p1,p2]==1 and I_P[p1]=i1 and F_P[p1]=j1 and I_P[p2]=i2 and F_P[p2]=j2}: x[i1,j1,p1]>=x[i2,j2,p2];