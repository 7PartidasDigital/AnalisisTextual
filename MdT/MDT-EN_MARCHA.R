library(tidyverse)
library(tidytext)
library(ggrepel)

mdt <- read_tsv("~/Documents/Github/AnalisisTextual/MdT/MdT.txt")
vacias <- read_tsv("~/Documents/Github/AnaText/datos/diccionarios/vacias.txt")

# Puntuaciones de cada capítulo de cada temporada
dat_ratings <- mdt %>%
  distinct(temporada, epi_temp, titulo, imdb) %>% 
  group_by(temporada) %>% 
  mutate(
    mejor_peor = case_when(
      imdb %in%
        (slice_max(., order_by = imdb, n = 1) %>% 
           pull(imdb)) ~ "mejor",
      imdb %in%
        (slice_min(., order_by = imdb, n = 1) %>% 
           pull(imdb)) ~ "peor",
      TRUE                  ~ "medio"
    )
  ) %>% 
  ungroup()

dat_ratings %>% 
  ggplot(aes(x = epi_temp, y = imdb)) +
  geom_point(aes(color = temporada), size = 2, show.legend = F) +
  geom_text_repel(
    dat_ratings %>% filter(mejor_peor != "medio"),
    mapping = aes(label = titulo),
    seed = 1, size = 3.25, alpha = .75, force = 5,
    direction = "both") +
  geom_smooth(se = FALSE) +
  facet_wrap(~temporada) +
  labs(
    x = "Título",
    y = "Imdb",
    title = "Ministerio del Tiempo",
    subtitle = "¿Cuáles son los mejores y peores episodios de cada temporada?",
    caption = "7PartidasDigital") +
  #geom_vline(xintercept = c(1,9,22,35)) +
  scale_y_continuous(breaks = seq(from = 7, to = 10, by = .5))

# Numero personajes en cada episodio…
mdt %>%
  select(2,9) %>%
  group_by(episodio) %>%
  distinct(personaje, episodio) %>%
  tally() %>%
  ggplot(aes(episodio, n)) +
  geom_bar(stat = 'identity', fill='steelblue') +
  geom_hline(aes(yintercept = mean(n))) +
  labs(title = "Ministerio del Tiempo",
       subtitle = "Número de personajes en cada episodio",
       caption = "7PartidasDigital")

mdt_palabras <- mdt %>%
  unnest_tokens(palabra, texto)

# Recuenta número de palabras por episodio
mdt_palabras %>%
  count(episodio) %>%
  ggplot(aes(episodio, n)) +
  geom_bar(stat = 'identity', fill='steelblue') +
  geom_hline(aes(yintercept = mean(n))) +
  labs(title = "Ministerio del Tiempo",
       subtitle = "Número de palabras en cada episodio",
       caption = "7PartidasDigital")

