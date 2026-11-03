# Libraries
library(rmarkdown)
library(knitr)
library(bookdown)
library(RCurl)
library(data.table)
library(DT)
#library(iotc.base.common.data)
library(zen4R)

# Functions
source("98.render_iotc.R")

# Scripts
#source("./01.initialise.R")
source("./02.configure_RMD.R")
source("./03.generate_HTML.R")
source("./04.upload.R")
