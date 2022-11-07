#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(chorddiag)


sector_list <- read.csv("sector_df.csv")
country_list <- read.csv("country_df.csv")
country_pre <- "CHN"
sector_pre <- "TOTAL"

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "./style.css"),
    tags$link(rel = "shortcut icon", href = "./favicon.ico")
  ),
  navbarPage(
    "Emissions embodied in trade",
    tabPanel(
      "Overview",
      sidebarLayout(
        sidebarPanel(
       
            h3("Emissions embodied in trade flows"),
            "About 27% of global emissions in final demand are embodied in international trade flows.
      Developed countires tend to be net importers of emissions, and developing and emerging countries are often net exporters.
      Without a global carbon pricing approach or carbon border adjustment mechanisms, carbon leakage and the outsourcing of emissive activies
      remains significant."
          ),
          mainPanel(
            radioButtons(
              "m_version",
              "Show all emissions or only emissions embodied in trade?",
              c("Total emissions" = "m_1", "Emissions embodied in trade" = "m_2")
            ),
            chorddiagOutput("overview",
              height = 800,
              width = 800
            )
          
        )
      )
    ),
    ## exporter perspective###########################################################


    tabPanel(
      "Exporter perspective",
      sidebarLayout(
        sidebarPanel(
          
          h3("How much emissions do countries export?"),
          "Aggregate exported emissions per industry sector.",
          br(),
          selectInput(
            "x_level",
            "Select ISIC classification level",
            c("Top level (total)" = 1, "Sector level, low detail" = 2, "Sector level, medium detail" = 3, "Sector level, high detail" = 4, "Sector level, highest detail" = 5),
            2
          ),
          selectInput(
            "x_sector",
            "Select a sector to explore in detail (top figure)",
            unique(sector_list),
            sector_pre
          ),
          sliderInput(
            "n_e_country", "How many countries?", 1, 20,
            10
          ),
          selectInput(
            "x_country",
            "Select a country to explore in detail (bottom figure)",
            unique(country_list),
            country_pre
          ),
          sliderInput(
            "n_e_sector", "How many sectors?", 1, 20,
            10
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("x_topCountries"),
          br(),
          plotlyOutput("x_topSectors")
        )
      )
    ),

    ## importer perspective###########################################################

    tabPanel(
      "Importer perspective",
      sidebarLayout(
        sidebarPanel(
          h3("How much emissions do countries import?"),
          "Aggregate imported emissions per industry sector.",
          br(),
          selectInput(
            "i_level",
            "Select ISIC classification level",
            c("Top level (total)" = 1, "Sector level, low detail" = 2, "Sector level, medium detail" = 3, "Sector level, high detail" = 4, "Sector level, highest detail" = 5),
            2
          ),
          selectInput(
            "i_sector",
            "Select a sector to explore in detail (top figure)",
            unique(sector_list),
            sector_pre
          ),
          sliderInput(
            "n_i_country", "How many countries?", 1, 20,
            10
          ),
          selectInput(
            "i_country",
            "Select a country to explore in detail (bottom figure)",
            unique(country_list),
            country_pre
          ),
          sliderInput(
            "n_i_sector", "How many sectors?", 1, 20,
            10
          )
        ),


        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("i_topCountries"),
          br(),
          plotlyOutput("i_topSectors")
        )
      )
    )
  )
))
