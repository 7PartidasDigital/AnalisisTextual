[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1195652.svg)](https://doi.org/10.5281/zenodo.1195652)

# Análisis Textual
En este repositorio se incluyen todos los materiales y scripts que se desarrollen referentes al **Análisis Textual** (minería de textos, estilometría, análisis de sentimientos, PLN, etc.) que sean colaterales al proyecto base y que se utlizan tanto para trabajo interno como para cursos y talleres.

En *MdT* están los materiales usados para analizar los diálogos del _Ministerio del tiempo_. Consisten en una tabla bajo formato .txt separada por tabs con cinco columnas. La primera indica la temporada, la segunda el episodio (de manera correlativa de 1 a 34), la tercera el título del episodio, la cuarta el nombre del personaje y la quinta el texto de pronuncia el personaje. El otro es una tabla excel con algunas estadística básicas y datos de audiencia sobre la serie.

En *Scripts* están todos los pequeños scripts de R que se emplean para las diversas tareas colaterales del proyecto y de otras investigaciones sobre lectura a distancia, estilometría, análisis textual automatizado, etc.

En *textos* están todos los textos necesarios para la enseñanza y experimentación de _Análisis textual con R_.

*vacias* contiene los ficheros planos de varios orígenes que recogen listas de palabras vacías (_stopwords_) y con el que se construye el `dataset vacias_esp` que se utiliza en los scripts necesarios.

<<<<<<< HEAD
*lexicones* contiene los lexicones que se han preparado para el análisis de sentimientos, tanto para realizarlo con el paquete _tidytext_ como con _syuzhet_. La carpeta _tidytext_ contiene la tabla con todos los diccionarios en español. Se ha mantenido la estructura "palabra" "sentimiento" "lexicon" "valor" de la dataframe original del paquete _tidytext_. Se ha eliminado el lexicon `loughran` y se han incorporado dos nuevos: `syuzhet`, que es una traducción adaptada del `syuzhet_dict` de ML Jockers y otro designado `uva` que se basa en todos los demás pero con positivo y negativo. En esa misma carpeta se encuentra la función `get_sentiments` ligeramente reescrita para puentear la función `get_sentiments` del paquete original.

En la carpeta _syuzhet_ se encuentran los diccionarios bing\_es, afinn\_es, syuzhet\_es y uva\_es para que puedan ser cargados como diccionarios `custom` en el paquete `syuzhet`.
=======
*lexicones* contiene los lexicones que se han preparado para el análisis de sentimientos, tanto para realizarlo con el paquete _tidytext_ como con _syuzhet_. La carpeta _tidytext_ contiene una única tabla con todos los diccionarios en español. Se ha mantenido la estructura "palabra" "sentimiento" "lexicon" "valor" de la dataframe original del paquete _tidytext_ separados por tabuladores. Se ha eliminado el lexicon `loughran` (no tenía interés para nuestro trabajo) y se han incorporado dos nuevos: `syuzhet`, que es una traducción adaptada del `syuzhet_dict` de ML Jockers, y otro designado `uva` que se basa en todos los demás pero que solo contempla valores `positivo` y `negativo`.

En la carpeta _syuzhet_ se encuentran los diccionarios `bing_es`, `afinn_es`, `syuzhet_es` y `uva_es` para que puedan ser cargados como diccionarios `custom` en el paquete `syuzhet`. No incorpora la versión al español de `nrc`ya que este es accesible de _serie_ en el paquete `syuzhet`.
>>>>>>> 0fe3e81bea90072e3180034d4e8f216d2ba89d58

Aviso: el lexicón `bing` está siendo objeto de una revisión, por lo que es previsible que un futuro cercano (finales verano 2018) haya una nueva versión.