# Recuenta número de palabras por personaje / episodio
mdt_palabras %>%
  filter(episodio != 0) %>%
  mutate(personaje = fct_lump_n(personaje, 10, other_level = "Resto")) %>%
  filter(personaje != "Other") %>%
  count(episodio, personaje) %>%
  mutate(personaje = reorder_within(personaje, n, episodio)) %>%
  ggplot(aes(n, personaje, fill = episodio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~episodio, scales = "free") +
  scale_y_reordered() +
  labs(y = NULL) +
  labs(title = "Ministerio del Tiempo",
       subtitle = "Número de palabras de cada uno de los personajes principales\nfrente al Resto en cada episodio",
       caption = "7PartidasDigital")

#Quien es el más hablador de la serie

palabras_personajes <- mdt_palabras %>%
  count(episodio, epi_temp, personaje, imdb) %>% 
  add_count(personaje, wt = n, name = "recuento") %>% 
  filter(recuento > 3000)

palabras_personajes %>% 
  count(personaje, recuento) %>% 
  ggplot(aes(x = reorder(personaje, desc(recuento)) , y = recuento)) +
  geom_bar(stat = 'identity', fill ="steelblue") +
  geom_text(aes(label = recuento), position = position_dodge(1), vjust = 2) +
  labs(
    title = "Ministerio del Tiempo",
    subtitle = "El que más habla es…",
    x = NULL, y = "Recuento de palabras",
    caption = "7PartidasDigital"
  )

# No merce la pena
p1 <- palabras_personajes %>% 
  ggplot(aes(x = episodio, y = imdb, color = personaje, size = n)) +
  geom_point() +
  facet_wrap(~ personaje) +
  labs(
    x = "Episodios", y = "Imdb",
    size = "Recuento de Palabras"
  ) + guides(color = FALSE)


p2 <- palabras_personajes %>% 
  ggplot(aes(x = n, y = imdb, color = personaje)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  facet_wrap(~ personaje) +
  labs(
    x = "Recuento de Palabras", y = "Imdb"
  ) + guides(color = FALSE)


p1 / p2 + 
  patchwork::plot_annotation(
    title = "Ministerio del Tiempo",
    subtitle = "¿El número de palabras tiene algo que ver con la puntuacuón IMBd?",
    caption = "7PartidasDigital")
# Fin no merece la pena

mdt_palabras2 <- mdt_palabras %>% 
  anti_join(vacias)



# Palabras más usadas en la serie
mdt_palabras2 %>% 
  count(palabra, sort = TRUE) %>%
  slice(1:20) %>% 
  mutate(palabra = fct_reorder(palabra, n)) %>% 
  ggplot(aes(x = n, y = palabra)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  geom_text(aes(label = n), nudge_x = 12) +
  labs(title = "Ministerio del Tiempo",
       subtitle = "Palabras más usadas",
       caption = "7PartidasDigital",
       x = "Recuento",
       y = "Palabras usadas")


mdt_palabras2 %>% 
  filter(palabra == "alonso") %>% 
  count(personaje, sort = TRUE) %>% 
  slice(1:10) %>% 
  mutate(personaje = fct_reorder(personaje, n)) %>% 
  ggplot(aes(x = n, y = personaje)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  geom_text(aes(label = n), nudge_x = 1.5) +
  labs(title = "Ministerio del Tiempo",
    subtitle = "¿Quién menciona a 'Alonso' más veces?",
    caption = "7PartidasDigital",
       x = "Recuento",
       y = "Personaje")

# Por fragmento de palabra
mdt_palabras2 %>% 
  filter(palabra == str_extract(palabra, "hideput.*")) %>% 
  count(personaje, sort = TRUE) %>% 
  slice(1:10) %>% 
  mutate(personaje = fct_reorder(personaje, n)) %>% 
  ggplot(aes(x = n, y = personaje)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  geom_text(aes(label = n), nudge_x = .5) +
  labs(title = "Ministerio del Tiempo",
       subtitle = "¿Quienes usan 'hideputa'?\nEstá claro que los personajes del Siglo de Oro",
       caption = "7PartidasDigital",
       x = "Recuento",
       y = "Personaje")


pal <- RColorBrewer::brewer.pal(9,"Blues")
mdt_palabras2 %>%
  count(palabra, sort = TRUE) %>%
  with(wordcloud::wordcloud(palabra, n, max.words = 50, colors = pal))


#Bigramas

mdt_bigramas <- mdt %>%
  unnest_tokens(bigrama,
                texto,
                token = "ngrams",
                n = 2)


mdt_bigramas %>%
  count(bigrama, sort = T)
bigramas_separados <- mdt_bigramas %>%
  separate(bigrama,
           c("palabra1", "palabra2"),
           sep = " ")
bigramas_filtrados <- bigramas_separados %>%
  filter(!palabra1 %in% vacias$palabra,
         !palabra2 %in% vacias$palabra)
bigramas_unidos <- bigramas_filtrados %>%
  unite(bigrama, palabra1, palabra2, sep = " ")
bigramas_unidos %>%
  filter(personaje %in% c("AMELIA", "ALONSO", "SALVADOR", "ERNESTO", "ANGUSTIAS", "JULIÁN", "PACINO", "LOLA", "IRENE", "VELÁZQUEZ")) %>%
  count(personaje, bigrama, sort = T) %>%
  group_by(personaje) %>%
  slice(1:15) %>%
  ggplot() +
  geom_col(aes(y = n , x = reorder(bigrama,n)),
           fill = "steelblue") +
  coord_flip() +
  facet_wrap(~ personaje, ncol = 2, scales = "free") +
  theme_linedraw() + 
  labs(x = "Bigramas",
       y = "Frecuencia",
       title = "Ministerio del Tiempo",
       subtitle = 'Bigramas más frecuentes de los personajes principales',
       caption = "7PartidasDigital")
