# Remember to source('C:/WABTEC/Internships/BlueMix-SensorTagTrial/RealTimeDashboard/Rfilters/ReadRestAPIjson.R') FIRST to train the Machine Learning Classifier!
#For external web access, run as: runApp(host="0.0.0.0",port=1234)

# library(shiny) 
# 
# shinyUI(fluidPage(  
#   mainPanel(
#     textOutput("text1")
#   )
#   
# ))


shinyUI(bootstrapPage(
  
  #   fluidPage(  
  #   mainPanel(
  #     textOutput("text1")
  #   )
  #   )
  
  # uiOutput("text1")
  #   htmlOutput(text1, inline = TRUE) #, container = if (inline) span else div, ...)
  mainPanel(
    textOutput(outputId="jsonoutput")
  )
))
