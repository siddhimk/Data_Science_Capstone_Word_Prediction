library(shiny)

shinyUI(
  fluidPage(
    
    # Application title
    titlePanel(h1(strong("Word Predictor App"), align="center")),
    
    sidebarLayout(
      sidebarPanel(
        h3("Welcome to the Word Predictor!"),
        p("This shiny app is created for some fun with Word Prediction. The app could guess the 
          most likely occuring word following an entered partial sentence."),
        
        hr(),
        
        h3("How to Use:"),
        HTML(
          "<ul>
                <li>Start writing partial sentence in the text box on the top.</li>
                <li>The input word is passed to the server where the prediction algorithm 
              gets executed.</li>
                <li>The basic word prediction is done using N-Gram Backoff Model.</li>
                <li>The predicted new word will be returned to the UI page and will be displayed in the same section.</li>
                </ul>"
        ),
        p("For additional information please refer to tab 'Additional Documentation'.")
      ),
      
      mainPanel(
        
        tabsetPanel(type="tabs",
                    tabPanel("Word Prediction",
                             h3(strong("Type partial sentence in English here:")),
                             textInput("inputText", label = "", value = ""),
                             
                             fluidRow(
                               h3(strong("Next word:")),
                               verbatimTextOutput("predWord")
                             )
                    ),
                    
                    tabPanel("Additional Documentation",
                             h3("Summary"),
                             p("This project is created for Final Project Submission of Data Science Capstone Course on Coursera. 
                                The goal of this project is to build a predictive model for text processing and present it using Shiny app. 
                                The shiny app has the User Interface that takes a phrase or a partial sentence as an input and outputs a 
                                prediction of the next word."),
                             h3("Data Pre-Processing"),
                             p("The data for word prediction model project is given by SwiftKey. The training data includes three types of datasets Blogs, 
                                News and Twitter. First step is data sampling, the appropriate sample (one percent) of data from all three files is 
                                selected. This sampling is done to handle the performance issues that could result due to the big size of the input 
                                files. The corpus is then created using the combined sample of all these datasets. The regular text pre-processing 
                                techniques are applied such as lower case conversion, removing numbers, removing punctuation marks, removing 
                                extra white spaces."),
                             p("The general text modeling practice includes stopwards removal. In this use case of word prediction, I am keeping the 
                                stopwords as this app can be used for predicting words used in common English language sentences. I have built the algorithm 
                                using N-grams created by removing stopwords, but then the alogrithm fails to predict the commonly used associated words."),
                             p("Next step is for the additional cleanup for removing the bad or profane words from 
                                the sample data or the training data. I have downloaded the list of bad words from google for performing this 
                                cleanup step on the data."),
                             p("The bigram (2-gram), trigram (3-gram), fourgram (4-gram) and fivegram (5-gram) sets 
                                are generated and sorted by frequency. These N-gram datasets are saved so that they can be later used for 
                                creating a predictive model"),
                             h3("Word Prediction Algorithm"),
                             p("The word prediction algorithm is using the Supid Back-Off apporach along with N-Grams created in the data pre-processing stage."),
                             p("If the number of words entered is 1, the bigram created during data pre-processing step is used to predict the most likely word 
                                with an entered input word. If the match is not found in the bigram dataset then the algorithm will return the most likely used 
                                unigram word using the unigram dataset. If the number of words entered is 1, the bigram created during data pre-processing step 
                                is used to predict the most likely word with an entered input word. If the match is not found in the bigram dataset then the 
                                algorithm will return the most likely used unigram word using the unigram dataset."),
                             p("If the number of words entered are 2, the trigram is used to predict the next likely word depending on the combination of given two words. 
                                If no match is found then the same prediction function is called using the secone word of the entered sentence which ultimately uses the 
                                trigram to predict the next best match."), 
                             p("If the number of words entered are 3, the fourgram is used to predict the most likely word depending on the 
                                combination of first three words. If no match is found then the same prediction function is called using last two words of the 
                                entered sentence which ultimately uses the bigram to predict the next best match."),
                             p("If the number of words entered are 4, use the fivegram created during data pre-processing step to predict the next likely word. 
                                If no match is found then the same prediction function is called using last three words of the entered sentence which ultimately 
                                uses the trigram to predict the next best match."),
                             p("If the number of words entered are more than 5, the fivgrams dataset will be used and the word prediction will happen based on the 
                                first four words. This is done to avoid the performance issues and delays with higher N-gram datasets. If no matches are found then 
                                word with the highest frequency from the unigram dataset is returned to the user as this is the most likely used single word.")
                    )
        )
      )
    )
  ))
