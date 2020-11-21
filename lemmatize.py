import spacy
import pandas as pd
nlp = spacy.load('pt_core_news_sm')

# Import .csv
senado = pd.read_csv('C:/Users/carol/Desktop/sen.csv', encoding = "LATIN1")

def lemmatize(text):
    """Perform lemmatization and stopword removal in the clean text
       Returns lower case lemmatized texts
    """
    doc = nlp(text)
    lemma_list = ' '.join([str(tok.lemma_).lower() for tok in doc
                  if tok.is_alpha and tok.text.lower()])
    return lemma_list

# Apply function
senado['clean'] = senado['Pronunciamento'].apply(lemmatize)

# Select columns
senado1 = senado[["CodigoPronunciamento", "clean"]]

# Save .csv
senado1.to_csv('senado1.csv')
