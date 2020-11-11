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
var x{(i,j) in Demanda, p in PATH :I_P[p]==i and F_P[p]==j}>=0 <=1;
#Variable de balance:
var alpha>=0;
 
minimize Carga: alpha+(sum{(i,j) in Demanda, p in PATH :I_P[p]==i and F_P[p]==j} x[i,j,p])/(sum{(i,j) in Demanda, p in PATH} 1)+(sum{(i1,j1) in links,(i2,j2) in Demanda,p in PATH: I_P[p]==i2 and F_P[p]==j2 and L_P[i1,j1,p]==1} x[i2,j2,p])/(sum{(i1,j1) in links} 1000);
subject to Camino_Entrada{(i,j) in Demanda : H[i,j] > 0}:sum{p in PATH:I_P[p]==i and F_P[p]==j} x[i,j,p]= 1;
subject to split{(i,j) in Demanda, (e1,e2) in links, (e1,e4) in links: e2<>e4 and sum{p in PATH:I_P[p]==i and F_P[p]==j} L_P[e1,e2,p]>0 and sum{p in PATH:I_P[p]==i and F_P[p]==j} L_P[e1,e4,p]>0}: sum{p1 in PATH: I_P[p1]==i and F_P[p1]==j and L_P[e1,e2,p1]==1} x[i,j,p1] = sum{p2 in PATH: I_P[p2]==i and F_P[p2]==j and L_P[e1,e4,p2]==1} x[i,j,p2];
subject to capacit{(i1,j1) in links}: sum{(i2,j2) in Demanda,p in PATH:  I_P[p]==i2 and F_P[p]==j2 and L_P[i1,j1,p]==1} H[i2,j2] * x[i2,j2,p]<=alpha*C[i1,j1];