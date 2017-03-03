library(stringr)
library(rvest)

URL <- "http://www.etihadguest.com/en/faqs/"
page <- read_html(URL)

## scraping questions
questions <- page %>% 
    html_nodes("dt") %>% 
    html_text() %>% 
    str_replace_all("[\r\n]" , "") %>% 
    str_replace_all('[0-9]+.\t*',"") %>%
    str_trim()

## scraping answers
answers <- page %>% 
    html_nodes("dd") %>% 
    html_text() %>% 
    str_replace_all("[\r\n]" , "") %>% 
    str_trim()

## Writing to file QA.txt
i <- 1;
while(i<=length(questions)){
    write(x = "Q. ", file = "QA.txt", append = T,ncolumns = 1)
    write(x = questions[i], file = "QA.txt", append = T,ncolumns = 1)
    write(x = "A. ", file = "QA.txt", append = T,ncolumns = 1)
    write(x = answers[i], file = "QA.txt", append = T,ncolumns = 1)
    write(x = "\r\n", file = "QA.txt", append = T,ncolumns = 1)
    i <- i+1;
}