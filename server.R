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
         col = "brown")
  })
  
  output$plot2 <- renderPlot({
    dist <- input$dist
    n <- input$n
    if(length(means()>1)){
    hist(means(),xlim=c(mean(data())-2*sd(data()),mean(data())+2*sd(data())),
         main=paste("Sample Means: Approximately ~ N(",round(mean(means()),3),",",round(sd(means()),3),")",sep=''),
         col = "yellow")
    }
  })
  
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
