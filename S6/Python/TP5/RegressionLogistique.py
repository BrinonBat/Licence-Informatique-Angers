import numpy as np
from sklearn import datasets
import torch as th
from tqdm import tqdm
import torch.optim as optim
import torch
import pandas as pd
import csv
########################### initialisation #####################################

np.random.seed(0)

datas=pd.get_dummies(pd.read_csv("bank_train_data.csv",sep=","))
labels=pd.read_csv("bank_train_labels.csv")
X=datas.values
y=labels.values
d = X.shape[1]
N = X.shape[0]

#Ajout d'une premiere colonne de "1" a la matrice X des entrees
X = np.hstack((np.ones((N,1)),X))

def prediction(f):
    return f.round()

def error_rate(y_pred,y):
    return ((y_pred != y).sum().float())/y_pred.size()[0]

def output(X,weights):
    return torch.sigmoid(torch.mm(X,weights)).view(-1)
#	return torch.sigmoid(torch.from_numpy(np.dot(X,weights.detach().numpy())))

def binary_cross_entropy(f,y):
    return - (y*th.log(f)+ (1-y)*th.log(1-f)).mean()


# Separation aleatoire du dataset en ensemble d'apprentissage (70%) et de test (30%)
indices = np.random.permutation(X.shape[0])
training_idx, test_idx = indices[:int(X.shape[0]*0.7)], indices[int(X.shape[0]*0.7):]
X_train = X[training_idx,:]
y_train = y[training_idx]

X_test = X[test_idx,:]
y_test = y[test_idx]

#vecteur de poids
weights = th.randn(d+1,1)
weights = weights.to("cpu")
weights.requires_grad_(True)

###################### chargement des donnees ##################################

# pas besoin de creer de variable device permettant de choisir entre CPU et cuda, ma machine ne disposant pas de cuda le choix par defaut est "cpu"

# Conversion des donnees en tenseurs Pytorch et envoi sur le cpu
X_train = th.from_numpy(X_train).float().to("cpu")
y_train = th.from_numpy(y_train).float().to("cpu")
y_train = y_train[:,0]

X_test = th.from_numpy(X_test).float().to("cpu")
y_test = th.from_numpy(y_test).float().to("cpu")
y_test = y_test[:,0]

# Definition du critere de Loss. Ici binary cross entropy pour un modele de classification avec deux classes
criterion = th.nn.BCELoss()

########################## Parametrage (optimizer, epochs...)###################

# Taux d'apprentissage (learning rate)
eta = 0.025

optimizer = optim.AdamW([weights], lr=eta)
nb_epochs = 4000
maj_affichage = 10

pbar = tqdm(range(nb_epochs))
weights.data.normal_()
############################# execution ########################################
for i in pbar:
    # Remise a zero des gradients a chaque epoch
    optimizer.zero_grad()

    f_train = output(X_train,weights)

    #Calcul de la loss
    loss = criterion(f_train,y_train)

    # Calculs des gradients
    loss.backward()

    # Mise a jour des parametres du modele suivant l'algorithme d'optimisation retenu
    optimizer.step()

    if(i%100==0):

        y_pred_train = prediction(f_train)
        error_train = error_rate(y_pred_train,y_train)
        loss = criterion(f_train,y_train)

        f_test = output(X_test, weights)
        y_pred_test = prediction(f_test)

        error_test = error_rate(y_pred_test, y_test)

		#affichage
        pbar.set_postfix(iter=i, loss = loss.item(), error_train=error_train.item(), error_test=error_test.item())

################ ecriture de predictions dans un CSV ##########################

data_test=pd.get_dummies(pd.read_csv("bank_test_data.csv",sep=",")).values
data_final = th.from_numpy(data_test).float().to("cpu")
final_test=output(data_final,weights[:-1,:])
pred=prediction(final_test)
pred=pred.detach().numpy()
print(pred)
with open("results_final.csv","w") as csvfile:
	file=csv.writer(csvfile,delimiter="\n")
	file.writerow(pred)
csvfile.close()
