
mdt <- readr::read_tsv("~/Documents/Github/AnalisisTextual/MdT/MdT.txt")
personajes <- unique(mdt$personaje)
for (i in 1:length(personajes)){
  texto <- mdt %>%
    filter(personaje == personajes[i])
  writeLines(texto$texto, paste(personajes[i], ".txt", sep=""))
}

freeling <- "/usr/local/Cellar/freeling/4.1_3/bin/analyze -f es.cfg <"
entrada <- list.files(pattern = "*.txt")
salida <- paste("POS_", entrada, sep = "")
for (i in 1:length(entrada)){
  proceso <- paste(freeling, entrada[i], ">", salida[i], sep = " ")
  system(proceso)
}
