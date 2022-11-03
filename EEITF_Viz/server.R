#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)



### Define emission database



emissions_df <- read.csv("emissions_df.csv")




# Define server logic 
shinyServer(function(input, output) {

    output$topCountries <- renderPlotly({

      sector<-input$sector
      
      plot_ly(
        data = top_n(emissions_df%>%filter(IND==sector),10,obsValue),
        x = ~obsValue,
        y = ~COU,
        type = "bar"
      )%>% 
        layout(yaxis = list(title="Exporting country",categoryorder = "total ascending"),
               xaxis = list(title="Emissions embodied in exports (tonnes, millions)",tickformat= ".0f"),
               title="The 10 countries with the largest exported emissions",
               plot_bgcolor = "#e5ecf6")

    })
    
    
    output$topSectors <- renderPlotly({
      
      country<-input$country
      
      plot_ly(
        data = top_n(emissions_df%>%filter(COU==country),10,obsValue),
        x = ~obsValue,
        y = ~IND,
        type = "bar"
      )%>% 
        layout(yaxis = list(title="Emitting sector",categoryorder = "total ascending"),
               xaxis = list(title="Emissions embodied in exports (tonnes, millions)",tickformat= ".0f"),
               title=paste0("The top 10 sectors with the largest exported emissions in ",country),
               plot_bgcolor = "#e5ecf6")
      
      
      
    })

})
