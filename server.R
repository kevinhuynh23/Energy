#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(leaflet)

state_data <-read.csv("./data/stateEnergyData.csv")
company_data <- read.csv("./data/companyEnergyData.csv")
state_coords <- read.csv("./data/States_Coordinates.csv")

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
  filteredEnergyInput <- reactive({
    
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
  
})
