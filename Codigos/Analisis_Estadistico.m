%% Análisis Estadísticos de resultados%%
%% Extraer data de struct
Kci=[];
Kdi=[];
Ksi=[];
E=[];
MuroIDi=[];
Derivai=[];
for i=1:length(UnDamagedIncresing)
    MuroIDi=vertcat(MuroIDi, UnDamagedIncresing(i).Info.ID);
    Kci=vertcat(Kci, UnDamagedIncresing(i).PerdidaRigidez.Carga');
    Kdi=vertcat(Kdi, UnDamagedIncresing(i).PerdidaRigidez.Descarga');
    Ksi=vertcat(Ksi, UnDamagedIncresing(i).PerdidaRigidez.Secante');
    Di=[UnDamagedIncresing(i).Deriva.MaxDeriva -UnDamagedIncresing(i).Deriva.MinDeriva];
    Derivai=vertcat(Derivai,Di);
    Energia= [UnDamagedIncresing(i).Energia.EnergiaDisipadaAcumuladaNormalizada'];
    E=vertcat(E,Energia);
end 

% Carga
Kc1i=Kci(:,1);
Kc2i=Kci(:,2);
Kc3i=Kci(:,3);
Kc4i=Kci(:,4);

%KCi=[Kc1i;Kc2i;Kc3i;Kc4i];

% Descarga
Kd1i=Kdi(:,1);
Kd2i=Kdi(:,2);
Kd3i=Kdi(:,3);
Kd4i=Kdi(:,4);
%KDi=[Kd1i;Kd2i;Kd3i;Kd4i];

%Secante
Ks1i=Ksi(:,1);
LogKs1i=log(Ks1i);

Ks2i=Ksi(:,2);
LogKs2i=log(Ks2i);

%KSi=[Ks1i;Ks2i];

%% Deriva
Deriva1i=Derivai(:,1);
Deriva2i=Derivai(:,2);

Deriva3i=mean([Deriva1i abs(Deriva2i)],2);
LogDeriva3i=log(Deriva3i);
%DKCi=[Deriva1i;Deriva2i;Deriva1i;Deriva2i];

% Regresiones 
[fitresult_D_Ks1, gof_D_Ks1] = Fit_power2(Deriva3i, Ks1i);
[fitresult_Log_D_Ks1, gof_Log_D_Ks1] = Fit_Lineal(LogDeriva3i,LogKs1i);
[fitresult_D_Ks2, gof_D_Ks2] = Fit_power2(Deriva3i, Ks2i);
[fitresult_Log_D_Ks2, gof_Log_D_Ks2] = Fit_Lineal(LogDeriva3i,LogKs2i);
%% Energía
LogE=log(E);
% Regresiones
[fitresult_E_Ks1, gof_E_Ks1] = Fit_power2(E, Ks1i);
[fitresult_E_Ks2, gof_E_Ks2] = Fit_power2(E, Ks2i);
[fitresult_LogE_Ks1, gof_LogE_Ks1] = Fit_Lineal(LogE,LogKs1i);
[fitresult_LogE_Ks2, gof_LogE_Ks2] = Fit_Lineal(LogE, LogKs2i);
%% Figuras K-Deriva

% KC% 
figure
scatter(Deriva1i,Kc1i,marker= '.')
hold on 
scatter(Deriva2i,Kc2i,marker='.')
hold on
scatter(Deriva1i,Kc3i,marker= '.')
hold on 
scatter(Deriva2i,Kc4i,marker='.')
ylim([0 2])
xlim([0,0.025])
grid on 
title("Kc vs deriva")
legend("Kc1","Kc2","Kc3","Kc4")
xlabel("Deriva")
ylabel("K_i/K")


% KD% 
figure
scatter(Deriva1i,Kd1i,marker= '.')
hold on 
scatter(Deriva2i,Kd2i,marker='.')
hold on
scatter(Deriva1i,Kd3i,marker= '.')
hold on 
scatter(Deriva2i,Kd4i,marker='.')
ylim([0 2])
xlim([0,0.025])
grid on 
title("Kd vs deriva")
legend("Kd1","Kd2","Kd3","Kd4")
xlabel("Deriva")
ylabel("K_i/K")


% KS% 
figure
subplot(2,1,1)
scatter(Deriva3i,Ks1i,marker= '.')
hold on
scatter(Deriva3i,Ks2i,marker= '.')
hold on 
ylim([0 2])
xlim([0,0.025])
grid on 
title("Ks vs Deriva")
legend("Ks1","Ks2")
xlabel("Deriva")
ylabel("K_i/K")

subplot(2,1,2)
scatter(LogDeriva3i,LogKs1i,marker= '.')
hold on
scatter(LogDeriva3i,LogKs2i,marker= '.')
hold on
title("Ks1 vs Deriva")

xlabel("ln(Deriva)")
ylabel("ln(K_i/K)")
legend("fit p1x+p2","Limites predicción 95%")
grid on


% Regresiones% 
%Ks1
figure
subplot(2,2,1)
scatter(Deriva3i,Ks1i,marker= '.')
hold on
plot(fitresult_D_Ks1,'predobs', 0.90 );
ylim([0 2])
xlim([0,0.025])
grid on 
title("Ks1 vs Deriva")
legend("fit ax^b+c","Limites predicción 95%")
xlabel("Deriva")
ylabel("K_i/K")

subplot(2,2,2)
scatter(LogDeriva3i,LogKs1i,marker= '.')
hold on
plot(fitresult_Log_D_Ks1,'predobs', 0.95 );
title("Ks1 vs Deriva")
xlabel("ln(Deriva)")
ylabel("ln(K_i/K)")
legend("fit p1x+p2","Limites predicción 95%")
grid on

%Ks2
%figure
subplot(2,2,3)
scatter(Deriva3i,Ks2i,color=[0.8500 0.3250 0.0980],marker= '.')
hold on
plot(fitresult_D_Ks2,'predobs', 0.90 );
ylim([0 2])
xlim([0,0.025])
grid on 
title("Ks2 vs deriva")
legend("fit ax^b+c","Limites predicción 95%")
xlabel("Deriva")
ylabel("K_i/K")

subplot(2,2,4)
scatter(LogDeriva3i,LogKs2i,marker= '.',color=[ 0.4940    0.1840    0.5560])
hold on
plot(fitresult_Log_D_Ks2,'predobs', 0.95 );
title("Ks2 vs Deriva")

xlabel("ln(Deriva)")
ylabel("ln(K_i/K)")
legend("fit p1x+p2","Limites predicción 95%")
grid on

%% Figuras K-Energía
%Energia
figure
subplot(2,1,1)
scatter(E,Ks1i,marker= '.')
hold on 
scatter(E,Ks2i,marker='.')
hold on
ylim([0 2])
grid on 
title("Ks vs Energía Acumulada Disipada Normalizada")
legend("Ks1","Ks2")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")

%LogE
subplot(2,1,2)
scatter(LogE,LogKs1i,marker= '.')
hold on 
scatter(LogE,LogKs2i,marker='.')
hold on
ylim([0 2])
grid on 
title("Ks vs Energía Acumulada Disipada Normalizada")
legend("Ks1","Ks2")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")
%%
% Regresiones% 
%Ks1
figure
subplot(2,2,1)
scatter(E,Ks1i,marker= '.')
hold on
plot(fitresult_E_Ks1,'predobs', 0.90 );
ylim([0 2])
grid on 
title("Ks1 vs Deriva")
legend("fit ax^b+c","Limites predicción 95%")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")

subplot(2,2,2)
scatter(LogE,LogKs1i,marker= '.')
hold on
plot(fitresult_LogE_Ks1,'predobs', 0.95 );
title("Ks1 vs Deriva")
xlabel("ln(\sum En)")
ylabel("ln(K_i/K)")
legend("fit p1x+p2","Limites predicción 95%")
grid on

%Ks2
%figure
subplot(2,2,3)
scatter(E,Ks2i,marker= '.')
hold on
plot(fitresult_E_Ks2,'predobs', 0.90 );
ylim([0 2])
grid on 
title("Ks2 vs deriva")
legend("fit ax^b+c","Limites predicción 95%")
xlabel("Energía Acumulada Disipada Normalizada")
ylabel("K_i/K")

subplot(2,2,4)
scatter(LogE,LogKs2i,marker= '.',color=[ 0.4940    0.1840    0.5560])
hold on
plot(fitresult_LogE_Ks2,'predobs', 0.95 );
title("Ks2 vs Deriva")

xlabel("ln(\sum En)")
ylabel("ln(K_i/K)")
legend("fit p1x+p2","Limites predicción 95%")
grid on