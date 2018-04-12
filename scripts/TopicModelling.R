################################# TOPIC MODELLING CON TIDYTEXT #############################
# Basado en https://cran.r-project.org/web/packages/tidytext/vignettes/topic_modeling.html #
#                                 Desarrollado y adaptado por                              #

#                                  José Manuel Fradejas Rueda                              #

#  Proyecto 7PartidasDigital "Edición crítica digital de las Siete Partidas de Alfonso X"  #
#        Proyecto financiado por el MINECO, referencia FFI2016-75014-P AEI-FEDER, EU       #
#                Universidad de Valladolid -- IP José Manuel Fradejas Rueda                #
#                              https://7partidas.hypotheses.org/                           #
#                             https://github.com/7PartidasDigital                          #
#                         Este material se distribuye con una licencia                     #
#                                            MIT                                           #
#                                         v. 1.0.0                                         #
############################################################################################
  

setwd("~/Dropbox/_textos_tidy")

# El wd puede ser cualquiera, pero ha de tener el subdirectorio data en el que han de estar
# los ficheros datos_esp.rda y get_sentiments.r que se encuentran disponibles en
# https://github.com/7PartidasDigital/AnalisisTextual/tree/master/data


# Carga los datos para puentear los ingleses del paquete tidytext
load("data/datos_esp.rda")
source("data/get_sentiments.r")

# Lee los textos de local y los convierte en tibbles 
# Para hacer el script más flexible y minimizar la edición de las líneas de código
# se ha de introducir el nombre del directorio en el que se encuentran los datos
# textuales sin refinar. En el ejemplo es TOPICO. Se ha de introducir en las líneas
# 36 y 41

library(dplyr)

novelas.ficheros <- list.files("TOPICO") # Introduce aquí el nombre del directorio en donde están los textos
titulos <- gsub(" -.*txt", "", novelas.ficheros, perl = T) # Obtiene el título de cada obra siempre. MODIFICABLE
novelas <- data.frame(texto=character(), titulo=character(), stringsAsFactors = F)
# ¡OJO! Pon en la línea 41 el mismo nombre que se puso en la línea 36
for (i in 1:length(novelas.ficheros)){
  texto <- data_frame(texto = readLines(paste("TOPICO/", novelas.ficheros[i], sep = ""), encoding = "UTF-8"), titulo = titulos[i])
  novelas <- bind_rows(novelas, texto, .id = NULL)
}
rm(novelas.ficheros,i,texto)
novelas <- as_tibble(novelas)

# Todo lo anterior ha creado una tibble con todos los textos que se contemplan.
# Los ficheros de texto originales se mantienen sin modificación en el directorio
# de entrada que se haya indicado (en el modelo: TOPICO).

# División de los libros en capítulos para luego separarlos en palabras y borrar palabras vacías.

library(tidytext) 
library(stringr) 
library(tidyr)


# Divide por capítulos. Solo válido para aquellos textos en los que los capítulos estén marcado con el
# término CAPÍTULO. No importa si está en mayúscula, minúscula o si está correctamente acentuado.
por_capitulo <- novelas %>%
  group_by(titulo) %>%   
  mutate(capitulo = cumsum(str_detect(texto, regex("^Cap[í|i]tulo ", ignore_case = TRUE)))) %>%   
  ungroup() %>%   
  filter(capitulo > 0)  

# Divide en palabras por capítulo
por_capitulo_palabras <- por_capitulo %>%   
  unite(titulo_capitulo, titulo, capitulo) %>%                 
  unnest_tokens(palabra, texto)  

# Elimina palabras vacías
palabra_conteo <- por_capitulo_palabras %>%   
  anti_join(vacias_esp) %>%   
  count(titulo_capitulo, palabra, sort = TRUE) %>%   
  ungroup()  

palabra_conteo

# En este momento, este dataframe está ordenado, con un término por documento por fila. 
# Sin embargo, el paquete TOPICMODELS requiere un DocumentTermMatrix (del paquete TM). 
# Se consigue esta adaptación a DocumentTermMatrix con cast_dtm de tidytext:
library(tm)
capitulos_dtm <- palabra_conteo %>%
  cast_dtm(titulo_capitulo, palabra, n)

capitulos_dtm

# Ahora estamos listos para usar el paquete topicmodels para crear un modelo LDA 
# con varios tópicos, uno por cada título. Para ello el valor lo tomará de la longitud
# del vector titulos, por lo que el sistema es autoadaptable al número de textos.
# Sin embargo, si se requiere un mayor número de tópicos al de títulos de obras, entonces,
# en la línea 95 se ha de cambiar length(titulos) por el número entero deseado. 

library(topicmodels)
capitulos_lda <- LDA(capitulos_dtm, k = length(titulos), control = list(seed = 1234)) # Ojo al valor de k
capitulos_lda

