source("scripts/01_Partie_mission1_q4.R")
### Question 5

## 5.1 Nombre de vols par destination -------------------------

vols_par_dest <- flights |>
  count(dest, name = "n_vols") |>
  left_join(
    airports |> select(faa, name, tzone),
    by = c("dest" = "faa")
  ) |>
  arrange(desc(n_vols))

tibble(
  Destination = vols_par_dest$dest,
  Nom_de_l_aéroport = vols_par_dest$name,
  Fuseau_horaire = vols_par_dest$tzone,
  Nombre_de_vols = vols_par_dest$n_vols
) |> 
  View(title = "Nombre de vols par destination")

write_csv(vols_par_dest, "outputs/tableaux/missions1_question_5/mission1_q5_vols_par_dest.csv")


## 5.2 Trier les vols par destination, aéroport d’origine, compagnie ----

vols_trie <- flights |>
  # joindre l'aéroport de destination
  left_join(
    airports |> select(faa, nom_aeroport_dest = name),
    by = c("dest" = "faa")
  ) |>
  # joindre l'aéroport d’origine
  left_join(
    airports |> select(faa, nom_aeroport_origin = name),
    by = c("origin" = "faa")
  ) |>
  # joindre le nom de la compagnie
  left_join(
    airlines |> select(carrier, nom_compagnie = name),
    by = "carrier"
  ) |>
  # trier dans l’ordre demandé : destination, aéroport d’origine, compagnie
  arrange(
    nom_aeroport_dest,
    nom_aeroport_origin,
    nom_compagnie
  ) |>
  # on garde les colonnes les plus utiles pour la lecture
  select(
    dest, nom_aeroport_dest,
    origin, nom_aeroport_origin,
    carrier, nom_compagnie,
    everything()
  )

tibble(
  Destination = vols_trie$dest,
  Nom_de_l_aéroport_de_destination = vols_trie$nom_aeroport_dest,
  Origine = vols_trie$origin,
  Nom_de_l_aéroport_d_origine = vols_trie$nom_aeroport_origin,
  Compagnie = vols_trie$carrier,
  Nom_de_la_compagnie = vols_trie$nom_compagnie,
  Nombre_de_vols = nrow(vols_trie)
) |>
  View(title = "Vols triés par destination, aéroport d'origine, compagnie")

# (optionnel) export du gros tableau trié
write_csv(vols_trie, "outputs/tableaux/missions1_question_5/mission1_q5_vols_tries_dest_origin_compagnie.csv")
