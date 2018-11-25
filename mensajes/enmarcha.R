discurso <- readLines("corpus/1975.txt")
discurso
library(tidyverse)
library(tidytext)
mensajes <- data_frame(parrafo = seq_along(discurso), texto = discurso)
mensajes
mensajes_palabras <- mensajes %>%
  unnest_tokens(palabra, texto)
mensajes %>%
  unnest_tokens(palabra, texto, to_lower = F)
mensaje_oraciones <- mensajes %>%
  unnest_tokens(oraciones, texto, token = "sentences", to_lower = F)
mensajes_palabras %>%
  count(palabra, sort = T)
mensajes_oraciones <- mensajes %>%
  unnest_tokens(oraciones, texto, token = "sentences") %>%
  mutate(NumPal = str_count(oraciones, "\\w+"))

# Segundo post

ficheros <- list.files(path ="corpus", pattern = "\\d+")
anno <- as.numeric(gsub("\\.txt", "", ficheros, perl = T))
mensajes <- data_frame(anno = integer(), parrafo = integer(), texto = character())
for (i in 1:length(ficheros)){
  discurso <- readLines(paste("corpus", ficheros[i], sep = "/"))
  temporal <- data_frame(anno = anno[i], parrafo = seq_along(discurso), texto = discurso)
  mensajes <- bind_rows(mensajes, temporal)
}

mensajes_palabras <- mensajes %>%
  unnest_tokens(palabra, texto)

mensajes_palabras %>%
  count(palabra, sort = T)

vacias <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/mensajes/vacias.txt", col_names = TRUE)

mensajes_palabras %>%
  anti_join(vacias) %>%
  count(palabra, sort = T)
