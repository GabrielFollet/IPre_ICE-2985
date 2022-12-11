   %%                   Codigo procesamiento data muros RC Carga Ciclica    
%{Este  scrip tiene como objetivo realizar un carcterización inicial  de comportamiento de un muro bajo cargascíclicas.%}
%% Carga Data experimental
RawData=load("Data Experimental\Moscoso\Moscoso_RW1.txt");
Id="ColmenaresRCW120-U";
Fuente="DIEG PUC";  
Lv= 4520; % mm
Unidades=["mm"   "KN"];
Comentarios=" ";
%% Perfiles y parámetros opcionales  

%Perfiles con posibles combinaciones de los parametros
Perfil=1;

%Pre-Procesamiento
window= 20; % largo de ventana para eliminación de ouliers con metodo mov-median

%BackBone
BackboneOption=1;           % Modelo de bakcbone a ajustar
B_Tolerancia_intermedia=0.95; % Tolerancia para determinar puntos de  backbone no finales
B_Tolerancia_final=0.97;       % Tolerancia para punto final , criterio falla 1
B_tolerancia_Perdida_F=0.10;   % Tolerancia para pérdida de fuerza en grupo -> muro falla
B_tolerancia_Perdida_F_final=0.99;   % Tolereancia para perida de fuerza en último ciclo -> muro falla

%Bi-Lineal
BiLinealOption=1;            % Modelo bi-lineal a ajustar
EnergyTolerance=0.05; % tolerancia para el error maximo en areas bi-lineal 

%Normalización
KNormOption=2; % metodo de normalización de rigidez
Q=0.6;% Valor que define punto en envolvente que define la rigidez de referencia  

%Ductilidad
DuctilityOption=2;% determina is se considera punto de falla como def última o ultimo de bi-lineal

%Detección de Ciclos y Protocoloes
Alpha=0.1; % mínimo de puntos por ciclo(% de segundo ciclo con menos puntos)
MinPointsCicle=6; % minimo de puntos por ciclo
CicleTolerance=0.15; % diferencia maxima entre ciclos a igual deformación para que se consideren parte del mismo grupo
PartialCicleTolerance=0.6;  % tolerancia para decidir si un ciclo parcial se usa para calcular kc kd y ks
FinalPointTolerance=0.4; % el ancho de la descarga en parte negativa tiene que ser al menos el %d del ancho de la parte negativa
MidPointTolerance=0.6; % el ancho de la descarga en parte positiva tiene que ser al menos el %d del ancho de la parte positivo

%Codigo para perfiles
if Perfil==1       % Bilineal con rigidez post-fluecnia
    %BACKBONE
    BackboneOption=1;           
    B_Tolerancia_intermedia=0.90; 
    B_Tolerancia_final=0.99;
    %BI-Lineal%
    BiLinealOption=1;           
    EnergyTolerance= 0.01;
    %Ductilidad
    DuctilityOption=2;
    %Normalizacion
    KNormOption=1; 

elseif Perfil==2    % Bilineal elastoplástica
     %BACKBONE
    BackboneOption=1;           
    B_Tolerancia_intermedia=0.95; 
    B_Tolerancia_final=0.95;
    %BI-Lineal%
    BiLinealOption=2;           
    EnergyTolerance= 0.01;
    %Ductilidad
    DuctilityOption= 1;
end 

%Crea Variable con opciones usadas para el análisis
OpcionesNombres=["window" "BackboneOption" "B_Tolerancia_intermedia " "B_Tolerancia_final" "B_tolerancia_Perdida_F" "B_tolerancia_Perdida_F_final"...
   "BiLinealOption" "EnergyTolerance" "KNormOption" "Q" "DuctilityOption" "Alpha" "MinPointsCicle" "CicleTolerance" "PartialCicleTolerance" "FinalPointTolerance"...
   "MidPointTolerance"]';
OpcionesValores=[window BackboneOption B_Tolerancia_intermedia  B_Tolerancia_final B_tolerancia_Perdida_F B_tolerancia_Perdida_F_final...
   BiLinealOption EnergyTolerance KNormOption Q DuctilityOption Alpha MinPointsCicle CicleTolerance PartialCicleTolerance FinalPointTolerance...
   MidPointTolerance]';

Opciones=horzcat(OpcionesNombres,OpcionesValores);
  
%% Pre-Procesamiento

%Remueve Outliers
[Data,outlierindex] = rmoutliers(RawData,"movmedian",window);
Outliers=nnz(outlierindex);

%Elimina def inicial neg y  agrega def inicial=0
dneg=true;
Neg_inicio=0;
while dneg
    def=Data(1,1);
    fuerza=Data(1,2);
    if def<=0 ||  fuerza<=0
        Data(1,:)=[];
        Neg_inicio=Neg_inicio+1; % registra cuantos puntos se han eliminado
    else 
        dneg=false;
    end
end
inicial= [0 0];                 % Agrega punto inicial
Data=[inicial;Data];
%% Detección de Ciclos y Protocolo

%Interpola puntos (0,f) y (d,0)
n=length(Data);
k=0; 

%Detecta punto donde def pasa de negativa a positiva, lo que marca el incicio/fin de ciclo
for i=2:n-1
    if (Data(i,1) <= 0) && (Data(i+1,1)>=0)
        k=k+1;
        puntoscriticos(k)=i;
    end
