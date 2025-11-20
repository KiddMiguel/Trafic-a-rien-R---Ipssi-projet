# On charge le fichier d'import
source("scripts/00_import_data.R")

# 2. Nettoyage des noms de colonnes
flights  <- flights  |> clean_names()
airports <- airports |> clean_names()
airlines <- airlines |> clean_names()
weather  <- weather  |> clean_names()
planes   <- planes   |> clean_names()

# 4. Vérifier les valeurs manquantes

na_summary <- function(df) {
  sapply(df, \(x) sum(is.na(x)))
}

na_flights  <- na_summary(flights)
na_airports <- na_summary(airports)
na_airlines <- na_summary(airlines)
na_planes   <- na_summary(planes)
na_weather  <- na_summary(weather)

na_flights
na_airports
na_airlines
na_planes
na_weather


# 5. Vérifier les doublons éventuels

nrow(flights) - nrow(distinct(flights))
# nrow(airports) - nrow(distinct(airports))
# nrow(airlines) - nrow(distinct(airlines))
# nrow(planes) - nrow(distinct(planes))
# nrow(weather) - nrow(distinct(weather))


# 6. Contrôles simples sur les clés (préparation Mission 2) -

## airports : faa doit être unique, sans NA
airports |> 
  summarise(
    n_total       = n(),
    n_unique_faa  = n_distinct(faa),
    n_na_faa      = sum(is.na(faa))
  )

## flights : origin/dest doivent ressembler à des codes aéroports (3 lettres)
flights |>
  summarise(
    ok_origin = all(str_detect(origin, "^[A-Z0-9]{3}$") | is.na(origin)),
    ok_dest   = all(str_detect(dest,   "^[A-Z0-9]{3}$") | is.na(dest))
  )

## airlines : carrier = code compagnie
airlines |>
  summarise(
    n_total      = n(),
    n_unique_car = n_distinct(carrier),
    n_na_car     = sum(is.na(carrier))
  )

## planes : tailnum = immatriculation
planes |>
  summarise(
    n_total       = n(),
    n_unique_tail = n_distinct(tailnum),
    n_na_tail     = sum(is.na(tailnum))
  )

# 7. Petite variable date pour les vols ---------------------

flights <- flights |>
  mutate(
    flight_date = as.Date(sprintf("%04d-%02d-%02d", year, month, day))
  )


view(flights)
view(airports)
view(airlines)
view(planes)
view(weather)