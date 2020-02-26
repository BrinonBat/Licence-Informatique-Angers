import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt


numExo=1#exercice 1#
Data= pd.read_csv("digits.csv", sep = " ")
labels=Data.iloc[:,-1]
entrees=Data.iloc[:,0:-2]

print("\n"+str(numExo)+": \n"+str(labels))
print("\n"+str(entrees))
