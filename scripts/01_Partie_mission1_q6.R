### Question 7

# Nombre de compagnies par destination
comp_par_dest <- flights |>
  group_by(dest) |>
  summarise(
    n_comp = n_distinct(carrier),
    compagnie = paste(unique(carrier), collapse = ", "),
    .groups = "drop"
  )

# Destinations exclusives (n_comp == 1)
dest_exclusives <- comp_par_dest |>
  filter(n_comp == 1) |>
  left_join(
    airports |> select(faa, nom_destination = name),
    by = c("dest" = "faa")
  ) |>
  left_join(
    airlines |> select(carrier, nom_compagnie = name),
    by = c("compagnie" = "carrier")
  )

tibble(
  Description = "Destinations exclusives à une seule compagnie",
  Destination = dest_exclusives$dest,
  Nom_de_la_destination = dest_exclusives$nom_destination,
  Compagnie_exclusive = dest_exclusives$compagnie,
  Nom_de_la_compagnie = dest_exclusives$nom_compagnie
) |> 
  View(title = "Destinations exclusives à une seule compagnie")

### Question 8 : Vols exploités par United, American ou Delta ----

# Codes des compagnies concernées
compagnies_cibles <- c("UA", "AA", "DL")

vols_UA_AA_DL <- flights |>
  filter(carrier %in% compagnies_cibles) |>
  left_join(airlines, by = "carrier") |>
  left_join(airports |> select(faa, nom_origin = name), by = c("origin" = "faa")) |>
  left_join(airports |> select(faa, nom_dest = name), by = c("dest" = "faa")) |>
  select(
    carrier, name,   # nom compagnie
    origin, nom_origin,
    dest, nom_dest,
    everything()
  )

tibble(
  Compagnie = vols_UA_AA_DL$carrier,
  Nom_de_la_compagnie = vols_UA_AA_DL$name,
  Aéroport_d_origine = vols_UA_AA_DL$origin,
  Nom_de_l_aéroport_d_origine = vols_UA_AA_DL$nom_origin,
  Destination = vols_UA_AA_DL$dest,
  Nom_de_la_destination = vols_UA_AA_DL$nom_dest,
  Nombre_de_vols = nrow(vols_UA_AA_DL)
) |> 
  View(title = "Vols exploités par United, American ou Delta")

write_csv(vols_UA_AA_DL, "outputs/tableaux/missions1_question_7_8/mission1_q8_vols_UA_AA_DL.csv")
write_csv(dest_exclusives, "outputs/tableaux/missions1_question_7_8/mission1_q7_dest_exclusives.csv")