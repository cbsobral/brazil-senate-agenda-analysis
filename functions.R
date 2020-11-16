# append senator speeches to main df
append_df <- function(sen, speeches_df){
  # rename and filter columns
  sen <- sen %>% 
    rename(
      CodigoPronunciamento = docvar1,
      Pronunciamento = text) %>% 
    select(CodigoPronunciamento, Pronunciamento)
  
  # merge with main df and delete empty rows
  sen_df <- merge(sen, speeches_df, by = "CodigoPronunciamento") %>% 
        na_if("") %>%
        na.omit
  
     return(sen_df)
}
