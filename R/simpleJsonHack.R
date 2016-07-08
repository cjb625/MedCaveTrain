# library(shiny)
# httpHandler = function(req){
#   message = list(value="hello")
#   return(list(status = 200L,
#               headers = list('Content-Type' = 'application/json'),
#               body = toJSON(message)))
# }
# shiny:::handlerManager$addHandler(shiny:::routeHandler("/myEndPoint",httpHandler) , "a_unique_id")

rm(list=ls())
source('PreloadSteps.R')

library(shiny)
library(jsonlite)
msgJson <- list(payload=FALSE)

httpHandler = function(req){
  # message = list(value="hello")
  return(list(status = 200L,
              headers = list('Content-Type' = 'application/json'),
              body = toJSON(msgJson))) #toJSON(message)))
}


# shiny:::handlerManager$removeHandler("a_unique_id")
 shiny:::handlerManager$addHandler(shiny:::routeHandler("/myEndPoint",httpHandler), "a_unique_id")
# shiny:::handlerManager$addHandler(shiny:::routeHandler("",httpHandler), "a_unique_id")

runApp(host="0.0.0.0", port=3782)

