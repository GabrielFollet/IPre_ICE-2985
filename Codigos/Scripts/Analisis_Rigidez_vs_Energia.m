%% Análisis Estadísticos de resultados%%
%% Rigidez vs Deriva (Ensayos Sin daño previo)
Ks=[];
MuroID=[];
E=[];
for i=1:length(UnDamaged)
    MuroID=vertcat(MuroID, UnDamaged(i).Info.ID);
    Ks=vertcat(Ks, UnDamaged(i).PerdidaRigidez.Secante');
    Energia= [UnDamaged(i).Energia.EnergiaDisipadaAcumuladaNormalizada'];
    E=vertcat(E,Energia);
end 


%Secante
Ks1=Ks(:,1);
Ks2=Ks(:,2);
KS=[Ks1;Ks2];
% Figuras Rigidez vs Energía
% KS% 
figure
scatter(E,Ks1,marker= '.')
hold on 
scatter(E,Ks2,marker='.')
hold on
% ylim([0 2])
% xlim([0,0.025])
grid on 
title("Perdida de rigidez(Ks) vs Energía Acumulada Disipada Normalizada")
legend("Ks1","Ks2")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")

%% Rigidez vs Deriva ( Undamaged Incresing)
Ks=[];
MuroID=[];
E=[];
for i=1:length(UnDamagedIncresing)
    MuroID=vertcat(MuroID, UnDamagedIncresing(i).Info.ID);
    Ks=vertcat(Ks, UnDamagedIncresing(i).PerdidaRigidez.Secante');
    Energia= [UnDamagedIncresing(i).Energia.EnergiaDisipadaAcumuladaNormalizada'];
    E=vertcat(E,Energia);
end 


%Secante
Ks1=Ks(:,1);
Ks2=Ks(:,2);
KS=[Ks1;Ks2];


% Figuras Rigidez vs Energía
% KS% 
[fitresult_D_Ks1, gof1] = Fit_Energia_Rigidez_SinDano_Incremental(E, Ks1);
figure
plot( fitresult_D_Ks1,'predobs', 0.9 );
hold on
scatter(E,Ks1,marker= '.')
% hold on 
% scatter(Deriva3i,Ks2i,marker='.')
hold on
ylim([0 2])
%xlim([0,15])
grid on 
title("Perdida de rigidez(Ks1) vs Energía Disipada")
legend("fit ax^b+c","Limites predicción 90%")
xlabel("Energía Disipada Acumulada Normalizada")
ylabel("K_i/K")

%% Ks vs E
figure
scatter(E,Ks1,marker= '.')
hold on 
scatter(E,Ks2,marker='.')
hold on
% ylim([0 2])
% xlim([0,0.025])
grid on 
title("Perdida de rigidez(Ks) vs Energía Acumulada Disipada Normalizada")
legend("Ks1","Ks2")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")

%% Rigidez vs Energia ( Colmenenares(30-60-120)
Ks=[];
MuroID=[];
E=[];
for i=2:length(Colmenares)
    MuroID=vertcat(MuroID, Colmenares(i).Info.ID);
    Ks=vertcat(Ks, Colmenares(i).PerdidaRigidez.Secante');
    Energia= [Colmenares(i).Energia.EnergiaDisipadaAcumuladaNormalizada'];
    E=vertcat(E,Energia);
end 


%Secante
Ks1=Ks(:,1);
Ks2=Ks(:,2);
KS=[Ks1;Ks2];


% Figuras Rigidez vs Energía
% KS% 
figure
scatter(E,Ks1,marker= '.')
hold on 
scatter(E,Ks2,marker='.')
hold on
% ylim([0 2])
% xlim([0,0.025])
grid on 
title("Perdida de rigidez(Ks) vs Energía Acumulada Disipada Normalizada")
legend("Ks1","Ks2")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")
%% Fit
[fitresult_D_Ks2, gof2] = Fit_Energia_Rigidez_Colmenares(E, Ks1);
[fitresult_D_Ks3, gof3] = Fit_Energia_Rigidez_Colmenares_lineal(E, Ks1);
figure
plot( fitresult_D_Ks2);
hold on
plot( fitresult_D_Ks3,'g');
hold on
scatter(E,Ks1,'b',marker='.')
hold on
ylim([0.6 1.2])
%xlim([0,15])
grid on 
title("Perdida de rigidez(Ks1) vs Energía Disipada")
legend("Ks1vsEnergia","fit ax^b+c","fit ax+b")
xlabel("Energía Disipada Acumulada Normalizada")
ylabel("K_i/K")

%% Rigidez vs Energia ( Colmenenares(30-60-120) Separados
Ks=[];
MuroID=[];
E=[];
figure
for i=2:length(Colmenares)
    MuroID=vertcat(MuroID, Colmenares(i).Info.ID);
    Ks=Colmenares(i).PerdidaRigidez.Secante';
    Energia= Colmenares(i).Energia.EnergiaDisipadaAcumuladaNormalizada';
    scatter(Energia,Ks(:,1),marker= '.')
    hold on
end 
grid on 
title("Perdida de rigidez(Ks1) vs Energía Acumulada Disipada Normalizada")
legend(MuroID)
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")