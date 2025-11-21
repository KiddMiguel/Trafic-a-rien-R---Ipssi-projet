#install.packages(c("shiny", "DT"))
# install.packages("mongolite")

library(tidyverse)
library(mongolite)

source("scripts/01_cleaning.R")

mongo_uri <- Sys.getenv("MONGO_URI")

if (mongo_uri == "") {
  stop("⚠️ MONGO_URI n'est pas défini dans .Renviron")
}
db_name <- Sys.getenv("MONGO_DB")

# 3. Connexions aux collections --------------------------------

col_airports <- mongo(collection = "airports", db = "trafic_airline", url = mongo_uri)
col_airlines <- mongo(collection = "airlines", db = "trafic_airline", url = mongo_uri)
col_planes   <- mongo(collection = "planes",   db = "trafic_airline", url = mongo_uri)
col_weather  <- mongo(collection = "weather",  db = "trafic_airline", url = mongo_uri)
col_flights  <- mongo(collection = "flights",  db = "trafic_airline", url = mongo_uri)

# On vide juste les collections
col_airports$drop()
col_airlines$drop()
col_planes$drop()
col_weather$drop()
col_flights$drop()


# 5. On insère les dataframes directement ----------------------

col_airports$insert(airports)
col_airlines$insert(airlines)
col_planes$insert(planes)
col_weather$insert(weather)
col_flights$insert(flights)

# 6. check ------------------------------------------------

col_airports$count()
col_airlines$count()
col_planes$count()
col_weather$count()
col_flights$count()