# IPre_ICE-2985

## ICE 2985 - "Análisis del comportamiento cíclico de muros de hormigón armado"

Gabriel Follet  <gabriel.follet@uc.cl>

Este repositorio contiene los resultados de la investigación de pregrado realizada en 2022-2 en el marco del programa Investigación en Pregrado (IPre) de la Escuela de Ingeniería de la Pontificia Universidad Católica de Chile. La investigación se convalidará como el ramo "ICE 2985 Investigación o Proyecto" del Departamento de Ingeniería Estructural y Geotécnica.

### A continuación se presenta una breve descripción del la oportunidad de investigación.

- ID:  	          2742
- Nombre:         Análisis del comportamiento cíclico de muros de hormigón armado
- Descripción:    Esta oportunidad consiste en determinar parámetros del comportamiento sísmico cíclico de muros de hormigón armado. Los parámetros se determinarán de                   resultados de ensayos experimentales existentes en la literatura.
- Mentor:         Profesor Matias Hube


La investigación se realizó bajo la supervisión del Profesor Matias Hube y de PHd(c) Edgar Chacon.
En esta investigación se realizó un recopilación bibliográfica de ensayos de muros de hormigón armado no confinado , se desarrollaron rutinas en Matlab para analizar el comportamiento de estos. Posteriormente, se realizó un análisis estadístico de los parámetros de daño calculados.

### Los archivos en este repositorio son: 

#### Códigos de Matlab
 
 - `Analisis_Data_Experimental.m` : Script principal que detecta el protocolo de carga del ensayo y calcula la pérdida de fuerza, rígidez y energía disipada en cada                                       ciclo para la data experimental cargada. Tiene como output un struct
 - `GraficarCiclos.m`             : Función que a partir del struct calculado en `Analisis_Data_Experimental.m` grafica el protocolo de carga (supone que es a                                             deformación controlada) en términos de la deriva.
 - `GraficarHisteresis.m`         : Función que a partir del struct calculado en `Analisis_Data_Experimental.m` grafica el comportamiento histéretico del ensayo.
 - `Resultados.m`                 : Función que a partir del struct calculado en `Analisis_Data_Experimental.m` grafica los principales resultados de                                                   `Analisis_Data_Experimental.m`
 - `Analisis_Rigidez_vs_Deriva.m` : Script que recibe un struct de dimensiones *nx1*, este es  un struct compuesto por la concatenación de *n* structs, donde cada uno                                       de estos es el output de `Analisis_Data_Experimental.m` para un ensayo. El script analiza la relación entre la pérdida de                                           rigidez en cada ciclo y la deriva de cada ciclo.
 - `Analisis_Rigidez_vs_Energía.m`: Script que recibe un struct de dimensiones *nx1*, este es un struct compuesto por la concatenación de *n* structs, donde cada                                         uno de estos es el output de  `Analisis_Data_Experimental.m` para un ensayo. El script analiza la relación entre la pérdida de                                       rigidez en cada ciclo y la deriva de cada ciclo.
 - `Fit_Deriva_Rigidez_SinDano_Incremental`:  Función que recibe los outputs de `Analisis_Rigidez_vs_Deriva.m` y genera un fit (ajuste) de  la struct que contiene la data de los ensayos sin protocolo de daño y con protocolo de carga cuasiestático incremental.
 - `Fit_Energía_Rigidez_SinDano_Incremental`:  Función que recibe los outputs de `Analisis_Rigidez_vs_Energia.m` y genera un fit (ajuste) de  la struct que contiene la data de los ensayos sin protocolo de daño y con protocolo de carga cuasiestático incremental.
 - `Fit_Deriva_Rigidez_Moscoso`:  Función que recibe los outputs de `Analisis_Rigidez_vs_Deriva.m` y genera un fit (ajuste) de  la struct que contiene la data de los ensayos de Moscoso (múltiples ciclos a un nivel de deformación).
 - `Fit_Energia_Rigidez_Moscoso`:  Función que recibe los outputs de `Analisis_Rigidez_vs_Energía.m` y genera un fit (ajuste) de  la struct que contiene la data de los ensayos de Moscoso (múltiples ciclos a un nivel de deformación).
 
 ### Ensayos Experimentales
 
 La carpeta **Data Experimental** contiene la data sin procesar de los ensayos considerados.
 
 ### Ensayos Procesados

 La carpeta **Data Procesada** contiene un struct con la data procesada con el scrip `Analisis_Data_Experimental.m` de cada ensayo.
 
 ### Documentación script ##
 La carpeta **Documentación** contiene un manual que explica el funcionamiento del script `Analisis_Data_Experimental.m` y de como utilizar este scrip para realizar el análisis de la data experimental. 
 En particular dentro de la carpeta se encuentran los siguientes archivos
 - Manual_Script.pdf: Archivo PDF con el manula
 - **Docs**: Carpeta con los archivos necesarios para compilar en Latex el manual
    - `Manual_Script.tex` : Archivo .tex con el *main* a compilar 
    - **Figuras** : Carpeta con la figuras utilizada en el manual
