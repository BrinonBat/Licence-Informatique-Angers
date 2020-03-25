import numpy as np
import math
import pandas as pd

########################### initialisation #####################################

np.random.seed(0)

datas=pd.get_dummies(pd.read_csv("bank_train_data.csv",sep=","))
labels=pd.read_csv("bank_train_labels.csv")
X=datas.values
y=labels.values

# Separation aleatoire du dataset en ensemble d'apprentissage (70%) et de test (30%)
indices = np.random.permutation(X.shape[0])
training_idx, test_idx = indices[:int(X.shape[0]*0.7)], indices[int(X.shape[0]*0.7):]
X_train = X[training_idx,:]
y_train = y[training_idx]

X_test = X[test_idx,:]
y_test = y[test_idx]

########################## fonctions ###########################################

def euclidian_distance(v1,v2):
	distance=0

	for i in range(v1.shape[0]):
		distance += (v1[i] - v2[i])**2

	return math.sqrt(distance)

print(euclidian_distance(X_train[0,:],X_train[1,:]))

def neighbors(X_train, y_label, X_test, k):

    list_distances =  []

    for i in range(X_train.shape[0]):
        distance = euclidian_distance(X_train[i,:], X_test)
        list_distances.append(distance)

    df = pd.DataFrame()
    df["label"] = y_label
    df["distance"] = list_distances
    df = df.sort_values(by="distance")

    return df.iloc[:k,:]


k = 3
nearest_neighbors = neighbors(X_train, y_train, X_test, k)
print(nearest_neighbors)


def prediction(neighbors):
    mean = neighbors["label"].mean()

    if (mean > 0.5):
        return mean, 1
    else:
        return mean, 0


score, pred = prediction(nearest_neighbors)

print("pred " + str(pred) + ", score " + str(score))
