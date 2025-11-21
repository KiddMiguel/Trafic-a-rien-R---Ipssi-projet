#### webapp/app.R — Mission 1 complète avec UI/UX améliorée ####
# install.packages(c("shinydashboard", "shinyWidgets", "plotly"), dependencies = TRUE)

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)
library(tidyverse)
library(ggplot2)
library(plotly)

# 0) Se placer à la racine du projet ---------------------------

root_dir <- normalizePath("..", winslash = "/", mustWork = TRUE)
setwd(root_dir)   # on remonte depuis webapp/ vers la racine

# 1) Neutraliser View() pour ne pas casser Shiny ---------------

View <- function(x, title = NULL, ...) {
  invisible(x)  # on ignore les fenêtres View() dans l'app
}

# 2) Charger les scripts nécessaires ---------------------------
# Nettoyage
source("scripts/01_cleaning.R")

# Toutes les questions de la Mission 1
source("scripts/01_Partie_mission1_q1.R")
source("scripts/01_Partie_mission1_q2.R")
source("scripts/01_Partie_mission1_q3.R")
source("scripts/01_Partie_mission1_q4.R")
source("scripts/01_Partie_mission1_q5.R")
source("scripts/01_Partie_mission1_q6.R")
source("scripts/01_Partie_mission1_q7_8.R")

# 3) UI avec Dashboard moderne --------------------------------

