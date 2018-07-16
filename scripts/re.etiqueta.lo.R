# re.etiqueta.lo
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