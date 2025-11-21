### Question 2 : aéroports, destinations et avions ----

## 2.1 Aéroport de départ le plus emprunté ----------------------

dep_airports <- flights |>
  count(origin, name = "n_vols") |>
  arrange(desc(n_vols)) |>
  left_join(airports, by = c("origin" = "faa"))  # ajoute le nom complet

# Aéroport de départ le plus utilisé
top_dep_airport <- dep_airports |>
  slice_max(n_vols, n = 1)

tibble(
  Description = "Aéroport de départ le plus emprunté",
  Code       = top_dep_airport$origin,
  Name       = top_dep_airport$name,
  Nombre_de_vols = top_dep_airport$n_vols
) |> 
  View(title = "Aéroport de départ le plus emprunté")


## 2.2 Top 10 destinations les plus / moins prisées -------------

dest_counts <- flights |>
  count(dest, name = "n_vols") |>
  mutate(
    pct = n_vols / sum(n_vols) * 100   # pourcentage de tous les vols
  ) |>
  arrange(desc(n_vols)) |>
  left_join(airports, by = c("dest" = "faa"))   # ajoute le nom complet

# 10 destinations les plus prisées
top10_dest <- dest_counts |>
  slice_max(n_vols, n = 10) |>
  mutate(pct = round(pct, 2))

tibble(
  Description = "Top 10 des destinations les plus prisées",
  Destinations = top10_dest$dest,
  Name         = top10_dest$name,
  Nombre_de_vols = top10_dest$n_vols,
  Pourcentage_des_vols = top10_dest$pct
) |> 
  View(title = "Top 10 des destinations les plus prisées")

# 10 destinations les moins prisées (mais qui ont au moins 1 vol)
bottom10_dest <- dest_counts |>
  arrange(n_vols, dest) |>
  slice_head(n = 10) |>
  mutate(pct = round(pct, 4))   # très petits % donc plus de décimales

tibble(
  Description = "Top 10 des destinations les moins prisées",
  Destinations = bottom10_dest$dest,
  Name         = bottom10_dest$name,
  Nombre_de_vols = bottom10_dest$n_vols,
  Pourcentage_des_vols = bottom10_dest$pct
) |> 
  View(title = "Top 10 des destinations les moins prisées")

## 2.3 Les 10 avions qui ont le plus / moins décollé -----------

plane_usage <- flights |>
  filter(!is.na(tailnum)) |>
  count(tailnum, name = "n_vols") |>
  arrange(desc(n_vols)) |>
  left_join(planes, by = "tailnum")  # ajoute infos avion (type, manufacturer, etc.)

# 10 avions qui ont le plus décollé
top10_planes <- plane_usage |>
  slice_max(n_vols, n = 10)

tibble(
  Description = "Top 10 des avions qui ont le plus décollé",
  Avions = top10_planes$tailnum,
  Type = top10_planes$type,
  Fabricant = top10_planes$manufacturer,
  Nombre_de_vols = top10_planes$n_vols
) |> 
  View(title = "Top 10 des avions qui ont le plus décollé")

# 10 avions qui ont le moins décollé (présents au moins 1 fois)
bottom10_planes <- plane_usage |>
  arrange(n_vols, tailnum) |>
  slice_head(n = 10)

tibble(
  Description = "Top 10 des avions qui ont le moins décollé",
  Avions = bottom10_planes$tailnum,
  Type = bottom10_planes$type,
  Fabricant = bottom10_planes$manufacturer,
  Nombre_de_vols = bottom10_planes$n_vols
) |> 
  View(title = "Top 10 des avions qui ont le moins décollé")

## On fait un recapitulatif de tous les résultats
# s'assurer que le dossier de sortie existe
dir.create("outputs/tableaux/missions1_question_2", recursive = TRUE, showWarnings = FALSE)

# écrire les CSV dans le dossier dédié
write_csv(top_dep_airport,  "outputs/tableaux/missions1_question_2/mission1_q2_top_dep_airport.csv")
write_csv(top10_dest,       "outputs/tableaux/missions1_question_2/mission1_q2_top10_dest.csv")
write_csv(bottom10_dest,    "outputs/tableaux/missions1_question_2/mission1_q2_bottom10_dest.csv")
write_csv(top10_planes,     "outputs/tableaux/missions1_question_2/mission1_q2_top10_planes.csv")
write_csv(bottom10_planes,  "outputs/tableaux/missions1_question_2/mission1_q2_bottom10_planes.csv")

# produire un .md récapitulatif avec tous les tableaux
tables <- list(
  "Aéroport de départ le plus emprunté"               = "outputs/tableaux/missions1_question_2/mission1_q2_top_dep_airport.csv",
  "Top 10 des destinations les plus prisées"          = "outputs/tableaux/missions1_question_2/mission1_q2_top10_dest.csv",
  "Top 10 des destinations les moins prisées"         = "outputs/tableaux/missions1_question_2/mission1_q2_bottom10_dest.csv",
  "Top 10 des avions qui ont le plus décollé"        = "outputs/tableaux/missions1_question_2/mission1_q2_top10_planes.csv",
  "Top 10 des avions qui ont le moins décollé"       = "outputs/tableaux/missions1_question_2/mission1_q2_bottom10_planes.csv"
)

md_lines <- c("# Résultats - Mission 1 : Question 2", "")
for (section in names(tables)) {
  path <- tables[[section]]
  md_lines <- c(md_lines, paste0("## ", section), "")
  if (file.exists(path)) {
    df <- readr::read_csv(path, show_col_types = FALSE)
    md_lines <- c(md_lines, knitr::kable(df, format = "markdown"), "")
  } else {
    md_lines <- c(md_lines, paste0("*Fichier introuvable :* ", path), "")
  }
}

writeLines(md_lines, "outputs/tableaux/missions1_question_2/mission1_q2_results.md")

