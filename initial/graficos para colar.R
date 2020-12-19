# mudança de partido
change <- speech_df %>% 
  group_by(Nome, Partido) %>% 
  count() 

list_change <- change %>% 
  group_by(Nome) %>% 
  count() %>% 
  filter(n > 1) %>% 
  pull(Nome)

final_change <- change %>% 
  subset(Nome %in% list_change) %>% 
  select(Nome, Partido)

# gráfico ana
scores_2 <- merge(theta_sen_wf, cemf_2019, by = 'party') 

# Senators
sen_df %>% 
  group_by(party_abbr) %>% 
  summarise(n = n()) %>% 
  rename(party = 'party_abbr') %>% 
  merge(scores_2, by = 'party') %>%  
  arrange(score) %>%    
  mutate(party = factor(party, levels = party)) %>% 
  ggplot(aes(x = theta_sen_wf, y = score, size = n, color = party)) + 
  geom_point() + 
  geom_label_repel(aes(label = party), size = 3) +
  scale_size_area(max_size = 16) +
  geom_abline(linetype = 'dotted') +
  xlim(-2.5, 3) +
  ylim(-2.5, 3) +
  ylab('Media Position') +
  xlab('Wordfish Position') +
  theme_minimal() +
  theme(legend.position = 'none') 

#Speeches
speech_df %>% 
  group_by(Partido) %>% 
  summarise(n = n()) %>% 
  rename(party = 'Partido') %>% 
  merge(scores_2, by = 'party') %>%  
  arrange(score) %>%    
  mutate(party = factor(party, levels = party)) %>% 
  ggplot(aes(x = theta_sen_wf, y = score, size = n, color = party)) + 
  geom_point() + 
  geom_label_repel(aes(label = party), size = 3) +
  scale_size_area(max_size = 16) +
  geom_abline(linetype = 'dotted') +
  xlim(-2.5, 3) +
  ylim(-2.5, 3) +
  ylab('Media Position') +
  xlab('Wordfish Position') +
  theme_minimal() +
  theme(legend.position = 'none') 



# proportion
merge(n_speeches, n_senators, by = 'Partido') %>% 
  select(Partido, Prop_Senators, Prop_Speeches) %>% 
  arrange(desc(Prop_Speeches)) %>% 
  mutate(diff = Prop_Speeches - Prop_Senators) %>% 
  group_by(Partido) %>% 
  # summarise(n = n()) %>%
  ggplot(aes(Partido, diff, label = diff)) +
  geom_col(fill = '#F8766D') +
  # geom_text(size = 2.5, nudge_y = -1) +
  geom_text(aes(y = diff + 2 * sign(diff), label = diff), 
            position = position_dodge(width = 0.9), 
            size = 2.5) +
  ylab('XXXXXXX') +
  xlab('Parties in Senate') +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90))
