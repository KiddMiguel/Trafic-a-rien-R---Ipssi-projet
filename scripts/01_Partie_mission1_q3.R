source("scripts/01_Partie_mission1_q2.R")
### Question 3 : Destinations par compagnie ----

## 3.1 Nombre de destinations par compagnie ---------------------

comp_dest <- flights |>
  group_by(carrier) |>
  summarise(
    n_destinations = n_distinct(dest),
    .groups = "drop"
  ) |>
  left_join(airlines, by = "carrier") |>
  arrange(desc(n_destinations))


tibble(
  Description = "Nombre de destinations par compagnie",
  Compagnie   = comp_dest$name,
  Nombre_de_destinations = comp_dest$n_destinations
) |> 
  View(title = "Destinations par compagnie")

# Graphique : nb de destinations par compagnie
library(ggplot2)

plot_comp_dest <- ggplot(comp_dest, aes(x = reorder(name, n_destinations),
                                        y = n_destinations)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Nombre de destinations desservies par compagnie",
    x = "Compagnie",
    y = "Nombre de destinations"
  )

plot_comp_dest

ggsave("outputs/graphiques/missions1_question_3/mission1_q3_dest_par_compagnie.png",
       plot_comp_dest, width = 8, height = 5)

## 3.2 Destinations par compagnie et par aéroport d’origine ----

comp_origin_dest <- flights |>
  group_by(carrier, origin) |>
  summarise(
    n_destinations = n_distinct(dest),
    .groups = "drop"
  ) |>
  left_join(airlines, by = "carrier") |>
  left_join(airports, by = c("origin" = "faa")) |>
  arrange(origin, desc(n_destinations))

tibble(
  Aéroport_d_origine = comp_origin_dest$origin,
  Nom_de_l_aéroport = comp_origin_dest$name,
  Compagnie = comp_origin_dest$name.y,
  Nombre_de_destinations = comp_origin_dest$n_destinations
) |>
  View(title = "Nombre de destinations par compagnie et par aéroport d'origine")

plot_comp_origin_dest <- ggplot(
  comp_origin_dest,
  aes(x = name.x, y = n_destinations, fill = origin)
) +
  geom_col(position = "dodge") +
  coord_flip() +
  labs(
    title = "Nombre de destinations par compagnie et aéroport d’origine",
    x = "Compagnie",
    y = "Nombre de destinations",
    fill = "Aéroport d’origine"
  )

plot_comp_origin_dest
ggsave("outputs/graphiques/missions1_question_3/mission1_q3_dest_par_compagnie_et_origin.png",
       plot_comp_origin_dest, width = 9, height = 5)
