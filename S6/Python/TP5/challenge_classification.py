import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn import datasets
import torch as th
from tqdm import tqdm
import torch.optim as optim
from torch.nn import functional as F
import torch
import pandas as pd
import csv
########################### initialisation #####################################
datas=pd.get_dummies(pd.read_csv("bank_train_data.csv",sep=","))
labels=pd.read_csv("bank_train_labels.csv")
X=datas.values
y=labels.values
d = X.shape[1]

def prediction(f):
    return f.round()

def error_rate(y_pred,y):
    return ((y_pred != y).sum().float())/y_pred.size()[0]

# Separation aleatoire du dataset en ensemble d'apprentissage (70%) et de test (30%)
indices = np.random.permutation(X.shape[0])
training_idx, test_idx = indices[:int(X.shape[0]*0.7)], indices[int(X.shape[0]*0.7):]
X_train = X[training_idx,:]
y_train = y[training_idx]

X_test = X[test_idx,:]
y_test = y[test_idx]

######################## Creation du reseau de neurones. #######################
class Neural_network_binary_classif(th.nn.Module):

    def __init__(self,d,h1,h2,h3,h4,h5,h6):
        super(Neural_network_binary_classif, self).__init__()

        self.layer1 = th.nn.Linear(d, h1)
        self.layer2 = th.nn.Linear(h1, h2)
        self.layer3 = th.nn.Linear(h2, h3)
        self.layer4 = th.nn.Linear(h3, h4)
        self.layer5 = th.nn.Linear(h4, h5)
        self.layer6 = th.nn.Linear(h5, h6)
        self.layer7 = th.nn.Linear(h6, 1)

        self.layer1.reset_parameters()
        self.layer2.reset_parameters()
        self.layer3.reset_parameters()
        self.layer4.reset_parameters()
        self.layer5.reset_parameters()
        self.layer6.reset_parameters()
        self.layer7.reset_parameters()

    def forward(self, x):
        phi1 = torch.sigmoid(self.layer1(x))
        phi2 = torch.sigmoid(self.layer2(phi1))
        phi3 = torch.sigmoid(self.layer3(phi2))
        phi4 = torch.sigmoid(self.layer4(phi3))
        phi5 = torch.sigmoid(self.layer5(phi4))
        phi6 = torch.sigmoid(self.layer6(phi5))
        return torch.sigmoid(self.layer7(phi6)).view(-1)

nnet = Neural_network_binary_classif(d,100,5,2,3,12,20)

# Taux d'apprentissage (learning rate)
eta = 0.0010

###################### chargement des donnees ##################################

# pas besoin de creer de variable device permettant de choisir entre CPU et cuda, ma machine ne disposant pas de cuda le choix par defaut est "cpu"

# Chargement du modele sur le cpu
nnet = nnet.to("cpu")


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
optimizer = optim.AdamW(nnet.parameters(), lr=eta)
nb_epochs = 4000
maj_affichage = 10

pbar = tqdm(range(nb_epochs))
############################# execution ########################################
for i in pbar:
    # Remise a zero des gradients
    optimizer.zero_grad()

    f_train = nnet(X_train)
    loss = criterion(f_train,y_train)
    # Calculs des gradients & mise a jour des poids
    loss.backward()
    optimizer.step()

	# maj de l'affichage
    if (i % maj_affichage == 0):

        y_pred_train = prediction(f_train)

        error_train = error_rate(y_pred_train,y_train)
        loss = criterion(f_train,y_train)

        f_test = nnet(X_test)
        y_pred_test = prediction(f_test)
        error_test = error_rate(y_pred_test, y_test)

		#affichage
        pbar.set_postfix(iter=i, loss = loss.item(), error_train=error_train.item(), error_test=error_test.item())

################ ecriture de predictions dans un CSV ##########################

data_test=pd.get_dummies(pd.read_csv("bank_test_data.csv",sep=",")).values
data_final = th.from_numpy(data_test).float().to("cpu")
final_test=nnet(data_final)
pred=prediction(final_test)
pred=pred.detach().numpy()
print(pred)
with open("results_final.csv","w") as csvfile:
	file=csv.writer(csvfile,delimiter="\n")
	file.writerow(pred)
csvfile.close()
