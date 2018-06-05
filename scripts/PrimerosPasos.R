


library(tidyverse) # Librería que carga todas la librería necesarias para el sistema tidy
library(tidytext) # Librería específica para manejar textos.

# Ya tienes las librería que son necesarias para trabajar con el sistema tidy. Quizá te hagan falta,
# más adelante, alguna más, pero por ahora basta.
# Lo usual es seleccionar un directorio de trabajo. Para este curso te recomendamos que crees en el
# escritorio de tu ordeandor una carpeta que llamarás AnaText, ahí irás guardando todo el material
# que necesites para el curso y que generes. Además, nos permitirá localizar las cosas con sencillez.
# Hay varias maneras de establecer el directorio de trabajo. Dentro de RStudio haz clic en Session > 
# Set Working Directory > Choose Directory Ahí se abrirá el Finder (Mac) / Explorador de Windows y
# es cuestión de localizar en el escritorio la carpeta AnaText, seleccionarla y hacer clic en Open.
# La otra manera es con el comando setwd()…
setwd("~/Desktop/AnaText") # En Mac
setwd("C:/Users/USUARIO/Desktop/AnaText") # En Win; USUARIO se debe cambiar por el nombre que se le
# haya dado al ordenador.

# Ahora vas a cargar un texto. Puedes tenerlo en tu ordanador o puede bajarlo de la red. En el ahora lo
# bajarás directamente a RStudio desde un sitio llamado GitHub, que es donde tenemos guardados todos
# los textos que usaremos en el curso. Tú los puedes bajar y guardar en tu ordenador para trabajar sin
# conexión a la red.

# Vas a bajar uno de los artículo de Mariano José de Larra. Para ello, lo primero que ha de hacer es
# declarar el objeto de R en el que se guardará. No seremos muy soriginales con los nombres, queremos
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

# Para asegurarte de que todo ha ido bien mira en la pestana Environment, ahí debe estar texto_entrada y a su derecha debe
# decir algo así como: texto_entrada           chr [1:16] "Los tiempos en qe la…
# Eso quiere decir que en la memoria de trabajo de R hay un objeto de R llamado texto_entrada, que es una cadena de caractere,
# el chr, y que tiene 16, digamos, líneas de texto (en R lo llaman elementos, así que ya sabes que son los eleentos en R), y
# después imprime las primera palabras. ¿Cuántas? Depende de de tu pantalla. Puedes comprobarlo con

texto_entrada # Pulsa contro/cmd + intro

# Aaprecerá en la ventana de la consola, todo el texto del artículo de Larra. Si retorcedes con el ratán hacia arriba podrás
# llegar al comienzo del texto. Virás que todos los elementos del objeto texto_entrada comienza con un número entre corchetes.
# Ese es un "truco" para guardar la pista de las cosas que va generando y guardando. En este caso, cada elemento corresponde
# a un párrafo del texto del artículo; o por decirlo de otra manera, toda la cadena de caracteres alfanuméricos que hay entre
# dos intros.

# Ya tienes el texto. Lo que has bajado no tiene el formato adecuado para trabajar dentro del ecosistema tidy. Este sistema
# trabja cómodamente, y con gran eficacia, cuando contempla los datos como una tabla en la que cada variable es una columna,
# y cada observación es una línea. Convirtámos la cadena de caracteres en una tabla de las de tidy (las llaman tibble, aunque
# también verás el nombre data frame). La tabla en la que vas a guardar el texto se llamará texto_tidy por eso está a la
# izquierda del signo <-. A continuación está la función que convertirá texto_entrada en una tibble: data_frame y como mínimo
# tiene que tener el nombre de la columna en la que se guardará el texto_entrada, que llamamos texto y de dónde lo ha de sacar,
# del objeto texto_entra:

texto_tidy <- data_frame(texto = texto_entrada)

# Fíjate en la ventana de Environment, ha aparecido una cosa nueva bajo la línea Data. Es el nuevo objeto texto_tidy y a la
# derecha informa de que contiene 16 observaciones de 1 variable. Es decir, la tabla tiene 16 líneas, una por cada elemento,
# párrafo del texto_entrada y con una sola columna. Mura el aspecto uque tiene con

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

# Ahora que ya tiene el número de párrafo te explico cómo lo hemos intertado. La columna en que se guardará es NumPar
# y le decimos a R que en cada casilla ponga un número consecutivo entre 1 y … no tengo porqué saber cuántos párrafos
# tiene el texto, R lo sabe y lo puede contar por mí… y lo hace con la función length y puesto que texto_entrada tiene
# los 16 párrafos del texto original, me basta con decirle a R length(texto_entrada). ¡Ojo!, no podría decirle que usar
# la longitud de texto_tidy, porque no cuenta las observaciones (las filas) sino las columnas. Y no es lo que quieres.
# Ya tienes el texto guardado en una tabla de una columna en la que cada párrafo está en una fila
# y además le hemos indicado que numere cada párrafo NumParr. Míralo…

texto_tidy

# Ahora lo podemos dividir en palabras con unnest_tokens que tiene dos argumentos, la columna en la que se va a guardar,
# en este caso palabra y la columna de donde ha de sacar los datos texto.
texto_palabras <- texto_tidy %>%
  unnest_tokens(palabra, texto)

# Podríamos haberlo hecho de esta otra manera:

palabras <- unnest_tokens(texto_tidy, palabra, texto)

# pero es una forma de programer más oscura, y te puedo asegurar que a veces, incluso con el sistema tidy
# la programación se puede volver enrevesada.











# El paquete tidytext incluye un listado de palabras vacías, es decir, de palabras de alta frecuencia
# de aparición pero escaso o nulo contenido. En muchos casos esas palabras no sirven para nada, porque
# nada nos pueden decir sobre el contenido del texto, por lo que a veces en necesario eliminarlas.
# Como decíamos, tidytext trae de serie una lista de stopwords (palabras vacías), pero solo para el
# ingles. No hay problema. Hemos creado un fichero que se puede cargar directamente y que contiene 765
# palabras de función o vacías. Incluye formas de los verbos ser, estar y haber, artículos, preposiciones,
# conjunciones, pronombres y algunas formas abreviadas y erratas clásicas como tí, o formas anticuadas
# como á. é, ó, fuí, fué ya que aparecen en muchos textos anteriores a la primera mitad del siglo XX.
# Cargarlo en el sistema es tan sencillo como…
vacias_esp <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/vacias/vacias_esp.txt")
# una vez cargado, en la ventana Data aparecerá vacias_esp 765 obs. of 1 variable. Ya lo podemos usar
