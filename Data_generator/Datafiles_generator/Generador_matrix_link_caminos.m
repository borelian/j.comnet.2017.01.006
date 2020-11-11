clear all;
clc;

tic
filedata_1=fopen('Caminos_ITALNET_SSP.txt');
filewrite=fopen('Matrix_L_P_Red_ITALNET_SSP.txt','w');
data=textscan(filedata_1,'%f %f %f %f %f %f','Delimiter',' ');
columnas=5;
fclose(filedata_1);
toc

tic
N_path=length(data{1});
N_nodos=max(data{1});
cont_1=0;
for i=1:1:N_path;
    for j=1:1:columnas;
        if length(data{j+1})>=i;
            if ismember(data{j+1}(i),1:N_nodos);
                cont_1=cont_1+1;
            else
                break;
            end;
        else
            break;
        end;
    end;
end;
toc

tic
link_path(1:cont_1,1:3)=0;
cont=0;
for i=1:1:N_path;
    for j=1:1:columnas;
        if length(data{j+1})>=i;
            if ismember(data{j+1}(i),1:N_nodos);
                cont=cont+1;
                link_path(cont,1:3)=[data{j}(i),data{j+1}(i),i];
            else
                break;
            end;
        else
            break;
        end;
    end;
end;
toc

tic
link=unique([link_path(:,1),link_path(:,2)],'rows');
N_link=length(link(:,1));
L_P(1:N_link,1:N_path)=0;
for i=1:1:N_link
    k=find((link_path(:,1)==link(i,1)).*(link_path(:,2)==link(i,2)));
    L_P(i,link_path(k,3))=1;
end;
toc

tic
fprintf(filewrite,'param Nnodos:=%d;\n',N_nodos);
fprintf(filewrite,'param P:=%d;\n',N_path);
fprintf(filewrite,'param: links: C:=\n');
for i=1:1:N_link;
    if i==N_link
        fprintf(filewrite,'%d %d %d;\n',link(i,1),link(i,2),1);
    else
        fprintf(filewrite,'%d %d %d\n',link(i,1),link(i,2),1);
    end;
end;

fprintf(filewrite,'param L_P:=\n');
for i=1:1:N_link;
    fprintf(filewrite,'[%d,%d,*]',link(i,1),link(i,2));
    for j=1:1:N_path;
        if j==N_path && i==N_link;
            fprintf(filewrite,' %d %d;\n',j,L_P(i,j));
        else
            if j==N_path;
                fprintf(filewrite,' %d %d\n',j,L_P(i,j));
            else
                fprintf(filewrite,' %d %d',j,L_P(i,j));
            end;
        end;
    end;
end;
fprintf(filewrite,'\n');
fprintf(filewrite,'param I_P:=\n');
for i=1:1:N_path;
        if i==N_path;
            fprintf(filewrite,'%d %d;\n',i,data{1}(i));
        else
            fprintf(filewrite,'%d %d\n',i,data{1}(i));
        end;
end;

Nodo_final(1:N_path)=0;
for i=1:1:N_path;
    for j=1:1:columnas+1;
        if length(data{j})>=i;
            if ismember(data{j}(i),1:N_nodos);
                Nodo_final(i)=data{j}(i);
            else
                break;
            end;
        else
            break;
        end;
    end;
end;

fprintf(filewrite,'\n');
fprintf(filewrite,'param F_P:=\n');
for i=1:1:N_path;
        if i==N_path;
            fprintf(filewrite,'%d %d;\n',i,Nodo_final(i));
        else
            fprintf(filewrite,'%d %d\n',i,Nodo_final(i));
        end;
end;

fclose(filewrite);
toc