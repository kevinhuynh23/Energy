

library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)

state_data <- read.csv("data/stateEnergyData.csv", stringsAsFactors = FALSE)
c_data <- read.csv("data/companies_and_state.csv", stringsAsFactors = FALSE)
company_data <- c_data %>% distinct()
state_coords <- read.csv("data/States_Coordinates.csv", stringsAsFactors = FALSE)

all_state_info <- full_join(state_data, state_coords, by = "State") %>% 
  select(State, Total.Power, Photovoltaic, Concentrated.Solar.Power, Onshore.Wind, Offshore.Wind,
         Biopower.Solid, Biopower.Gaseous, Geothermal.Hydrothermal,
         EGS.Geothermal, Hydropower, Latitude, Longitude)
national_option <- c("National")
state_options <- as.vector(all_state_info$State)
state_options <- append(national_option, state_options)
company_options <- company_data %>% select(utility_name)
company_options <- unique(as.vector(company_options$utility_name))
energy_options <- colnames(all_state_info)[3:11]
# Define UI for application that draws a map and floating sidebar
shinyUI(navbarPage("Power in the 21st Century", id="nav",
                         tabPanel("Energy Map",
                                  #Import css file
                                  div(class="outer"),
                                  tags$head(
                                    includeCSS("format.css")
                                  ),
                                  #refers to map data from server
                                  leafletOutput("map", width = "100%", height = "100%"),
                                  
                                  #creates panel with css formating
                                  absolutePanel(id="controls", class = "panel", fixed = TRUE,
                                                draggable = TRUE, top = 50, left = "auto", rigth = 30, bottom = "auto",
                                                width = 330, height = "auto",
                                  h2("Location choices"),
                                  
                                  #Drop down for state options
                                  selectInput("state", "State", state_options),
                                  #Drop down for company options
                                  selectInput("company", "Company", company_options, selected = company_options[0]),
                                  #Radio buttons for type of energy
                                  radioButtons("type", "Energy Type", energy_options),
                                  #Slider for energy range
                                  sliderInput("power", label = h3("Total Power Output (GWh)"), min = 100000,
                                                                  max = 7200000, value = c(1000000, 6000000)))
                         ),
                         tabPanel("Energy Table",
                                  fluidRow(
                                    column(3,
                                           selectInput("states", "States", state_options)
                                    )
                                  ),
                                  hr(),
                                  fluidRow(
                                  DT::dataTableOutput("energyTable")
                                  )
                         )
)
)
