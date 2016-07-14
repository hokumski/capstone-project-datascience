# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part 3 - Afterprocess NGrams

rm(list=ls())
gc()

#load('allUnigrams.RData')  #allUnigrams
load('allBigrams.RData')   #allBigrams
load('allTrigrams.RData')  #allTrigrams
load('allFourgrams.RData') #allFourgrams

#removing from frequency tables values with freq less than... see thresholds
#and saving to other RData files

#allUnigrams  <- allUnigrams[ allUnigrams$freq > 50,]
allBigrams   <- allBigrams[  allBigrams$freq > 2,]
allTrigrams  <- allTrigrams[ allTrigrams$freq > 2,]
allFourgrams <- allFourgrams[allFourgrams$freq > 2,]

#allUnigrams$terms  <- as.character(allUnigrams$terms)
allBigrams$terms   <- as.character(allBigrams$terms)
allTrigrams$terms  <- as.character(allTrigrams$terms)
allFourgrams$terms <- as.character(allFourgrams$terms)

#save(allUnigrams,  file='someUnigrams.RData')
save(allBigrams,   file='someBigrams.RData')
save(allTrigrams,  file='someTrigrams.RData')
save(allFourgrams, file='someFourgrams.RData')
