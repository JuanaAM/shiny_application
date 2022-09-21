library(shiny)
library(plotly)
shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Visualization of data from the USA on a Map"),
      p("In this map you can see information related to the
        50 states of the USA, this data was taken from the dataset state.x77, for more information
        on the variables ",a("see here.", href="https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/state.html")),
      h4("Instructions:"),
      tags$ul(
        tags$li("Below you can choose the variable you want to observe on the map."),
        tags$li("In the checkboxes you have the option to see the maximum and minimum values of the chosen variable."),
        tags$li("By clicking on one of the states of the map you can access to the complete data about that state, this will be shown in the table at the bottom of the map.")
      ),

      selectInput("variable", "Choose a variable to plot:",
                  list("Population","Income","Illiteracy",
                       "Life Exp","Murder","HS Grad","Frost","Area")),
      checkboxInput("showmin", "Show Minimum Value ", value = FALSE),
      checkboxInput("showmax", "Show Maximum Value ", value = FALSE)
    ),

    mainPanel(
      plotlyOutput("map"),
      textOutput("textmin"),
      textOutput("textmax"),
      br(),
      br(),
      tableOutput("info"),
      tags$head(tags$style("#textmin{color: gray;
                                 font-size: 15px;
                           text-align:center
                                 }")
      ),
      tags$head(tags$style("#textmax{color: gray;
                                 font-size: 15px;
                           text-align:center
                                 }")
      )

    )
  )
))

