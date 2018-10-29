library(rvest)
listado <- read.delim("https://raw.githubusercontent.com/7PartidasDigital/AnalisisTextual/master/mensajes/DISCURSOS-INDICE.txt", header = T, sep = "\t", stringsAsFactors = F)
for (i in 1:nrow(listado)){
  url <- listado$Direccion[i]
  discurso <- read_html(url)
  mensaje <- discurso %>%
    html_nodes(".wysiwyg") %>%
    html_nodes(":not(.resaltar)") %>%
    html_text()
  salida <- paste(listado$Año[i], "txt", sep=".")
  writeLines(mensaje, salida)
}


url <- "http://www.casareal.es/ES/Actividades/Paginas/actividades_discursos_detalle.aspx?data=5632"
