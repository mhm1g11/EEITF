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
library(ggplot2)
library(plotly)
library(chorddiag)
library(directlabels)

### Set colour palette

c1 <- "#2C3333"
c2 <- "#1a374d"
c3 <- "#A5C9CA"
c4 <- "#DFF6FF"
c5 <- "#9F73AB"

sector_list <- read.csv("sector_df.csv")


### Define emission database



exporter_emissions_df <- read.csv("exporter_emissions_df.csv")
importer_emissions_df <- read.csv("importer_emissions_df.csv")
flows_m_1 <- read.csv("flows_m_1.csv") %>%
  select(-1)%>%
  column_to_rownames("x_region")
m_1 <- as.matrix(flows_m_1)

flows_m_2 <- read.csv("flows_m_2.csv") %>%
  select(-1)%>%
  column_to_rownames("x_region")
m_2 <- as.matrix(flows_m_2)





# Define server logic
shinyServer(function(input, output) {
  ## overview###########################################################
  
  

  output$overview <- renderChorddiag({
    
    
    if(input$m_version=="m_1"){
      chorddiag(m_1, type = "directional", showTicks = F, groupnameFontsize = 13, groupnamePadding = 10, margin = 200)
    }else if (input$m_version=="m_2") {
      chorddiag(m_2, type = "directional", showTicks = F, groupnameFontsize = 13, groupnamePadding = 10, margin = 200)
    }
    
    
    
  })



  ## exporter perspective###########################################################

  
  observe({
    updateSelectInput(getDefaultReactiveDomain(), "x_sector", choices = exporter_emissions_df%>%
                        filter(Level==input$x_level)%>%
                        select(Desc)%>%
                        unique(),
                      selected=NULL)
  })
  
  
  output$x_topCountries <- renderPlotly({

    
    x_sector<- input$x_sector
    
    ggplotly(
      ggplot(top_n(exporter_emissions_df %>%
                     filter(Level== input$x_level)%>%
                     filter(Desc == input$x_sector), input$n_e_country, obsValue))+
        
        
        geom_bar(aes(x=obsValue,y=reorder(COU,obsValue)),fill=c2,color=c2, stat = "identity")+
        
        geom_text(aes(x=ifelse(obsValue<max(obsValue)*7/127,
                               obsValue+(max(obsValue)*3/100),
                               obsValue-(max(obsValue)*3/100)),y=reorder(COU,obsValue),label=ifelse(obsValue<max(obsValue)*7/127,COU,element_blank())), color=c2, size=3)+
        
        geom_text(aes(x=ifelse(obsValue<max(obsValue)*7/127,
                      obsValue+(max(obsValue)*3/100),
                      obsValue-(max(obsValue)*3/100)),y=reorder(COU,obsValue),label=ifelse(obsValue>max(obsValue)*7/127,COU,element_blank())), color="white", size=3)+
        
        
        labs(title =paste0("The ",input$n_e_country, " countries with the largest exported emissions"),
             x ="Emissions embodied in exports (tonnes, millions)",
             y="")+
        theme_light()+
        theme(legend.position="right",
              legend.direction="vertical",
              legend.margin=margin(),
              plot.title = element_text(color = c1),
              plot.subtitle = element_text(color = c1),
              axis.title = element_text(color = c1),
              legend.text = element_text(color = c1),
              legend.title = element_text(color = c1),
              
              
              axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_blank())
      
      
      
    )
    
  })



  
  
  
  

  
  
  output$x_topSectors <- renderPlotly({
    
    x_country <- input$x_country
    
    ggplotly(
      ggplot(top_n(exporter_emissions_df %>% 
                     filter(Level==input$x_level)%>%
                     filter(COU == input$x_country), input$n_e_sector, obsValue))+
        geom_bar(aes(x=obsValue,y=reorder(Desc,obsValue)),fill=c2,color=c2, stat = "identity")+
        #geom_text(aes(x=obsValue+(max(obsValue)*10/100),y=reorder(Desc,obsValue),label=ifelse(obsValue<max(obsValue)*20/127,Desc,element_blank())), color=c2, size=3, hjust="right")+
        #geom_text(aes(x=obsValue-(max(obsValue)*10/100),y=reorder(Desc,obsValue),label=ifelse(obsValue>max(obsValue)*20/127,Desc,element_blank())), color="white", size=3, hjust="right")+
        
        labs(title =paste0("The top ", input$n_e_sector," sectors with the largest exported emissions in ", x_country),
             x ="Emissions embodied in exports (tonnes, millions)",
             y="")+
        theme_light()+
        theme(legend.position="right",
              legend.direction="vertical",
              legend.margin=margin(),
              plot.title = element_text(color = c1),
              plot.subtitle = element_text(color = c1),
              axis.title = element_text(color = c1),
              legend.text = element_text(color = c1),
              legend.title = element_text(color = c1),
              
              
              axis.line=element_blank(),
              axis.text.x=element_blank(),
              #axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_blank())
      
      
    )
    
  })

  ## importer perspective###########################################################

  observe({
    updateSelectInput(getDefaultReactiveDomain(), "i_sector", choices = importer_emissions_df%>%
                        filter(Level==input$i_level)%>%
                        select(Desc)%>%
                        unique(),
                      selected=NULL)
  })
  
  
  
  
   output$i_topCountries <- renderPlotly({
    i_sector <- input$i_sector

    ggplotly(
      ggplot(top_n(importer_emissions_df %>% filter(Desc == input$i_sector), input$n_i_country, obsValue))+
        geom_bar(aes(x=obsValue,y=reorder(COU,obsValue)),fill=c2,color=c2, stat = "identity")+
        geom_text(aes(x=ifelse(obsValue<max(obsValue)*7/127,
                               obsValue+(max(obsValue)*3/100),
                               obsValue-(max(obsValue)*3/100)),y=reorder(COU,obsValue),label=ifelse(obsValue<max(obsValue)*7/127,COU,element_blank())), color=c2, size=3)+
        
        geom_text(aes(x=ifelse(obsValue<max(obsValue)*7/127,
                               obsValue+(max(obsValue)*3/100),
                               obsValue-(max(obsValue)*3/100)),y=reorder(COU,obsValue),label=ifelse(obsValue>max(obsValue)*7/127,COU,element_blank())), color="white", size=3)+
        labs(title =paste0("The ",input$n_i_country, " countries with the largest imported emissions"),
             x ="Emissions embodied in imports (tonnes, millions)",
             y="")+
        theme_light()+
        theme(legend.position="right",
              legend.direction="vertical",
              legend.margin=margin(),
              plot.title = element_text(color = c1),
              plot.subtitle = element_text(color = c1),
              axis.title = element_text(color = c1),
              legend.text = element_text(color = c1),
              legend.title = element_text(color = c1),
              
              
              axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_blank())
    )
      
  })


  output$i_topSectors <- renderPlotly({
    i_country <- input$i_country

    ggplotly(
      ggplot(top_n(importer_emissions_df %>% 
                     filter(Level==input$i_level)%>%
                     filter(COU == input$i_country), input$n_i_sector, obsValue))+
        geom_bar(aes(x=obsValue,y=reorder(Desc,obsValue)),fill=c2,color=c2, stat = "identity")+
        geom_text(aes(x=obsValue,y=reorder(Desc,obsValue),label=obsValue), color=c1)+
        labs(title =paste0("The top ", input$n_i_sector," sectors with the largest imported emissions in ", i_country),
             x ="Emissions embodied in imports (tonnes, millions)",
             y="")+
        theme_light()+
        theme(legend.position="right",
              legend.direction="vertical",
              legend.margin=margin(),
              plot.title = element_text(color = c1),
              plot.subtitle = element_text(color = c1),
              axis.title = element_text(color = c1),
              legend.text = element_text(color = c1),
              legend.title = element_text(color = c1),
              
              
              axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_blank())
      
      
    )
    
    
    
  })
})
