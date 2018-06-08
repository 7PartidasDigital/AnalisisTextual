


library(tidyverse) # Librería que carga todas la librería necesarias para el sistema tidy
library(tidytext) # Librería específica para manejar textos.

# Ya tienes las librerías que son necesarias para trabajar con el sistema tidy. Quizá te hagan falta,
# más adelante, alguna más, pero por ahora basta.
# Lo usual es seleccionar un directorio de trabajo. Para este curso te recomendamos que crees en el
# escritorio de tu ordeandor una carpeta que llamarás AnaText, ahí irás guardando todo el material
# que necesites para el curso y que generes. Además, nos permitirá localizar las cosas con sencillez.
# Hay varias maneras de establecer el directorio de trabajo. Dentro de RStudio haz clic en Session > 
# Set Working Directory > Choose Directory. Se abrirá el Finder (Mac) / Explorador de Windows y ya solo
# es cuestión de localizar en el escritorio la carpeta AnaText, seleccionarla y hacer clic en Open.
# La otra manera es con el comando setwd()…
setwd("~/Desktop/AnaText") # En Mac
setwd("C:/Users/USUARIO/Desktop/AnaText") # En Win; USUARIO se debe cambiar por el nombre que se le
# haya dado al ordenador.

# Ahora vas a cargar un texto. Puedes tenerlo en tu ordenador o puedes bajarlo de la red. Ahora lo
# bajarás directamente a RStudio desde un sitio llamado GitHub, que es donde tenemos guardados todos
# los textos que usaremos en el curso. Tú los puedes bajar y guardar en tu ordenador para trabajar
# con ellos sin tener conexión a la red.

# Vas a bajar uno de los artículo de Mariano José de Larra. Para ello, lo primero que ha de hacer es
# declarar el objeto de R en el que se guardará. No seremos muy originales con los nombres, queremos
# que vea las cosas lo más claro posible, así que lo llamaremos texto_entrada.

# Tal y como te explicamos en el tema 2, hay que usar el símbolo <- para decirle a R que guarde en lo que hay
# a la izquierda del símbolo lo que se le ordene en la parte de la derecha. Ahí usaremos la función
# read_lines que necesita un único argumento: el nombre del fichero en el que está el texto. Si estuviera en
# el directorio de trabajo de tu ordenador bastaría con read_lines("FICHERO_ENTRADA.txt"), pero también puede
# ser una dirección de internet, como en este caso. Antes de que hagas clic en Run o control + intro, fíjate
# que hay otro argumento separado por una coma: skip. Este argumento le dice que no lea un número determinado de
# líneas del fichero de entrada. En este caso le hemos dicho que 5. La explicación es sencilla: todos los ficheros
# de texto que te facilitaremos para procesarlos tienen metadatos. Estos informan del contenido del fichero, del
# dónde procede, y otras informaciones. En nuestro caso lo hemos reducido a la mínima expresión, por eso le indicamos
# que no lea las cinco primeras líneas, que tan solo dicen

# La caza
# Mariano José de Larra 
# Revista El Mensajero
# 1835-07-06
######################

# No queremos procesarlas. Visto esto, ejecuta la siguiente línea...

texto_entrada <- read_lines("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/textos/larra_caza.txt", skip = 5)

# Para asegurarte de que todo ha ido bien, mira en la pestaña Environment, ahí debe estar texto_entrada y a su derecha debe
# decir algo así como: texto_entrada           chr [1:16] "Los tiempos en que la…
# Eso quiere decir que en la memoria de trabajo de R hay un objeto de R llamado texto_entrada, que es una cadena de caracteres,
# el chr, y que tiene 16, digamos, líneas de texto (en R lo llaman elementos, así que ya sabes que son los elementos en R), y
# después imprime las primera palabras. ¿Cuántas? Depende de de tu pantalla. Puedes comprobarlo con

texto_entrada # Pulsa contro/cmd + intro

