function [] = GraficarCiclos(ProcessedData)
nombre=ProcessedData.Info.ID;
Ciclos=ProcessedData.Ciclos.DataCiclos;
puntoscriticos=ProcessedData.Ciclos.puntoscriticos;
Lv=ProcessedData.Info.ShearSpan;
n=length(Ciclos);
figure
for i=1:n
    desfase=puntoscriticos(i);
    cicloactual=Ciclos{i};
    tiempoactual=(desfase:1:length(cicloactual)+desfase-1);
    scatter(tiempoactual,cicloactual(:,1)/Lv*100,"filled")
    grid on
    ylabel("Deriva(%)")
    hold on
end
title("Data separada por ciclos "+nombre)
end