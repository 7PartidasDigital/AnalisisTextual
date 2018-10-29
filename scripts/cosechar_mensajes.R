library(rvest)
listado <- read.delim("DISCURSOS-INDICE.txt", header = T, sep = "\t", stringsAsFactors = F)
for (i in 1:nrow(listado)){
  url <- listado$Direccion[i]
  discurso <- read_html(url)
  mensaje <- discurso %>%
    html_node(".wysiwyg") %>%
    html_text()
  salida <- paste(listado$Año[i], "txt", sep=".")
  writeLines(mensaje, salida)
}