end

%Agrega putnos inicio/fin ciclo
k=0;
n=length(puntoscriticos);
num_interp=n-2;
b=zeros(k,2);

%Interpola linealmente para (0,)
for i=1:n 
    indice=puntoscriticos(i);
    f1=Data(indice,2);
    f11=Data(indice+1,2);
    d1=Data(indice,1);
    d11=Data(indice+1,1);
    
    fnew=f1-(f11-f1)/(d11-d1)*d1;
    
    b(i,:)=[0;fnew];
end 

j=0;
%Inserta puntos interpolados recientemente
for i=1:length(b) 
    indice=puntoscriticos(i)+j; 
    j=j+1;
    Data = [Data(1:indice, :); b(i,:); Data(indice+1:end, :)];
end 

%Agrega punto de fuerza 0
n=length(Data);

%Carga 
for i=2:n-1
    if (Data(i,2) <= 0) && (Data(i+1,2)>=0)
        k=k+1;
        f0c(k)=i;
    end
end
nc=length(f0c);
bc=zeros(k,2);

%Interpola linealmente para (0,f)
for i=1:nc 
    indice=f0c(i);
   
    f1=Data(indice,2);
    f11=Data(indice+1,2);
    d1=Data(indice,1);
    d11=Data(indice+1,1);
    
    dc=d1+-f1/(f11-f1)*(d11-d1);
    bc(i,:)=[dc,0];
end 
j=0; 

%Inserta puntos interpolados recientemente
for i=1:nc 
    indice=f0c(i)+j;
    j=j+1;
    Data = [Data(1:indice, :); bc(i,:); Data(indice+1:end, :)];
end 

%Descarga
k=0;

%Detecta punto donde def pasa de neg a pos --> fin de ciclo
for i=2:n-1 
    if (Data(i,2) >= 0) && (Data(i+1,2)<=0)
        k=k+1;
        f0d(k)=i;
    end
end
nd=length(f0d);
bd=zeros(k,2);

%Interpola linealmente para (0,f)
for i=1:nd
    indice=f0d(i);
   
    f1=Data(indice,2);
    f11=Data(indice+1,2);
    d1=Data(indice,1);
    d11=Data(indice+1,1);
    
    dd=d1+-f1/(f11-f1)*(d11-d1);
    bd(i,:)=[dd,0];
end 
j=0; 

%Inserta puntos interpolados recientemente
for i=1:nd 
    indice=f0d(i)+j;
    j=j+1;
    Data = [Data(1:indice, :); bd(i,:); Data(indice+1:end, :)];
end 

%Detección Ciclo 
n=length(Data);
k=0; 
for i=2:n 
    if Data(i,1) == 0
        k=k+1;
       puntoscriticos(k)=i;
    end
end

%Crea un cell(vertical) donde cada elemento es  un array def-fuerza de cada ciclo
puntoscriticos=[1,puntoscriticos,length(Data)]';
ncrit=length(puntoscriticos);
Ciclos=cell(ncrit-1,1);
for i=1:(length(Ciclos))
    if i<ncrit
        Ciclos{i,1}=Data(puntoscriticos(i):puntoscriticos(i+1),:);
    else
        Ciclos{i,1}=Data(puntoscriticos(i):puntoscriticos(ncrit),:);
    end
end
clearvars ncrit
%Elimina ciclos con muy pocos puntos
% agresividad 
duracionminima=max(MinPointsCicle,Alpha*length(Ciclos{1}));
Ciclos_eliminados=cell(3,1);
j=1;%contador interno del ciclo for
for i=1:length(Ciclos)
    largo=length(Ciclos{i,1});
    if largo<duracionminima 
        disp("Ciclo eliminado, muy pocos puntos")
        Ciclos_eliminados{1,j}=i;
        Ciclos_eliminados{2,j}=Ciclos{i,1}; % Registro de ciclos eliminados
        Ciclos{i,1}=[];
        puntoscriticos(i-1)= 0; % se usa el menos uno, pues simepre habrá un punto crítico mas que ciclos, pues estos marcan las transiciones
        j=j+1;
    end
end

emptyeliminatedCells = cellfun('isempty', Ciclos_eliminados); 
Ciclos_eliminados(all(emptyeliminatedCells,2),:) = [];
emptyCells = cellfun('isempty', Ciclos); 
Ciclos(all(emptyCells,2),:) = [];

Idx_neg = puntoscriticos == 0;
puntoscriticos(Idx_neg) = [];

