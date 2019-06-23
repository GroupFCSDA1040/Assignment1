library(shiny)
library(shinydashboard)
library(proxy)
library(recommenderlab)
library(reshape2)
library(plyr)
library(dplyr)
library(DT)
library(RCurl)

# load pre-build files
anime_df <- readRDS("anime_dts.Rds") 
anime_dfNum <- nrow(anime_df)

shinyUI(fluidPage(
  
  titlePanel(title = "Anime System"),
  sidebarLayout(position = "left",
    sidebarPanel(h3("Enter Favourite Anime Details"),
                 #textInput("name", "Enter Anime Name", "" ),
                 
                 selectInput("input_item1", "Anime Name 1", choices = c("",as.list(anime_df[,2]))),
                 selectInput("input_item2", "Anime Name 2", choices = c("",as.list(anime_df[,2]))),
                 selectInput("input_item3", "Anime Name 3", choices = c("",as.list(anime_df[,2])))
#               ,actionButton("submit", "Submit")
#                 ,textInput("age", "Enter your age", "" ),
#                 radioButtons("gender", "select the gender", list("Male", "Female", "Not disclosing"), "")
                          ),


    mainPanel(h4("Recommended Animes"),
              textOutput("rec_animename"),
              tabItem(tabName = "animes recommended",
                      fluidRow(
                        box(
                          width = 6, status = "info", solidHead = TRUE,
                          title = "Other Animes You Might Like"
                         ,tableOutput("table"))
#                        ,valueBoxOutput("tableRatings1"),
#                        valueBoxOutput("tableRatings2"),
#                        valueBoxOutput("tableRatings3"),
#                        HTML('<br/>'),
#                        box(DT::dataTableOutput("myTable"), title = "Table of All Animes", width=12, collapsible = TRUE)
                      )
              )
              #,textOutput("myage"),
              #textOutput("mygender")
                                      )
  )
)

)
