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


datas=pd.get_dummies(pd.read_csv("bank_train_data.csv",sep=","))
labels=pd.read_csv("bank_train_labels.csv")

X=datas.values
y=labels.values

d = X.shape[1]


#2) fonction qui calcule les predictions (0 ou 1) a partir des sorties du modele
def prediction(f):
    return f.round()

#3) Fonction qui calcule le taux d'erreur en comparant les y predits avec les y reels
def error_rate(y_pred,y):
    return ((y_pred != y).sum().float())/y_pred.size()[0]


#5) Separation aleatoire du dataset en ensemble d'apprentissage (70%) et de test (30%)
indices = np.random.permutation(X.shape[0])
training_idx, test_idx = indices[:int(X.shape[0]*0.7)], indices[int(X.shape[0]*0.7):]
X_train = X[training_idx,:]
y_train = y[training_idx]

X_test = X[test_idx,:]
y_test = y[test_idx]


#6) Creation du modele de regression logistique multivarie. Il etend la classe th.nn.Module de la librairie Pytorch
class Neural_network_binary_classif(th.nn.Module):

    # Constructeur qui initialise le modele
    def __init__(self,d,h1,h2,h3,h4):
        super(Neural_network_binary_classif, self).__init__()

        self.layer1 = th.nn.Linear(d, h1)
        self.layer2 = th.nn.Linear(h1, h2)
        self.layer3 = th.nn.Linear(h3, h4)
        self.layer4 = th.nn.Linear(h4, 1)

        self.layer1.reset_parameters()
        self.layer2.reset_parameters()
        self.layer3.reset_parameters()
        self.layer4.reset_parameters()

    # Implementation de la passe forward du modele
    def forward(self, x):
        phi1 = torch.sigmoid(self.layer1(x))
        phi2 = torch.sigmoid(self.layer2(phi1))
        phi3 = torch.sigmoid(self.layer3(phi2))
        return torch.sigmoid(self.layer4(phi3)).view(-1)


#7) creation d'un reseau de neurones avec deux couches cachees de taille 200 et 100
nnet = Neural_network_binary_classif(d,400,200,200,200)

#8) Specification du materiel utilise device = "cpu" pour du calcul CPU, device = "cuda:0" pour du calcul sur le device GPU "cuda:0".
device = "cpu"

#9) Chargement du modele sur le materiel choisi
nnet = nnet.to(device)


#10) Conversion des donnees en tenseurs Pytorch et envoi sur le device
X_train = th.from_numpy(X_train).float().to(device)
y_train = th.from_numpy(y_train).float().to(device)
y_train = y_train[:,0]

X_test = th.from_numpy(X_test).float().to(device)
y_test = th.from_numpy(y_test).float().to(device)
y_test = y_test[:,0]

#11) Taux d'apprentissage (learning rate)
eta = 0.15

#12) Definition du critere de Loss. Ici binary cross entropy pour un modele de classification avec deux classes
criterion = th.nn.BCELoss()

# optim.SGD Correspond a la descente de gradient standard.
# Il existe d'autres types d'optimizer dans la librairie Pytorch
# Le plus couramment utilise est optim.Adam
optimizer = optim.SGD(nnet.parameters(), lr=eta)

# tqdm permet d'avoir une barre de progression
nb_epochs = 100000
pbar = tqdm(range(nb_epochs))

for i in pbar:
    # Remise a zero des gradients
    optimizer.zero_grad()

    f_train = nnet(X_train)
    loss = criterion(f_train,y_train)
    # Calculs des gradients
    loss.backward()

    # Mise a jour des poids du modele avec l'optimiseur choisi et en fonction des gradients calcules
    optimizer.step()

    if (i % 1000 == 0):

        y_pred_train = prediction(f_train)

        error_train = error_rate(y_pred_train,y_train)
        loss = criterion(f_train,y_train)

        f_test = nnet(X_test)
        y_pred_test = prediction(f_test)

        error_test = error_rate(y_pred_test, y_test)

        pbar.set_postfix(iter=i, loss = loss.item(), error_train=error_train.item(), error_test=error_test.item())
