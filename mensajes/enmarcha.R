discurso <- readLines("corpus/1975.txt")
discurso
library(tidyverse)
library(tidytext)
mensaje_tidy <- data_frame(parrafo = seq_along(discurso), texto = discurso)
mensaje_tidy
mensaje_palabras <- mensaje_tidy %>%
  unnest_tokens(palabra, texto)

mensaje_tidy %>%
  unnest_tokens(palabra, texto, to_lower = F)
mensaje_oraciones <- mensaje_tidy %>%
  unnest_tokens(oraciones, texto, token = "sentences", to_lower = F)

mensaje_palabras %>%
  count(palabra, sort = T)

mensaje_oraciones <- mensaje_tidy %>%
  unnest_tokens(oraciones, texto, token = "sentences") %>%
  mutate(NumPal = str_count(oraciones, "\\w+"))



ficheros <- list.files(path ="corpus", pattern = "*.txt")
anno <- as.numeric(gsub("\\.txt", "", ficheros, perl = T))
mensaje_tidy <- data.frame(anno = integer(), parrafo = integer(), texto = character(), stringsAsFactors = F)
mensaje_tidy <- as_tibble(mensaje_tidy)
for (i in 1:length(ficheros)){
  for (i in 1:2){
  discurso <- readLines(paste("corpus", ficheros[i], sep = "/"))
  mensaje <- data_frame(anno = anno[i], parrafo = seq_along(discurso), texto = discurso)
  mensaje_tidy <- bind_rows(mensaje_tidy, mensaje)
}
  

  
}
