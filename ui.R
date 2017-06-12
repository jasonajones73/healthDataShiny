library(shiny)
library(leaflet)
library(shinythemes)
library(RColorBrewer)
library(readxl)
library(plotly)

### Read in data ###
schools <- read_excel("C:/Users/jjones6/Desktop/healthData/healthData/healthDataShiny/data/data.xlsx")

vars <- c(colnames(schools[6:16]))

### Define UI for application ###
shinyUI(fluidPage( theme=shinytheme("cerulean"),
  
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
      
      hr(),
      
      selectInput("selectVariable", 
                  label = h3("Please select a variable"), 
                  choices = vars,
                  selectize = TRUE
                  ),
      
      submitButton("Update Map")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("map"),
      
      hr(),
      
      fluidRow(
        column(6, plotlyOutput("chart")),
               
        column(6, plotlyOutput("scat"))
      )
    )
  )
))
