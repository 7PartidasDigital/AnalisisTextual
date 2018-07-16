library(tidyverse)
library(tidytext)

# Previo
# Crea la tibble que servirá para limpiar por etiquetas
etiquetas_vacias <- tibble(etiqueta = c("PUNT", "PREP", "DET", "ART", "CCOP", "AUX", "CSUB", "PRON"))
palabras_vacias <- read_tsv("~/Documents/GitHub/AnalisisTextual/vacias/vacias_esp.txt", quote="\"", col_names = T)
source("~/Documents/GitHub/AnalisisTextual/scripts/re.etiqueta.lo.R")

# Lee texto
entrada <- read_tsv("~/Desktop/Trabajo/ARTICULO.txt", col_names = F) %>%
  rename(palabra = X1, PoS = X2) %>% # renombra las columnas
  add_row(palabra = NA, PoS = NA, .before = 1) %>% # Añade NA como primera fila
  mutate (frase = as.factor(cumsum(is.na(palabra)))) %>% # Cuenta y numera oraciones
  drop_na() # Borra los NA

# Invoca la función re.etiqueta.lo
re.analizado <- re.etiqueta.lo(entrada)


# Reconstruye texto por etiquetas y lo divide por oraciones

novela_etiquetada <- paste(re.analizado$etiqueta, collapse = " ")
novela_etiquetada <- gsub(" ([,.:;?!])", "\\1", novela_etiquetada)
novela_etiquetada <- gsub("\\*", "", novela_etiquetada) # Ojo a los cambio de escena
novela_etiquetada <- gsub("([¿¡]) ", "\\1", novela_etiquetada)
novela_etiquetada <- gsub(" NA ", " ", novela_etiquetada)
novela_etiquetada <- tibble(texto = novela_etiquetada)
etiquetada_tidy <- novela_etiquetada %>%
  unnest_tokens(oracion, texto, token = "sentences", to_lower = F)




# Crea una tabla con las oraciones y cuenta las palabras en
art_oraciones <- novela_etiquetada %>%
  unnest_tokens(oracion, texto, token="sentences") %>%
  mutate(num_pal = str_count(oracion, "\\w+"))

