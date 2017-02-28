library(rvest)
library(magrittr)
library(stringr)

## function scraps question and answer from yahoo
getQAFromYahoo <- function(URL){
    page <- read_html(URL)
    
    question <- page %>% 
        html_nodes("#ya-question-detail h1") %>% 
        html_text() %>% 
        str_replace_all("[\r\n]" , "") %>% 
        str_trim()
    
    answers <- page %>% 
        html_nodes("#ya-qn-answers .answer-detail .ya-q-full-text") %>% 
        html_text() %>% 
        str_replace_all("[\r\n]" , "") %>%
        str_trim()
    return(c(question, answers))
}

## function scraps question and answer from Answers.com
getQAFromAnswers <- function(URL){
    page <- read_html(URL)
    
    question <- page %>% 
        html_nodes(".question_title .title") %>% 
        html_text() %>% 
        str_replace_all("[\r\n]" , "") %>% 
        str_trim()
    
    answers <- page %>% 
        html_nodes(".answer_text") %>% 
        html_text() %>%
        str_replace_all("[\r\n]" , "") %>%
        str_trim()
    return(c(question, answers))
}

getQAFromURL <- function(URL){
    ## checks if url is yahoo
    if(grepl("answers.yahoo.com", URL)){
        return(getQAFromYahoo(URL))
    }
    ## checks if url is answers.com
    else if(grepl("answers.com", URL)){
        return(getQAFromAnswers(URL))
    }
    else if(URL == ""){
        return(c("Please Enter URL", ""))
    }
    else {
        return(c("invalid URL..! enter valid Answers | Yahoo URL only", ""))
    }
}