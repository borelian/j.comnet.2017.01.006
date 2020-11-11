clear all;
clc;

filedata=fopen('Links_UKNET.txt');
data=textscan(filedata,'%f %f %f','Delimiter',' ');
fclose(filedata);
nodo_i=data{1};
nodo_f=data{2};

N_nodos=max(max(nodo_i,nodo_f))+1;
A(1:N_nodos,1:N_nodos)=0;

for i=0:N_nodos-1;
    for j=0:N_nodos-1;
        if sum((nodo_i==i).*(nodo_f==j))>0;
            A(i+1,j+1)=1;
        end;
    end;
end;

clear N_nodos nodo_i nodo_f data filedata i j;

filewrite=fopen('Caminos_UKNET_SP.txt','w');
N_nodos=length(A(:,1));
for i=1:1:N_nodos;
    rutas=Dijkstra(A,i);
    N_r=length(rutas(:,1));
    for j=1:1:N_r;
        for k=2:1:rutas(j,1)+1;
            fprintf(filewrite,'%d ',rutas(j,k));
        end;
        fprintf(filewrite,'%d\n',rutas(j,rutas(j,1)+2));
    end;
end;
fclose(filewrite);