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
library(chorddiag)




### Define emission database



exporter_emissions_df <- read.csv("exporter_emissions_df.csv")
importer_emissions_df <- read.csv("importer_emissions_df.csv")
flows_m <- read.csv("flows_m.csv")%>%
  column_to_rownames("x_region")
m<-as.matrix(flows_m)




# Define server logic
shinyServer(function(input, output) {
  

  
  ##overview###########################################################
  
  
  output$overview <- renderChorddiag({

    
    chorddiag(m,type = "directional", showTicks = F, groupnameFontsize = 13, groupnamePadding = 10, margin = 200)

    
  })
  
  
  
##exporter perspective###########################################################
  
  output$x_topCountries <- renderPlotly({
    x_sector <- input$x_sector

    plot_ly(
      data = top_n(exporter_emissions_df %>% filter(IND == x_sector), 10, obsValue),
      x = ~obsValue,
      y = ~COU,
      type = "bar"
    ) %>%
      layout(
        yaxis = list(title = "Exporting country", categoryorder = "total ascending"),
        xaxis = list(title = "Emissions embodied in exports (tonnes, millions)", tickformat = ".0f"),
        title = "The 10 countries with the largest exported emissions",
        plot_bgcolor = "#e5ecf6"
      )
  })


  output$x_topSectors <- renderPlotly({
    x_country <- input$x_country

    plot_ly(
      data = top_n(exporter_emissions_df %>% filter(COU == x_country), 10, obsValue),
      x = ~obsValue,
      y = ~IND,
      type = "bar"
    ) %>%
      layout(
        yaxis = list(title = "Emitting sector", categoryorder = "total ascending"),
        xaxis = list(title = "Emissions embodied in exports (tonnes, millions)", tickformat = ".0f"),
        title = paste0("The top 10 sectors with the largest exported emissions in ", x_country),
        plot_bgcolor = "#e5ecf6"
      )
  })

##importer perspective###########################################################

  output$i_topCountries <- renderPlotly({
    i_sector <- input$i_sector

    plot_ly(
      data = top_n(importer_emissions_df %>% filter(IND == i_sector), 10, obsValue),
      x = ~obsValue,
      y = ~COU,
      type = "bar"
    ) %>%
      layout(
        yaxis = list(title = "Importing country", categoryorder = "total ascending"),
        xaxis = list(title = "Emissions embodied in imports (tonnes, millions)", tickformat = ".0f"),
        title = "The 10 countries with the largest imported emissions",
        plot_bgcolor = "#e5ecf6"
      )
  })


  output$i_topSectors <- renderPlotly({
    i_country <- input$i_country

    plot_ly(
      data = top_n(importer_emissions_df %>% filter(COU == i_country), 10, obsValue),
      x = ~obsValue,
      y = ~IND,
      type = "bar"
    ) %>%
      layout(
        yaxis = list(title = "Emitting sector", categoryorder = "total ascending"),
        xaxis = list(title = "Emissions embodied in imports (tonnes, millions)", tickformat = ".0f"),
        title = paste0("The top 10 sectors with the largest imported emissions in ", i_country),
        plot_bgcolor = "#e5ecf6"
      )
  })
})
