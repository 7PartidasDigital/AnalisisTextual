

#### MODIFICACIÓN DE get_sentiment() DE TIDYTEXT ####
# Se ha de cargar después del paquete tidytext
# También exige cargar previamente load("sentimiento.rda")

get_sentiments <- function(lexicon = c("nrc", "bing", "AFINN", "syuzhet")) {
  data(sentimiento, package= NULL, envir = environment())
  lex <- match.arg(lexicon)
  
  if (lex == "afinn") {
    # turn uppercase: reverse compatibility issue
    lex <- "AFINN"
  }
  
  ret <- sentimiento %>%
    dplyr::filter(lex == lexicon) %>%
    dplyr::select(-lexicon)
  
  if (lex == "AFINN") {
    ret$sentiment <- NULL
  } else {
    ret$score <- NULL
  }
  
  ret
}

