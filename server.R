library(shiny)
library("recommenderlab")
library("Matrix")
library(reshape2)

## Reading in Data ---------------------------------------------------------------------

# Load pre-trained recommender object
recommender <- readRDS("AnimeRecommender.Rds") 
ar_select <- readRDS("Anime.Rds")
animes <- readRDS("anime_dts.Rds") 
#animes <- animes[1:110,]
#print(animes)

#server.R

shinyServer(
  
  function(input, output, session){
    observeEvent(input$submit, {
      #print('test0')
      row_num <- which(animes[,2] == input$input_item1)
      #print('test11')
      #print('test2')
      ar_inp_selected <- ar_select[,2] == animes[row_num,]
      g<-acast(ar, user_id ~ anime_id)
      #print('test3')
      #as(recommended.items.mf2, "list")
      #print('test4')
      output$rec_animename <- renderTable(
      animes[row_num,]
      )
    })
    
  }
)

#movies <- read.csv("movies.csv", header = TRUE, stringsAsFactors=FALSE)
#movies <- movies[with(movies, order(title)), ]
#ratings <- read.csv("ratings100k.csv", header = TRUE)

shinyServer(function(input, output) {
  
  # Text for the 3 boxes showing average scores
  formulaText1 <- reactive({
    paste(input$input_item1)
  })
  formulaText2 <- reactive({
    paste(input$input_item2)
  })
  formulaText3 <- reactive({
    paste(input$input_item3)
  })
  
  output$movie1 <- renderText({
    formulaText1()
  })
  output$movie2 <- renderText({
    formulaText2()
  })
  output$movie3 <- renderText({
    formulaText3()
  })
  
  # Table containing recommendations
  output$table <- renderTable({
    
    # Filter for based on genre of selected movies to enhance recommendations
    cat1 <- subset(animes, name==input$input_item1)
    cat2 <- subset(animes, name==input$input_item2)
    cat3 <- subset(animes, name==input$input_item3)
    print('test0')
    
anime_recommendation <- function(input,input2,input3){
      row_num <- which(animes[,2] == input)
      row_num2 <- which(animes[,2] == input2)
      row_num3 <- which(animes[,2] == input3)
      print('test1')
      print('test1a')
      print(length(unique(animes$anime_id)))
      userSelect <- matrix(NA,length(unique(ar_select$anime_id)))
      userSelect[row_num] <- 5 #hard code first selection to rating 5
      userSelect[row_num2] <- 4 #hard code second selection to rating 4
      userSelect[row_num3] <- 4 #hard code third selection to rating 4
      userSelect <- t(userSelect)
      print('test2')
      ratingmat <- dcast(ar_select, user_id~anime_id, value.var = "rating", na.rm=FALSE)
      ratingmat <- ratingmat[,-1]
      colnames(userSelect) <- colnames(ratingmat)
      ratingmat2 <- rbind(userSelect,ratingmat)
      ratingmat2 <- as.matrix(ratingmat2)
      print('test3')
      #Convert rating matrix into a sparse matrix
      ratingmat2 <- as(ratingmat2, "realRatingMatrix")
      
      #Create Recommender Model
      #recommender_model <- Recommender(ratingmat2, method = "UBCF",param=list(method="Cosine",nn=30))
      #recom <- predict(recommender, ratingmat2[1], n=30)
      recommender_model <- Recommender(ratingmat2, method = "POPULAR",param=list(method="Cosine",nn=30))
      recom <- predict(recommender_model, ratingmat2[1], n=30)
      recom_list <- as(recom, "list")
      recom_result <- data.frame(matrix(NA,30))
      recom_result[1:30,1] <- animes[as.integer(recom_list[[1]][1:30]),3]
      recom_result <- data.frame(na.omit(recom_result[order(order(recom_result)),]))
      #recom_result <- data.frame(recom_result[1:10,])
      recom_result <- data.frame(animes[ recom_result[1:10,],2])
      colnames(recom_result) <- "User-Based Collaborative Filtering Recommended Titles"
      return(recom_result)
    }
    
    anime_recommendation(input$input_item1, input$input_item2, input$input_item3)
    
  })
  

}
)
