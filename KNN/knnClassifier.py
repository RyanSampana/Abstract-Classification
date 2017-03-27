from scipy.spatial import distance
import numpy as np
from operator import itemgetter
from collections import Counter
from collections import defaultdict

# euclidean distance 
def euc(a,b):
	return distance.euclidean(a,b)

class knnClassifier():
	def fit(self, X_train, y_train):
		self.X_train = X_train
		self.y_train = y_train

	# default value for k is 3
	def predict(self,X_test,k=3):
		predictions = []
		for row in X_test:
			if k == 1:
				label = self.closest(row,k)
				predictions.append(label)
			else:
				labels = self.closest(row,k)
				# equals to list(set(labels)) unique classes in labels
				classes = Counter(labels).keys() 
				# counts the elements' frequency
				counts = Counter(labels).values() 
				zipped = zip(classes,counts)
				zipped = sorted(zipped, key = lambda zipped: zipped[1], reverse = True)
				# extract the class with the most counts
				label = zipped[0][0] 
				predictions.append(label)
		return predictions

	def closest(self,row, k=3):
	    distances = list()
	    for index in range(len(self.X_train)):
	        dist = euc(row,self.X_train[index])
	        distances.append( (dist,index) )
	    
	    # this gets the distance of the tuple [(dist_1,index_1)]
	    getDistance = itemgetter(0)

	    # now we sort distances by the distance
	    distances = sorted(distances, key=getDistance )

	    # some handling depending on the k
	    if k == 1:
	        anIndex = distances[0][1]
	       	return self.y_train[anIndex]
	    else:
	    	# this gets the index of the tuple [(dist_1,index_1)]
	    	getIndex = itemgetter(1)
	    	labels = []
	    	listOfIndecies = list(map(getIndex, distances[0:k]))
	    	for index in listOfIndecies:
	    		labels.append(self.y_train[index])
	        return labels

"""
# Uncomment to test my classifier against scikit learn
# Time to test my model against scikit-learn
# I use the skearn iris dataset
from sklearn.datasets import load_iris
iris = load_iris()
X = iris.data
y = iris.target

# simple train test split
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.6, random_state=0)


# ML
from sklearn.neighbors import KNeighborsClassifier

clf = KNeighborsClassifier(n_neighbors=3)

clf.fit(X_train,y_train)

predictions = clf.predict(X_test)

from sklearn.metrics import accuracy_score
print"The accuracy of sklearn on iris data is:", (accuracy_score(y_test,predictions))*100,"%"

# my classifier's turn
my_classifier = knnClassifier()

my_classifier.fit(X_train, y_train)

predictions = my_classifier.predict(X_test)

print"The accuracy of my classifieron iris data is:", (accuracy_score(y_test,predictions))*100,"%"
"""