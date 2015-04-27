# read word doc and scan

rm(list=ls())

library(tm)

TEXTFILE <- file.choose()


shakespeare = readLines(TEXTFILE)
length(shakespeare)
head(shakespeare)

doc.vec <- VectorSource(shakespeare)
doc.corpus <- Corpus(doc.vec)



doc.corpus <- tm_map(doc.corpus, content_transformer(tolower))
doc.corpus <- tm_map(doc.corpus, content_transformer(removePunctuation)) # remove punctuation
doc.corpus <- tm_map(doc.corpus, content_transformer(removeNumbers))

doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))
inspect(doc.corpus)
length(doc.corpus)


library(SnowballC)
doc.corpus <- tm_map(doc.corpus, stemDocument)

# All of these transformations have resulted in a lot of whitespace, which is then removed.
doc.corpus <- tm_map(doc.corpus, stripWhitespace)

TDM <- TermDocumentMatrix(doc.corpus)
TDM
inspect(TDM[1:10,1:10])
