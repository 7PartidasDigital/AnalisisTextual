
# galdosenr

## Paquete de R con los Episodios Nacionales (1.ª serie)


Este paquete permite acceder al texto completo de los diez primeros *Episodios Nacionales* de Benito Pérez Galdós. Los textos planos se obtuvieron de [Wikisource](https://es.wikisource.org/wiki/Episodios_nacionales), y han sido revisados y corregidos. Cada uno de los textos es un vector de caracteres en los que cada elemento tiene un máximo de 80 caracteres. El paquete contiene:

* `trafalgar`: *Trafalgar*, publicado en 1873
* `corte_carlos_iv`: *La corte de Carlos IV*, publicado en 1873
* `marzo19_2mayo`: *El 19 de marzo y el 2 de mayo*, publicado en 1873
* `bailen`: *Bailén*, publicado en 1873
* `napoleon_en_chamartin`: *Napoleón en Chamartín*, publicado en 1874
* `zaragoza`: *Zaragoza*, publicado en 1874
* `gerona`: *Gerona*, publicado en 1874
* `cadiz`: *Cádiz*, publicado en 1874
* `empecinado`: *Juan Martín el Empecinado*, publicado en 1874
* `batalla_arapiles`: *La batalla de los Arapiles*, publicado en 1875


Quien utilice este paquete debe tener en cuenta que, debido al origen desconocido último aunque sospechado de los textos, hay pequeñas diferencias de un texto a otro. Se ha de tener en cuenta que siguen las reglas de acentuación y prefijación *antiguas*.

## Instalación

Para instalar el paquete escriba lo siguiente:

```
library(devtools)
install_github("7partidasdigital/AnalisisTextual/galdosenr")
library(galdosenr)
```

## Cómo emplear este paquete
La separación de párrafos se ha marcado con elementos vacíos. Los seis primeros actúan como metadatos ya que contienen el título, el autor y el número del episodio bajo el formato **Episodio Nacional, n**.

## Disponibilidad
Los textos están disponibles bajo la [Licencia Creative Commons Atribución-CompartirIgual 3.0](https://creativecommons.org/licenses/by-sa/3.0/deed.es); pueden aplicarse términos adicionales.
