
import rpy2.robjects as robjects
from rpy2.robjects import pandas2ri
pandas2ri.activate()

import os
os.chdir(r"C:\Users\sugarkhuu\Documents\SCF")

readRDS = robjects.r['readRDS']
df = readRDS('scf 2019.rds')
# df = pandas2ri.rpy2py_dataframe(df)

df_rw = readRDS('scf 2019 rw.rds')



for i in range(len(df)):
    print(df[i].shape)
    
    
import matplotlib.pyplot as plt

plt.plot(df[0].income)


for i in range(len(df)):
    print(df[i].income.mean())

df_rw.sum()/1e6
b = df_rw/df_rw.sum()/1e6

for i in range(len(df)):
    print(df[i].wgt.sum())
    
        
df_median['INCOME'].plot(kind='bar')
df_median['NETWORTH'].plot(kind='bar')
