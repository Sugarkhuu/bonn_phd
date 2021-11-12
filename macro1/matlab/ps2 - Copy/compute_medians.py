### Code to compute income and networth medians from SCF data


# =============================================================================
# IMPORT PACKAGES
# =============================================================================

import pandas as pd
import numpy as np
import os


# =============================================================================
# FUNCTIONS
# =============================================================================



def process_data(df,age0,age1):
    var_list = ['WGT','AGE','INCOME','NETWORTH'] # no need of other variables
    df = df[var_list].copy()
    
    df['impute_id'] = [1,2,3,4,5]*int(len(df)/5) # imputation ID in SCF data
    for i in range(5):
        print(df[df['impute_id'] == i+1]['WGT'].sum())
    
    df['WGT'] = df['WGT']*5 # Multiply weights by 5 to arrive at total US population for each imputation
    df = df[(df['AGE']>=age0-2)&(df['AGE']<=age1+2)] # will use -2,+2 ages for MA
    return df

def calc_median(df):
# calculate median for each imputation and average over the imputations
    
    df_median_tot = pd.DataFrame(columns=('AGE','INCOME','NETWORTH'))
    
    for i in range(5): 
        df_i = df[df['impute_id'] == i+1]
        age_list = list(set(df['AGE']))
        df_median = pd.DataFrame(columns=('AGE','INCOME','NETWORTH'))
    
        # median for each age
        for age in age_list:
            df_age = df_i[df_i['AGE'] == age]
            inc_median = median_(df_age['INCOME'].values,df_age['WGT'].values)
            nw_median  = median_(df_age['NETWORTH'].values,df_age['WGT'].values)
            df_median.loc[len(df_median)] = [age, inc_median, nw_median]
    
        # Moving average        
        df_median['INCOME'] = df_median['INCOME'].rolling(5, center=True).mean()
        df_median['NETWORTH'] = df_median['NETWORTH'].rolling(5, center=True).mean()
        df_median.dropna(inplace=True) # drop -2,+2 ages
        df_median_tot = df_median_tot.append(df_median, ignore_index = True)
    
    # average over 5 imputations
    df_median_tot = df_median_tot.groupby('AGE')['INCOME','NETWORTH'].mean()
    
    return df_median_tot

def median_(val, freq):
    # use median using the WGTs 
    # Credit: https://stackoverflow.com/questions/46086663/how-to-get-mean-and-standard-deviation-from-a-frequency-distribution-table-in-py/46090291
    ord = np.argsort(val)
    cdf = np.cumsum(freq[ord])
    return val[ord][np.searchsorted(cdf, cdf[-1] // 2)]

def avg_inc(df):
    # func to calculate average income between 25-64 years
    avg_inc = df[(df['AGE'] >= 25)&(df['AGE'] <= 64)]['INCOME'].mean()
    return avg_inc



# =============================================================================
# MAIN PART
# =============================================================================


# mydir    = r"C:\Users\sugarkhuu\Documents\phd\bonn\bonn_phd\macro1\matlab\ps2"
df_all   = pd.read_csv('SCFP2019.csv')
age0     = 25
T_years  = 60
age1     = age0 + T_years # age to die

df        = process_data(df_all,age0,age1)
df_median = calc_median(df)
df_median.reset_index(drop=False, inplace=True)
avg_income = avg_inc(df_median)


df_median['y_norm'] = df_median['INCOME']/avg_income            # normalize income to 1
df_median['a2y']    = df_median['NETWORTH']/df_median['INCOME'] # wealth to income

# save [AGE,INCOME,NETWORTH,y_norm,a2y]
df_median.to_csv('inc_wl_us_2019.csv',index=False)

















