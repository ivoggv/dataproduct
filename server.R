

library(shiny)
library(dplyr)
library(tidyr)
library(leaflet)
library(gmapsdistance)

# Variables -------------------------------------------------------------------------------------------------------

API.KEY=Sys.getenv("API.KEY")

# Functions -------------------------------------------------------------------------------------------------------

source('./functions/functions.R')

hosp=readRDS('./data/hospitales.rds') %>% mutate(dir=paste0(latitude,'+',longitude))


shinyServer(function(input, output) {
    
    observeEvent(
        eventExpr = input[["start"]],
        
        handlerExpr = {
        ip.id=reactive(input$getIP)
        location=ip.coord(ip.id())
        
        if (location$country!='SV') {
            output$ip <- renderText('The App only works for People in El Salvador')
            output$pais<-renderText('Sorry for the Inconvenience')
            output$map<-renderLeaflet({
                leaflet() %>%
                    addTiles() %>%  
                    addMarkers(lng=location$lon, 
                               lat=location$lat, 
                               label="You are here") 
            })
        }else{
            
        answer=closest_hosp(me = location,hosp = hosp)
            
        output$ip <- renderText(ip.id())
        output$pais<-renderText(glue::glue(location$city,'-',location$country))
        output$map<-renderLeaflet({
            answer$map
        } )
        output$results<-renderUI({
            str1 <- paste("<b>Name<b/>: ", answer$name)
            str2 <- paste("<b>Time<b/>: ", answer$time)
            str3 <- paste("<b>ETA<b/>: ", answer$eta)
            str4 <- paste("<b>Distance<b/>: ", answer$dist)
            
            
            HTML(paste(str1, str2,str3,str4, sep = '<br/>'))
        }
        
        )

            
        }

        }
)

})