%Con ese codigo se eliminadn ciclos particulares con errores de datos
% Ciclos(1)=[];
% puntoscriticos(1)=[];
Ciclos(end)=[];
puntoscriticos(end)=[];
rpuntoscriticos=[0,puntoscriticos'];

% %%
% Ciclos1=Ciclos(1:6,:);
% Ciclos2=[Ciclos{7,:} ;Ciclos{8,:}];
% Ciclos3=[Ciclos{9,:} ;Ciclos{10,:}];
% Ciclos4=Ciclos(11:end,:);
% 
% Ciclos=[Ciclos1; Ciclos2 ;Ciclos3;Ciclos4];
% 
% rpuntoscriticos=zeros(length(Ciclos),1);
% for i=1:length(Ciclos)
%     rpuntoscriticos(i)=Ciclos{i}(1,1);
% end 
%


%Identifica Protocolo Carga
% Identitica protocolo de carga utilizado en el experimento y encuentra
% maximo y minimos
%Los indices de estos puntos son locales( en cada ciclo)
for i=1:length(Ciclos)
    [maxdef(i),maxdefI(i)]=max(Ciclos{i}(:,1)) ;
    [maxf(i),maxfI(i)]=max(Ciclos{i}(:,2));
    [mindef(i),mindefI(i)]=min(Ciclos{i}(:,1)); 
    [minf(i),minfI(i)]=min(Ciclos{i}(:,2));
end 

%Tolerancia para caracterizacion de ciclo ( en sección fine-tunning)
dciclo=max(abs(mindef(1)),maxdef(1));
deformacion(1)=dciclo;
t=1;
k=1;
for i=2:length(maxdef)
    delta=CicleTolerance*dciclo;
    if i==length(maxdef)
       dciclo_actual=max(abs(mindef(end)),maxdef(end)); 
    else
        dciclo_actual=0.5*(maxdef(i)+abs(mindef(i)));
    end
    if dciclo_actual>dciclo-delta && dciclo_actual<dciclo+delta
        t=t+1;
        dciclo=mean([dciclo dciclo_actual]);
      
    else 
        cantidad_ciclos(k)=t;
        k=k+1;
        dciclo=0.5*(maxdef(i)+abs(mindef(i)));
        deformacion(k)=dciclo;
        t=1;
    end 
end
cantidad_ciclos(k)=t;  
k=0;

%Se crea la tabla con protocolo identificado
Protocolo=table(round(deformacion/Lv*100,2)',cantidad_ciclos');
Protocolo.Properties.VariableNames = {'Deriva(%)','Cantidad de Ciclos'};
info=[round(deformacion)' cantidad_ciclos'];

maxderiva=maxdef./Lv;
minderiva=mindef./Lv;
 
%% Pérdida Fuerza
MaxConsecutive=max(cantidad_ciclos);
DifCicles=length(deformacion);
PerdidaFuerzaPos=zeros(DifCicles,MaxConsecutive);
PerdidaFuerzaNeg=zeros(DifCicles,MaxConsecutive);
Acumulado=1;
for i=1:DifCicles
    N=cantidad_ciclos(i);
    MaxBaseline=maxf(Acumulado);
    MinBaseline=minf(Acumulado);
    for k=1:N
        PerdidaFuerzaPos(i,k)=maxf(Acumulado)/MaxBaseline;
        PerdidaFuerzaNeg(i,k)=minf(Acumulado)/MinBaseline;
        Acumulado=Acumulado+1;
    end
end
%% Perdida Rigidez
% Calcula la rigidez de carga y descarga
n=length(Ciclos);
%Primeros Calculamos rigidez para n-1 Ciclos, y dispues calcualmos par
%ciclos finales(probablmente no completos)

% Creamos vectores vacios
Kc1=zeros(length(Ciclos),1);
Kc2=zeros(length(Ciclos),1);
Kd1=zeros(length(Ciclos),1);
Kd2=zeros(length(Ciclos),1);

Kc1neg=zeros(length(Ciclos),1);
Kc2neg=zeros(length(Ciclos),1);
Kd1neg=zeros(length(Ciclos),1);
Kd2neg=zeros(length(Ciclos),1);

Ks1=zeros(1,length(Ciclos));

Ks2=zeros(1,length(Ciclos));
% Ciclo que calcula rigidez
for i=1:n-1
    rig=find(~Ciclos{i}(:,2));
    y2=Ciclos{i}(maxfI(i),2);
    x2=Ciclos{i}(maxfI(i),1);
    y1=0;
    x1=Ciclos{i}(rig(end),1);
    y3=Ciclos{i}(maxdefI(i),2);
    x3=Ciclos{i}(maxdefI(i),1);
    y4=0; 
    x4=Ciclos{i}(rig(1),1);
    Kc1(i)=(y2-y1)/(x2-x1);
    Kc2(i)=(y3-y1)/(x3-x1);
    Kd1(i)=(y2-y4)/(x2-x4);
    Kd2(i)=(y3-y4)/(x3-x4);

    Datax=Ciclos{i}(1:maxfI(i),1);
    Datay=Ciclos{i}(1:maxfI(i),2);

    % Guardamos esto pues se utilizara para construir el backbone
    Y2(i)=y2;
    X2(i)=x2;

    % Parte Negativa
    y2neg=Ciclos{i}(minfI(i),2);
    x2neg=Ciclos{i}(minfI(i),1);

    y3neg=Ciclos{i}(mindefI(i),2);
    x3neg =Ciclos{i}(mindefI(i),1);

    % Guardamos esto pues se utilizara para construir el backbone
    Y2neg(i)=y2neg;
    X2neg(i)=x2neg;

    % Rigideces parte negativa
    Kc1neg(i)=(y2neg-y4)/(x2neg-x4);
    Kc2neg(i)=(y3neg-y4)/(x3neg-x4);
    Kd1neg(i)=(y2neg-y1)/(x2neg-x1);
    Kd2neg(i)=(y3neg-y1)/(x3neg-x1);

    % Secante
    Ks1(i)=(y2-y2neg)/(x2-x2neg);
    Ks2(i)=(y3-y3neg)/(x3-x3neg);
end  
% Rigidez Ciclo final
 % Tipo 1
if PartialCicleTolerance*maxf(end-1)<maxf(end) % decide si se considera rigidez de carga metodo 1
    x0=Ciclos{end}(1,1);
    y0=Ciclos{end}(1,2);
    x1=Ciclos{end}(maxfI(end),1);
    y1=maxf(end);
    Kc1(end)=(y1-y0)/(x1-x0);
    Y2(n)=y1;
    X2(n)=x1;
end 

% Tipo 2
if PartialCicleTolerance*maxdef(end-1)<maxdef(end) % decide si se considera rigidez de carga metodo 2
    x0=Ciclos{end}(1,1);
    y0=Ciclos{end}(1,2);
    y1=Ciclos{end}(maxdefI(end),2);
    x1=maxdef(end);
    Kc2(end)=(y1-y0)/(x1-x0);
end  

% Tipo 3
if length(find(~Ciclos{end}(:,2)) )>= 1 % decide si se considera rigidez de descarga metodo 1 y 2
    rig=find(~Ciclos{end}(:,2));
    if isempty(rig)
        if Ciclos{end}(end,2)>MidPointTolerance*maxdef(end)
            x0=Ciclos{end}(end,1);
            y0=Ciclos{end}(end,2);
            Kd1(end)=(y1-y0)/(x1-x0);
            y2=Ciclos{end}(maxdefI(end),2);
            x2=maxdef(end);
            Kd2(end)=(y2-y0)/(x2-x0);
        end
    else 
        rig=rig(1);
        x0=Ciclos{end}(rig,1);
        y0=Ciclos{end}(rig,2);
        x1=Ciclos{end}(maxfI(end),1);
        y1=maxf(end);
        Kd1(end)=(y1-y0)/(x1-x0);
        y2=Ciclos{end}(maxdefI(end),2);
        x2=maxdef(end);
        Kd2(end)=(y2-y0)/(x2-x0);
    end
end

% Tipo 4
if PartialCicleTolerance*minf(end-1)>minf(end) % decide si se considera rigidez de Carga neg metodo 1
    rig=find(~Ciclos{end}(:,2));
    if isempty(rig)               % arrgla bug de fallo de interpolacion de (d,o) en ciclo parcial final
        % detecta punto donde def pasa de neg a pos --> fin de ciclo
        for i=2:length(Ciclos{end})
            Data_=Ciclos{end};
            if (Data_(i,2) >= 0) && (Data_(i+1,2)<=0)
                d11=Ciclos{end}(i,1);
                f11=Ciclos{end}(i,2);

                d1=Ciclos{end}(i+1,1);
                f1=Ciclos{end}(i+1,2);

                x0=d1+-f1/(f11-f1)*(d11-d1);
                y0=0;
            end
        end 
    else 
        rig=rig(1);
        x0=Ciclos{end}(rig,1);
        y0=Ciclos{end}(rig,2);
    end 
    x1=Ciclos{end}(minfI(end),1);
    y1=minf(end);
    Kc1neg(end)=(y0-y1)/(x0-x1);
   
    x3=Ciclos{end}(maxfI(end),1);
    y3=maxf(end);
    Ks1(end)=(y3-y1)/(x3-x1);

    Y2neg(n)=y1;
    X2neg(n)=x1;
end 

% Tipo 5
if PartialCicleTolerance*mindef(end-1)>mindef(end) % decide si se considera rigidez de carga metodo 2
    rig=find(~Ciclos{end}(:,2));
    % Mismo cachamullo anterior de interpolacion de (f,0) en ciclo parcial final
    if isempty(rig)               % arrgla bug de fallo de interpolacion de (d,o) en ciclo parcial final
        % detecta punto donde def pasa de neg a pos --> fin de ciclo
        for i=2:length(Ciclos{end})
            Data_=Ciclos{end};
            if (Data_(i,2) >= 0) && (Data_(i+1,2)<=0)
                d11=Ciclos{end}(i,1);
                f11=Ciclos{end}(i,2);

                d1=Ciclos{end}(i+1,1);
                f1=Ciclos{end}(i+1,2);

                x0=d1+-f1/(f11-f1)*(d11-d1);
                y0=0;
            end
        end 
    else 
        rig=rig(1);
        x0=Ciclos{end}(rig,1);
        y0=Ciclos{end}(rig,2);
    end 
    y1=Ciclos{end}(mindefI(end),2);
    x1=mindef(end);
    Kc2neg(end)=(y0-y1)/(x0-x1);

    y3=Ciclos{end}(maxdefI(end),2);
    x3=maxdef(end);
    Ks2(end)=(y3-y1)/(x3-x1);
end 

% Tipo 6
AltoCicloFinal=+abs(mindef(end));
AltoCicloParcial=abs(mindef(end))-abs(Ciclos{end}(end,1));
if Kc2(end)~=0 && AltoCicloParcial>=FinalPointTolerance*AltoCicloFinal % decide si se considera rigidez de descarga metodo 1 y 2
    x0=Ciclos{end}(end,1);
    y0=Ciclos{end}(end,2);
    x1=Ciclos{end}(minfI(end),1);
    y1=minf(end);
    Kd1neg(end)=(y1-y0)/(x1-x0);
    y2=Ciclos{end}(mindefI(end),2);
    x2=mindef(end);
    Kd2neg(end)=(y2-y0)/(x2-x0);
end
Kcarga=[Kc1'; Kc2'; Kc1neg'; Kc2neg'];
Kdescarga=[Kd1';Kd2';Kd1neg';Kd2neg'];
Ksecante=[Ks1; Ks2];

%% Energía disipada 
for i=1:length(Ciclos)
    x=Ciclos{i}(:,1);
    y=Ciclos{i}(:,2);
    Edisipada(i)=polyarea(x,y);
end
Eacumulada(1)=Edisipada(1);
for i=2:length(Edisipada)
    Eacumulada(i)=Eacumulada(i-1)+Edisipada(i);
end
%% BackBone y Bilineal
 desfase=0;
 %Tipo de Backbone 

 % Versión  ASCE 41 7.6.3
if BackboneOption==1        
    for i=1:length(deformacion)
        num_ciclo_def=cantidad_ciclos(i);
        max_def_grupo2(i)=maxdef(1+desfase);
        F_at_max_def_grupo2(i)=maxf(1+desfase);
        min_def_grupo(i)=mindef(1+desfase);
        F_at_min_def_grupo(i)=minf(1+desfase);
        desfase=desfase+num_ciclo_def;
        
    end 
    BackBone=[[fliplr(min_def_grupo) 0 max_def_grupo2]' [fliplr(F_at_min_def_grupo) 0 F_at_max_def_grupo2]'];

 % Versión desp maximo de cada grupo
 elseif BackboneOption==2                                                    
    for i=1:length(deformacion)
        num_ciclo_def=cantidad_ciclos(i);
        [max_def_grupo_v2(i),indice_max_grupo_v2]=max(maxdef(1+desfase:num_ciclo_def+desfase));
        [min_def_grupo_v2(i),indice_min_grupo_v2]=min(mindef(1+desfase:num_ciclo_def+desfase));
        indice_max_grupo_v2=indice_max_grupo_v2+desfase;
        indice_min_grupo_v2=indice_min_grupo_v2+desfase;
        desfase=desfase+num_ciclo_def;
        F_at_max_def_grupo(i)=maxf(indice_max_grupo_v2);
        F_at_min_def_grupo(i)=minf(indice_min_grupo_v2);
    end 
    BackBone=[[fliplr(min_def_grupo_v2) 0 max_def_grupo_v2]' [fliplr(F_at_min_def_grupo) 0 F_at_max_def_grupo]'];

 % Versión f_max maximo de cada grupo
 elseif BackboneOption==3                                                    
    for i=1:length(deformacion)
        num_ciclo_def=cantidad_ciclos(i);
        [max_f_grupo_v3(i),indice_max_grupo_v3]=max(maxf(1+desfase:num_ciclo_def+desfase));
        [min_f_grupo_v3(i),indice_min_grupo_v3]=max(minf(1+desfase:num_ciclo_def+desfase));
        indice_max_grupo_v3=indice_max_grupo_v3+desfase;
        indice_min_grupo_v3=indice_min_grupo_v3+desfase;
        desfase=desfase+num_ciclo_def;
        D_at_max_def_grupo(i)=maxdef(indice_max_grupo_v3);
        D_at_min_def_grupo(i)=mindef(indice_min_grupo_v3);
    end 
    BackBone=[[fliplr(D_at_min_def_grupo) 0  D_at_max_def_grupo]' [fliplr(min_f_grupo_v3) 0 max_f_grupo_v3]'];
end 

BackBoneCopy=BackBone;
 % Verificamos falla y eliminamos puntos no incrementales
j=(length(BackBone)-1)/2;
 BackBonePOS=BackBone(end-j+1:end,:);
 BackBoneNEG=BackBone(1:j,:);
 indices_eliminar_pos=[];


%%Falla por pérdida de fuerza en ciclos a misma def
fallaPOS=[0 0 ];
fallaNEG=[0 0];

%Positiva 
%Perdida fuerza ciclos intermedios
Found=false;
for i=1:length(BackBonePOS(:,1))-1
    if Found
            break
    end
    for k=1:length(PerdidaFuerzaPos(1,:))
        Fposperdidamax=PerdidaFuerzaPos(i,k);
        if Fposperdidamax>0 && Fposperdidamax<B_tolerancia_Perdida_F 
            if length(BackBonePOS(:,1))~=1 % para caso de protocolo de daño a def constante
                BackBonePOS=BackBonePOS(1:i,:);
            end 
            N=sum(cantidad_ciclos(1:i));
            P=N-cantidad_ciclos(i)+k;
            fallaPOS=Ciclos{P}(maxdefI(P),:);
            Found=true;
            break
        end  
    end 
end
%Perdida fuerza final
for k=1:length(PerdidaFuerzaPos(end,:))
    Fposperdidamax=PerdidaFuerzaPos(end,k);
    if Fposperdidamax>0 && Fposperdidamax<B_tolerancia_Perdida_F_final 
        N=sum(cantidad_ciclos(1:end));
        P=N-cantidad_ciclos(end)+k;
        fallaPOS=Ciclos{P}(maxdefI(P),:);
        break
    end  
end 

%Negativo
% Perdida fuerza ciclos intermedios
Found=false;
for i=1:length(BackBoneNEG(:,1))-1
    if Found
            break
    end
    for k=1:length(PerdidaFuerzaNeg(1,:))
        Fposperdidamax=PerdidaFuerzaNeg(i,k);
        if Fposperdidamax>0 && Fposperdidamax<B_tolerancia_Perdida_F 
            if length(BackBoneNEG(:,1))~=1 % para evitar caso de protocolo de daño a def constante
                BackBoneNEG=BackBoneNEG(length(BackBoneNEG)-i+1:end,:);
            end 
            N=sum(cantidad_ciclos(1:i));
            P=N-cantidad_ciclos(i)+k;
            fallaNEG=Ciclos{P}(mindefI(P),:);
            Found=true;
            break
        end  
    end 
end
%Perdida fuerza final
for k=1:length(PerdidaFuerzaNeg(end,:))
    Fposperdidamax=PerdidaFuerzaNeg(end,k);
    if Fposperdidamax>0 && Fposperdidamax<B_tolerancia_Perdida_F_final 
        N=sum(cantidad_ciclos(1:end));
        P=N-cantidad_ciclos(end)+k;
        fallaNEG=Ciclos{P}(mindefI(P),:);
        break
    end  
end
%Verficamos is ulitmo punto fallo el muro
k=0;
if length(BackBonePOS(:,1))~=1% Caso para protocolos de daño a def constante
    if BackBonePOS(end,2)<(B_Tolerancia_final)*BackBonePOS(end-1,2)
        fallaPOS=BackBonePOS(end,:);
        BackBonePOS(end,:)=[];
    end 
end 
if length(BackBoneNEG(:,1))~=1 
    if BackBoneNEG(1,2)>(B_Tolerancia_final)*BackBoneNEG(2,2)
        fallaNEG=BackBoneNEG(1,:);
        BackBoneNEG(1,:)=[];
    end 
end 


 % Eliminamos de Backbone punto no incrementales
 k=0; %cantidad de puntos eliminados
for i=2:length(BackBonePOS)
    if length(BackBonePOS(:,1))>1 % evitar problemas con protocolo de daño a def constante
        if BackBonePOS(i,2)<BackBonePOS(i-k-1,2)*(B_Tolerancia_intermedia)
            k=k+1;
            indices_eliminar_pos(k)=i;
        end 
    end 
end 
BackBonePOS(indices_eliminar_pos,:)=[];
% 
indices_eliminar_neg=[];
k=0;
Back_neg_inverted=flipud(BackBoneNEG);
for i=2:length(BackBoneNEG)
    if length(BackBoneNEG(:,1))~=1% caso de protocolo de daño a def constante
        if abs(Back_neg_inverted(i,2))<abs(Back_neg_inverted(i-k-1,2))*(B_Tolerancia_intermedia)
            k=k+1;
            indices_eliminar_neg(k)=i;
        end 
    end 
end 

Back_neg_inverted(indices_eliminar_neg,:)=[];
BackBoneNEG=flipud(Back_neg_inverted);

BackBone=vertcat(BackBoneNEG(1:end,:),[0 0],BackBonePOS);
 %  Estimación del modelo Bilineal
j=(length(BackBone)-1)/2;
% Se extrae la data de las env
Backbone_def_pos=[0; BackBonePOS(:,1)];
Backbone_fuerza_pos=[0;BackBonePOS(:,2)];
Backbone_def_neg=[BackBoneNEG(:,1);0];
Backbone_fuerza_neg=[BackBoneNEG(:,2);0];
bbpos_area_pos = trapz(Backbone_def_pos,Backbone_fuerza_pos);
bbpos_area_neg = trapz(Backbone_def_neg,Backbone_fuerza_neg);
delta_max=BackBone(end,1);
delta_min=BackBone(1,1);
f_at_def_max=BackBone(end,2);
f_at_def_min=BackBone(1,2);
xq_pos = (0:0.0001:0.3*delta_max)'; % el valor de 0.3 sirve para acotar la busqueda (Knsearch)
vq_pos = interp1(Backbone_def_pos,Backbone_fuerza_pos,xq_pos);
xq_neg = (0.3*delta_min:0.0001:0)'; 
vq_neg = interp1(Backbone_def_neg,Backbone_fuerza_neg,xq_neg);
fyi_pos = zeros(length(xq_pos),1); 
fyi_neg = zeros(length(xq_neg),1); 
delta_yi_pos = zeros(length(xq_pos),1); 
delta_yi_neg = zeros(length(xq_neg),1); 

% Modelo 1
if BiLinealOption==1  
    % Parte Positiva
    for i=1:length(xq_pos)
        fyi_pos(i,1) = vq_pos(i,1)/0.6;
        Kei = vq_pos(i,1) / xq_pos(i,1); 
        delta_yi_pos(i,1) = fyi_pos(i,1) / Kei;
        if fyi_pos(i,1) >= f_at_def_max
           fyi_pos(i,1) = f_at_def_max;
           delta_yi_pos(i,1) = xq_pos(i,1);
        end
        A_i = 0.5*fyi_pos(i,1)*delta_yi_pos(i,1)+(delta_max-delta_yi_pos(i,1))*fyi_pos(i,1)+...
            0.5 * (delta_max-delta_yi_pos(i,1))*(f_at_def_max-fyi_pos(i,1));
        error(i,1) = (A_i-bbpos_area_pos);
        if abs(error(i,1)) <= EnergyTolerance
            break
        end
    end
%     disp(error)
    [aa,Idx] = min(abs(error)); 
    error = error(Idx);
    Yp = [delta_yi_pos(Idx) fyi_pos(Idx)];
    bilin_pos = [0 0;Yp;[delta_max f_at_def_max]];
   
    % Parte Negativa 
    for i=1:length(xq_neg) 
        fyi_neg(i,1) = vq_neg(i,1)/0.6;
        Kei = vq_neg(i,1) / xq_neg(i,1); 
        delta_yi_neg(i,1) = fyi_neg(i,1) / Kei;
        if fyi_neg(i,1) <= f_at_def_min
           fyi_neg(i,1) = f_at_def_min;
           delta_yi_neg(i,1) = xq_neg(i,1);
        end
        A_i = 0.5*abs(fyi_neg(i,1))*abs(delta_yi_neg(i,1))+(abs(delta_min)-abs(delta_yi_neg(i,1)))*abs(fyi_neg(i,1))+...
            0.5 * (abs(delta_min)-abs(delta_yi_neg(i,1)))*(abs(f_at_def_min)-abs(fyi_neg(i,1)));
        error(i,1) = (A_i-abs(bbpos_area_neg));
        if abs(error(i,1)) <= EnergyTolerance
            break
        end
    end
    [bb,Idx] = min(abs(error));
    error = error(Idx);
    Yp = [delta_yi_neg(Idx) fyi_neg(Idx)];
    bilin_neg = [0 0;Yp;[delta_min f_at_def_min]];
    
% Modelo 2
elseif BiLinealOption==2                                                    
    
    % Parte Positiva
    idx_2 = knnsearch(vq_pos,0.6*f_at_def_max);
    vq_pos(idx_2);
    xq_pos(idx_2);
    delta_ySezen = xq_pos(idx_2) /0.6;
    Yp_matamoros = [delta_ySezen f_at_def_max];
    bilin_pos = [0 0;Yp_matamoros;[delta_max f_at_def_max]];
   
    % Parte Negativa
    idx_2_neg = knnsearch(vq_neg,0.6*f_at_def_min);
    vq_neg(idx_2);
    xq_neg(idx_2);
    delta_ySezen = xq_neg(idx_2_neg) /0.6;
    Yp_matamoros = [delta_ySezen f_at_def_min];
    bilin_neg = [0 0;Yp_matamoros;[delta_min f_at_def_min]];
end 

%% Ductilidad

if DuctilityOption==1
    Du=bilin_pos(end,1);
    Duneg=bilin_neg(end,1);
else 
    if fallaPOS==[0 0]
        Du=bilin_pos(end,1);
    else 
        Du=fallaPOS(1,1);
    end
    if fallaNEG==[0 0]
        Duneg=bilin_neg(end,1);
    else 
        Duneg=fallaNEG(1,1);
    end
end 

 mu_pos=Du/bilin_pos(2,1);
 mu_neg=Duneg/bilin_neg(2,1);
Mu=[mu_pos;mu_neg];
MuPos=[];
MuNeg=[];

for i=1:length(maxdef)
    MuPos(i)=maxdef(i)/mu_pos;
end
for i=1:length(mindef)
    MuNeg(i)=mindef(i)/mu_neg;
end
 
%% Normalización de Parámetros
% Rigidez 
if KNormOption==1
    % Discretizamos el backbone
    Backbone_x= (round(delta_min,1):0.1:round(delta_max,1))';
    Backbone_y= interp1(BackBone(:,1),BackBone(:,2),Backbone_x);
    
    % Rigidez referencia positiva
    iKepos = find(Backbone_y< round(Q*f_at_def_max,1));
    Kepos=(Backbone_y(iKepos(end))/Backbone_x(iKepos(end)));
    
    % Rigidez referencia negativa
    iKeneg = find(Backbone_y>= round(Q*f_at_def_min,1));
    Keneg=(Backbone_y(iKeneg(1))/Backbone_x(iKeneg(1)));
    
    % Rigidez referencia secante
    Kesec=(Backbone_y(iKepos(end))-Backbone_y(iKeneg(1)))/(Backbone_x(iKepos(end))-Backbone_x(iKeneg(1)));

elseif KNormOption==2 
% Rigidez referencia de Ajustes lineales
    Kepos=bilin_pos(2,2)/bilin_pos(2,1);
    Keneg=bilin_neg(2,2)/bilin_neg(2,1);
    Kesec=(bilin_pos(2,2)-bilin_neg(2,2))/(bilin_pos(2,1)-bilin_neg(2,1));
end 
% Agrupando rigideces postivas y negativas normalizadas
PerdidaKC=[(Kc1./Kepos)  (Kc2./Kepos) (Kc1neg./Keneg) (Kc2neg./Keneg)]';
PerdidaKD=[(Kd1./Kepos)  (Kd2./Kepos) (Kd1neg./Keneg) (Kd2neg./Keneg)]';
PerdidaKS=[(Ks1./Kesec); (Ks2./Kesec)];
%Energía 
dx2neg=bilin_neg(3,2)/bilin_neg(2,2)*bilin_neg(2,1);
neg=vertcat([bilin_neg(3,1)-dx2neg 0],bilin_neg);
%
dx2pos=bilin_pos(3,2)/bilin_pos(2,2)*bilin_pos(2,1);
pos=vertcat([bilin_pos(3,1)-dx2pos 0],bilin_pos);


E_norm=polyarea(neg(:,1),neg(:,2))+...
    polyarea(pos(:,1),pos(:,2));

% Esto es para ensayos a multiples ciclos de la misma def y el bug de la
% bilienal ajsutada
if E_norm < bilin_neg(end,2)*bilin_neg(end,1)*0.7 % se considero el 0.7 para evitar falsos positivos,
    E_norm =bilin_neg(end,2)*bilin_neg(end,1)/2+ bilin_pos(end,2)*bilin_pos(end,1)/2;
    % no se dividió por 2, pues la E del lado neg debiese de ser similar                                                 
end               
EacumuladaNormalizada=Eacumulada/E_norm;
%% Combinamos Data en struct array
ProcessedData=vertcat(Ciclos{:});
formatSpec="\n----------------------------- \n Ensayo  %s\n -----------------------------\n " + ...
    "Unidades: %s , %s \n ShearSpan:%d mm\n\n " + ...
    "Historia de Manipulación/Alteración: \n\t" + ...
    "Se identificaron y eliminaron %d puntos muestrales irregulares \n\t" + ...
    "Se eliminaron %d puntos muestrales iniciales con fuerza o deformación negativa \n\t"+ ...
    "Se agregó punto inicial (0,0)\n\t"+...
    "Se agregaron %d puntos tipo (0,f) interpolados linealmente para definir limites de ciclos\n\t" + ...
    "Se eliminaron %d ciclos por no cumplir con los requisitos mínimos\n\n" + ...
    "Se identificó el siguiente protocolo de ensayo:\n";
Resumen1=fprintf(formatSpec,Id,Unidades(1),Unidades(2),Lv,Outliers,Neg_inicio,num_interp,length(Ciclos_eliminados));
Protocolo
% formatSpec="Rigidez Final \n \t\t Carga:  %.2f %%  \n\t\t Descarga: %.2f  %% \n\t\t Secante: %.2f %% \n";
% Resumen2=fprintf(formatSpec,(PerdidaKC(end,1)*100),(PerdidaKD(end,1)*100),(PerdidaKS(end,1)*100));
%Creamos structure array
DataProcesada.Data=struct('RawData',{RawData},'ProcessedData',{ProcessedData});
DataProcesada.Ciclos = struct('DataCiclos',{Ciclos},'puntoscriticos',{puntoscriticos},"Protocolo",{Protocolo});
DataProcesada.Deriva = struct('MaxDeriva',{maxderiva'},'MinDeriva',{minderiva'});
DataProcesada.Fuerza = struct('FuerzaMax',{maxf'},'FuerzaMin',{minf'});
DataProcesada.Rigidez = struct('Carga',{Kcarga},'Descarga',{Kdescarga},'Secante',{Ksecante});
DataProcesada.Energia=struct('EnergiaDisipada',{Edisipada'},'EnergiaDisipadaAcumulada',{Eacumulada'},'EnergiaDisipadaAcumuladaNormalizada',{EacumuladaNormalizada});
DataProcesada.Info=struct('Fuente',{Fuente},'ShearSpan',{Lv},'Unidades',{Unidades},'ID',{Id});
DataProcesada.PerdidaRigidez=struct('Carga',{PerdidaKC},'Descarga',{PerdidaKD},'Secante',{PerdidaKS});
DataProcesada.PerdidaFuerza=struct('FuerzaMaxima',{PerdidaFuerzaPos},'FuerzaMinima',{PerdidaFuerzaNeg});
DataProcesada.Backbone=struct('BackBone',{BackBoneCopy},'BackBoneBilineal',{BackBone},"ModeloBiLineal",{[flipud(bilin_neg);bilin_pos;]},"Falla",{vertcat(fallaPOS,fallaNEG)},"Ductilidad",{Mu},"Ductilidad_en_Ciclo",{vertcat(MuPos,MuNeg)});
DataProcesada.Otros=struct('Outliers',{outlierindex},'PuntosNegInicial',{Neg_inicio},'CiclosMuyCortos',{Ciclos_eliminados},'Comentarios',{Comentarios}, 'OpcionesUsadas',{Opciones});
%%  Validación Graficas 
%OutliersGrafico(RawData,Data,outlierindex);
%GraficarCiclos(Colmenares_RCW060D)
GraficarHysteresis(DataProcesada,1)
GraficarCiclos(DataProcesada)
Resultados(DataProcesada)
% Eliminando variables intermedias
clearvars -except DataProcesada
