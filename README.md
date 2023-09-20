# Shiny-App-Interface-Life-Expectancy-Prediction

Table of Contents
1. Introduction
2. Installation
3. Usage
4. Technologies
5. Features
6. Performance Metrics
7. Key Takeaways
8. Contributing

I. Introduction
- This project leverages Kaggle data to construct a linear regression model that predicts a country's life expectancy. The analysis culminates in a user-friendly Shiny App interface, allowing everyone to test the model's performance.

- Data for the model can be found here: https://www.kaggle.com/datasets/lashagoch/life-expectancy-who-updated

II. Installation
- To run this project, you need to have R, Rstudio, and Python installed.

III. Usage (for the shiny app)

- Open the Shiny App from the file app.R or via this deployed link: https://9c81h7-nam0tran.shinyapps.io/Life_Expectancy_Prediction/
- Enter the required features for prediction.
- Click "Predict" to get the life expectancy of the country.

IV. Technologies

R
Python
Shiny App
Linear Regression
Feature Engineering
Machine Learning

V. Features
Three different linear regression models constructed using various feature selection methods.
- Raw features only
- Features with outliers removed
- Stepwise selection applied and features outliers removed

VI. Performance Metrics

- Best Model: Model 3
- R-Squared: 0.983
- RMSE: 1.1849
- MAE: 0.9072

VII. Key Takeaways
Economic Development: Countries with higher GDP per capita and better economic status tend to have higher life expectancy.

Healthcare Investment: Reducing adult mortality rates and child deaths, as well as raising HIV awareness, can significantly impact life expectancy.

VIII. Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

