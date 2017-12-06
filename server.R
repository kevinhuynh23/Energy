library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(plotly)
library("ggplot2")


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
    capFirst <- function(s) {
      gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", s, perl=TRUE)
    }
    
    state_df <- map_data("state")
    names(state_df) <- c("lng", "lat", "group", "order", "State", "subregion")
    state_df$State <- capFirst(state_df$State)
    choropleth <- inner_join(state_df, all_state_info, by = "State")
    choropleth <- choropleth[!duplicated(choropleth$order), ]
    
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
    state_info_with_slider <- chosen_state_national %>% filter(Total.Power > input$power) %>%
      filter(Total.Power < input$type)
    
    #once an energy type is selected this data frame will contain data for either
    # all states (if National) or a single state (if state chosen) for only
    #the selected energy type
    
    selected_energy_state <- chosen_state_national %>% select(State, input$type, Longitude, Latitude)
    
    colnames(selected_energy_state)[2] <- 'EnergyType'
    
    choropleth2 <- choropleth %>% select(lng, lat, State, input$type, group)
    colnames(choropleth2)[4] <- 'SelectedEnergyType'
    
    
    
    #once a company is selected this data frame will contain
    #all the states which the company covers
    #the state names are abbreviated in this data frame
    selected_states_for_company <- company_data %>% 
      filter(Utility.Name == input$company) 
    
    
    
    stateCompany <- all_state_info %>%   #inner_join(c_data, all_state_info, by = "State")
      filter(all_state_info$State == selected_states_for_company$State)
      
    companyInfo <- inner_join(stateCompany, selected_states_for_company, by = "State")
    
    p <- ggplot() 
    g <- p + geom_polygon(data = choropleth2, aes(lng, lat, group = group, fill = SelectedEnergyType)) +
      #geom_polygon(data = state_df, colour = "white", fill = NA) +
      geom_point(aes(x = companyInfo$Longitude, y = companyInfo$Latitude,
                     text = companyInfo$Utility.Name), 
                 colour="red", alpha = 1/2) +
      xlab('Longitude') + 
      ylab('Latitude')
    
    g <- ggplotly(g)
    
   g <- plotly_build(g)

   
    
  })

})

