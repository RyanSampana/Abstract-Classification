# -*- coding: utf-8 -*-
"""
Created on Tue Oct 11 17:54:57 2016

@author: Clinton Lewis
"""

# Importing various libraries
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import naive_bayes, preprocessing
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import VotingClassifier
from sklearn.svm import LinearSVC

# Importing the csv files using the pandas library and then iterating through the data to store it in a list
df_in = pd.read_csv(r'datasets/train_in.csv',header=None, skiprows=1, usecols=[1])
X_train = [val for sublist in df_in.values.tolist() for val in sublist]
            
df_out = pd.read_csv(r'datasets/train_out.csv',header=None, skiprows=1, usecols=[1])
Y_train = [val for sublist in df_out.values.tolist() for val in sublist]
            
df_in = pd.read_csv(r'datasets/test_in.csv',header=None, skiprows=1, usecols=[1])
X_test = [val for sublist in df_in.values.tolist() for val in sublist]

# Map the output labels to integer values                        
le = preprocessing.LabelEncoder()
Y_train = le.fit_transform(Y_train)         

# Extract the Tfidf vector of features from the strings of abstracts
tfidf_vectorizer = TfidfVectorizer(max_features=100000, ngram_range=(1,2), stop_words='english', sublinear_tf=True) 
tfidf_vectorizer.fit(X_train + X_test)

# Transform the training and test data seperately into our feature vector
train_matrix = tfidf_vectorizer.transform(X_train) 
test_matrix = tfidf_vectorizer.transform(X_test) 

# Logistic Regression Classifier
logreg = LogisticRegression(C=1.8, solver='sag', multi_class='multinomial', verbose=10)

# Linear SVC and Naive Bayes are also used in a majority vote scheme to decide the output classes
eclf1 = VotingClassifier(estimators=[('lr', logreg),('linsvc', LinearSVC(C=0.7, verbose=10)), ('mnb', naive_bayes.MultinomialNB(alpha=0.0001))])

# fit the training data to the model
eclf1 = eclf1.fit(train_matrix, Y_train)

# predict the validation data
Y_pred = eclf1.predict(test_matrix)
# Map the test output back to the labels
Y_pred = le.inverse_transform(Y_pred)

# Store the output in a .csv file
my_df = pd.DataFrame(Y_pred)
my_df.columns=['Category']
my_df.to_csv(r'datasets/test_out.csv', index_label="id")
