%% Análisis Estadísticos de resultados%%
%% Rigidez vs Deriva(Ensayos sin daño previo)
Kc=[];
Kd=[];
Ks=[];
MuroID=[];
Deriva=[];
for i=1:length(UnDamaged)
    MuroID=vertcat(MuroID, UnDamaged(i).Info.ID);
    Kc=vertcat(Kc, UnDamaged(i).PerdidaRigidez.Carga');
    Kd=vertcat(Kd, UnDamaged(i).PerdidaRigidez.Descarga');
    Ks=vertcat(Ks, UnDamaged(i).PerdidaRigidez.Secante');
    D=[UnDamaged(i).Deriva.MaxDeriva UnDamaged(i).Deriva.MaxDeriva -UnDamaged(i).Deriva.MinDeriva -UnDamaged(i).Deriva.MinDeriva];
    Deriva=vertcat(Deriva,D);
end 

% Carga
Kc1=Kc(:,1);
Kc2=Kc(:,2);
Kc3=Kc(:,3);
Kc4=Kc(:,4);
KC=[Kc1;Kc2;Kc3;Kc4];
% Descarga
Kd1=Kd(:,1);
Kd2=Kd(:,2);
Kd3=Kd(:,3);
Kd4=Kd(:,4);
KD=[Kd1;Kd2;Kd3;Kd4];
%Secante
Ks1=Ks(:,1);
Ks2=Ks(:,2);
KS=[Ks1;Ks2];
%Deriva
Deriva1=Deriva(:,1);
Deriva2=Deriva(:,2);
Deriva3=mean([Deriva1 Deriva2],2);
DKC=[Deriva1;Deriva2;Deriva1;Deriva2];

% Figuras Rigidez vs deriva
% KC% 
figure
scatter(Deriva1,Kc1,marker= '.')
hold on 
scatter(Deriva2,Kc2,marker='.')
hold on
scatter(Deriva1,Kc3,marker= '.')
hold on 
scatter(Deriva2,Kc4,marker='.')
ylim([0 2])
xlim([0,0.025])
grid on 
title("Perdida de rigidez(Kc) vs deriva")
legend("Kc1","Kc2","Kc3","Kc4")
xlabel("Deriva")
ylabel("K_i/K")

% KD% 
figure
scatter(Deriva1,Kd1,marker= '.')
hold on 
scatter(Deriva2,Kd2,marker='.')
hold on
scatter(Deriva1,Kd3,marker= '.')
hold on 
scatter(Deriva2,Kd4,marker='.')
ylim([0 2])
xlim([0,0.025])
grid on 
title("Perdida de rigidez(Kd) vs deriva")
legend("Kd1","Kd2","Kd3","Kd4")
xlabel("Deriva")
ylabel("K_i/K")

% KS% 
figure
scatter(Deriva3,Ks1,marker= '.')
hold on 
scatter(Deriva3,Ks2,marker='.')
hold on
ylim([0 2])
xlim([0,0.025])
grid on 
title("Perdida de rigidez(Ks) vs deriva")
legend("Ks1","Ks2")
xlabel("Deriva")
ylabel("K_i/K")

% Agrupados%
figure
scatter(DKC,KC,marker= '.')
hold on 
scatter(DKC,KD,marker='.')
hold on
scatter([Deriva3;Deriva3],KS,marker='.')
hold on
ylim([0 2])
xlim([0,0.025])
grid on 
title("Perdida de rigidez(Kc1,2,3,4)(Kd1,2,3,4)(Ks1,2) vs deriva")
legend("Kc","Kd","Ks")
xlabel("Deriva")
ylabel("K_i/K")

%% Realizamos los mismo pero eliminmos ensyaos de Colmenareas( multiples ciclos 30/60/120 a misma def)
%% Rigidez vs Deriva
Kci=[];
Kdi=[];
Ksi=[];
MuroIDi=[];
Derivai=[];
for i=1:length(UnDamagedIncresing)
    MuroIDi=vertcat(MuroIDi, UnDamagedIncresing(i).Info.ID);
    Kci=vertcat(Kci, UnDamagedIncresing(i).PerdidaRigidez.Carga');
    Kdi=vertcat(Kdi, UnDamagedIncresing(i).PerdidaRigidez.Descarga');
    Ksi=vertcat(Ksi, UnDamagedIncresing(i).PerdidaRigidez.Secante');
    Di=[UnDamagedIncresing(i).Deriva.MaxDeriva UnDamagedIncresing(i).Deriva.MaxDeriva -UnDamagedIncresing(i).Deriva.MinDeriva -UnDamagedIncresing(i).Deriva.MinDeriva];
    Derivai=vertcat(Derivai,Di);
end 


% Carga
Kc1i=Kci(:,1);
Kc2i=Kci(:,2);
Kc3i=Kci(:,3);
Kc4i=Kci(:,4);
KCi=[Kc1i;Kc2i;Kc3i;Kc4i];
% Descarga
Kd1i=Kdi(:,1);
Kd2i=Kdi(:,2);
Kd3i=Kdi(:,3);
Kd4i=Kdi(:,4);
KDi=[Kd1i;Kd2i;Kd3i;Kd4i];
%Secante
Ks1i=Ksi(:,1);
Ks2i=Ksi(:,2);
KSi=[Ks1i;Ks2i];
%Deriva
Deriva1i=Derivai(:,1);
Deriva2i=Derivai(:,2);
Deriva3i=mean([Deriva1i Deriva2i],2);
DKCi=[Deriva1i;Deriva2i;Deriva1i;Deriva2i];

% Figuras Rigidez vs deriva
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
title("Perdida de rigidez(Kc) vs deriva")
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
title("Perdida de rigidez(Kd) vs deriva")
legend("Kd1","Kd2","Kd3","Kd4")
xlabel("Deriva")
ylabel("K_i/K")

% KS% 

[fitresult_D_Ks, gof] = Fit_Deriva_Rigidez_SinDano_Incremental(Deriva3i, Ks1i);
figure
plot( fitresult_D_Ks,'predobs', 0.9 );
hold on
scatter(Deriva3i,Ks1i,marker= '.')
% hold on 
% scatter(Deriva3i,Ks2i,marker='.')
hold on
ylim([0 2])
xlim([0,0.025])
grid on 
title("Perdida de rigidez(Ks1) vs deriva")
legend("fit ax^b+c","Limites predicción 90%")
xlabel("Deriva")
ylabel("K_i/K")

% Agrupados%
figure
scatter(DKCi,KCi,marker= '.')
hold on 
scatter(DKCi,KDi,marker='.')
hold on
scatter([Deriva3i;Deriva3i],KSi,marker='.')
hold on
ylim([0 2])
xlim([0,0.025])
grid on  
title("Perdida de rigidez(Kc1,2,3,4-Kd1,2,3,4-Ks1,2) vs deriva")
legend("Kc","Kd","Ks")
xlabel("Deriva")
ylabel("K_i/K")

