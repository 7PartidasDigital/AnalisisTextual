library(tidyverse)

datos <- read.csv("~/Documents/GitHub/AnalisisTextual/mensajes/duracion_mensajes.txt",
                  header = T, sep = "\t", stringsAsFactors = F)

xmas1975 <- readLines("1975.txt")
xmas1976 <- readLines("1976.txt")
xmas1977 <- readLines("1977.txt")
xmas1978 <- readLines("1978.txt")
xmas1979 <- readLines("1979.txt")
xmas1980 <- readLines("1980.txt")
xmas1981 <- readLines("1981.txt")
xmas1982 <- readLines("1982.txt")
xmas1983 <- readLines("1983.txt")
xmas1984 <- readLines("1984.txt")
xmas1985 <- readLines("1985.txt")
xmas1986 <- readLines("1986.txt")
xmas1987 <- readLines("1987.txt")
xmas1988 <- readLines("1988.txt")
xmas1989 <- readLines("1989.txt")
xmas1990 <- readLines("1990.txt")
xmas1991 <- readLines("1991.txt")
xmas1992 <- readLines("1992.txt")
xmas1993 <- readLines("1993.txt")
xmas1994 <- readLines("1994.txt")
xmas1995 <- readLines("1995.txt")
xmas1996 <- readLines("1996.txt")
xmas1997 <- readLines("1997.txt")
xmas1998 <- readLines("1998.txt")
xmas1999 <- readLines("1999.txt")
xmas2000 <- readLines("2000.txt")
xmas2001 <- readLines("2001.txt")
xmas2002 <- readLines("2002.txt")
xmas2003 <- readLines("2003.txt")
xmas2004 <- readLines("2004.txt")
xmas2005 <- readLines("2005.txt")
xmas2006 <- readLines("2006.txt")
xmas2007 <- readLines("2007.txt")
xmas2008 <- readLines("2008.txt")
xmas2009 <- readLines("2009.txt")
xmas2010 <- readLines("2010.txt")
xmas2011 <- readLines("2011.txt")
xmas2012 <- readLines("2012.txt")
xmas2013 <- readLines("2013.txt")
xmas2014 <- readLines("2014.txt")
xmas2015 <- readLines("2015.txt")
xmas2016 <- readLines("2016.txt")
xmas2017 <- readLines("2017.txt")
anno <- c("1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017")
mensaje <- c("xmas1975", "xmas1976", "xmas1977", "xmas1978", "xmas1979", "xmas1980", "xmas1981", "xmas1982", "xmas1983", "xmas1984", "xmas1985", "xmas1986", "xmas1987", "xmas1988", "xmas1989", "xmas1990", "xmas1991", "xmas1992", "xmas1993", "xmas1994", "xmas1995", "xmas1996", "xmas1997", "xmas1998", "xmas1999", "xmas2000", "xmas2001", "xmas2002", "xmas2003", "xmas2004", "xmas2005", "xmas2006", "xmas2007", "xmas2008", "xmas2009", "xmas2010", "xmas2011", "xmas2012", "xmas2013", "xmas2014", "xmas2015", "xmas2016", "xmas2017")
duracion <- c("5:01", "7:31", "9:23", "8:13", "19:26", "9:05", "7:26", "8:34", "11:05", "8:44", "9:20", "10:29", "7:20", "8:21", "9:59", "10:33", "10:36", "12:44", "11:45", "12:46", "14:09", "12:25", "11:20", "12:17", "11:47", "7:04", "8:26", "11:02", "13:03", "12:03", "12:22", "12:40", "14:14", "13:46", "12:41", "9:33", "13:04", "8:56", "11:37", "12:40", "12:11", "12:20", "10:47")


entrada <- readLines("~/Documents/GitHub/AnalisisTextual/mensajes/corpus/1975.txt")
mensaje <- data_frame(parrafo = 1:length(entrada), texto = entrada)
mensaje$rey <- datos$rey[1]
mensaje$anno <- datos$anno[1]
mensaje$duracion <- datos$duracion[1]

mensaje$wordCount <- sapply(gregexpr("\\W+", mensaje$texto), length) +1
mensaje$phraseCount <- sapply(gregexpr("\\.|\\. ", mensaje$texto), length)
mensaje$wordPhrase <- mensaje$wordCount / mensaje$phraseCount

