library("shiny")
library("dplyr")
library("leaflet")

shinyServer(function(input, output) {
  
  state_data <- read.csv("data/stateEnergyData.csv", stringsAsFactors = FALSE)
  company_data <- read.csv("data/companies_and_state.csv", stringsAsFactors = FALSE)
  state_coords <- read.csv("data/States_Coordinates.csv", stringsAsFactors = FALSE)
  
  all_state_info <- full_join(state_data, state_coords, by = "State") %>% 
                    select(State, Photovoltaic, CSP, OnshoreWind, OffshoreWind,
                           BiopowerSolid, BioPowerGaseous, GeothermalHydrothermal,
                           EGSGeothermal, Hydropower, Latitude, Longitude)
  
  output$GETNAMEFROMUI <- renderLeaflet({
    
    #input$check for energy
    #input$dropdown for companies
    #input$dropdown2 for states
    #input$slider for power
    
    chosen_state <- all_state_info %>% filter(State == input$dropdown2)
    
    
    
    #map code
    
  })
  
})
