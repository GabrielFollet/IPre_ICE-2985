function [] = Resultados(DataProcesada)
%Graficos Generales
%   (1)Rigidez KC vs  deriva
%   (2)Rigidez KD vs  deriva
%   (3)Rigidez KS vs  deriva
%   (4)Rigidez KS vs  energia
%   (5)Rigidez  KC vs  suma ductilidad
%   (6)Rigidez  KD vs  suma ductilidad
%   (7)Rigidez  KS vs  suma ductilidad
%   (9)Energia vs ductilidad
%   (10) Energía vs deriva vs perdida rigidez
EnergiaAcumulada=DataProcesada.Energia.EnergiaDisipadaAcumuladaNormalizada;


Dmax=DataProcesada.Deriva.MaxDeriva;
Dmin=DataProcesada.Deriva.MinDeriva;

Kc1=DataProcesada.PerdidaRigidez.Carga(1,:);
Kc2=DataProcesada.PerdidaRigidez.Carga(2,:);
Kc1neg=DataProcesada.PerdidaRigidez.Carga(3,:);
Kc2neg=DataProcesada.PerdidaRigidez.Carga(4,:);

Kd1=DataProcesada.PerdidaRigidez.Descarga(1,:);
Kd2=DataProcesada.PerdidaRigidez.Descarga(2,:);
Kd1neg=DataProcesada.PerdidaRigidez.Descarga(3,:);
Kd2neg=DataProcesada.PerdidaRigidez.Descarga(4,:);

Ks1=DataProcesada.PerdidaRigidez.Secante(1,:);
Ks2=DataProcesada.PerdidaRigidez.Secante(2,:);

MuPos=DataProcesada.Backbone.Ductilidad_en_Ciclo(1,:);
MuNeg=DataProcesada.Backbone.Ductilidad_en_Ciclo(2,:);

SumMuPos=cumsum(MuPos);
SumMuNeg=cumsum(MuNeg);

for i=2:length(MuPos)
    SumMuPos(i)=SumMuPos(i-1)+MuPos(i);
    SumMuNeg(i)=SumMuNeg(i-1)+MuNeg(i);
end 
%% (1) Deriva vs Perdida Rigidez(c)
figure
scatter(Dmax,Kc1,"filled")
hold on 
scatter(Dmax,Kc2,"filled")
legend()
scatter(abs(Dmin),Kc1neg,"filled")
hold on 
scatter(abs(Dmin),Kc2neg,"filled")
legend('KC1/Ke','KC2/Ke','KC1-/Ke-','KC2-/Ke-')
title("Perdida Rigidez vs deriva")
grid on 
grid minor
ylabel('K_i/K_e-')
xlabel('Deriva')
ylim([0,1.5])
%% (2) Deriva vs Perdida Rigidez (d)
figure
scatter(Dmax,Kd1,"filled")
hold on 
scatter(Dmax,Kd2,"filled")
legend()
scatter(abs(Dmin),Kd1neg,"filled")
hold on 
scatter(abs(Dmin),Kd2neg,"filled")
legend('KD1/Ke','KD2/Ke','KD1-/Ke-','KD2-/Ke-')
title("Perdida Rigidez vs deriva")
grid on 
grid minor
ylabel('K_i/K_e-')
xlabel('Deriva')
ylim([0,1.5])
%% (3) Deriva vs Perdida Rigidez(s)
figure
scatter(0.5*(Dmax+abs(Dmin)),Ks1,"filled")
hold on 
scatter(0.5*(Dmax+abs(Dmin)),Ks2,"filled")
legend('Ks1/Ke','Ks2/Ke')
title("Perdida Rigidez vs deriva")
grid on 
grid minor
ylabel('K_i/K_e-')
xlabel('Deriva')
ylim([0,1.5])
%% (4) Energía Acumulada vs Perdida Rigidez (s)
figure
scatter(EnergiaAcumulada,Ks1,"filled")
hold on 
scatter(EnergiaAcumulada,Ks2,"filled")
legend('Ks1/Ke','Ks2/Ke')
title("Perdida Rigidez vs  Energia Disipada Acumulada Normalizada")
grid on 
grid minor
ylabel('K_i/K_e-')
xlabel('$\sum _1^i E/Ee$',Interpreter='latex')
ylim([0,1.5])
%% (5) Ductilidad Acumulada vs Perdida Rigidez 
figure
scatter(SumMuPos,Kc1,"filled")
hold on 
scatter(SumMuPos,Kc2,"filled")
scatter(SumMuPos,Kc1neg,"filled")
hold on 
scatter(SumMuPos,Kc2neg,"filled")
legend('KC1/Ke','KC2/Ke','KC1-/Ke-','KC2-/Ke-')
title("Pérdida Rigidez vs  suma D/dy")
grid on 
grid minor
ylabel('K_i/K_e-')
xlabel('$\sum _1 ^i D_i/D_y$',Interpreter='latex') 
ylim([0,1.5])
%% (6) Ductilidad vs Perdida Rigidez +
figure
scatter(MuPos,Kc1,"filled")
hold on 
scatter(MuPos,Kc2,"filled")
hold on
scatter(MuPos,Kc1neg,"filled")
hold on 
scatter(MuPos,Kc2neg,"filled")
legend('KC1/Ke','KC2/Ke','KC1-/Ke-','KC2-/Ke-')
title("Perdida Rigidez vs d/dy")
grid on 
grid minor
ylabel('K_i/K_e-')
xlabel('D_i/D_y')
ylim([0,1.5])
%% (7) Ductilidad vs Pérdida Rigidez -
figure
scatter(MuPos,Kd1,"filled")
hold on 
scatter(MuPos,Kd2,"filled")
hold on 
scatter(MuPos,Kd1neg,"filled")
hold on 
scatter(MuPos,Kd2neg,"filled")
legend('KD1/Ke','KD2/Ke','KD1-/Ke-','KD2-/Ke-')
title("Perdida Rigidez vs D_i/Dy")
grid on 
grid minor
ylabel('K_i/K_e')
xlabel('D_i/D_y')
ylim([0,1.5])
%% (8) Ductilidad Acumulada vs Energía Disipada Acumulada
figure
scatter(0.5*(SumMuPos+abs(SumMuNeg)),EnergiaAcumulada,"filled")
title("Ductilidad Acumulada vs Energia Disipada Acumulada")
grid on 
grid minor
ylabel('$(\sum _1^i E)/E_T$',Interpreter='latex')
xlabel('$(\sum _1 ^i D_i)/D_y$',Interpreter='latex')
 
end