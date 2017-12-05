
library("shiny")
library("dplyr")
library("leaflet")

library(shiny)
library(dplyr)
library(leaflet)

state_data <-read.csv("data/stateEnergyData.csv")
company_data <- read.csv("data/companies_and_state.csv")
state_coords <- read.csv("data/States_Coordinates.csv")


shinyServer(function(input, output) {
  
  state_data <- read.csv("data/stateEnergyData.csv", stringsAsFactors = FALSE)
  c_data <- read.csv("data/companies_and_state.csv", stringsAsFactors = FALSE)
  company_data <- c_data %>% distinct()
  state_coords <- read.csv("data/States_Coordinates.csv", stringsAsFactors = FALSE)
  
  all_state_info <- full_join(state_data, state_coords, by = "State") %>% 
    select(State, Total.Power, Photovoltaic, Concentrated.Solar.Power, Onshore.Wind, Offshore.Wind,
           Biopower.Solid, Biopower.Gaseous, Geothermal.Hydrothermal,
           EGS.Geothermal, Hydropower, Latitude, Longitude)
  
  output$GETNAMEFROMUI <- renderLeaflet({
    
    #input$type for energy
    #input$company for companies
    #input$state for states
    #input$power for power
    
    #by default the option chosen will be National
    if (input$state != 'National') {
      #if a state is chosen
      chosen_state_national <- all_state_info %>% filter(State == input$state)
      #chosen_state_national table will contain info only about that state
    } else {
      #if National is chosen
      chosen_state_national <- all_state_info
      #chosen_state_national table will contain info about all states
    }
    #the name of the data frame created, whether a state is chosen or National, will be the same

    
    #when national is chosen states are filtered out according to the slider's min and max Total Power levels
    #if one state is chosen, it will be shown if still in the range otherwise a blank map will be shown
    state_info_with_slider <- chosen_state_national %>% filter(Total.Power > input$power[1]) %>%
      filter(Total.Power < input$power[2])
    
    #once an energy type is selected this data frame will contain data for either
    # all states (if National) or a single state (if state chosen) for only
    #the selected energy type
    selected_energy_state <- chosen_state_national %>% select(State, input$type)
    
    #once a company is selected this data frame will contain
    #all the states which the company covers
    #the state names are abbreviated in this data frame
    selected_states_for_company <- company_data %>% 
      filter(utility_name == input$company) %>%
      select(state)
    
    
    #map code
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
    
    
  })

})
