import pandas as pd                                               #library for data manipulation and analysis
import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "Times New Roman"
import numpy as np
import seaborn as sns
from datetime import datetime

def takeClosest(num,collection):
   return min(collection,key=lambda x:abs(x-num))

band = 600
grid_x = 71 
grid_y = 107

for c in  ['c1','c2','c3','c4','c5','c6']:
    spacing_dev2 = pd.read_csv('Output_files/spacing_dev2_ESGG_'+c+'.csv', 
    header=0,
    sep=','
    )
    
    number_of_flights = spacing_dev2['pair_ID'].max() + 1 #because the pairs are of consecutive aircraft and the last one does not have any other to pair with
    if number_of_flights < 2:
        SE_max = 0
        SE_min = 0
        SE_avg = 0
        SE_median = 0
        SE_std = 0
    
    else:
        seq_effort = spacing_dev2[['time_to_final','recalculated_dev','quantile05','quantile95']]
    
        seq_effort_fin = seq_effort.groupby(['time_to_final'])[['time_to_final','quantile05','quantile95']].head(1)
        #seq_effort_fin['quantile_width'] = seq_effort_fin['quantile95'] - seq_effort_fin['quantile05']
    
        if seq_effort_fin.loc[(seq_effort_fin['time_to_final'] == 30)]['quantile95'].empty == True:
            quantile_width_t0 = 0
        else:
            quantile_width_t0 = int(seq_effort_fin.loc[(seq_effort_fin['time_to_final'] == 30)]['quantile95'])
       
        #quantile_width_t0 = seq_effort_fin.loc[(seq_effort_fin['time_to_final'] == 30)]['quantile_width']
        seq_effort_fin['quantile_width_t0'] = int(quantile_width_t0)
        seq_effort_fin['seq_effort'] = seq_effort_fin['quantile95'] - seq_effort_fin['quantile_width_t0']
    
        seq_effort_fin = seq_effort_fin.sort_values(by=['time_to_final'])
    
        seq_effort_fin = seq_effort_fin.reset_index(drop=True)
        SE_max = abs(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (band + 100))]['seq_effort'].max())
        SE_min = seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (band + 100))]['seq_effort'].min()
        SE_avg = round(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (band + 100))]['seq_effort'].mean(),2)
        SE_median = round(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (band + 100))]['seq_effort'].median(),2)
        SE_std = round(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (band + 100))]['seq_effort'].std(),2)
    
    
    print(SE_max, SE_min, SE_avg, SE_median, SE_std)
    
    fig, ax = plt.subplots(1, 1)
    plot = seq_effort_fin.plot(x="time_to_final", y="seq_effort", kind="line",figsize=(8,6),ax=ax)
    plot.set_xlabel("Minimum time to final",fontsize=19)

    if c in ['c1', 'c4']:
        plot.set_ylabel("Sequencing effort",fontsize=19)

    plt.title("Cluster "+c[1:],fontsize=23)
    ax.set_xlim([0,600])                                                              
    ax.set_ylim([0,200])
    plt.savefig('Plots/sequencing_effort_ESGG_'+c+'.jpg',bbox_inches="tight")
    plt.show() 

