# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part ui.R


suppressWarnings(library(shiny))

shinyUI(fluidPage(

    titlePanel("Word Prediction with N-Grams"),
    h2(),
    sidebarLayout(
        
        sidebarPanel(
            textInput('userQuery', 'Say something?)',value = ''),
            sliderInput('thresholdPercents', label='Freq.threshold', min = 1, max=100,value = 90)
        ),
        
        mainPanel(
            
            tabsetPanel(type = "pills", 
                        tabPanel("Prediction", 
                                 h2(),
                                 htmlOutput('prediction'),
                                 htmlOutput('somedebug'),
                                 plotOutput('freqplot')
                        ), 
                        tabPanel("Readme", 
                                 h4('How it works?'),
                                 p('We have a lot of words and phrases: this is a our text corpus.'),
                                 p('Then we did processing and prepared 3 tables: most common phrases from our corpus, containing 2,3 and 4 words. This means that we have collected N-grams with frequency of these phrases.'),
                                 p('Idea how to predict next word: let\'s take last 3 words in the sentence and check if it is first 3 words of 4-gram?  No? Then, take last 2 words and check for 3-gram. If not, may be last word is a part of 2-gram?'),
                                 p('So, we found some N-grams starting with last words of your sentence and now have to choose one. You can set threshold level: if it equals to 100%, algorythm picks most frequent word, in other case - random word with frequency greater than X percent of most frequent.'),
                                 p('It works! Just try to write some words :)'),
                                 
                                 a(href='https://github.com/hokumski/capstone-project-datascience','"Word Prediction with N-Grams" on GitHub'),
                                 br(),
                                 a(href='mailto:ak@dived.me','ak@dived.me')
                                 
                                 
                        )
            )
            
        )
    )
))
