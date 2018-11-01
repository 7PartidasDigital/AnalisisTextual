# Análisis PoS y Legibilidad
#########
library(koRpus)
library(koRpus.lang.es)
set.kRp.env(TT.cmd="~/Documents/TreeTagger/cmd/tree-tagger-spanish", lang="es")
get.kRp.env(TT.cmd=TRUE)

mensajes <- list.files("~/Documents/GitHub/AnalisisTextual/mensajes/corpus/")

LIX("~/Documents/GitHub/AnalisisTextual/mensajes/corpus/1975.txt")
readability("~/Documents/GitHub/AnalisisTextual/mensajes/corpus/1977.txt")

rayoy2015 <- readability("~/Dropbox/_R-nuevo/_SENTIMIENTO_ARTICULO/DEBATE_ESTADO_NACION/corpus/Rajoy_2015.txt")