# Aparecerá en la ventana de la consola, todo el texto del artículo de Larra. Si te mueves con el ratón hacia arriba, podrás
# llegar al comienzo del texto. Verás que todos los elementos del objeto texto_entrada comienza con un número entre corchetes.
# Ese es un "truco" para guardar la pista de las cosas que va generando y guardando. En este caso, cada elemento corresponde
# a un párrafo del texto del artículo; o por decirlo de otra manera, toda la cadena de caracteres alfanuméricos que hay entre
# dos intros.

# objeto que has creado, texto-entrada, es uno de los más comunes en R se le llama normalmente vector. Piense en él como una
# tabla de una sola columna y muchas filas. Además, solo puede contener un solo tipo de información: pueden ser letras,
# números o lógico. Para saber qué longitud, qué tipo de vector es y otros atributos, R tiene una serie de funciones para
# averiguarlo. Escribe en la consola

letras <- letters
numeros <- 1:26

# En el primer caso  lo que has hecho ha sido rellenar el vector letras con las 26 letras de alfabeto. En el segundo, numeros
# los has rellenado con los números 1 a 26 (en vez de escribirlos uno a uno, le has dicho, comienza en 1 y acaba en 26; podrías
# haberlo dicho 100:200 (pruébalo):

numeros <- 100:200

# Veamos a ahora como averiguar de que tipo es cada uno. Lo puedes ver en la pantalla Environment. Ahí te dice que letras es de
# caracteres chr y que hay 26 elementos, del 1 al 26. Pero comprébalo con

str(letras)
summary(letras)

# Ahora inténtalo con el vector números

str(numeros)
summary(numeros) # Ojo no es lo mismo

# Si ahora uno, concateno, letras y numeros

todo <- c(letras,numeros)

# R obligará a los números a que dejen de ser números y pasen a ser meros carateres. Ten en cuenta esto, no te empeñes en sumar
# lo que crees que son números, cuando en realidad son caracteres. Para que lo vea más claro. Pusiste en numeros número enteros, del
# 1 al 26 y de 100 al 200, y eso es lo que quiere decir el int que hay antes de los corchetes que te dicen cuántos elementos hay
# en el vector. Ahora rellena números con

numeros <- 2.5:9.5

# Verás que el int ha cambiado a num. Si ahora unes letras y numeros, como has hecho antes:

todo <- c(letras,numeros)

# y miras la str de todo verás que dice chr. Un detalle, cuando los números van entre comillas entonces son meros caracteres.

str(todo)

# y cuando son números, no importa de qué tipo (enteros, reales, etc.) entonces no están protegidos por las comillas:

numeros

# Ya tienes el texto. Lo que has bajado no tiene el formato adecuado para trabajar dentro del ecosistema tidy. Este sistema
# trabaja cómodamente, y con gran eficacia, cuando contempla los datos como una tabla en la que cada variable es una columna,
# y cada observación es una línea. Convirtamos la cadena de caracteres, el vector, en una tabla de las de tidy (las llaman tibble, aunque
# también verás el nombre data frame). La tabla en la que vas a guardar el texto se llamará texto_tidy por eso está a la
# izquierda del signo <-. A continuación está la función que convertirá texto_entrada en una tibble: data_frame y como mínimo
# tiene que tener el nombre de la columna en la que se guardará el texto_entrada, que llamamos texto y de dónde lo ha de sacar,
# del objeto texto_entra:

texto_tidy <- data_frame(texto = texto_entrada)

# Fíjate en la ventana de Environment, ha aparecido una cosa nueva bajo la línea Data. Es el nuevo objeto texto_tidy y a la
# derecha informa de que contiene 16 observaciones de 1 variable. Es decir, la tabla tiene 16 líneas, una por cada elemento,
# párrafo del vector de caracteres texto_entrada y con una sola columna. Mira el aspecto uque tiene con

texto_tidy

