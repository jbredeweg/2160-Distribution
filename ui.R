library(shiny)

# UI definition for distribution tool
shinyUI(pageWithSidebar(
  
  # title
  headerPanel("STAT 2160 Distribution Visualization Tool"),
  
  # Sidebar for choosing distribution type, sample size, # of means, etc.
  sidebarPanel(
    radioButtons("dist", "Distribution type:",
                 list("Normal" = "norm",
                      "Uniform" = "unif",
                      "Log-normal" = "lnorm",
                      "Exponential" = "exp")),
    br(),
    

    sliderInput("n", 
                "Number of observations (n):", 
                value = 500,
                min = 1, 
                max = 5000),
    
    # animation looping for number of sample means to take
    # note: interval controls the speed in ms between steps
        
    sliderInput("xbar.size",
                "Sample Size for Sample Mean (sample):",
                value = 5,
                min = 1,
                max = 500),
    
    sliderInput("N",
                "Number of Sample Means (N):", 1,500,1,step=1,
                animate=animationOptions(interval=200, loop=T)),
    
    
    br(),
    
    helpText("To begin the simulation, make your selections for the underlying distribution and it's size (n).",
             " Select the sample size for each sample mean (sample) and then press the play button below the slider ",
             "for the number of sample means (N).",
             br(), br(), "When you want to change the distribution type, press the ",
             "reset button, then the refresh button to clear the data and start fresh."),
    
    downloadButton('resetData', 'Reset'),
    
    HTML("<a class='btn' href='/'>Refresh</a>")
        
  ),
  
  # Present information in 2 tabs: plot and data summary
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("plot1"),plotOutput("plot2")), 
      tabPanel("Summary", verbatimTextOutput("summary1"),verbatimTextOutput("summary2")) 
    )
  )
))
