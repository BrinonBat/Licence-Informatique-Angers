import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt


numExo=1#exercice 1#
Iris= pd.read_csv("iris.csv", sep = ",")

print("\n"+str(numExo)+": \n"+str(Iris))

numExo+=1#exercice 2#
print("\n"+str(numExo)+": \n"+str(Iris.head(10)))

numExo+=1#exercice 3#
Iris.plot.scatter(x="petal_length",y="petal_width",c="species")
plt.show()

numExo+=1#exercice 4#

def euclidian_distance(v1,v2):
    distance=0

    for i in range(v1.shape[0]):
        distance+=(v1[i]-v2[i])**2
    return math.sqrt(distance)

numExo+=1#exercice 5#
res=euclidian_distance(Iris.values[0],Iris.values[32])

print("\n"+str(numExo)+": \n"+str(res))

numExo+=1#exercice 6#

def neighbors(df,test,k):
	temp=df.copy()
	list_distances=[]
	for i in range(df.shape[0]):
		list_distances.append(euclidian_distance(df.values[i],test))

	temp["distance"]=list_distances
	temp=temp.sort_values(by="distance")

	return temp.iloc[:k,:]

print("\n"+str(numExo)+": \n"+str(neighbors(Iris,Iris.values[3],6)))


numExo+=1#exercice 7#
k = 3
x_test1 = np.array([3,0.6,0])
x_test2 = np.array([5,1.6,0])
x_test3 = np.array([1,0.3,0])
print("\n"+str(numExo)+": \n"+str(neighbors(Iris,x_test1,k))+"\n"+str(neighbors(Iris,x_test3,k))+"\n"+str(neighbors(Iris,x_test3,k)))


numExo+=1#exercice 8#
def prediction(voisinage):
	mean=voisinage["species"].mean()
	if (mean<0.5):
		return 0
	elif(mean<1.5):
		return 1
	else:
		return 2

print("\n"+str(numExo)+": \n"+str(prediction(neighbors(Iris,x_test1,k))))


numExo+=1#exercice 9#
sixperc=int(Iris.shape[0]*0.6)
train=Iris.sample(sixperc)
Iris=(Iris-train).dropna()
exo=Iris.sample(int(Iris.shape[0]*0.4))

print("\n"+str(numExo)+": \n"+str(train)+": \n"+str(exo))


#numExo+=1#exercice 10#
#wins=0
#loses=0
#for i in range(Iris.shape[0]):
#	if(prediction(neighbors(Iris,Iris.values[i],k))==Iris.iloc[i,3]):
#		wins+=1
#	else:
#		loses+=1
#taux_reu=wins/(wins+loses)
#
#print("\n"+str(numExo)+": "+str(taux_reu))
