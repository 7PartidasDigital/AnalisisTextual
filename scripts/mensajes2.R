library(tidyverse)
library(tidytext)

ficheros <- list.files(pattern = "*.txt")
MetaDatos <- read_tsv("../MetaDatos.txt", col_names = T, col_types = cols(anno = col_character()))

# Esto los lee y los guarda en MensajesNavidad
MensajesNavidad <- data_frame(ficheros) %>%
  mutate(texto = map(ficheros, read_lines)) %>%
  rename(anno = ficheros) %>%
  unnest()
# Borra de la columna anno la extensión de fichero .txt
MensajesNavidad$anno <- gsub("\\.txt", "", MensajesNavidad$anno, perl =T)

# Une a MensajesNavidad los MetaDatos: rey y duración en segundos de cada mensaje
MensajesNavidad <- left_join(MensajesNavidad, MetaDatos, by ="anno")

# Convierte rey y anno a factores (Ya veremos para qué) y numera cada párrafo de cada
# mensaje.
MensajesNavidad <- MensajesNavidad %>%
  mutate_at(c("anno", "rey"), funs(factor(.))) %>%
  group_by(anno) %>%
  mutate(parrafo = row_number()) %>%
  ungroup()
# Reordena las columnas
MensajesNavidad <- MensajesNavidad[, c(1,3,4,5,2)]
# No se suele recomendar, pero para tener un poco más limpio el Environment,
# borro dos objetos que ya no harán falta:
rm(MetaDatos,ficheros)

# Ya tenemos el texto de todos los Mensaje recogidos en una gran tabla de cinco
# columnas Anno, rey, duracion, parrafo, texto. Mantener los párrafos y numerarlos
# es interesante porque podremos extraer informaciones interesantes.

# Ahora lo vamos a dividir en oraciones.
MensajesNavidad_oraciones <- MensajesNavidad %>%
  unnest_tokens(oraciones, texto, token = "sentences") %>%
  group_by(anno,parrafo) %>%
  mutate(oracion_id = row_number()) %>%
  ungroup()
MensajesNavidad_oraciones <- MensajesNavidad_oraciones[, c(1,2,3,4,6,5)]



