#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(leaflet)

state_options <- all_state_info[, State]
company_options <- unique(select(company_data, company_data$utility_name))
company_options <- company_options[, utility_name]
energy_options <- colnames(all_state_info)[3:11]
# Define UI for application that draws a histogram
ui <- shinyUI(navbarPage("Power in the 21st Century", id="nav",
                         tabPanel("Energy Map",
                                  div(class="outer"),
                                  tags$head(
                                    includeCSS("format.css")
                                  ),
                                  leafletOutput("map", width = "100%", height = "100%"),
                                  
                                  absolutePanel(id="controls", class = "panel", fixed = TRUE,
                                                draggable = TRUE, top = 50, left = "auto", rigth = 30, bottom = "auto",
                                                width = 330, height = "auto",
                                  h2("Location choices"),
                                  
                                  selectInput("state", "State", state_options),
                                  selectInput("company", "Company", company_options, selected = company_options[0]),
                                  radioButtons("type", "Energy Type", energy_options),
                                  sliderInput("power", lbael = h3("Total Power Output (GWh)", min = 1000000,
                                                                  max = 7200000, value = c(200000, 600000))))
                         )
  
<<<<<<< HEAD

)
)
=======
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       plotOutput("map")
    )
  )
))
>>>>>>> 7dd4e2b4b6c6d299701b11528ee3175299574243