ui <- dashboardPage(
  skin = "blue",
  
  # Header
  dashboardHeader(
    title = tags$div(
      tags$i(class = "fa fa-plane", style = "margin-right: 10px;"),
      "Trafic Airline Dashboard"
    ),
    titleWidth = 300
  ),
  
  # Sidebar
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      id = "tabs",
      menuItem("📊 Statistiques Globales", tabName = "q1", icon = icon("chart-bar")),
      menuItem("✈️ Aéroports & Destinations", tabName = "q2", icon = icon("map-marker-alt")),
      menuItem("🏢 Compagnies", tabName = "q3", icon = icon("building")),
      menuItem("🌍 Houston & Seattle", tabName = "q4", icon = icon("globe-americas")),
      menuItem("📍 Vols par Destination", tabName = "q5", icon = icon("location-arrow")),
      menuItem("🔍 Couverture Compagnies", tabName = "q6", icon = icon("search")),
      menuItem("🎯 Destinations Exclusives", tabName = "q7", icon = icon("bullseye"))
    ),
    
    # Informations projet
    br(),
    div(
      style = "margin: 20px;",
      h5("📋 Informations", style = "color: white; margin-bottom: 15px;"),
      tags$small(
        style = "color: #ecf0f1;",
        "Mission 1 - Analyse des données de vol", br(),
        "Projet R - IPSSI", br(), br(),
        tags$i(class = "fa fa-database"), " Source : nycflights13"
      )
    )
  ),
  
  # Body
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f4f4f4;
        }
        .value-box-number {
          font-weight: bold;
          font-size: 28px;
        }
        .box.box-solid.box-primary {
          border: 1px solid #3c8dbc;
        }
        .nav-tabs-custom .nav-tabs li.active a {
          background-color: #3c8dbc;
          color: white;
        }
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_processing,
        .dataTables_wrapper .dataTables_paginate {
          color: #333;
        }
        .skin-blue .main-header .navbar {
          background-color: #2c3e50;
        }
        .skin-blue .main-header .logo {
          background-color: #34495e;
        }
        .content {
          padding: 20px;
        }
      "))
    ),
    
    tabItems(
      # Q1 - Statistiques Globales
      tabItem(tabName = "q1",
        fluidRow(
          box(
            title = tags$div(
              tags$i(class = "fa fa-chart-bar", style = "margin-right: 10px;"),
              "Indicateurs Clés"
            ),
            status = "primary", solidHeader = TRUE, width = 12,
            DTOutput("table_q1")
          )
        ),
        
        fluidRow(
          valueBoxOutput("vbox_airports", width = 3),
          valueBoxOutput("vbox_companies", width = 3),
          valueBoxOutput("vbox_planes", width = 3),
          valueBoxOutput("vbox_cancelled", width = 3)
        )
      ),
      
      # Q2 - Aéroports & Destinations
      tabItem(tabName = "q2",
        fluidRow(
          box(
            title = tags$div(
              tags$i(class = "fa fa-trophy", style = "margin-right: 10px;"),
              "Aéroport le Plus Fréquenté"
            ),
            status = "success", solidHeader = TRUE, width = 6,
            DTOutput("q2_top_dep")
          ),
          box(
            title = tags$div(
              tags$i(class = "fa fa-plane", style = "margin-right: 10px;"),
              "Top Destinations"
            ),
            status = "warning", solidHeader = TRUE, width = 6,
            DTOutput("q2_top10_dest")
          )
        ),
        
        fluidRow(
          tabBox(
            title = "Analyses Détaillées",
            width = 12,
            tabPanel(
              title = "🔻 Destinations Moins Prisées",
              DTOutput("q2_bottom10_dest")
            ),
            tabPanel(
              title = "🚀 Top Avions",
              DTOutput("q2_top10_planes")
            ),
            tabPanel(
              title = "😴 Avions Moins Utilisés",
              DTOutput("q2_bottom10_planes")
            )
          )
        )
      ),
      
      # Q3 - Compagnies
      tabItem(tabName = "q3",
        fluidRow(
          box(
            title = tags$div(
              tags$i(class = "fa fa-building", style = "margin-right: 10px;"),
              "Destinations par Compagnie"
            ),
            status = "primary", solidHeader = TRUE, width = 12,
            plotlyOutput("q3_plot_comp_dest", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = tags$div(
              tags$i(class = "fa fa-map", style = "margin-right: 10px;"),
              "Analyse par Origine et Compagnie"
            ),
            status = "info", solidHeader = TRUE, width = 12,
            plotlyOutput("q3_plot_comp_origin_dest", height = "450px")
          )
        )
      ),
      
      # Q4 - Houston & Seattle
      tabItem(tabName = "q4",
        fluidRow(
          valueBoxOutput("vbox_houston", width = 4),
          valueBoxOutput("vbox_nyc_sea", width = 4),
          valueBoxOutput("vbox_companies_sea", width = 4)
        ),
        
        fluidRow(
          tabBox(
            title = "Données Détaillées",
            width = 12,
            tabPanel(
              title = "🏙️ Vols vers Houston",
              DTOutput("q4_vols_houston")
            ),
            tabPanel(
              title = "🌲 NYC → Seattle",
              DTOutput("q4_vols_nyc_sea")
            )
          )
        )
      ),
      
      # Q5 - Vols par Destination
      tabItem(tabName = "q5",
        fluidRow(
          tabBox(
            title = "Analyse des Destinations",
            width = 12,
            tabPanel(
              title = "📊 Comptage par Destination",
              DTOutput("q5_vols_par_dest")
            ),
            tabPanel(
              title = "🔄 Données Triées",
              DTOutput("q5_vols_tries")
            )
          )
        )
      ),
      
      # Q6 - Couverture des Compagnies
      tabItem(tabName = "q6",
        fluidRow(
          tabBox(
            title = "Couverture des Compagnies Aériennes",
            width = 12,
            tabPanel(
              title = "❌ Couverture Partielle",
              DTOutput("q6_not_all_origins")
            ),
            tabPanel(
              title = "✅ Couverture Complète",
              DTOutput("q6_all_dest")
            ),
            tabPanel(
              title = "📋 Récapitulatif",
              DTOutput("q6_comp_orig_dest")
            )
          )
        )
      ),
      
      # Q7 & Q8 - Destinations Exclusives
      tabItem(tabName = "q7",
        fluidRow(
          box(
            title = tags$div(
              tags$i(class = "fa fa-star", style = "margin-right: 10px;"),
              "Destinations Exclusives"
            ),
            status = "warning", solidHeader = TRUE, width = 6,
            DTOutput("q7_dest_exclusives")
          ),
          box(
            title = tags$div(
              tags$i(class = "fa fa-users", style = "margin-right: 10px;"),
              "Vols UA, AA & DL"
            ),
            status = "success", solidHeader = TRUE, width = 6,
            DTOutput("q8_vols_UA_AA_DL")
          )
        )
      )
    )
  )
)

# 4) SERVER avec améliorations --------------------------------

