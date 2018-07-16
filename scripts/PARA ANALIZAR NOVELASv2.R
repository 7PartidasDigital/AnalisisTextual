library(tidyverse)
library(tidytext)

# Previo
# Crea la tibble que servirá para limpiar por etiquetas
etiquetas_vacias <- tibble(etiqueta = c("PUNT", "PREP", "DET", "ART", "CCOP", "AUX", "CSUB", "PRON"))
palabras_vacias <- read_tsv("~/Documents/GitHub/AnalisisTextual/vacias/vacias_esp.txt", quote="\"", col_names = T)

# Lee texto
entrada <- read_tsv("~/Desktop/Trabajo/ARTICULO.txt", col_names = F) %>%
  rename(palabra = X1, PoS = X2) %>% # renombra las columnas
  add_row(palabra = NA, PoS = NA, .before = 1) %>% # Añade NA como primera fila
  mutate (frase = as.factor(cumsum(is.na(palabra)))) %>% # Cuenta y numera oraciones
  drop_na() # Borra los NA

# Añade nueva columna con etiquetas más genéricas
re.etiqueta.lo <- function(x){ # Se podría convertir en una función para aligerar el sistema
  expandido <- x$PoS
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
  final <- as_tibble(cbind(entrada,expandido))
  final <- final %>%
    select(palabra,PoS,etiqueta,frase)
}

# Invoca la función re.etiqueta.lo
re.analizado <- re.etiqueta.lo(entrada)


# Reconstruye texto por etiquetas y lo divide por oraciones

novela_etiquetada <- paste(re.analizado$etiqueta, collapse = " ")
novela_etiquetada <- gsub(" ([,.:;?!])", "\\1", novela_etiquetada)
novela_etiquetada <- gsub("([¿¡]) ", "\\1", novela_etiquetada)
novela_etiquetada <- gsub(" NA ", " ", novela_etiquetada)
novela_etiquetada <- tibble(texto = novela_etiquetada)
etiquetada_tidy <- novela_etiquetada %>%
  unnest_tokens(oracion, texto, token = "sentences", to_lower = F)

