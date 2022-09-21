library(plotly)
library(shiny)
library(dplyr)
shinyServer(function(input, output) {
    states_info<-as.data.frame(state.x77)
    states_info$State <- rownames(states_info)
    states_info <- states_info[,c(9, 1:8)]
    states_info$code <- state.abb
    hoverClick <- reactive({
      currentEventData <- unlist(event_data(event = "plotly_click",
                                            source = "A"))
      })
    output$textmin <- renderText({
      if (input$showmin){
          variable<-as.character(input$variable)
          pos<-which(names(states_info)==variable)
          min<-states_info%>%select(State,pos)%>%
            filter(states_info[,pos] == min(states_info[,pos]))
          if (length(min[[1]])>1){
            min <-c(paste(min[1][[1]],collapse=','),min[[2]][1])
          }
          textmin<-paste("Minimum:",(min[1]),"=",
                         as.character(min[2]))
          }
      })
    output$textmax <- renderText({
      if (input$showmax){
          variable<-as.character(input$variable)
          pos<-which(names(states_info)==variable)
          max<-states_info%>%select(State,pos)%>%
            filter(states_info[,pos] ==max(states_info[,pos]))
          if (length(max[[1]])>1){
            max <-c(paste(max[1][[1]],collapse=','),max[[2]][1])
            }
          textmax<-paste("Maximum:",as.character(max[1]),"=",
                         as.character(max[2]))
          }
      })

    output$info <- renderTable({
      row<-hoverClick()[2]+1
      table<-states_info[row,0:8]
    },align = "c", width = "100%")

    output$map<-renderPlotly({
      variable<-as.character(input$variable)
      title<-paste(variable, "in the USA")
      pos<-which(names(states_info)==variable)
      hover<-paste(states_info$State,'<br>', states_info[,pos])
      states_info$variable<-states_info[,pos]
      borders <- list(color=toRGB('black'))
      map_options<- list(
        scope = "usa",
        projection = list(type = 'albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB('white')
      )
      plot_ly(states_info)%>%add_trace(z=~variable,text=~hover,hoverinfo="text",
              locations=~code,type='choropleth',ids=~code,
              locationmode='USA-states',color=~variable,
              colors='Greens', marker=list(line=list(
                width=0)), source="A")%>%
        layout(title=title,geo = map_options)%>%colorbar(title = variable)
    })
  })

