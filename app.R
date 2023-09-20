# Load packages


library(shiny)
library(tidyverse)
library(shinythemes)

# 
# import the data


df = read.csv('filtered_data.csv', stringsAsFactors = T, check.names = F)


col_names <- colnames(df)

cleaned_column_names <- gsub("Region_", "", col_names)

colnames(df) <- cleaned_column_names

colnames(df)


# Train a linear regression model using all features

model <- lm(Life_expectancy ~ ., data = df)
# 
# UI for the app


ui <- fluidPage(
  theme = shinytheme("cerulean"),  # Apply a modern theme
  titlePanel(
    HTML("<h1>Life Expectancy Prediction</h1>")
  ),
  
  fluidRow(
    
    column(4,
           wellPanel(
             HTML("<h3>Health & Economy</h3>"),
             sliderInput("alcoholConsumption", "Alcohol Consumption:", min = 0, max = 100, value = 5),
             sliderInput("gdpPerCapita", "GDP per Capita:", min = 0, max = 100000, value = 10000),
             sliderInput("BMI", "BMI:", min = 18, max = 33, value = 20),
             sliderInput("Incidents_HIV", "Incidents HIV:", min = 0, max = 22, value = 10),
             sliderInput("underFiveDeaths", "Under Five Deaths:", min = 0, max = 1000, value = 50),
             sliderInput("Hepatitis_B", "Hepatitis B:", min = 0, max = 100, value = 90),
             selectInput("economyStatus", "Economy Status:", choices = c("Developed", "Developing"))
           )
    ),
    column(4,
           wellPanel(
             HTML("<h3>Demographic Info</h3>"),
             sliderInput("adultMortality", "Adult Mortality:", min = 0, max = 1000, value = 100),
             sliderInput("populationMln", "Population (Millions):", min = 0, max = 1500, value = 35),
             sliderInput("Schooling", "Number of Years in Education:", min = 0, max = 15, value = 8),
             sliderInput("Year", "Year:", min = 2000, max = 2015, value = 2010),
             selectInput("region", "Region:", choices = c("Central America and Caribbean", "South America", "European Union", "Oceania", "Middle East", "Asia"))),
             actionButton("predictBtn", "Predict Life Expectancy", icon = icon("rocket"))
    ),
    
    column(4,
           mainPanel(
             HTML("<h2>Results</h2>"),
             wellPanel(
               style = "background-color: #f7f7f7;",  # light gray background
               HTML("<h4>Life Expectancy Prediction</h4>"),
               textOutput("predictedLifeExpectancy")
             ),
             
             hr(),  # Horizontal line for separation
             
             wellPanel(
               style = "background-color: #f7f7f7;",  # light gray background
               HTML("<h4>Model Performance Metrics</h4>"),
               tags$ul(
                 tags$li(HTML("Root Mean Square Error (RMSE): <strong>1.1849</strong>")),
                 tags$li(HTML("Mean Absolute Error (MAE): <strong>0.9072</strong>"))
               )
             )
           )
    )
  )
)




# Server logic



# Define the server logic
server <- function(input, output) {
  
  # Load the trained model here
  # model <- load("path/to/your/model.RData")
  
  observeEvent(input$predictBtn, {
    
    # Debug: Print input values
    print(paste("Debug - Adult Mortality:", input$adultMortality))
    
    # Initialize region dummy variables to 0
      region_dummies <- data.frame(
      `Central America and Caribbean` = 0,
      `South America` = 0,
      `European Union` = 0,
      `Oceania` = 0,
      `Middle East` = 0,
      `Asia` = 0,
      check.names = FALSE
    )
    
    # Update the selected region to 1
    region_dummies[1, input$region] <- 1

    # For economy status
    economy_dummies <- ifelse(input$economyStatus == "Developed", 1, 0)
    
    new_data <- data.frame(
    Adult_mortality = as.numeric(input$adultMortality),
    Under_five_deaths = as.numeric(input$underFiveDeaths),
    Alcohol_consumption = as.numeric(input$alcoholConsumption),
    GDP_per_capita = as.numeric(input$gdpPerCapita),
    Population_mln = as.numeric(input$populationMln),
    BMI = as.numeric(input$BMI),
    Year = as.numeric(input$Year),
    Incidents_HIV = as.numeric(input$Incidents_HIV),
    Hepatitis_B = as.numeric(input$Hepatitis_B),
    Schooling = as.numeric(input$Schooling)
  )
  
  new_data <- cbind(new_data, region_dummies[1, ])
  
  new_data$Economy_status_Developed <- as.numeric(economy_dummies)
  
  original_col_order <- c("Adult_mortality", 
                        "Under_five_deaths", 
                        "Alcohol_consumption", 
                        "GDP_per_capita", 
                        "Population_mln", 
                        "Central America and Caribbean", 
                        "Economy_status_Developed",
                        "South America", 
                        "BMI", 
                        "Year", 
                        "Incidents_HIV", 
                        "European Union", 
                        "Oceania", 
                        "Hepatitis_B", 
                        "Middle East", 
                        "Asia", 
                        "Schooling")

  new_data <- new_data %>% 
    select(all_of(original_col_order))
    
    # Debug: Print new data
    print(paste("Debug - New Data:", new_data))
    
    # Prediction and Error Handling
    tryCatch({
      prediction <- predict(model, newdata = new_data)
      output$predictedLifeExpectancy <- renderText({
        paste("The predicted Life Expectancy is:", round(prediction, 2), "years")
      })
    }, error = function(e) {
      output$predictedLifeExpectancy <- renderText({
        paste("Prediction error: ", e)
      })
    })
  })
}





shinyApp(ui = ui, server = server)

