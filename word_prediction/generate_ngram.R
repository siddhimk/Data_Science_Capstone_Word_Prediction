# Load packages

library(tm)
library(stringi)
library(RWeka)

# Read 3 given input files

blogs <- readLines("./final/en_US/en_US.blogs.txt")
news <- readLines("./final/en_US/en_US.news.txt")
twitter <- readLines("./final/en_US/en_US.twitter.txt")

blogsLength <- length(blogs)
newsLength <- length(news)
twitterLength <- length(twitter)

# Sample all 3 files 

set.seed(1995)
sampleSize <- 0.01 

blogsSample <- sample(blogs, blogsLength * sampleSize)
newsSample <- sample(news, newsLength * sampleSize)
twitterSample <- sample(twitter, twitterLength * sampleSize)

# Combine the 3 sample into one in order to generate the corpus

sampleAll <- c(blogsSample, newsSample, twitterSample)

# Generate corpus

corpus <- VCorpus(VectorSource(sampleAll))

# Applying text-processing techniques to cleanup the corpus

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)

# Remove profane words

badwords <- readLines("list_bad_words.txt")
corpus <- tm_map(corpus, removeWords, badwords)

# Remove unwanted variables to free up memory

rm(blogs, news, twitter, blogsSample, newsSample, twitterSample)

# Generate unigram (1-gram)

unigram_token <- function(x) NGramTokenizer(x, Weka_control(min=1, max=1))
unigram_mat <- TermDocumentMatrix(corpus, control = list(tokenize = unigram_token))
unigram_mat <- removeSparseTerms(unigram_mat, 0.9999)

unigram_freq <- sort(rowSums(as.matrix(unigram_mat)), decreasing = TRUE)
unigram_freq.df <- data.frame(Word = names(unigram_freq), Freq = unigram_freq)

saveRDS(unigram_freq.df, file = "unigram.RData")

# Generate bigram (2-grams)

bigram_token <- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))
bigram_mat <- TermDocumentMatrix(corpus, control = list(tokenize = bigram_token))
bigram_mat <- removeSparseTerms(bigram_mat, 0.9999)

bigram_freq <- sort(rowSums(as.matrix(bigram_mat)), decreasing = TRUE)
bigram_freq.df <- data.frame(Word = names(bigram_freq), Freq = bigram_freq)

saveRDS(bigram_freq.df, file = "bigram.RData")

# Generate trigram (3-grams)

trigram_token <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))
trigram_mat <- TermDocumentMatrix(corpus, control = list(tokenize = trigram_token))
trigram_mat <- removeSparseTerms(trigram_mat, 0.9999)

trigram_freq <- sort(rowSums(as.matrix(trigram_mat)), decreasing = TRUE)
trigram_freq.df <- data.frame(Word = names(trigram_freq), Freq = trigram_freq)

saveRDS(trigram_freq.df, file = "trigram.RData")

# Generate fourgram (4-grams)

fourgram_token <- function(x) NGramTokenizer(x, Weka_control(min=4, max=4))
fourgram_mat <- TermDocumentMatrix(corpus, control = list(tokenize = fourgram_token))
fourgram_mat <- removeSparseTerms(fourgram_mat, 0.9999)

fourgram_freq <- sort(rowSums(as.matrix(fourgram_mat)), decreasing = TRUE)
fourgram_freq.df <- data.frame(Word = names(fourgram_freq), Freq = fourgram_freq)

saveRDS(fourgram_freq.df, file = "fourgram.RData")

# Generate fivegram (5-grams)

fivegram_token <- function(x) NGramTokenizer(x, Weka_control(min=5, max=5))
fivegram_mat <- TermDocumentMatrix(corpus, control = list(tokenize = fivegram_token))
fivegram_mat <- removeSparseTerms(fivegram_mat, 0.9999)

fivegram_freq <- sort(rowSums(as.matrix(fivegram_mat)), decreasing = TRUE)
fivegram_freq.df <- data.frame(Word = names(fivegram_freq), Freq = fivegram_freq)

saveRDS(fivegram_freq.df, file = "fivegram.RData")
