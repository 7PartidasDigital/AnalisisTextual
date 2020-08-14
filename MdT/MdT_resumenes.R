library(rvest)
library(tidyverse)
capitulos <- readLines("MdT_resumenes.txt")
final <- NULL
for (i in 1:length(capitulos)){
  episodio <- read_html("https://www.formulatv.com/series/el-ministerio-del-tiempo/capitulos/49256/")
  resumen <- episodio %>%
    html_nodes("[class='sintxt']") %>%
    html_text()
titulo <- episodio %>%
    html_nodes("[class='captit']") %>%
    html_text()
  titulo <- trimws(titulo[1])
  dialogos <- episodio %>%
    html_nodes("[class='textRel']") %>%
    html_text()
  writeLines(dialogos, paste("SyP_", titulo, ".txt", sep = ""))
  final <- bind_rows(final, tibble(titulo = titulo, fecha =  fecha, resumen = resumen))
}
write_tsv(final, "MdT_Metadatos.txt")
