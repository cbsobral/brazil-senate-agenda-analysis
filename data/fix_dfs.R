# Party changes -------
speech_df <- speech_df %>%  
  filter(DataPronunciamento >= 2019-01-01) %>% 
  rename(Partido = SiglaPartidoParlamentarNaData) %>% 
  mutate(Partido = str_replace(Partido, "PODE\\b", "PODEMOS"))
  mutate(Partido = str_replace(Partido, "PMDB", "MDB"))
  mutate(Partido = str_replace(Partido, "PPS", "CIDADANIA")) %>% 
  mutate(Partido = str_replace(Partido, "PR\\b", "PL")) %>% 
  mutate(Partido = str_replace(Partido, "PRP", "REPUBLICANOS"))

# Translate Gender ------
sen_df <- sen_df %>% 
  mutate(gender = str_replace(gender, "Feminino", "Female")) %>% 
  mutate(gender = str_replace(gender, "Masculino", "Male"))

save(sen_df, file = 'sen_df.Rda')

speech_df <- speech_df %>% 
  mutate(Gender = str_replace(Gender, "Feminino", "Female")) %>% 
  mutate(Gender = str_replace(Gender, "Masculino", "Male"))

save(speech_df, file = 'speech_df.Rda')