# Te informa de que es A tibble con 16 filas y 1 columna. Que la columna se llama texto y que el contenido son <chr>
# caracteres. Pero nos interesa identificar cada párrafo con el número "original" para cuando empecemos a trocear más
# el texto, pues nos puede ser de interés para nuestro análisis saber el párrafo de procedencia de una palabra, de una
# oración… Es fácil. Ahora al cuestión es, dónde quiero insertar la columna que identifique el párrafo (la vamos a llamar
# NumPar). Si es antes de la columna texto la orden es

texto_tidy <- data_frame(NumPar = 1:length(texto_entrada), texto = texto_entrada)

texto_tidy

# si la quieres a la derecha:

texto_tidy <- data_frame(texto = texto_entrada, NumPar = 1:length(texto_entrada))

texto_tidy

# Una de las maravillas de las data_frames y las tibble es que cada columna (varaible), puede ser de un tipo, una de caracteres,
# otra de enteros, otras de números reales, otra lógica, etc. La única limitación que tiene, es que todas las columnas (variables)
# han de tener el mismo número de filas, por lo que cuando falta algún valor, R introduce automáticamente NA, que quiere decir
# no disponible (No Available).

# Ahora que ya tiene el número de párrafo te explico cómo lo hemos intertado. La columna (variable) en que se guardará es NumPar
# y le decimos a R que en cada casilla ponga un número consecutivo entre 1 y … no tengo porqué saber cuántos párrafos
# tiene el texto, R lo sabe y lo puede contar por mí… y lo hace con la función length y puesto que texto_entrada tiene
# los 16 párrafos del texto original, me basta con decirle a R length(texto_entrada). ¡Ojo!, no podría decirle que usar
# la longitud de texto_tidy, porque no cuenta las observaciones (las filas) sino las columnas (las variables). Y no es lo que quieres.
# Ya tienes el texto guardado en una tabla de una columna en la que cada párrafo está en una fila y además le hemos indicado
# que numere cada párrafo NumParr. Míralo…

texto_tidy

# Ahora lo podemos dividir en palabras con unnest_tokens que tiene dos argumentos, la columna (varialbe) en la que se va a guardar,
# en este caso palabra y la columna (variable) de donde ha de sacar los datos texto.

texto_palabras <- texto_tidy %>%
  unnest_tokens(palabra, texto)

# Podríamos haberlo hecho de esta otra manera:

texto_palabras <- unnest_tokens(texto_tidy, palabra, texto)

# pero es una forma de programer más oscura, y te puedo asegurar que a veces, incluso con el sistema tidy
# la programación se puede volver enrevesada.

# Cuando le decimos que extraiga los tokens (unnest_tokens), no solo divide el texto en palabras, sino que además las
# pasa todas a minúsculas (si no lo quisiéramos habría que añadir el argumento to_lower = F; lo que le indica que no las
# pase a minúsculas, que las deje tal y como aparecen en el objeto de origen).

texto_palabras <- unnest_tokens(texto_tidy, palabra, texto, to_lower = F)

# El pasarlas a minúsculas es para evitar que la máquina con tenga por palabras diferentes rey y Rey por el sencillo
# hecho de que una esté tras punto, y la otra en el interior de una frase. Ambas son las misma, pero para el ordenador no.
# Veamos qué tiene texto_palabras

texto_palabras

# No dice que es una tible que tiene 2348 filas y 2 columnas. Las columnas se llaman NumPar y palabra. Además, nos informa
# de que NumPar son número enteros (int) y que palabra son caracteres (chr)

# Acabas de ver cuán sencillo es cargar un texto en R y dividirlo en palabras. Con la misma comodiad puedes dividirlo en
# oraciones, bigramas --secuencias de dos o más palabras--, líneas, etc. (mira la ayuda). Vamos a dividir el texto de
# entrada en oraciones que las vamos a guardar en la tibble texto_oraciones y que la columna en la que la guardemos se
# llame oracion

