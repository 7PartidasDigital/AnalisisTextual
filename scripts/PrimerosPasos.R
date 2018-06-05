

library(tidyverse) # Librería que carga todas la librería necesarias para el sistema tidy
library(tidytext) # Librería específica para manejar textos.

# Un documento muy tonto…
documento <- paste("Usar el análisis textual automatizado es sencillo.",
                   "En este curso te enseñaremos cómo hacerlo.",
                   "Partirás de cero y no sabemos dónde llegarás.")
df <- data_frame(texto = documento)


# Lo primero que vamos hacer ahora es dividir estas tres sencillas oraciones en oraciones…
documento_lineas <- unnest_tokens(df, input = texto, output = oración, token = "sentences", to_lower = F)
documento_lineas$NumOracion <- seq_along(documento_lineas$oración)
documento_lineas

# Ahora lo vamos a dividir en palabras…
documento_palabras <- documento_lineas %>% 
  unnest_tokens(output = palabra, input = oración, token = "words")
documento_palabras

# pero también podemos dividirlo en bigramas, es decir, en secuencias de dos palabras en dos…
documento_bigramas <- documento_lineas %>% 
  unnest_tokens(output = bigrama, input = oración, token = "ngrams", n = 2)
documento_bigramas

# pero también podemos dividirlo en bigramas, es decir, en secuencias de tres palabras en tres…
documento_trigramas <- documento_lineas %>% 
  unnest_tokens(output = trigrama, input = oración, token = "ngrams", n = 3)
documento_trigramas

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

# Pero el texto que acabamos de ver es poco práctico. Vamos a cargar un artículo de Mariano José Larra
texto <- read_lines("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/textos/larra_caza.txt", skip = 5)

# Ya tienes el texto. Lo que has bajado no tiene el formato adecuado para trabajar dentro del ecosistema tidy. 
