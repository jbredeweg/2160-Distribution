library(shiny)

allMeans <- NULL

# server logic
shinyServer(function(input, output) {  
  
  #generate data from selected distribution
  data <- reactive({  

    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   logis = rlogis,
                   rnorm)
    
    dist(input$n)
  })
  
  means <- reactive({
    if(input$N>1){    
    sample.means<-numeric(input$N)
    sample.means<-mean(sample(data(),input$xbar.size,FALSE))
    allMeans <<- c(allMeans,sample.means)
    allMeans
   }
  })
  
  # Plot the underlying distribution on top, and the distribution
  # of the sample mean on bottom.
  output$plot1 <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(data(), 
         main=paste("Observations: ",'r', dist, " ~ (",round(mean(data()),3),",",round(sd(data()),3),")", sep=''),
         xlim=c(min(data()),max(data())),
         col = rgb(.2,.0628,0), border="white",
         xlab = "Data")
  })
  
  suppressWarnings(
    output$plot2 <- renderPlot({
    dist <- input$dist
    n <- input$n
    if(length(means()>1)){
    hist(means(),
         xlim=c(min(data()),max(data())),
         main=paste("Sample Means: Approximately ~ N(",round(mean(means()),3),",",round(sd(means()),3),")",sep=''),
         col = rgb(.933,.694,.0667),
         xlab = paste(length(allMeans)," Sample Means Taken",sep=""),
         prob = T)
      if(length(means()>2) & input$density==T){
      lines(density(means(),adjust=2))
      }
    }
  })
  )
  
  # Generate a summary of the data
  output$summary1 <- renderPrint({
    summary(data())
  })
  
  output$summary2 <- renderPrint({
    summary(means())
  })
  
  #Reset means dataset
  output$resetData <- reactive({ 
  allMeans<<-NULL
  
  })
  

})