texto_oraciones <- texto_tidy %>%
  unnest_tokens(oracion, texto, token = "sentences")

# Échale una ojeada:

texto_oraciones

# Aquí podríamos estar discutiendo hasta el infinito sobre qué es una oración o qué marca los límites de una oración. Abordemos
# el problema de la manera más sencilla: el límite de una oración lo marca un punto, o una admiración o interrogación de cierre.
# Que gramaticalmente es un fiasco, bueno, ya llegaremos a resolver ese problema, pero por ahora nos basta. Si te fijas en el
# resultado de imprimir texto_oraciones te dirá que hay 43 oraciones que están guardadas en la columna (variable) oracion, la cual
# es de caracteres. Fíjate, además, que ha mantenido la columna (variable) NumPar, con lo que puedes aber sin mayor problemas
# cuántas oraciones hay en cada párrafo.

# Ahora vas a dividir el texto en bigramas, es decir, de dos en dos palabras, podría ser de tres en tres o de cuatro en cuatro. Es
# igual de sencillo:

texto_bigramas <- texto_tidy %>%
  unnest_tokens(bigrama, texto, token = "ngrams", n = 2)

# Los atributos de unnest_tokens son: bigrama es la columna (vriable en la que guardará el resultado), texto el la parte de texto_tidy
# de donde ha de extraer el texto que dividirá, en "ngrams" y que la cantidad de palabras juntas sea de 2 y que todo ello lo guarde en
# texto_bigramas. Vemos si lo ha hecho:

texto_bigramas

# Quizá esto te haya parecido algo aburrido. Vamos a hacer algo más interesante. Averiguar cuáles son las palabras más frecuentes del
# texto. También es muy sencillo.

texto_palabras %>%
  count(palabra)

# Fíajate que ahora la tible, no la hemos guardado. Ahora estamos jugando. Nos dice que tiene 969 filas. Eso sencillamente quiere decir
# que este artículo de Larra tiene 969 palabras diferentes, es lo que encontrarás referido como palabras-token, o snecillamente tokens.
# Verás que a la derecha hay una columna (n) con números. Esta almacena el número de veces que aparece cada palabra. La lista aparece
# ordenada alfabéticamente, pero quieres saber cuáles son las más frecuentes. Entonces hay que indicarle que lo organice de manera
# descendente, de mayor a menor número de aparaciones (y estás siempre después por orden alfabético). Es sencillo…

texto_palabras %>%
  count(palabra, sort = TRUE)

# Fíjate ahora que la primera palabra es de, porque aparece 152 veces, que a ha pasado a la posición 4 porque se ha usado 59 veces. Pero
# esas palabras son muy "aburridas" no nos dicen nada del texto, y si miras cualquier texto verás que ahí arriba aparecen casi siempre
# las mismas.
# Para muchos problemas de análisis textual automatizado estas palabras de altísima frecuencia, pero de escaso o nulo valor semántico,
# on cruciales, por ejemplo en la estilomtería, pero en otros, como en el Topic Modelling son inútiles. Podemos borrarlas con sencillez.
# El paquete tidytext incluye un listado de palabras vacías (stopwords), pero solo para el ingles. No hay problema. Hemos creado un fichero
# que se puede cargar directamente y que contiene 765 palabras de función o vacías. Incluye formas de los verbos ser, estar y haber,
# artículos, preposiciones, conjunciones, pronombres y algunas formas abreviadas y erratas clásicas como tí, o formas anticuadas
# como á. é, ó, fuí, fué ya que aparecen en muchos textos anteriores a la primera mitad del siglo XX.
# Cargarlo en el sistema es tan sencillo como…

vacias_esp <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/vacias/vacias_esp.txt")

# una vez cargado, en la ventana Data aparecerá vacias_esp 765 obs. of 1 variable. Ya lo podemos usar… Pero antes te voy a explicar
# qué acabas de hacer, aunque es posible que lo haya deducido.
