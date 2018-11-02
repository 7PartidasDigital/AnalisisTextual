library(tidyverse)
library(tidytext)

annos <- c("1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017")
duracion <- c("5:01", "7:31", "9:23", "8:13", "19:26", "9:05", "7:26", "8:34", "11:05", "8:44", "9:20", "10:29", "7:20", "8:21", "9:59", "10:33", "10:36", "12:44", "11:45", "12:46", "14:09", "12:25", "11:20", "12:17", "11:47", "7:04", "8:26", "11:02", "13:03", "12:03", "12:22", "12:40", "14:14", "13:46", "12:41", "9:33", "13:04", "8:56", "11:37", "12:40", "12:11", "12:20", "10:47")

ficheros <- list.files()
# Esto los lee y los guarda en MesnajesNavidad
MensajesNavidad <- data_frame(ficheros) %>%
  mutate(texto = map(ficheros, read_lines)) %>%
  rename(anno = ficheros) %>%
  unnest()

MensajesNavidad$anno <- gsub("\\.txt", "", MensajesNavidad$anno, perl =T)
# Convierte el $ficheros en factor
MensajesNavidad$anno <- as_factor(MensajesNavidad$anno)

MensajesNavidad <- MensajesNavidad %>%
  group_by(anno) %>%
  mutate(parrafo = row_number()) %>%
  ungroup() #%>%

MensajesNavidad_tidy


