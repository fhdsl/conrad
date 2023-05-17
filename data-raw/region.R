## code to prepare `region` dataset goes here
library(dplyr)
library(rvest)
library(xml2)

# Speech service supported regions
url <- paste0("https://learn.microsoft.com/en-us/azure/",
              "cognitive-services/Speech-Service/regions")
# Read html
url_page <- xml2::read_html(url)
# Parse tables into tibbles
url_table <- rvest::html_table(url_page)
# First table shows regions supported for text to speech
region <- url_table[[1]]$`Region identifier`
# Remove numbers at least two spaces to the right of region
region <- gsub("\\s.+", "", region)

usethis::use_data(region, overwrite = TRUE)
