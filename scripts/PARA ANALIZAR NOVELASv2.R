library(tidyverse)
library(tidytext)

# Previo
# Crea la tibble que servirá para limpiar por etiquetas
etiquetas_vacias <- tibble(etiqueta = c("PUNT", "PREP", "DET", "ART", "CCOP", "AUX", "CSUB", "PRON"))
palabras_vacias <- read_tsv("~/Documents/GitHub/AnalisisTextual/vacias/vacias_esp.txt", quote="\"", col_names = T)
source("~/Documents/GitHub/AnalisisTextual/scripts/re.etiqueta.lo.R")

# Lee texto
ficheros <- list.files(path = "~/Desktop/Sucio")

entrada <- read_tsv(paste("~/Desktop/Sucio/", ficheros[3], sep=""), col_names = F) %>%
  rename(palabra = X1, lema = X2, PoS = X3) %>% # renombra las columnas
  add_row(palabra = NA, lema = NA, PoS = NA, .before = 1) %>% # Añade NA como primera fila
  mutate (frase = as.factor(cumsum(is.na(palabra)))) %>% # Cuenta y numera oraciones
  drop_na() # Borra los NA

# Invoca la función re.etiqueta.lo
re.analizado <- re.etiqueta.lo(entrada)


# Extrae los adverbios en -mente
adv_mente <- re.analizado %>%
  filter(str_detect(re.analizado$palabra, "^\\w+mente$"))

# Borra puntuación
sin_puntuacion <- re.analizado %>%
  filter(etiqueta != "PUNT")

re.analizado %>%
  filter(str_detect(re.analizado$palabra, "^\\w+mente$"), etiqueta != "ADV")


re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "."] <- ".")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == ","] <- ",")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == ":"] <- ":")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == ";"] <- ";")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "("] <- "(")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == ")"] <- ")")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "¿"] <- "¿")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "?"] <- "?")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "…"] <- "…")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "¡"] <- "¡")
re.analizado <- within(re.analizado, etiqueta [etiqueta == "PUNT" & palabra == "!"] <- "!")


# Reconstruye texto por etiquetas y lo divide por oraciones
novela_etiquetada <- paste(re.analizado$etiqueta, collapse = " ")
novela_etiquetada <- gsub(" ([…,.:;?!])", "\\1", novela_etiquetada)
novela_etiquetada <- gsub("\\*", "", novela_etiquetada) # Ojo a los cambio de escena
novela_etiquetada <- gsub("([¿¡]) ", "\\1", novela_etiquetada)
#novela_etiquetada <- gsub("…", "\\.\\.\\.", novela_etiquetada)
novela_etiquetada <- gsub(" NA ", " ", novela_etiquetada)
novela_etiquetada <- tibble(texto = novela_etiquetada)
novela_etiquetada_tidy <- novela_etiquetada %>%
  unnest_tokens(oracion, texto, token = "sentences", to_lower = F) %>%
  mutate(num_pal = str_count(oracion, "\\w+"))

######
# Algo falla aquí
# Reconstruye el texto por palabras y lo divide por oraciones
novela_texto <- paste(re.analizado$palabra, collapse = " ")
novela_texto <- gsub(" ([…,.:;?!])", "\\1", novela_texto)
novela_texto <- gsub("\\*", "", novela_texto) # Ojo a los cambio de escena
novela_texto <- gsub("([¿¡]) ", "\\1", novela_texto)
#novela_etiquetada <- gsub("…", "\\.\\.\\.", novela_etiquetada)
novela_texto <- gsub(" NA ", " ", novela_texto)
novela_texto <- tibble(texto = novela_texto)
novela_texto_tidy <- novela_texto %>%
  unnest_tokens(oracion, texto, token = "sentences") %>%
  mutate(num_pal = str_count(oracion, "\\w+"))
######

# Quita pasos intermedios
rm(novela_etiquetada, novela_texto)


re.analizado %>%
  count(etiqueta, sort = T) %>%
  filter(n > 100) %>%
  mutate(etiqueta = reorder(etiqueta, n)) %>%
  ggplot(aes(etiqueta, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
