### partie 1

# QUESTION 1 

## 1) Nombre d’aéroports de départ
n_airports_origin <- flights |> 
  summarise(n = n_distinct(origin)) |>
  pull(n)

# Nombre d'aéroports de destination
n_airports_dest <- flights |>
  summarise(n = n_distinct(dest)) |>
  pull(n)

# Nombre total d'aéroports (union des deux)
n_airports_total <- flights |>
  summarise(n = n_distinct(c(origin, dest))) |>
  pull(n)

# Affichage des résultats plus clairs dans un tableau
tibble(
  Type = c("Aéroports de départ", "Aéroports de destination", "Total des aéroports"),
  Nombre = c(n_airports_origin, n_airports_dest, n_airports_total)
) |> 
  View(title = "Nombre d'aéroports")

## 2) Aéroports qui ne passent pas à l’heure d’été (dst == "N")

n_airports_no_dst <- airports |>
  filter(dst == "N") |>
  nrow()

tibble(
  Description = "Aéroports ne passant pas à l'heure d'été",
    Nombre = n_airports_no_dst
) |> 
  View(title = "Aéroports sans heure d'été")


## 3) Nombre de fuseaux horaires différents
n_timezones <- airports |>
  summarise(n = n_distinct(tzone)) |>
  pull(n)
  
tibble(
  Description = "Nombre de fuseaux horaires différents",
    Nombre = n_timezones
) |>
    View(title = "Fuseaux horaires")

## 4) Nombre de compagnies, d’avions, de vols annulés

# compagnies
n_companies <- airlines |>
  summarise(n = n_distinct(carrier)) |>
  pull(n)

# avions
n_planes <- planes |>
  summarise(n = n_distinct(tailnum)) |>
  pull(n)

# vols annulés : on considère dep_time manquant = vol annulé
n_cancelled <- flights |>
  filter(is.na(dep_time)) |>
  nrow()

tibble(
  Type = c("Compagnies aériennes", "Avions", "Vols annulés"),
    Nombre = c(n_companies, n_planes, n_cancelled)
) |>
    View(title = "Compagnies, avions et vols annulés")


## 5) Tableau récapitulatif
mission1_q1 <- tibble(
  indicateur = c(
    "Nb aéroports départ",
    "Nb aéroports destination",
    "Nb aéroports total (origin ∪ dest)",
    "Nb aéroports sans DST",
    "Nb fuseaux horaires (tzone)",
    "Nb compagnies",
    "Nb avions",
    "Nb vols annulés"
  ),
  valeur = c(
    n_airports_origin,
    n_airports_dest,
    n_airports_total,
    n_airports_no_dst,
    n_timezones,
    n_companies,
    n_planes,
    n_cancelled
  )
)
View(mission1_q1, title = "Résumé Mission 1")

write_csv(mission1_q1, "outputs/tableaux/missions1_question_1/mission1_q1.csv")

# on crée un fichier .md avec le tableau
library(rmarkdown)
library(knitr)

# s'assurer que le dossier de sortie existe
dir.create("outputs/tableaux/missions1_question_1", recursive = TRUE, showWarnings = FALSE)

# écrire le CSV si mission1_q1 est présent
if (exists("mission1_q1")) {
  readr::write_csv(mission1_q1, "outputs/tableaux/missions1_question_1/mission1_q1.csv")
} else {
  message("mission1_q1 introuvable dans l'environnement ; vérifiez l'exécution précédente.")
}

# produire un .md en évitant kableExtra (utilise knitr::kable au format markdown)
if (!exists("mission1_q1") && file.exists("outputs/tableaux/missions1_question_1/mission1_q1.csv")) {
  mission1_q1 <- readr::read_csv("outputs/tableaux/missions1_question_1/mission1_q1.csv", show_col_types = FALSE)
}

if (exists("mission1_q1")) {
  md <- knitr::kable(mission1_q1, format = "markdown")
  writeLines(md, "outputs/tableaux/missions1_question_1/mission1_q1.md")
} else {
  message("Aucun tableau mission1_q1 disponible pour créer le .md.")
}