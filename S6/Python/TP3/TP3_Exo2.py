import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt



numExo=1#exercice 1#
Diabetes= pd.read_csv("diabetes.csv", sep = ",")

print("\n"+str(numExo)+": \n"+str(Diabetes))

numExo+=1#exercice 2#
print("\n"+str(numExo)+": \n"+str(Diabetes.head(10)))

numExo+=1#exercice 3#
#aucune indication de ce qui doit etre realise durant l'exo

numExo+=1#exercice 4#

def euclidian_distance(v1,v2):
    distance=0

    for i in range(v1.shape[0]):
        distance+=(v1[i]-v2[i])**2
    return math.sqrt(distance)

numExo+=1#exercice 5#
res=euclidian_distance(Diabetes.values[0],Diabetes.values[32])

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

print("\n"+str(numExo)+": \n"+str(neighbors(Diabetes,Diabetes.values[3],6)))


numExo+=1#exercice 7#

def prediction(voisinage):
	mean=voisinage["Outcome"].mean()
	if (mean<0.5):
		return 0
	else:
		return 1


numExo+=1#exercice 8#
sixperc=int(Diabetes.shape[0]*0.6)
train=Diabetes.sample(sixperc)
Diabetes=(Diabetes-train).dropna()
exo=Diabetes.sample(int(Diabetes.shape[0]*0.4))

print("\n"+str(numExo)+": \n"+str(train)+": \n"+str(exo))


#numExo+=1#exercice 9#
#wins=0
#loses=0
#for i in range(Diabetes.shape[0]):
#	if(prediction(neighbors(Diabetes,Diabetes.values[i],k),Diabetes.values[i])==Diabetes.iloc[i,3]):
#		wins+=1
#	else:
#		loses+=1
#taux_reu=wins/(wins+loses)
#
#print("\n"+str(numExo)+": "+str(taux_reu))
