# 1. Installation des packages
# tidyverse: pour la manipulation et la visualisation des données
# readxl: pour lire les fichiers Excel
# jsonlite: pour lire les fichiers JSON
# janitor: pour le nettoyage des données
# rvest: pour le web scraping
# pdftools: pour extraire du texte des fichiers PDF

# install.packages(c("tidyverse", "readxl", "jsonlite", "janitor", "rvest", "pdftools"))


library(tidyverse)
library(readxl)
library(jsonlite)
library(janitor)
library(rvest)
library(pdftools)

# 3. Import des données

## Vols
flights <- read_excel("data/flights.xlsx")

## Aéroports
airports <- read_excel("data/airports.xlsx")

## Airlines
airlines <- fromJSON("data/airlines.json") |> 
  as_tibble()

## Avions
planes <- read_html("data/planes.html") |>
  html_table(fill = TRUE) |>
  (\(x) x[[1]])() |>
  clean_names()


## weather
weather_pages <- pdf_text("data/weather.pdf")
weather_csv    <- paste(weather_pages, collapse = "\n") # on recolle tout
weather <- read_csv(I(weather_csv))

# head()	Voir les premières lignes
# View()	Ouvrir le tableau entier
# summary()	Voir des stats (min, max, moyenne)
# glimpse()	Voir la structure complète + types

glimpse(flights)
glimpse(airports)
glimpse(airlines)
glimpse(planes)
glimpse(weather)