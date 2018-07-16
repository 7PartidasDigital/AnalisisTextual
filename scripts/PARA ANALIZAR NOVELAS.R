library(tidyverse)
library(tidytext)
novela <- read_tsv("~/Desktop/Trabajo/Aventura_inesperada-Corin_Tellado-PoS.txt", col_names = F)
vacias <- read_tsv("~/Documents/GitHub/AnalisisTextual/vacias/vacias_esp.txt", quote="\"", col_names = T)
novela <- novela %>%
  rename(palabra = X1, PoS = X2) %>% # renombra las columnas
  add_row(palabra = NA, PoS = NA, .before = 1) %>% # Añade NA como primera fila
  mutate (frase = cumsum(is.na(palabra))) %>% # Cuenta y numera oraciones
  drop_na() # Borra los NA

# Ahora creamos una nueva columna con etiqutas más genéricas
# Se podría convertir en una función para aligerar el sistema
expandido <- novela$PoS
expandido <- gsub("^A.*", "ADJ", expandido) # Adjetivos
expandido <- gsub("^R.*", "ADV", expandido) # Adverbios
expandido <- gsub("^N.*", "SUST", expandido) # Sustantivos
expandido <- gsub("^VM.*", "VRB", expandido) # Verbos
expandido <- gsub("^V[A|S].*", "AUX", expandido) # Verbos
expandido <- gsub("^P.*", "PRON", expandido) # Pronombres
expandido <- gsub("^SPS.*", "PREP", expandido) # Preposciones
expandido <- gsub("^CC", "CCOP", expandido) # Conjunción copulativa
expandido <- gsub("^CS", "CSUB", expandido) # Conjunción subordinante
expandido <- gsub("^F.*", "PUNT", expandido) # Puntuación
expandido <- gsub("^I", "INTER", expandido) # Interjección
expandido <- gsub("^DA.*", "ART", expandido) # Artículos
expandido <- gsub("^D.*", "DET", expandido) # Determinantes
expandido <- gsub("^Z", "NUM", expandido) # Números

expandido <- as_tibble(expandido)
expandido <- rename(expandido, etiqueta = value)
novela <- as_tibble(cbind(novela,expandido))
novela <- novela %>%
  select(palabra,PoS,etiqueta,frase)
novela

novela %>% count(etiqueta, sort = T)

# Crea la tibble que servirá para limpiar por etiquetas
etiquetas_vacias <- tibble(etiqueta = c("PUNT", "PREP", "DET", "ART", "CCOP", "AUX", "CSUB", "PRON"))

novela_tidy <- novela %>%
  anti_join(etiquetas_vacias) %>%
  mutate(palabra = tolower(palabra))

novela_tidy %>% count(etiqueta,sort = T)
novela_tidy %>% count(palabra,sort = T)


novela_etiquetada <- paste(novela$PoS, collapse = " ")
novela_etiquetada <- gsub(" ([,.:;?!])", "\\1", novela_etiquetada)
novela_etiquetada <- gsub("([¿¡]) ", "\\1", novela_etiquetada)
novela_etiquetada <- gsub(" NA ", " ", novela_etiquetada)
novela_etiquetada <- tibble(texto = novela_etiquetada)
etiquetado_tidy <- novela_etiquetada %>%
  unnest_tokens(oracion, texto, token = "sentences", to_lower = F)