server <- function(input, output, session) {

  # Value Boxes pour Q1
  output$vbox_airports <- renderValueBox({
    valueBox(
      value = "105",
      subtitle = "Aéroports Total",
      icon = icon("plane-departure"),
      color = "blue"
    )
  })
  
  output$vbox_companies <- renderValueBox({
    valueBox(
      value = "16", 
      subtitle = "Compagnies",
      icon = icon("building"),
      color = "green"
    )
  })
  
  output$vbox_planes <- renderValueBox({
    valueBox(
      value = "3322",
      subtitle = "Avions",
      icon = icon("fighter-jet"),
      color = "yellow"
    )
  })
  
  output$vbox_cancelled <- renderValueBox({
    valueBox(
      value = "8255",
      subtitle = "Vols Annulés", 
      icon = icon("ban"),
      color = "red"
    )
  })

  # Value Boxes pour Q4
  output$vbox_houston <- renderValueBox({
    valueBox(
      value = nrow(vols_arrivent_houston),
      subtitle = "Vols vers Houston",
      icon = icon("city"),
      color = "purple"
    )
  })
  
  output$vbox_nyc_sea <- renderValueBox({
    valueBox(
      value = n_vols_nyc_sea,
      subtitle = "Vols NYC → Seattle",
      icon = icon("route"),
      color = "teal"
    )
  })
  
  output$vbox_companies_sea <- renderValueBox({
    valueBox(
      value = n_compagnies_sea,
      subtitle = "Compagnies NYC → Seattle",
      icon = icon("handshake"),
      color = "orange"
    )
  })

  ## Tables avec style amélioré ----
  table_options <- list(
    pageLength = 10,
    scrollX = TRUE,
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    language = list(
      search = "Rechercher :",
      lengthMenu = "Afficher _MENU_ entrées",
      info = "Affichage de _START_ à _END_ sur _TOTAL_ entrées",
      paginate = list(
        first = "Premier",
        last = "Dernier", 
        "next" = "Suivant",
        previous = "Précédent"
      )
    )
  )

  ## Q1 ----
  output$table_q1 <- renderDT({
    datatable(
      mission1_q1,
      options = table_options,
      rownames = FALSE,
      class = "display nowrap"
    ) %>%
    formatStyle(columns = c(1, 2), fontSize = '14px')
  })

  ## Q2 ----
  output$q2_top_dep <- renderDT({
    datatable(
      top_dep_airport,
      options = list(dom = "t"),
      rownames = FALSE
    )
  })

  output$q2_top10_dest <- renderDT({
    datatable(
      top10_dest,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q2_bottom10_dest <- renderDT({
    datatable(
      bottom10_dest,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q2_top10_planes <- renderDT({
    datatable(
      top10_planes,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q2_bottom10_planes <- renderDT({
    datatable(
      bottom10_planes,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  ## Q3 ----
  output$q3_plot_comp_dest <- renderPlotly({
    p <- plot_comp_dest + 
      theme_minimal() +
      theme(
        text = element_text(size = 12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, hjust = 0.5)
      )
    ggplotly(p) %>%
      layout(showlegend = FALSE)
  })

  output$q3_plot_comp_origin_dest <- renderPlotly({
    p <- plot_comp_origin_dest + 
      theme_minimal() +
      theme(
        text = element_text(size = 12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, hjust = 0.5)
      )
    ggplotly(p)
  })

  ## Q4 ----
  output$q4_vols_houston <- renderDT({
    datatable(
      vols_arrivent_houston,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q4_vols_nyc_sea <- renderDT({
    datatable(
      vols_nyc_sea,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q4_resume <- renderText({
    paste0(
      "Nombre de vols NYC → Seattle : ", n_vols_nyc_sea, "\n",
      "Nombre de compagnies qui desservent Seattle depuis NYC : ", n_compagnies_sea, "\n",
      "Nombre d'avions uniques sur NYC → Seattle : ", n_avions_uniques_sea
    )
  })

  ## Q5 ----
  output$q5_vols_par_dest <- renderDT({
    datatable(
      vols_par_dest,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q5_vols_tries <- renderDT({
    datatable(
      vols_trie,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  ## Q6 ----
  output$q6_not_all_origins <- renderDT({
    datatable(
      comp_not_all_origins,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q6_all_dest <- renderDT({
    datatable(
      comp_all_dest,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q6_comp_orig_dest <- renderDT({
    datatable(
      comp_orig_dest_table,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  ## Q7 & Q8 ----
  output$q7_dest_exclusives <- renderDT({
    datatable(
      dest_exclusives,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$q8_vols_UA_AA_DL <- renderDT({
    datatable(
      vols_UA_AA_DL,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

}

shinyApp(ui, server)
