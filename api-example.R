library(tidyverse)
library(rvest)
library(httr)
library(jsonlite)

endpoint <- "https://legis.senado.leg.br/dadosabertos/senador/5529/discursos"

raw_json <- GET(endpoint, add_headers("Accept:application/json"))
parsed_json <- fromJSON(content(raw_json, "text"), flatten = TRUE)
str(parsed_json)
speeches_df <- parsed_json$DiscursosParlamentar$Parlamentar$Pronunciamentos$Pronunciamento
View(speeches_df)
