#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

shinyUI(fluidPage(
    
    titlePanel('Find Nearest Hospital Based on Your Current IP'),
    tags$script(
        '$(document).on("shiny:sessioninitialized",function(){$.get("https://api.ipify.org", function(response) {Shiny.setInputValue("getIP", response);});})'
    ),
    sidebarLayout(
        sidebarPanel(h2("Press Start"),
                     actionButton(inputId = "start",
                                  label = "START"),
                     width = 3,
                     h4('Your location'),
                     textOutput('ip'),
                     textOutput('pais'),
                     h4('Closest Hospital'),
                     htmlOutput(outputId = "results")),
        mainPanel(
            h2("Map"),
            leafletOutput("map"),
            width = 9),
        position = 'left'
        
    )

)
)


