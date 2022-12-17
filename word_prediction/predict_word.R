library(tm)


predict_new_word <- function(word){
  
  # pre-process entered sentence
  
  word <- tolower(word)                     # convert to lowercase
  
  # below is newly added code
  
  word <- gsub("#\\S+", "", word)           # remove twitter hashtags
  word <- gsub("\\brt\\b", "", word)        # remove rt
  word <- gsub("[^a-z ]", "", word)         # remove foreign characters
  
  word <- gsub("i'm", "i am", word)         # commonly used English language phrases
  word <- gsub("can't", "cannot", word)
  word <- gsub("won't", "will not", word)
  word <- gsub("ain't", "am not", word)
  word <- gsub("what's", "what is", word)
  word <- gsub("'d", " would", word)
  word <- gsub("'re", " are", word)
  word <- gsub("n't", " not", word)
  word <- gsub("'ll", " will", word)
  word <- gsub("'ve", " have", word)
  
  word <- gsub("i'm", "i am", word)
  word <- gsub("can't", "cannot", word)
  word <- gsub("won't", "will not", word)
  word <- gsub("ain't", "am not", word)
  word <- gsub("what's", "what is", word)
  
  word <- gsub("'d", " would", word)
  word <- gsub("'re", " are", word)
  word <- gsub("n't", " not", word)
  word <- gsub("'ll", " will", word)
  word <- gsub("'ve", " have", word)
  
  word <- gsub("\\bb\\b", "be", word)
  word <- gsub("\\bc\\b", "see", word)
  word <- gsub("\\br\\b", "are", word)
  word <- gsub("\\bu\\b", "you", word)
  word <- gsub("\\by\\b", "why", word)
  word <- gsub("\\bo\\b", "oh", word)
  
  word <- gsub("\\bb\\b", "be", word)       # replace commonly used single letters with full words
  word <- gsub("\\bc\\b", "see", word)
  word <- gsub("\\br\\b", "are", word)
  word <- gsub("\\bu\\b", "you", word)
  word <- gsub("\\by\\b", "why", word)
  word <- gsub("\\bo\\b", "oh", word)
  
  # new code ends here
  
  word <- removePunctuation(word, preserve_intra_word_spaces = TRUE)
  word <- removeNumbers(word)         # remove numbers
  
  word <- gsub("[^a-z ]", "", word)         # NEW CODE - remove foreign characters
  
  word <- stripWhitespace(word)
  word <- strsplit(word, " ")[[1]]
  
  len <- length(word)
  
  if(len == 1)
  {
    word <- as.character(tail(word, 1))
    next_word <- pred_bigram(word)
  }
  else if (len == 2)
  {
    word <- as.character(tail(word, 2))
    next_word <- pred_trigram(word)
  }
  else if (len == 3)
  {
    word <- as.character(tail(word, 3)) 
    next_word <- pred_fourgram(word)
  }
  else if (len == 4)
  {
    word <- as.character(tail(word, 4))
    next_word <- pred_fivegram(word)
  }
  else if (len >= 5)
  {
    word <- as.character(tail(word, 4))
    next_word <- pred_fivegram(word)
  }
  
  if(is.na(word) && word == "")
    return(NULL)
  else
    return(noquote(next_word))
}


pred_bigram <- function(word){
  
  unigram <- readRDS("unigram.RData")
  
  bigram <- readRDS("bigram.RData")
  
  bigram$Word <- as.character(bigram$Word)
  
  bigram_split <- strsplit(bigram$Word, split = " ")
  bigram <- transform(bigram, word1 = sapply(bigram_split, "[[", 1),
                      word2 = sapply(bigram_split, "[[", 2))
  
  bigram <- bigram[bigram$Freq > 1,]
  bigram <- data.frame(w1 = bigram$word1, w2 = bigram$word2,
                       freq = bigram$Freq, stringsAsFactors = FALSE)
  
  if(identical(character(0), as.character(head(bigram[bigram$w1 == word[1], 2], 1)))) 
  {
    next_word = as.character(head(unigram$Word[1], 1))
  }
  else
  {
    next_word = as.character(head(bigram[bigram$w1 == word[1], 2], 1))
  }
  
  
  return(next_word)
  
}


