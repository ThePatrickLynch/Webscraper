##################################
# Webscraper script
#
# This script will recurse through a website and create a cleaned text page for each webpage
# encountered
#
##################################


rm(list=ls())

library("RCurl")
library(XML)

###################
# just sort out my directory depending where I am working
###################

home <- T
laptop = F
dir="d:/data/dir" # default to work
if (home) dir="e:/data/dir/" 
if (laptop) dir <- "c:/data/dir"
  
####################
# set starting point
####################

baseurl <- "http://www.birmingham.ac.uk"
url <- paste(baseurl,"/index.aspx", sep="")

######
# function to read a webpage and write a file for each link on the page
######

writeurltext <- function(url, filename) {
  url
  html <- getURL(url, followlocation = TRUE)
  html <- htmlParse(html, useInternal = TRUE)
  links <- as.vector(xpathSApply(html, "//a/@href")) # as.vector gets rid of the href attribute

  # parse html
  txt <- xpathApply(html, "//body//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)]", xmlValue)
  
  #file <- paste(dir,as.character(file),'.txt',sep="")
  
  sink(filename)
  cat(paste(txt), collapse = " ")
  sink()
  return(links)
}

#################
# Starting by getting links from first page into a cleaned list
#################

html <- getURL(url, followlocation = TRUE) # reads the main page
html <- htmlParse(html, useInternal = TRUE) # parses the html
links <- as.vector(xpathSApply(html, "//a/@href")) # gets the links, as.vector gets rid of the href attribute cleaning

# start cleaning
links <- setdiff(links,'#') # setdiff is difference from links and '#' - so removes #'s

# make long urls for relative links
idx <- substr(links,1,1) == '/' # build an index list of those which are a subpage ie. start with /
links[idx] <- paste(baseurl,links[idx],sep="") # apply the concatenation to those items in the index

# lose those that aren't birmingham
idx <- substr(links,1,28) == 'http://www.birmingham.ac.uk/'
links <- links[idx]

# send each line to the function which reads and outputs
len=length(links)
for (i in 1:len) {
  filename <- paste(i,'.txt', sep="")
  filename <- paste(dir,filename,sep='')
  url <- paste(links[i], '/index.asp', sep="")
  test <- writeurltext(url, filename)
}

# now to work out how to navigate everything !!!

# then when I have all the files its time to analyse...