# (En este caso, sabemos que hay X temas porque hay X libros, 
# en la práctica es posible que tengamos que probar algunos valores diferentes para k).
# Ahora tidytext nos da la opción de volver a un análisis ordenado, 
# utilizando las voces ordenados.

capitulos_lda_td <- tidy(capitulos_lda)
capitulos_lda_td

# Para cada combinación, el modelo decide la probabilidad de que ese término se genere a partir de ese tema.
# Podríamos usar top_n de dplyr para encontrar los 5 términos principales dentro de cada tema:

terminos_frecuentes <- capitulos_lda_td %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

as.data.frame(terminos_frecuentes) # De esta forma permite ver todos los topicos cuando la lista es larga (más de 10)

# Este modelo se presta a una visualización:

library(ggplot2)
theme_set(theme_bw())

terminos_frecuentes %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ topic, scales = "free") +
  theme(axis.text.x = element_text(size = 15, angle = 90, hjust = 1))

# ¡Estos temas están claramente asociados con los cuatro libros!
# Clasificación por documento

# Cada capítulo es un "documento" en este análisis. Por lo tanto, es posible que deseemos 
# saber qué temas están asociados con cada documento. 

# Surge una cuestión importante: ¿Podemos juntar los capítulos en los libros correctos?

capitulos_lda_gamma <- tidy(capitulos_lda, matrix = "gamma")
capitulos_lda_gamma

# Configuración de matriz = "gamma" devuelve una versión ordenada con un documento 
# y podemos ver el grado de acierto del aprendizaje no supervisado para distinguir 
# entre los libros considerados.
# Primero volvemos a separar el nombre del documento en título y capítulo:

capitulos_lda_gamma <- capitulos_lda_gamma %>%
  separate(document, c("titulo", "capitulo"), sep = "_", convert = TRUE)
capitulos_lda_gamma


# Cuando examinamos resultados
ggplot(capitulos_lda_gamma, aes(gamma, fill = factor(topic))) +
  geom_histogram() +
  facet_wrap(~ titulo, nrow = 2)

# Notamos que casi todos los capítulos de Orgullo y prejuicio, 
# La guerra de los mundos y Veinte mil leguas de viaje submarino se identificaron 
# de manera única como un único tema.

capitulo_clasificaciones <- capitulos_lda_gamma %>%
  group_by(titulo, capitulo) %>%
  top_n(1, gamma) %>%
  ungroup() %>%
  arrange(gamma)

capitulo_clasificaciones

#Observamos

topicos_libro <- capitulo_clasificaciones %>%
  count(titulo, topic) %>%
  top_n(1, n) %>%
  ungroup() %>%
  transmute(consensus = titulo, topic)

topicos_libro

# Luego vemos qué capítulos fueron identificados erróneamente:

capitulo_clasificaciones %>%
  inner_join(topicos_libro, by = "topic") %>%
  count(titulo, consensus)

# Vemos que solo unos pocos capítulos de Grandes esperanzas fueron clasificados erróneamente. 

# Por asignaciones de palabras: augment

# Un paso importante es asignar cada palabra de cada documento a un tema. 
# Cuantas más palabras en un documento se asignan a ese tema, en general, más peso (gamma) 

asignaciones <- augment(capitulos_lda, data = capitulos_dtm)

# Podemos combinar esto con los títulos del libro para ver qué  palabras fueron clasificadas incorrectamente.

asignaciones <- asignaciones %>%
  separate(document, c("titulo", "capitulo"), sep = "_", convert = TRUE) %>%
  inner_join(topicos_libro, by = c(".topic" = "topic"))

asignaciones

#Podemos crear una "matriz de confusión"

asignaciones %>% 
  count(titulo, consensus, wt = count) %>%
  spread(consensus, n, fill = 0)

# Sólo en Grandes esperanzas se produce una cantidad relevante de errores de asignación.

# ¿Cuáles fueron las palabras más comúnmente confundidas?

palabras_equivocadas <- asignaciones %>%
  filter(titulo != consensus)

palabras_equivocadas

palabras_equivocadas %>%
  count(titulo, consensus, term, wt = count) %>%
  ungroup() %>%
  arrange(desc(n))

# Observa la palabra "flopson":  esta palabra equivocada no aparece necesariamente en las
# novelas a las que se asignó incorrectamente. De hecho, se puede confirmar que "flopson"
# aparece solo en Great Expectations (Grandes esperanzas).
# No funcionará nunca en español salvo si se tiene Grandes esperanzas en el elenco de textos.
# Lo importante es que el modelo funciona con textos en español y en local, no solo con textos en inglés
# descargados de Gutenberg.
palabra_conteo %>%
  filter(palabra == "flopson")
# pero esta instrucción permite localizar ciertos términos dentro de cada texto y dentro de él en
# cada capítulo. Véase por ejemplo
palabra_conteo %>%
  filter(palabra == "nemo")
palabra_conteo %>%
  filter(palabra == "pocket")
