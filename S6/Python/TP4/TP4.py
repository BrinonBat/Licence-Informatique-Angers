import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

numExo=1#questions 1#
Data=pd.read_csv("digits.csv", sep = " ")
labels=np.array(Data.iloc[:,-1])
entrees=np.array(Data.iloc[:,0:-1])

print("\n"+str(numExo)+": \n"+str(labels))
print("\n"+str(entrees))

numExo+=1#question 2#
premChiffre=np.reshape(np.array(entrees[0,:]),(8,8))
plt.imshow(premChiffre,cmap='gray_r')
plt.show()

numExo+=1#question 3#
d=64#nombre de valeurs par entree
k=10#nombre de chiffres possibles

print("\n"+str(numExo)+": d="+str(d)+" k="+str(k))

numExo+=1#question 4#
weights=np.random.randn(d+1,k)/100

print("\n"+str(numExo)+": moyenne de "+str(round(weights.mean()))+" et ecart-type de "+str(round(weights.std(),2)))

numExo+=1#question 5#
nouvCol=np.ones((entrees.shape[0],1))
entrees=np.hstack((nouvCol,entrees))

print("\n"+str(numExo)+": \n"+str(entrees))

numExo+=1#question 6#
def output(entrees, weights):
	numerateur=np.exp(np.dot(entrees,weights))
	denominateur=numerateur.sum(axis=1)
	return (numerateur/(denominateur.reshape(denominateur.shape[0],1)))

print("\n"+str(numExo)+": \n"+str(output(entrees,weights)))

numExo+=1#question 7#
f=output(entrees,weights)
sommeParLigne=np.zeros(f.shape[0])
for i in range (f.shape[0]):
	sommeParLigne[i]+=f[i, :].sum()

print("\n"+str(numExo)+": "+str(sommeParLigne))

numExo+=1#question 8#
oneHotEncoding=np.zeros([labels.shape[0], 10])
for i in range (labels.shape[0]):
	oneHotEncoding[i,int(labels[i])]=1

print("\n"+str(numExo)+": \n"+str(oneHotEncoding))

numExo+=2#question 9-10#
def crossentropy(f,y_one_hot):
	return -(y_one_hot*np.log(f)).sum()/y_one_hot.shape[0]

print("\n9-10: "+str(crossentropy(f,oneHotEncoding)))

numExo+=1#question 11#
sortie=np.ones(f.shape)

print("\n"+str(numExo)+": "+str(crossentropy(sortie,oneHotEncoding)))

numExo+=1#question 12#
def prediction(f):
	return np.argmax(f,axis=1)

print("\n"+str(numExo)+": \n"+str(prediction(f)))

numExo+=1#question 13#
y_pred=prediction(f)

numExo+=1#question 14#
def error_rate(y_pred,labels):
	echecs=0
	for i in range(labels.shape[0]):
		if(labels[i]!=y_pred[i]):
			echecs+=1
	return echecs/labels.shape[0]

numExo+=1#question 15#
print("\n"+str(numExo)+": \n"+str(error_rate(y_pred,labels)))

numExo+=1#question 16#
def gradient(X,f,y_one_hot):
    #gradient=-(np.transpose(X,0,1)@(y_one_hot-f))/X.shape[0]
	gradient=1 # l'autre est en commentaire car ne compile pas
	return gradient

numExo+=1#question 17#
indices = np.random.permutation(entrees.shape[0])
training_idx, test_idx = indices[:int(entrees.shape[0]*0.7)], indices[int(entrees.shape[0]*0.7):]
X_train = entrees[training_idx,:]
y_train = labels[training_idx]
X_test = entrees[test_idx,:]
y_test = labels[test_idx]
print("\n"+str(numExo)+": ")
print(str(X_train))
print(str(y_train))
print(str(X_test))
print(str(y_test))

numExo+=1#question 18#
y_one_hot_train = oneHotEncoding[training_idx]

print("\n"+str(numExo)+": \n"+str(y_one_hot_train))

numExo+=1#question 19#
eta = 0.01
nb_epochs=10000
for i in range(nb_epochs):

    f_train = output(X_train,weights)

    weights = weights - eta*gradient(X_train,f_train,y_one_hot_train)

    if(i%100==0):
        y_pred_train = prediction(f_train)
        error_train = error_rate(y_pred_train,y_train)
        f_test = output(X_test, weights)
        y_pred_test = prediction(f_test)
        error_test = error_rate(y_pred_test, y_test)
        loss = crossentropy(f_train,y_one_hot_train)
        print("iter : " + str(i) + " loss " + str(loss) +  " error train : " + str(error_train)  + " error test : " + str(error_test))

# quenstion 20 : il est judicieux d'arêter l'algorithme quand les erreurs sont proches de 0
