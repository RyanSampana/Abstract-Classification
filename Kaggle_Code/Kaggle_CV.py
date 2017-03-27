# -*- coding: utf-8 -*-
"""
Created on Tue Oct 11 17:04:37 2016

@author: ttw
"""

# Importing various libraries
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import naive_bayes, preprocessing
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import VotingClassifier
from sklearn.svm import LinearSVC
from sklearn.metrics import confusion_matrix, classification_report 

# Importing the csv files using the pandas library and then iterating through the data to store it in a list
df_in = pd.read_csv(r'datasets/train_in.csv',header=None, skiprows=1, usecols=[1])
data_in = [val for sublist in df_in.values.tolist() for val in sublist]
            
df_out = pd.read_csv(r'datasets/train_out.csv',header=None, skiprows=1, usecols=[1])
data_out = [val for sublist in df_out.values.tolist() for val in sublist]

# Map the output labels to integer values            
le = preprocessing.LabelEncoder()
data_out = le.fit_transform(data_out)            

# Extract the Tfidf vector of features from the strings of abstracts
tfidf_vectorizer = TfidfVectorizer(max_features=110000, ngram_range=(1,2), stop_words='english', sublinear_tf=True) 
tfidf_vectorizer.fit(data_in)

# Split our input data into training and validation sets
X_train, X_test, y_train, y_test = train_test_split(data_in, data_out, random_state=2)  
train_matrix = tfidf_vectorizer.transform(X_train) 
test_matrix = tfidf_vectorizer.transform(X_test) 

# Logistic Regression Classifier
logreg = LogisticRegression(C=1.8, solver='sag', multi_class='multinomial', verbose=10, random_state=67)

# Linear SVC and Naive Bayes are also used in a majority vote scheme to decide the output classes
eclf = VotingClassifier(estimators=[('lr', logreg),('linsvc', LinearSVC(C=0.7, verbose=10, random_state=23)), ('mnb', naive_bayes.MultinomialNB(alpha=0.0001))])

# Searching through a grid of parameters for the best estimator
eclf1 = GridSearchCV(estimator=eclf, param_grid={'lr__C':[1.7,1.8,1.9], 'linsvc__C' :[0.6,0.7,0.8], 'mnb__alpha' :[0.1,0.01,0.0001] }, cv=5)

# fit the training data to the model
eclf1 = eclf1.fit(train_matrix, y_train)

# predict the validation data
y_pred = eclf1.predict(test_matrix)

# print the different metrics for our validated data
print eclf1.score(test_matrix, y_test)
print confusion_matrix(y_test, y_pred)
print classification_report(y_test, y_pred)