pred_trigram <- function(word){
  
  trigram <- readRDS("trigram.RData")
  
  trigram$Word <- as.character(trigram$Word)
  
  trigram_split <- strsplit(trigram$Word, split = " ")
  trigram <- transform(trigram, word1 = sapply(trigram_split, "[[", 1),
                       word2 = sapply(trigram_split, "[[", 2),
                       word3 = sapply(trigram_split, "[[", 3))
  
  trigram <- trigram[trigram$Freq > 1,]
  trigram <- data.frame(w1 = trigram$word1, w2 = trigram$word2, w3 = trigram$word3,
                        freq = trigram$Freq, stringsAsFactors = FALSE)
  
  if(identical(character(0), as.character(head(trigram[trigram$w1 == word[1] & trigram$w2 == word[2], 3], 1)))) {
    next_word = as.character(predict_new_word(word[2]))
  }
  else
  {
    next_word = as.character(head(trigram[trigram$w1 == word[1] & trigram$w2 == word[2], 3], 1))
  }
  
  return(next_word)
}

pred_fourgram <- function(word){
  
  fourgram <- readRDS("fourgram.RData")
  
  fourgram$Word <- as.character(fourgram$Word)
  
  fourgram_split <- strsplit(fourgram$Word, split = " ")
  fourgram <- transform(fourgram, word1 = sapply(fourgram_split, "[[", 1),
                        word2 = sapply(fourgram_split, "[[", 2),
                        word3 = sapply(fourgram_split, "[[", 3),
                        word4 = sapply(fourgram_split, "[[", 4))
  
  fourgram <- fourgram[fourgram$Freq > 1,]
  fourgram <- data.frame(w1 = fourgram$word1, w2 = fourgram$word2, w3 = fourgram$word3, w4 = fourgram$word4,
                         freq = fourgram$Freq, stringsAsFactors = FALSE)
  
  if(identical(character(0), as.character(head(fourgram[fourgram$w1 == word[1] &
                                                        fourgram$w2 == word[2] &
                                                        fourgram$w3 == word[3], 4], 1)))) {
    next_word = as.character(predict_new_word(paste(word[2], word[3], sep=" ")))
  }
  else
  {
    next_word = as.character(head(fourgram[fourgram$w1 == word[1] &
                                             fourgram$w2 == word[2] & 
                                             fourgram$w3 == word[3], 4], 1))
  }
  
  return(next_word)
}

pred_fivegram <- function(word){
  
  fivegram <- readRDS("fivegram.RData")
  
  fivegram$Word <- as.character(fivegram$Word)
  
  fivegram_split <- strsplit(fivegram$Word, split = " ")
  fivegram <- transform(fivegram, word1 = sapply(fivegram_split, "[[", 1),
                        word2 = sapply(fivegram_split, "[[", 2),
                        word3 = sapply(fivegram_split, "[[", 3),
                        word4 = sapply(fivegram_split, "[[", 4),
                        word5 = sapply(fivegram_split, "[[", 5))
  
  fivegram <- fivegram[fivegram$Freq > 1,]
  fivegram <- data.frame(w1 = fivegram$word1, w2 = fivegram$word2, w3 = fivegram$word3, w4 = fivegram$word4, w5 = fivegram$word5,
                         freq = fivegram$Freq, stringsAsFactors = FALSE)
  
  if(identical(character(0), as.character(head(fivegram[fivegram$w1 == word[1] &
                                                        fivegram$w2 == word[2] &
                                                        fivegram$w3 == word[3] &
                                                        fivegram$w4 == word[4], 5], 1)))) {
    next_word = as.character(predict_new_word(paste(word[2], word[3], word[4], sep=" ")))
  }
  else
  {
    next_word = as.character(head(fivegram[fivegram$w1 == word[1] &
                                             fivegram$w2 == word[2] &
                                             fivegram$w3 == word[3] &
                                             fivegram$w4 == word[4], 5], 1))
  }
  
  return(next_word)
}