library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(plotly)

shinyServer(function(input, output) {
  
  state_data <- read.csv("data/stateEnergyData.csv", stringsAsFactors = FALSE)
  c_data <- read.csv("data/companies_and_state.csv", stringsAsFactors = FALSE)
  company_data <- c_data %>% distinct()
  state_coords <- read.csv("data/States_Coordinates.csv", stringsAsFactors = FALSE)
  
  all_state_info <- full_join(state_data, state_coords, by = "State") %>% 
    select(State, Total.Power, Photovoltaic, Concentrated.Solar.Power, Onshore.Wind, Offshore.Wind,
           Biopower.Solid, Biopower.Gaseous, Geothermal.Hydrothermal,
           EGS.Geothermal, Hydropower, Latitude, Longitude)
  
 
  output$map <- renderPlotly({
    
    
    
    #input$type for energy
    #input$company for companies
    #input$state for states
    #input$power for power
    
    #by default the option chosen will be National
    if (input$state != 'National') {
      #if a state is chosen
      chosen_state_national <- all_state_info %>% filter(State == 'Washington')
      #chosen_state_national table will contain info only about that state
    } else {
      #if National is chosen
      chosen_state_national <- all_state_info
      #chosen_state_national table will contain info about all states
    }
    #the name of the data frame created, whether a state is chosen or National, will be the same

    #when national is chosen states are filtered out according to the slider's min and max Total Power levels
    #if one state is chosen, it will be shown if still in the range otherwise a blank map will be shown
    state_info_with_slider <- chosen_state_national %>% filter(Total.Power > 2089068) %>%
      filter(Total.Power < 3189068)
    
    #once an energy type is selected this data frame will contain data for either
    # all states (if National) or a single state (if state chosen) for only
    #the selected energy type
    selected_energy_state <- chosen_state_national %>% select(State, Offshore.Wind)
    
    #once a company is selected this data frame will contain
    #all the states which the company covers
    #the state names are abbreviated in this data frame
    selected_states_for_company <- company_data %>% 
      filter(utility_name == "City of Aberdeen") %>%
      select(state)
    
    
    
    
    
  })
  
  l <- list(color = toRGB("grey"), width = 0.5)
  
  # specify map projection/options
  g <- list(
    scope = 'usa',
    showlakes = TRUE,
    lakecolor = toRGB('white')
  )
  
  p <- plot_geo(all_state_info, locationmode = 'USA-states') %>%
    add_trace( colors = 'Purples'
    ) %>%
    colorbar(title = "Millions USD") %>%
    layout(
      title = '2011 US Agriculture Exports by State<br>(Hover for breakdown)',
      geo = g
    )
  

})
