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
sector_pre <- "DTOTAL"

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  navbarPage(
    "Emissions embodied in trade",
    tabPanel(
      "Overview",
      
      sidebarLayout(
      sidebarPanel(
        
      h3("Headline"),
      "Lorem Ipsum",
      br(),
        
      ),
      
      mainPanel(

        chorddiagOutput("overview", height=600, width=600)
        
      )
      
      
      
      )),
    
##exporter perspective###########################################################
  
    
    tabPanel(
      "Exporter perspective",
      sidebarLayout(
        sidebarPanel(
          
          h3("Headline"),
          "Lorem Ipsum",
          br(),
          
          selectInput(
            "x_sector",
            "Select a sector to explore in detail",
            unique(sector_list),
            sector_pre
          ),
          selectInput(
            "x_country",
            "Select a country to explore in detail",
            unique(country_list),
            country_pre
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
    
##importer perspective###########################################################
    
    tabPanel(
      "Importer perspective",
      sidebarLayout(
        sidebarPanel(
          
          h3("Headline"),
          "Lorem Ipsum",
          br(),
          
          selectInput(
            "i_sector",
            "Select a sector to explore in detail",
            unique(sector_list),
            sector_pre
          ),
          selectInput(
            "i_country",
            "Select a country to explore in detail",
            unique(country_list),
            country_pre
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
