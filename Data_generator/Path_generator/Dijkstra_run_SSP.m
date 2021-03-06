clear all;
clc;

filedata=fopen('Links_ITALNET.txt');
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
            A(j+1,i+1)=1;
        end;
    end;
end;

clear N_nodos nodo_i nodo_f data filedata i j;

filewrite=fopen('Caminos_ITALNET_SSP.txt','w');
N_nodos=length(A(:,1));
for i=1:1:N_nodos;
    rutas=Dijkstra(A,i);
    N_r=length(rutas(:,1));
    Nodo_fin=0.*(1:N_r);
    for j=1:1:N_r;
        temp=find(rutas(j,:)==0,1,'first');
        if isempty(temp);
            Nodo_fin(j)=rutas(j,end);
        else
            Nodo_fin(j)=rutas(j,temp-1);
        end;
    end;
    for j=1:1:N_r;
        if sum(Nodo_fin==Nodo_fin(j))>1;
        else
            for k=2:1:rutas(j,1)+1;
                fprintf(filewrite,'%d ',rutas(j,k));
            end;
            fprintf(filewrite,'%d\n',rutas(j,rutas(j,1)+2));
        end;
    end;
end;
fclose(filewrite);