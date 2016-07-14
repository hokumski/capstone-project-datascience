# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part of server.R - functions


cleanQuery <- function(string)
{
    
    string <- iconv(string, "latin1", "ASCII", sub=" ");
    string <- gsub("[^[:alpha:][:space:][:punct:]]", "", string);
    
    # we use same routine like in 'createNGrams' to ensure same method of text preparation
    corpus <- VCorpus(VectorSource(string))
    
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, removePunctuation)
    
    # take it back from corpus
    string <- as.character(corpus[[1]])
    string <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", string)
    
    if (is.na(string)) {
        string <- ''
    }
    
    string
}


starts_with <- function(vars, match, ignore.case = TRUE) {
    if (ignore.case) match <- tolower(match)
    n <- nchar(match)
    
    if (ignore.case) vars <- tolower(vars)
    substr(vars, 1, n) == match
}

# if threshold=0, it takes random
getWord<-function(ngrams, freqThreshold=1) {
    
    result<-''
    
    if (freqThreshold>1 | freqThreshold<0) {
        freqThreshold<-1
    }
    
    if (nrow(ngrams)>0) {
        
        # take random, if there are some with equal top frequency
        # if we use freqThreshold, take random from terms with frequency > x*max
        # this means, if threshold=0.75, take random one from top quarter
            
        maxFrequency <- max(ngrams$freq)
        topResults <- ngrams[ ngrams$freq>=as.integer(maxFrequency*freqThreshold), ] 
            
        result<-sample(topResults$terms,1)
    }

    result<-word(result,-1)
}

# todo: return as list
predictNextWord <- function(string, freqThreshold=1)
{
    string <- cleanQuery(string)
    
    stringVector <- unlist(strsplit(string, split=' '));
    queryLength <- length(stringVector);
    
    prediction <- ''
    
    usedN <- 0
    usedForChoice<-data.frame()
    
    # stage 1. looking for four-grams
    if (queryLength>=3)
    {
        # will search for 4-grams starting with this 3 words:
        last3Words <- paste(paste(stringVector[(queryLength-2):queryLength], collapse=' '),' ', sep='');
        
        searchIndex <- starts_with(allFourgrams$terms, last3Words)
        foundFourgrams<- allFourgrams[searchIndex, ];
        prediction<-getWord(foundFourgrams, freqThreshold)
        
        usedN <- 4
        usedForChoice<-foundFourgrams
        
    }
    
    # stage 2. looking for tri-grams
    if (queryLength>= 2 & prediction=='')
    {
        
        last2Words <- paste(paste(stringVector[(queryLength-1):queryLength], collapse=' '),' ', sep='');
        
        searchIndex <- starts_with(allTrigrams$terms, last2Words)
        foundTrigrams<- allTrigrams[searchIndex, ];
        prediction<-getWord(foundTrigrams, freqThreshold)
        
        usedN <- 3
        usedForChoice<-foundTrigrams
    }
    
    # stage 3. looking for bi-grams
    if (queryLength>= 1 & prediction=='')
    {
        lastWord <- paste(stringVector[queryLength],' ',sep='')
        
        searchIndex <- starts_with(allBigrams$terms, lastWord)
        
        foundBigrams<- allBigrams[searchIndex, ];
        prediction<-getWord(foundBigrams, freqThreshold)
        
        usedN <- 2
        usedForChoice<-foundBigrams
    }
       
    list(prediction=prediction, depth=usedN, ngram=usedForChoice)
}
