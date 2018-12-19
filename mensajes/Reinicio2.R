########################   Reinicio para Mensajes de Navidad    ###########################
#                   Este fichero contiene el script mostrado en el post                   #
#                         https://7partidas.hypotheses.org/2955   OJO AL NÚMERO                        # 
#            dentro de la serie de entradas sobre Análisis Automático de Textos           #
#  Proyecto 7PartidasDigital "Edición crítica digital de las Siete Partidas de Alfonso X" #
#        Proyecto financiado por el MINECO, referencia FFI2016-75014-P AEI-FEDER, EU      #
#                Universidad de Valladolid -- IP José Manuel Fradejas Rueda               #
#                              https://7partidas.hypotheses.org/                          #
#                             https://github.com/7PartidasDigital                         #
#                         Este material se distribuye con una licencia                    #
#                                            MIT                                          #
#                                         v. 1.0.0                                        #

# Establece el directorio. No lo olvides.
# Tienes que ser la carpeta mensajes.
# Carga las librerías.
library(tidyverse)
library(tidytext)
# Ahora cargará todos los ficheros de los mensajes
ficheros <- list.files(path ="corpus", pattern = "\\d+")
anno <- gsub("\\.txt", "", ficheros, perl = T)
mensajes <- data_frame(anno = character(), parrafo = numeric(), texto = character())
for (i in 1:length(ficheros)){
  discurso <- readLines(paste("corpus", ficheros[i], sep = "/"))
  temporal <- data_frame(anno = anno[i], parrafo = seq_along(discurso), texto = discurso)
  mensajes <- bind_rows(mensajes, temporal)
}

# Regenera la tabla general con todas las palabras
mensajes_palabras <- mensajes %>%
  unnest_tokens(palabra, texto)
mensajes_frecuencias <- mensajes_palabras %>%
  count(palabra, sort = T) %>%
  mutate(relativa = n / sum(n))
# Borra objetos que no sirven y que son temporales
rm(temporal,discurso,i)

frecuencias_anno <- mensajes_palabras %>%
  group_by(anno) %>%
  count(palabra, sort = T) %>%
  mutate(relativa = n / sum(n)) %>%
  ungroup()

vacias <- get_stopwords("es")
vacias <- vacias %>%
  rename(palabra = word)

mensajes_vaciado <- mensajes_palabras %>%
  anti_join(vacias)

vacias <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/vacias/vacias_esp.txt", col_names = TRUE)

mensajes_palabras %>%
  anti_join(vacias) %>%
  count(palabra, sort = T)
