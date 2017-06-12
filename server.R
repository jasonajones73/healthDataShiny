library(shiny)
library(RColorBrewer)
library(leaflet)
library(readxl)
library(DT)
library(htmltools)
library(ggplot2)
library(plotly)


### Define server logic ###
shinyServer(function(input, output) {
  
  ### Read in data ###
  schools <- read_excel("C:/Users/jjones6/Desktop/healthData/healthData/healthDataShiny/data/data.xlsx")
  
  ### Subset data based on school type input ###
  schoolsFilter <- reactive({
    schools[schools$Type == input$selectType, ]
    })
  
  
  output$map <- renderLeaflet({
    ### Construct Intro map w/ school markers ###
    leaflet(schools) %>%
      addTiles(urlTemplate="https://api.mapbox.com/styles/v1/jasonajones73/cj3ohxtbf000b2snuj3hsjlp2/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFzb25ham9uZXM3MyIsImEiOiJjajE0YnNjY2UwMDQ4MnFvN2dvdWd4MHNxIn0.yZLkU--A8y1XwkMOfQFfSQ", group="Moonlight") %>%
      addTiles(urlTemplate="https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFzb25ham9uZXM3MyIsImEiOiJjajE0YnNjY2UwMDQ4MnFvN2dvdWd4MHNxIn0.yZLkU--A8y1XwkMOfQFfSQ", group="Light") %>%
      addTiles(group="Default Street") %>%
      addTiles(urlTemplate="https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFzb25ham9uZXM3MyIsImEiOiJjajE0YnNjY2UwMDQ4MnFvN2dvdWd4MHNxIn0.yZLkU--A8y1XwkMOfQFfSQ", group="Mapbox") %>%
      
      ### Layers Control ###
      addLayersControl(baseGroups=c("Moonlight", "Light", "Default Street", "Mapbox"), 
                       options=layersControlOptions(collapsed=TRUE)) %>%
      
      ### Add school markers ###    
      addCircleMarkers(lng=schools$Long,
                 lat=schools$Lat)
    
  })

  
  observe({
    colorBy <- input$selectVariable
    
    colorData <- schoolsFilter()[[colorBy]]
    pal <- colorBin("BuPu", colorData, 7, pretty = TRUE)
    
    leafletProxy("map", data = schoolsFilter()) %>%
                  clearMarkers() %>%
                  clearPopups()%>%
                  addCircleMarkers(lng=schoolsFilter()$Long,
                                   lat=schoolsFilter()$Lat,
                                   stroke=FALSE,
                                   fillOpacity = 1,
                                   fillColor = pal(colorData),
                                   label = paste(sep=" - ", schoolsFilter()$School, paste(colorBy,": ",schoolsFilter()[[colorBy]] ))) %>%
      ### Add Reactive Legend ###
      addLegend("bottomleft",
                pal=pal,
                values=colorData,
                title=colorBy,
                layerId="legend")
  })
  
  observe({
    chartBy <- input$selectVariable
    chartData <-  schoolsFilter()[[chartBy]]
    
    output$chart <- renderPlotly(plot_ly(data = schoolsFilter(), x=~School, y=~chartData))
    output$scat <- renderPlotly(plot_ly(data = schoolsFilter(), x=schoolsFilter()$`Number of Identified Health Condition`, y=~chartData))
  })
  
### End Server Function ###  
})
