library(shiny)
library(leaflet)
library(shinythemes)
library(RColorBrewer)

### Read in data ###
schools <- read_excel("C:/Users/jjones6/Desktop/healthData/healthData/data/data.xlsx")

vars <- c(colnames(schools[6:16]))

### Define UI for application ###
shinyUI(fluidPage( theme=shinytheme("darkly"),
  
  #### Application title ###
  titlePanel("School Health Data"),
  
  ### Sidebar ### 
  sidebarLayout(
    sidebarPanel(
      selectInput("selectType", 
                  label = h3("Please select a school type"), 
                  choices = c(unique(schools$Type)),
                  selectize = TRUE
                  ),
      
      selectInput("selectVariable", 
                  label = h3("Please select a variable"), 
                  choices = vars,
                  selectize = TRUE
                  ),
      
      submitButton("Update Map")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("map", height = 500),
      DT::dataTableOutput('dataTable')
    )
  )
))
