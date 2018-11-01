library(tidyverse)

datos <- read.csv("~/Documents/GitHub/AnalisisTextual/mensajes/duracion_mensajes.txt",
                  header = T, sep = "\t", col_types = list(col_integer(), col_factor(), col_character()))

tbl <- list.files(pattern = "*.txt") %>% 
  map_chr(~ read_file(.)) %>% 
  data_frame(texto = .)
