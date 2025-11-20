source("scripts/01_Partie_mission1_q5.R")
### Question 6

## Prep : nb total d’aéroports d’origine et de destinations dans le dataset ----

nb_origins_tot <- flights |>
  summarise(n = n_distinct(origin)) |>
  pull(n)

nb_dest_tot <- flights |>
  summarise(n = n_distinct(dest)) |>
  pull(n)


## 6.1 Compagnies qui n'opèrent pas sur tous les aéroports d’origine ----

comp_origins <- flights |>
  group_by(carrier) |>
  summarise(
    n_origins = n_distinct(origin),
    .groups = "drop"
  ) |>
  left_join(airlines, by = "carrier")

# compagnies qui NE sont pas présentes sur tous les aéroports d’origine
comp_not_all_origins <- comp_origins |>
  filter(n_origins < nb_origins_tot) |>
  arrange(desc(n_origins))


tibble(
  Description = "Compagnies ne desservant pas tous les aéroports d'origine",
  Compagnie   = comp_not_all_origins$name,
  Nombre_d_aéroports_d_origine_desservis = comp_not_all_origins$n_origins
) |> 
  View(title = "Compagnies ne desservant pas tous les aéroports d'origine")


## 6.2 Compagnies qui desservent l’ensemble des destinations ----

comp_destinations <- flights |>
  group_by(carrier) |>
  summarise(
    n_dest = n_distinct(dest),
    .groups = "drop"
  ) |>
  left_join(airlines, by = "carrier")

# compagnies présentes sur TOUTES les destinations du dataset
  comp_all_dest <- comp_destinations |>
    filter(n_dest == nb_dest_tot) |>
    arrange(carrier)
  
tibble(
  Description = "Compagnies desservant toutes les destinations",
  Compagnie   = comp_all_dest$name,
  Nombre_de_destinations_desservies = comp_all_dest$n_dest
) |> 
  View(title = "Compagnies desservant toutes les destinations")

## 6.3 Tableau récapitulatif origines + destinations par compagnie ----

comp_orig_dest_table <- flights |>
  group_by(carrier) |>
  summarise(
    origins      = paste(sort(unique(origin)), collapse = ", "),
    destinations = paste(sort(unique(dest)),   collapse = ", "),
    .groups = "drop"
  ) |>
  left_join(airlines, by = "carrier") |>
  select(
    carrier, name, origins, destinations
  ) |>
  arrange(carrier)

tibble(
  Compagnie = comp_orig_dest_table$name,
  Aéroports_d_origine_desservis = comp_orig_dest_table$origins,
  Destinations_desservies = comp_orig_dest_table$destinations
) |>
  View(title = "Aéroports d'origine et destinations par compagnie")

write_csv(comp_orig_dest_table,
          "outputs/tableaux/missions1_question_6/mission1_q6_comp_origines_destinations.csv")
write_csv(comp_not_all_origins,
          "outputs/tableaux/missions1_question_6/mission1_q6_comp_not_all_origins.csv")