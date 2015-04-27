rm(list=ls())

library("RCurl")
library(XML)

dir="d:/data/dir/"
baseurl <- "http://www.birmingham.ac.uk"

url <- paste(baseurl,"/index.aspx", sep="")
file <- 1


######
# function to read a webpage and write a file for each link on the page
######

writeurltext <- function(url, filename) {
  
  html <- getURL(url, followlocation = TRUE)
  html <- htmlParse(html, useInternal = TRUE)
  links <- as.vector(xpathSApply(html, "//a/@href")) # as.vector gets rid of the href attribute
  
  # parse html
  txt <- xpathApply(html, "//body//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)]", xmlValue)
  
  #file <- paste(dir,as.character(file),'.txt',sep="")
  file
  
  sink(file)
  cat(paste(txt), collapse = " ")
  sink()
  return(links)
}

# Get links from base page
html <- getURL(url, followlocation = TRUE) # reads the main page
html <- htmlParse(html, useInternal = TRUE) # parses the html
links <- as.vector(xpathSApply(html, "//a/@href")) # gets the links, as.vector gets rid of the href attribute


idx <- substr(links,1,1) == '#'  # index those beginning with # - internal links
links2 <- setdiff(links,idx) # setdiff is set union this gets those items not in idx

idx
links
links2

idx <- substr(links,1,1) == '/' # build an index list of those which are a subpage, I need the full url
links[idx] <- paste(baseurl,links[idx],sep="") # apply the concatenation to those items in the index


#idx <- substr(links,1,27) == 'http://www.birmingham.ac.uk'
#links2 <- intersect(links,idx)

links

links2

test <- writeurltext(links[1])

