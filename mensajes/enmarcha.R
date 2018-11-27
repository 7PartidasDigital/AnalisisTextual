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
mensajes_frecuencias <- mensajes_palabras %>%
  count(palabra, sort = T) %>%
  mutate(relativa = n / sum(n))
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

# Este snippet calcula la frecuencia absoluta -count- y relativa -RelAnno-
# por año
df <- mensajes_palabras %>%
  group_by(anno) %>%
  count(palabra, sort = T) %>%
  mutate(RelAnno = n / sum(n)) %>%
  ungroup()

# Este snippet calcula la frecuencia absoluta -count- y relativa -relativa-
# de todo el set
df_total <- mensajes_palabras %>%
  count(palabra, sort = T) %>%
  mutate(relativa = n / sum(n))



vacias <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/vacias/vacias_esp.txt", col_names = TRUE)

mensajes_palabras %>%
  anti_join(vacias) %>%
  count(palabra, sort = T)

# Copn la literatura

ficheros <- list.files(path ="~/Dropbox/_CORPUS_BASICO/-NADAL/txt", pattern = "\\d+")
a <- gsub(".txt", "", ficheros, perl = T)
a <- gsub("-", " ", a, perl = T)
titulo <- gsub("^(.*?)_.*", "\\1", a, perl = T)
autor <- gsub("^.*?_(.*?)_.*", "\\1", a, perl = T)
anno <- as.integer(gsub(".*_(\\d+)_.*", "\\1", a, perl = T))
premio <- gsub(".*?([[:upper:]]+)$", "\\1", a, perl = T)
nadal <- data_frame(premio = character(), anno = integer(), autor = character(), titulo = character(), parrafo = integer(), texto = character())
for (i in 1:length(ficheros)){
  discurso <- readLines(paste("~/Dropbox/_CORPUS_BASICO/-NADAL/txt", ficheros[i], sep = "/"))
  temporal <- data_frame(premio = premio[i], anno = anno[i],
                         autor = autor[i], titulo = titulo[i],
                         parrafo = seq_along(discurso), texto = discurso)
  nadal <- bind_rows(nadal, temporal)
}

ficheros <- list.files(path ="~/Dropbox/_CORPUS_BASICO/-PLANETA/txt", pattern = "\\d+")
a <- gsub(".txt", "", ficheros, perl = T)
a <- gsub("-", " ", a, perl = T)
titulo <- gsub("^(.*?)_.*", "\\1", a, perl = T)
autor <- gsub("^.*?_(.*?)_.*", "\\1", a, perl = T)
anno <- as.integer(gsub(".*_(\\d+)_.*", "\\1", a, perl = T))
premio <- gsub(".*?([[:upper:]]+)$", "\\1", a, perl = T)
planeta <- data_frame(premio = character(), anno = integer(), autor = character(), titulo = character(), parrafo = integer(), texto = character())
for (i in 1:length(ficheros)){
  discurso <- readLines(paste("~/Dropbox/_CORPUS_BASICO/-PLANETA/txt", ficheros[i], sep = "/"))
  temporal <- data_frame(premio = premio[i], anno = anno[i],
                         autor = autor[i], titulo = titulo[i],
                         parrafo = seq_along(discurso), texto = discurso)
  planeta <- bind_rows(planeta, temporal)
}

premios <- bind_rows(nadal,planeta)

# YA TENEMOS TODO
vacias <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/vacias/vacias_esp.txt", col_names = TRUE)
# Estop es replicando a ciegas: https://jwinternheimer.github.io/blog/churn-survey-text-analysis/

premios_palabras <- premios %>%
  unnest_tokens(palabra, texto)

premios_palabras <- premios_palabras %>%
  anti_join(vacias)

premios_palabras %>%
  count(palabra, sort = T) %>%
  filter(n > 200) %>%
  mutate(palabra = reorder(palabra, n)) %>%
  ggplot(aes(palabra, n)) +
  geom_col() +
  labs(x = "", y ="", title = "Palabras más comunes") +
  coord_flip()



# Este snippet calcula la frecuencia absoluta -count- y relativa -RelAnno-
# por novela
premios_frecuencias <- premios_palabras %>%
  group_by(titulo) %>%
  count(palabra, sort = T) %>%
  mutate(RelAnno = n / sum(n)) %>%
  ungroup()

# Este snippet calcula la frecuencia absoluta -count- y relativa -relativa-
# de todo el set
premios_total <- premios_palabras %>%
  count(palabra, sort = T) %>%
  mutate(relativa = n / sum(n))

premios_total_vaciado <- premios_total %>%
  anti_join(vacias)

