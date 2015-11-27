#Household Model Chile (HMC)

El presente informe intenta explicar en detalle cada uno de los pasos realizados para desarrollar el modelo household Chile (HMC), con el principal objetivo de que su c�digo sea entendido por otros usuarios y de esta manera el proceso de desarrollo pueda ser retroalimentado por quienes participan de este.

La estructura general del modelo se divide en tres m�dulos principales (carpetas): 

 1. **_data_**, que cubre la declaraci�n y definici�n de los sets utilizados, la declaraci�n de par�metros y los datos asignados; 
 2. **_model_**, que cubre la declaraci�n de variables y ecuaciones del modelo, las definiciones de las ecuaciones y las definici�n del modelo a resolver; y 
 3. **_results_**, donde se guardan los archivos en formato gdx que contienen tanto los resultados como la base de datos utilizada.

El presente informe se estructura en base a los m�dulos descritos anteriormente, donde cada uno de ellos ser� descrito en detalle.


##data
La carpeta data est� subdividida en diferentes carpetas y archivos necesarios para crear la base de datos inicial que se utilizar� en el presente modelo. La descripci�n de cada una de ellas se describe a continuaci�n:

###carpetas

####activities
La carpeta activities contiene dos archivos:

* FinalDB_2910.xlsx: Archivo xlsx que contiene los datos para cada uno de las explotaciones tipo identificadas previamente. Dentro del archivo, existe informaci�n adicional de los datos (e.g. Unidades de medida de variables utilizadas)  
* FinalDB_2910.gdx: Informaci�n en formato .gdx para ser utilizada por GAMS 
 
####markets
La carpeta markets contiene los archivos con datos de elasticidad de algunos cultivos como tambi�n precios a nivel de consumidor


####sets
Esta carpeta almacena los sets definidos en el archivo .gms 


####supportpoints


###archivos