### Question 4 : Houston + NYC → Seattle ----

# 1) Trouver tous les vols ayant atterri à Houston (IAH ou HOU)

houston_airports <- c("IAH", "HOU")

vols_arrivent_houston <- flights |>
  filter(dest %in% houston_airports)

vols_arrivent_houston   # liste complète
n_vols_houston <- nrow(vols_arrivent_houston)

# 2) Combien de vols partent des NYC airports vers Seattle ?

nyc_airports <- c("JFK", "LGA", "EWR")

vols_nyc_sea <- flights |>
  filter(origin %in% nyc_airports, dest == "SEA")

n_vols_nyc_sea <- nrow(vols_nyc_sea)

# 3) Combien de compagnies desservent Seattle depuis NYC ?

n_compagnies_sea <- vols_nyc_sea |>
  summarise(n = n_distinct(carrier)) |>
  pull(n)

# 4) Combien d’avions uniques desservent Seattle depuis NYC ?

n_avions_uniques_sea <- vols_nyc_sea |>
  summarise(n = n_distinct(tailnum)) |>
  pull(n)

# Simplifier : écrire un seul CSV récapitulatif pour la question 4
dir.create("outputs/tableaux/missions1_question_4", recursive = TRUE, showWarnings = FALSE)

mission1_q4 <- tibble(
  indicateur = c(
    "Nb vols arrivant à Houston (IAH/HOU)",
    "Nb vols NYC -> Seattle (SEA)",
    "Nb compagnies NYC -> Seattle",
    "Nb avions uniques NYC -> Seattle"
  ),
  valeur = c(
    n_vols_houston,
    n_vols_nyc_sea,
    n_compagnies_sea,
    n_avions_uniques_sea
  )
)

readr::write_csv(mission1_q4, "outputs/tableaux/missions1_question_4/mission1_q4_summary.csv")

