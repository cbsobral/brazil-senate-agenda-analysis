library("congressbr")
library(tidyverse)
library(rvest)
library(httr)
library(jsonlite)
library(plyr)
library(readr)
library(glue)
library(quanteda)
library(readtext)
library(topicmodels)

senators <- sen_senator_list()

# 5996 ------------------
# Get DF

id = {5996}
endpoint <- glue("https://legis.senado.leg.br/dadosabertos/senador/{id}/discursos")

raw_json <- GET(endpoint, add_headers("Accept:application/json"))
parsed_json <- fromJSON(content(raw_json, "text"), flatten = TRUE)
str(parsed_json)
speeches_df <- parsed_json$DiscursosParlamentar$Parlamentar$Pronunciamentos$Pronunciamento

# Download Files
url_list <-
  as.list(as.data.frame(t(speeches_df['UrlTextoBinario'])))

names_list <- 
  as.list(as.data.frame(t(speeches_df['CodigoPronunciamento'])))  

names <- 
  tidyr::expand_grid(names_list) %>%
  glue_data("{names_list}.rtf")

safe_download <- safely(~ download.file(.x , .y, mode = "wb"))
walk2(url_list, names, safe_download)



# Add PDF Files to DF ---------------

pdf_path <- glue("C:\\Users\\carol\\Desktop\\Fall_2020\\TADA\\Senado\\{id}")

# List the TRF 
pdfs <- list.files(path = pdf_path, pattern = "*.pdf", full.names = TRUE) 

# Import the TRF into R


spill_texts <- readtext(pdfs,
                        docvarsfrom = "filenames", verbosity = TRUE)



#-----------------
# DFM

proj_dfm <- dfm(spill_corpus, groups = "docvar1", 
                remove = stopwords("portugues"),
                remove_numbers = TRUE, 
                remove_punct = TRUE,
                remove_symbols = TRUE,
                verbose  = FALSE, 
                stem = F,
                tolower = TRUE)


proj_dfm <- dfm_select(proj_dfm, min_nchar = 3)


## Including Plots


# LDA
lda_model <- LDA(proj_dfm, k = 6, control = list(seed = 123))



#probability of term being generated from topic

topics <- tidy(lda_model, matrix = "beta")

top_terms <- topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta) %>% 
  arrange(desc(beta))
top_terms


#graph result -- also in graph.R
top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()
top_terms




