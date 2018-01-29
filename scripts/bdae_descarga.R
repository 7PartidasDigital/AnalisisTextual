# Esta función descarga n textos desde bdae
# y los convierte en un tibble. Tiene que
# tener instalado tibble (tidyverse)

#library(tidyverse)

bdae_descarga <- function(bdae_id){
  texto <- NULL
  texto_total <- NULL
for (i in 1:length(bdae_id)){
  id <- bdae_id[i]
  texto_entrada <- readLines(paste("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/bdae/textos/",as.character(id),".txt", sep = ""), encoding = "UTF-8")
  texto <- texto_entrada
  texto <- as.matrix(cbind(rep(id, length(texto)), texto))
  colnames(texto) <- c("bdae_id", "texto")
  texto_total <- rbind(texto_total,texto)
  }
  texto_total <- tibble::as_tibble(texto_total)
}

# Para bajar un libro
# libro <- bdae_descarga() y un número para la obra

# Para bajar varios
# libros <- bdae_descarga(c(numero, numero)) todos los numeros separados por coma

#coloma$bdae_id <- as.integer(coloma$bdae_id) 
