import spacy
nlp = spacy.load("en_core_web_sm")
s1=nlp("get the names of employees")
s2=nlp("How many employees")

s1_verbs=" ".join([token.lemma_ for token in s1 if token.pos_ == "VERB"])
s1_adjs=" ".join([token.lemma_ for token in s1 if token.pos_ == "ADJ"])
s1_nouns=" ".join([token.lemma_ for token in s1 if token.pos_ == "NOUN"])

s2_verbs=" ".join([token.lemma_ for token in s2 if token.pos_ == "VERB"])
s2_adjs=" ".join([token.lemma_ for token in s2 if token.pos_ == "ADJ"])
s2_nouns=" ".join([token.lemma_ for token in s2 if token.pos_ == "NOUN"])

print(nlp(s1_adjs).similarity(nlp(s2_adjs)))