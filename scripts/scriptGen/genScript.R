## loading libraries
library(rvest)
library(stringr)

## load url and page
URL <- "https://kotlinlang.org/docs/reference/faq.html"
fileName <- "./FAQs.txt";
page <- read_html(URL)

## get body node of html
bodyDiv <- page %>% html_nodes("body")

## get child node of html
childDiv <- html_children(bodyDiv[1])

## find all the div nodes whcich contains question mark
## those are possible FAQ candidates
## remove script, header, footer html tag content
childDiv <- childDiv[!html_name(childDiv) %in% c("script","header","footer")]
listDivs <- vector()
for(i in 1:length(childDiv)){
    divText <- childDiv[i] %>% html_text()
    if(grepl("[?]", divText)){
        listDivs <- append(listDivs, i)
    }
}
childDivF <- childDiv[listDivs]

## Loop until we have got to h1,p html tags  
## or we got multiple divs containing Questions
listDivs <- vector()
while(length(childDivF) == 1){
    childDivF <- html_children(childDivF[1])
    childDivF <- childDivF[!html_name(childDivF) %in% c("script","style")]
    listDivs <- vector()
    split <- TRUE;
    for(i in 1:length(childDivF)){
        if(html_name(childDivF[i]) %in% c("h1","h2","h3","h4","p","h5","h6")){
            split <- FALSE;
            break;
        }
        divText <- childDivF[i] %>% html_text()
        if(grepl("[?]", divText)){
            listDivs <- append(listDivs, i)
        }
    }
    if(split == FALSE){
        break
    }
    childDivF <- childDivF[listDivs]
}

## Save file content to a file
fileContent <- html_text(childDivF) %>% str_trim()

write(x = fileContent,file = fileName)

#####################
## Post processing ##
#####################

## Scraping multiple newlines or lines containg single character " "
lines <- readLines(fileName)
lines <- lines %>% str_trim()
lines <- lines[which(str_length(lines)>1)]

## scraping initial metadata
lineNo = integer();
for(i in 1:length(lines)){
    if(grepl("[?]", lines[i])){
        lineNo <- i;
        break()
    }
}
if(lineNo > 3){
    lines <- tail(lines, -(lineNo-1))
}

## Scraping continuous questions which are present in some websites
## div structure as a summery
i <- 1
while(i < length(lines)){
    if(grepl("[?]",lines[i])){
        if(grepl("[?]",lines[i+1])){
            if(grepl("[?]",lines[i+2])){
                q <- i;
                while(grepl("[?]",lines[i])){
                    i<- i+1;
                }
                if(i-q>3){
                    lines[q:(i-2)] <- "";
                }
            }
        }
    }
    i <- i+1;
}
lines <- lines %>% str_trim()
lines <- lines[which(str_length(lines)>1)]

## getting questions and answers in right format seperated by 2 newLines
insertElems = function(vect, pos, elems) {
    l = length(vect)
    j = 0
    for (i in 1:length(pos)){
        if (pos[i]==1)
            vect = c(elems[j+1], vect)
        else if (pos[i] == length(vect)+1)
            vect = c(vect, elems[j+1])
        else
            vect = c(vect[1:(pos[i]-1+j)], elems[j+1], vect[(pos[i]+j):(l+j)])
        j = j+1
    }
    return(vect)
}

i <- 2
while(i < length(lines)){
    if(grepl("[?]",lines[i])){
        lines <- insertElems(lines,i,"\n\n")
        i <- i+2
    }
    i <- i+1;
}

write(x = lines,file = fileName)