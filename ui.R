

library(shiny)
library(dplyr)
library(leaflet)

state_options <- all_state_info[, State]
company_options <- unique(select(company_data, company_data$utility_name))
company_options <- company_options[, utility_name]
energy_options <- colnames(all_state_info)[3:11]
# Define UI for application that draws a map and floating sidebar
ui <- shinyUI(navbarPage("Power in the 21st Century", id="nav",
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
                                  sliderInput("power", lbael = h3("Total Power Output (GWh)", min = 1000000,
                                                                  max = 7200000, value = c(200000, 600000))))
                         ),
                         tabPanel("Energy Table",
                                  fluidRow(
                                    column(3,
                                           selectInput("states", "States", state_options)
                                    )
                                  ),
                                  hr(),
                                  DT::dataTableOutput("ziptable")
                         )
                         
  )
)

