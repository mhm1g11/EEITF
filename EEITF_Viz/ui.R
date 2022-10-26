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


sector_list<-read.csv("../sector_df.csv")
country_list<-read.csv("../country_df.csv")
country_pre<-"CHN"
sector_pre<-"DTOTAL"

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
          selectInput("sector",
                      "Select a sector to explore in detail",
                      unique(sector_list),
                      sector_pre),
          
          
          selectInput("country",
                      "Select a country to explore in detail",
                      unique(country_list),
                      country_pre)
            
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("topCountries"),  
          plotlyOutput("topSectors")
        )
    )
))
