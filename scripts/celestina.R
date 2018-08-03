library(tidyverse)
library(tidytext)
library(scales)
library(igraph)
library(ggraph)
options(scipen = 999) # que no emplee notación científica
# Carga un paquete de datos que contiene las stop-words españolas
vacias_cast <- as_tibble(read_lines("~/Documents/Github/AnalisisTextual/vacias/vacias_cast.txt")) %>%
  rename(palabra = value)

# Carga el texto
celestina <- read_delim("~/Dropbox/_R-nuevo/CELESTINA/corpus copia/celestina.txt", delim = "\t")
celestina

celestina %>%
  count(personaje) %>%
  filter(personaje != "ARGUMENTO")



celestina <- celestina %>% 
  filter(texto != "" & !is.na(texto)) %>%
  filter(personaje != "ARGUMENTO") %>%
  mutate(personaje2 = ifelse(
    personaje %in% c("CALISTO", "CELESTINA", "MELIBEA", "PARMENO", "SEMPRONIO"),
    personaje, "ZESTO"))

# Divide el texto en palabras y borra las palabras vacías
celestina_tidy <- celestina %>% 
  unnest_tokens(palabra, texto) %>% 
  anti_join(vacias_cast)

# Cuenta las palabras que emplea cada personaje
frecuencia <- celestina_tidy %>% 
  mutate(palabra = str_extract(palabra, "[[:alpha:]]+")) %>% 
  count(personaje2, palabra) %>% 
  group_by(personaje2) %>% 
  mutate(proporcion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(personaje2, proporcion) %>% 
  gather(personaje, proporcion, CALISTO:SEMPRONIO)

# Y tras hacer el recuento presenta un bonito gráfico
ggplot(frecuencia, aes(x = proporcion, y = ZESTO, 
                       color = abs(ZESTO - proporcion))) +
  geom_abline(color = "gray31", lty = 2) +
  geom_jitter(alpha = .02, size = 2.5, width = .3, height = .3) +
  geom_text(aes(label = palabra), check_overlap = TRUE, vjust = 1.5, size = 4) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, .001), low = "#6A6EC2", high = "gray75") +
  facet_wrap(~personaje, ncol = 2) +
  labs(y = "ZESTO", x = NULL)  +
  theme(legend.position = "none")

# En los cinco gráficos, las palabras que se sitúan a lo largo de la línea de puntos
# tienen una frecuencia de uso similar en el personaje frente al resto de los personajes
# (ZESTO). De manera que las que aparecen por debajo de la línea son las que más utiliza
# cada uno de los personajes que da nombre al cuadro; las que están por encima, son las
# que usan más los del ZESTO (excluidos los otros cuatro personajes principales).


# Ahora vamos hacer un análisis de correlación para ver la similitud de la frecuencia
# de las palabras que usa los cinco personajes principales comparados con el resto (ZESTO)
# de los personajes

frecuencia %>% 
  group_by(personaje) %>% 
  do(tidy(cor.test(.$proporcion, .$ZESTO))) %>% 
  ggplot(aes(estimate, personaje)) +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high, height = .2, 
                     color = estimate), size = 1) +
  geom_point(color = "gray10", size=2) +
  labs(x = "coeficiente de correlación",
       title = "Correlacion de la frecuencia de las palabras",
       subtitle = "Cinco principales en comparación al resto de los personajes") +
  theme(legend.position = "none",
        axis.title.y = element_blank())

# Los cinco protagonista tienen una correlación bastante alta entre ellos.

# Otro estadístico que se puede calcular es el tf-idf. No lo veamos a definir, pero su
# interés reside en que sirve para calcular qué palabras son más características para
# cada personaje. No quiere decir qué palabras son las que más utiliza. No, tan solo
# cuáles son las palabras que un personaje dado usa con respecto al resto. Si lo hacemos
# con un conjunto de obras, por ejemplo, podríamos ver cuáles son las palabras preferidas
# de Lorenzo Silva en Bevilacqua frente a las de Giménez Bartlett y su heroina Petra
# Delicado.

palabras_personaje <- celestina %>% 
  unnest_tokens(palabra, texto) %>% 
  count(personaje2, palabra) %>%
  mutate(palabra = str_extract(palabra, "[[:alpha:]]+")) %>% #Aquí borra los números
  ungroup()

total_palabras <- palabras_personaje %>% 
  group_by(personaje2) %>% 
  summarize(total = sum(n))

palabras_personaje <- left_join(palabras_personaje, total_palabras) %>% 
  bind_tf_idf(palabra, personaje2, n)

personaje_plot <- palabras_personaje %>% 
  arrange(desc(tf_idf)) %>% 
  mutate(palabra = factor(palabra, levels = rev(unique(palabra))))

personaje_plot %>% 
  filter(personaje2 != "ZESTO") %>% 
  group_by(personaje2) %>% 
  top_n(10) %>% 
  ungroup() %>% 
  ggplot(aes(palabra, tf_idf, fill = personaje2)) +
  geom_col(show.legend=FALSE) +
  facet_wrap(~personaje2, scales = "free") +
  coord_flip() +
  labs(x = "tf-idf",
       title = "Palabras más características de cada personaje",
       subtitle = "Medidas por medio de tf-idf") +
  theme(legend.position = "none",
        axis.title.y = element_blank())

# Palabras más características de cada episodio.


palabras_acto <- celestina %>% 
  unnest_tokens(palabra, texto) %>% 
  count(acto, palabra, sort = TRUE) %>% 
  ungroup()

total_palabras <- palabras_acto %>% 
  group_by(acto) %>% 
  summarize(total = sum(n))

palabras_acto <- left_join(palabras_acto, total_palabras) %>% 
  bind_tf_idf(palabra, acto, n)


acto_top <- palabras_acto %>% 
  arrange(acto, desc(tf_idf)) %>% 
  filter(!duplicated(acto)) %>% 
  transmute(acto,
            palabra,
            n, 
            total,
            tf_idf = round(tf_idf, 4))
# Imprimer una tabla con la PALABRA más característica de cada episodios
as.data.frame(acto_top)


# Análisis y relación de bigramas en el MdT

bigramas_celestina <- celestina %>% 
  unnest_tokens(bigrama, texto, token = "ngrams", n = 2)

bigramas_separados <- bigramas_celestina %>% 
  separate(bigrama, c("palabra1", "palabra2"), sep = " ")

bigramas_filtrados <- bigramas_separados %>% 
  filter(!palabra1 %in% vacias_cast$palabra) %>% 
  filter(!palabra2 %in% vacias_cast$palabra) %>% 
  filter(palabra1 != palabra2)

cuenta_bigramas <- bigramas_filtrados %>% 
  count(palabra1, palabra2, sort = TRUE)

# Si se cambia el n > cuanto mayor sea menos bigramas aparecerán
grafico_bigramas <- cuenta_bigramas %>% 
  filter(n > 5) %>% 
  graph_from_data_frame()

set.seed(10)

a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(grafico_bigramas, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.03, 'inches')) +
  geom_node_point(color = "lightblue", size = 3) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()


