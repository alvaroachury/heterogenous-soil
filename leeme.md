# README #

This README would normally document whatever steps are necessary to get your application up and running.

Este archivo describe la estructura general de la estructura de las carpetas generadas que permiten organizar la informacion generada al 
realizar el analisis de un modelo empleando opensees, con el script de matlab almacenado en la carpeta 'soil-prj/src/matlab'

para poder hacer uso de este programa es necesario descargar el ejecutable de opensees de la pagina principal de 'open' y almacenarlo 
directamente en la carpeta 'soil/prj/src/opensees

a continuacion se describe la estructura general de carpetas y el contenido del proyecto creado para la evaluacion de un suelo heterogeneo

Los archivos de resultados son creados en la misma ubicacion donce se localiza el ejecutable del opensees

suelo-prj/
├── archivos																	carpeta para almacenar archivos empleados como plantillas
├── leeme.txt															
├── resultados																	carpeta que almacena los resultados y el modelo generado
│   └── x_<tamaño>--y<tamaño>_-dx<tamaño>_-dy_<tamaño>		carpeta cuyo nombre esta definido por el tamaño del modelo x_<>
│       └── conx_<tamaño>-lt_<tamaño>
│           └── suelo_<numero de suelo>										carpeta donde se almacena el suelo heterogeneo generado 
│               └── corte_<distancia de corte>									carpeta donde se almacenan datos y resultados del corte respectivo
│            														
├── analisis
│   └── x_<tamaño>--y<tamaño>_-dx<tamaño>_-dy_<tamaño>		carpeta cuyo nombre esta definido por el tamaño del modelo x_<>
│       └── conx_<tamaño>-lt_<tamaño>
│           └── soil_<numero de suelo>										carpeta donde se almacena el suelo heterogeneo generado 
├── src
│   ├── matlab															carpeta que contiene los codigos en matlab
│   └── opensees															carpeta que contiene el ejecutable de opensees
└── tmp																	En esta carpeta se almacenan los resultados preliminares al correr una simulacion
																				una vez evaluado el modelo se almacenan y organizan los resultados en la respectiva
																				carpeta y se elimina el contenido de esta carpeta 




### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact



