# README #

# SOFTWARE
Windows 11
Matlab 2022b con machine learning toolbox
Opensees 3.5.0 64bit

# EJECUCION DEL CODIGO
Una vez se cuenta con las herramientas de software necesarias es necesario verificar el contenido
de la carpeta 'heteogenous-soil->src->opensees'. Esta carpeta debe contener los archivos relacionados con la ejecucion de opensees contenida en las dos carpetas por defecto 'bin' y 'lib'. 

Se abre matlab y se agrega al 'path' la carpeta raiz que contiene todo el proyecto 'heterogenous-soil'.

Para ello en la ventana 'current folder' navegamos de tal forma que sea posible ver la carpeta
principal del proyecto 'heteogenous-soil', sobre la cual damos clic derecho y seleccionamos la 
opcion 'add to path -> select folders and subfolders'


La carpeta 'src->matlab' contiene dos archivos 'main_suelo_generacion.m' y 'main_opensees_analisis.m'

'main_suelo_generacion.m' : permite crear el modelo del suelo heterogeneo a partir de los parametros definidos en las variables x_tamano ( tamaño x), dx ( discretizacion eje x), y_tamano ( tamaño y), 
dy ( discretizacion eje y), ll_medio, cov, l_ac (longitud autocorrelacion).

El modelo del suelo heterogeneo es almacenado en el archivo 'suelo_espacio.mat' que puede ser ubicado en la carpeta 'resultados' de acuerdo a los parametros de tamaño de suelo, varianza y covarianza, asi como el consecutivo respectivo del suelo generado al ejecutar el script. Este archivo contiene una variable cuyo nombre por defecto es 'suelo_0', siempre es el mismo sin importar la carpeta suelo que contenga el archivo 'suelo_espacio.mat'.

'main_opensees_analisis' : permite ejecutar el analisis del modelo de acuerdo a los parametros definidos en las variables x_tamano, dx, y_tamano, dy, cov, l_ac, folder_name, earth_quake_file, 
cortes

# ESTRUCTURA DE CARPETAS

El proyecto esta organizado en una estructura de carpetas para organizar el codigo creado y asi mismo la informacion ralacionada con los resultados obtenidos 
al evaluar 

Los archivos de resultados son creados en la misma ubicacion donce se localiza el ejecutable del opensees

suelo-prj/
├── archivos																	carpeta para almacenar archivos empleados como plantillas
├── leeme.txt															
├── resultados																	Se crea durante la ejecucion : carpeta que almacena los resultados y el modelo generado
│   └── x_<tamaño>--y<tamaño>_-dx<tamaño>_-dy_<tamaño>		carpeta cuyo nombre esta definido por el tamaño del modelo x_<>
│       └── conx_<tamaño>-lt_<tamaño>
│           └── suelo_<numero de suelo>										carpeta donde se almacena el suelo heterogeneo generado 
│               └── corte_<distancia de corte>									carpeta donde se almacenan datos y resultados del corte respectivo
│                  └── simulacion												carpeta donde se almacenan los resultados de la simulacion realizada con opensees
│	                   └── heterogeneo											simulacion realizada del suelo heterogeneo con opensees
│    	               └── limiteInferior										simulacion realizada del suelo limiteInferior con opensees
│        	           └── limiteSuperior										simulacion realizada del suelo limiteSuperior con opensees
│                  └── analisis												carpeta donde se almacenan los analisis efectuados para cada conjunto de datos
│	                   └── heterogeneo											analisis de resultados suelo heterogeneo con opensees
│    	               └── limiteInferior										analisis de resultados suelo limiteInferior con opensees
│        	           └── limiteSuperior										analisis de resultados suelo limiteSuperior con opensees
├── src
│   ├── matlab															carpeta que contiene los codigos en matlab
│   └── opensees															carpeta que contiene el ejecutable de opensees
└── tmp																	Se crea durante la ejecucion : En esta carpeta se almacenan los resultados preliminares al correr una simulacion una vez evaluado el modelo se almacenan y organizan los resultados en la respectiva carpeta y se elimina el contenido de esta carpeta 





