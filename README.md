#Household Model Chile (HMC)

El presente informe intenta explicar en detalle cada uno de los pasos realizados para desarrollar el modelo household Chile (HMC), con el principal objetivo de que su código sea entendido por otros usuarios y de esta manera el proceso de desarrollo pueda ser retroalimentado por quienes participan de este.

La estructura general del modelo se divide en tres módulos principales (carpetas): 

 1. **_data_**, que cubre la declaración y definición de los sets utilizados, la declaración de parámetros y los datos asignados; 
 2. **_model_**, que cubre la declaración de variables y ecuaciones del modelo, las definiciones de las ecuaciones y las definición del modelo a resolver; y 
 3. **_results_**, donde se guardan los archivos en formato gdx que contienen tanto los resultados como la base de datos utilizada.

El presente informe se estructura en base a los módulos descritos anteriormente, donde cada uno de ellos será descrito en detalle.


##data
La carpeta data está subdividida en diferentes carpetas y archivos necesarios para crear la base de datos inicial que se utilizará en el presente modelo. La descripción de cada una de ellas se describe a continuación:

###carpetas

####activities
La carpeta activities contiene dos archivos:

* FinalDB_2910.xlsx: Archivo xlsx que contiene los datos para cada uno de las explotaciones tipo identificadas previamente. Dentro del archivo, existe información adicional de los datos (e.g. Unidades de medida de variables utilizadas)  
* FinalDB_2910.gdx: Información en formato .gdx para ser utilizada por GAMS 
 
####markets
La carpeta markets contiene los archivos con datos de elasticidad de algunos cultivos como también precios a nivel de consumidor


####sets
Esta carpeta almacena los sets definidos en el archivo .gms 


####supportpoints


###archivos