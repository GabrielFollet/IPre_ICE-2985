function [] = GraficarHysteresis(ProcessedData,opt)
%Grafica hysteresis general y opcionalmente la de cada ciclo 
% Util para ver si interpolacione,es rigidez de carga y otros se estan
% calculando bien
Ciclos=ProcessedData.Ciclos.DataCiclos;
unidades=ProcessedData.Info.Unidades;
titulo=ProcessedData.Info.ID;
Hysteresis=ProcessedData.Data.ProcessedData;
BackBone=ProcessedData.Backbone.BackBone;
BackBoneMod=ProcessedData.Backbone.BackBoneBilineal;
Bilineal=ProcessedData.Backbone.ModeloBiLineal;
PuntoFalla=ProcessedData.Backbone.Falla;
%Bilineal=ProcessedData.Backbone.Ajuste_Bilineal;
if opt==1
    figure
    plot(Hysteresis(:,1),Hysteresis(:,2),'-','Color',[0.8 0.8 0.8],'LineWidth',1)
    hold on
    plot(BackBone(:,1),BackBone(:,2),"Color",'k',LineWidth=2)
    hold on 
    plot(BackBoneMod(:,1),BackBoneMod(:,2),"Color",'b',LineWidth=2)
    hold on 
    plot(Bilineal(:,1),Bilineal(:,2),"Color",'r',LineWidth=2)
    hold on 
    if PuntoFalla(1,:)~=[0 0]
        scatter(PuntoFalla(1,1),PuntoFalla(1,2),250,'r',Marker='x',LineWidth=2)
        hold on
        plot([Bilineal(end,1) PuntoFalla(1,1)],[Bilineal(end,2) PuntoFalla(1,2)],':',"Color",'r',LineWidth=2)
    end 
    if PuntoFalla(2,:)~=[0 0]
        scatter(PuntoFalla(2,1),PuntoFalla(2,2),250,'r',Marker='x',LineWidth=2)
        hold on
        plot([Bilineal(1,1) PuntoFalla(2,1)],[Bilineal(1,2) PuntoFalla(2,2)],':',"Color",'r',LineWidth=2)
    end
    title("Idealización Comportamiento Fuerza-Deformación")
    ylabel("Fuerza"+"("+unidades(2)+")")
    xlabel("Deformación"+"("+unidades(1)+")")
    grid on
    grid minor
    legend("Puntos Experimentales","Backbone","Backbone procesado", "Modelo Bi-Lineal",Location="best")



else 
    n=length(Ciclos);
    for i=1:n-1
        figure
        cicloactual=Ciclos{i};
        scatter(cicloactual(:,1),cicloactual(:,2),'filled')
        hold on 
        if opt==3
            rig=find(~cicloactual(:,2));
            y1=0; 
            x1=cicloactual(rig(end),1);
            [maxf(i),maxfI(i)]=max(cicloactual(:,2));
            y2=cicloactual(maxfI(i),2);
            x2=cicloactual(maxfI(i),1);

            [maxdef(i),maxdefI(i)]=max(cicloactual(:,1));
            y3=cicloactual(maxdefI(i),2);
            x3=cicloactual(maxdefI(i),1);

            [minf(i),minfI(i)]=min(cicloactual(:,2));
            y2neg=cicloactual(minfI(i),2);
            x2neg=cicloactual(minfI(i),1);

            [mindef(i),mindefI(i)]=min(cicloactual(:,1));
            y3neg=cicloactual(mindefI(i),2);
            x3neg=cicloactual(mindefI(i),1);


            y4=0; 
            x4=cicloactual(rig(1),1);

             plot([x2 x1],[y2 y1],"r",LineWidth=0.7)
             hold on
             plot([x3 x1],[y3 y1],"m",LineWidth=0.7)
             hold on
             hold on
             plot([x2 x4],[y2 y4],"c",LineWidth=0.7)
             hold on
             plot([x3 x4],[y3 y4],"b",LineWidth=0.7)
             hold  on
             plot([x2neg x2],[y2neg y2],"g",LineWidth=2)
             plot([x3neg x3],[y3neg y3],"y",LineWidth=2)
             legend("Datos experimetales","K_{c1}","K_{c2}","K_{d1}","K_{d2}","K_{s1}","K_{s2}",'Location','northwest')
        end

        grid on
        title(titulo+"---Hysteresis ciclo = "+ num2str(i))
        ylabel("Fuerza"+"("+unidades(2)+")")
        xlabel("Deformación"+"("+unidades(1)+")")
        hold on
    end

end