# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part 2 - Creating NGrams

# it takes about 1.75 hours to process all data
# single round of cycle-1 ~ 30 secs

rm(list=ls())
gc()

if (!file.exists('temp')) {
    dir.create('temp')
}

library(tm)
library(SnowballC)
library(RWeka)

#loading textForCorpus from p.1
load(file='textForCorpus.RData')

#tokenizeUnigram  <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
tokenizeBigram   <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tokenizeTrigram  <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
tokenizeFourgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

# processing of text corpus takes a lot of time and resources if corpus is large
# thanks forums for idea to split text to a big number of chunks and process it separately, then combine together

# it is ok to process in this way, it's like parallel processing

linesInChunk <- 1000
numberOfIterations <- as.integer( length(textForCorpus) / linesInChunk )

# cycle 1 : creating separate frequency tables and saving to temporary files
for (i in 0:numberOfIterations) {

    startPosition <- i*linesInChunk+1
    endPosition <- min( (i+1)*linesInChunk, length(textForCorpus) )
 
    linesToProcess <- textForCorpus[ startPosition:endPosition ] 
    
    partialCorpus <- VCorpus(VectorSource(linesToProcess))
    
    partialCorpus <- tm_map(partialCorpus, content_transformer(tolower))
    partialCorpus <- tm_map(partialCorpus, stripWhitespace)
    partialCorpus <- tm_map(partialCorpus, removeNumbers)
    partialCorpus <- tm_map(partialCorpus, removePunctuation)
    
    #tdmUnigrams  <- TermDocumentMatrix(partialCorpus, control = list(tokenize = tokenizeUnigram))
    tdmBigrams   <- TermDocumentMatrix(partialCorpus, control = list(tokenize = tokenizeBigram))
    tdmTrigrams  <- TermDocumentMatrix(partialCorpus, control = list(tokenize = tokenizeTrigram))
    tdmFourgrams <- TermDocumentMatrix(partialCorpus, control = list(tokenize = tokenizeFourgram))
        
    # sort as descending frequency
    
    #sortedFreqUnigrams  <- sort(rowSums(as.matrix(tdmUnigrams)),  decreasing=TRUE)
    sortedFreqBigrams   <- sort(rowSums(as.matrix(tdmBigrams)),   decreasing=TRUE)
    sortedFreqTrigrams  <- sort(rowSums(as.matrix(tdmTrigrams)),  decreasing=TRUE)
    sortedFreqFourgrams <- sort(rowSums(as.matrix(tdmFourgrams)), decreasing=TRUE)

    #dataUnigrams   <- data.frame(terms=names(sortedFreqUnigrams),  freq=sortedFreqUnigrams)
    dataBigrams    <- data.frame(terms=names(sortedFreqBigrams),   freq=sortedFreqBigrams)
    dataTrigrams   <- data.frame(terms=names(sortedFreqTrigrams),  freq=sortedFreqTrigrams)
    dataFourgrams  <- data.frame(terms=names(sortedFreqFourgrams), freq=sortedFreqFourgrams)
        
    #save(dataUnigrams,  file=paste('temp/1-',i,'.RData',sep=''))
    save(dataBigrams,   file=paste('temp/2-',i,'.RData',sep=''))
    save(dataTrigrams,  file=paste('temp/3-',i,'.RData',sep=''))
    save(dataFourgrams, file=paste('temp/4-',i,'.RData',sep=''))
    
    print(i)
}

#creating empty data frames for merging
#allUnigrams  <- dataUnigrams[0,]
allBigrams   <- dataBigrams[0,]
allTrigrams  <- dataTrigrams[0,]
allFourgrams <- dataFourgrams[0,]

mergeTwoData <- function (data1, data2){
    
    data1 <- data1[order(data1$terms),]
    data2 <- data2[order(data2$terms),]
    
    # how it works: if data2 contains terms from data1, freq1<-freq1+freq2
    # then, add to data1 unique terms from data2 
    
    data1$freq[data1$terms %in% data2$terms] <- data1$freq[data1$terms %in% data2$terms] + data2$freq[data2$terms %in% data1$terms]

    newdata <- rbind(data1, data2[!(data2$terms %in% data1$terms),])
    newdata
}


# cycle 2 : merging frequency tables from temporary files
for (i in 0:numberOfIterations) {
 
    #load(paste('temp/1-',i,'.RData',sep='')) #dataUnigrams
    load(paste('temp/2-',i,'.RData',sep='')) #dataBigrams
    load(paste('temp/3-',i,'.RData',sep='')) #dataTrigrams
    load(paste('temp/3-',i,'.RData',sep='')) #dataFourgrams
    
    #allUnigrams  <- mergeTwoData( allUnigrams,  dataUnigrams )    
    allBigrams   <- mergeTwoData( allBigrams,   dataBigrams )    
    allTrigrams  <- mergeTwoData( allTrigrams,  dataTrigrams )    
    allFourgrams <- mergeTwoData( allFourgrams, dataFourgrams )   
    
    print(i)
}

#save(allUnigrams,  file='allUnigrams.RData')
save(allBigrams,   file='allBigrams.RData')
save(allTrigrams,  file='allTrigrams.RData')
save(allFourgrams, file='allFourgrams.RData')
