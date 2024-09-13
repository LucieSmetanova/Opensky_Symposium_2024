# -*- coding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt


flights1 = pd.read_csv('Output_files\Grid_frame_ESGG_c3.csv', 
header=0,
sep=','
)

min_time = pd.read_csv('Output_files\min_time_ESGG_c3.csv', 
header=0,
sep=','
)

Grid_frame = flights1
Grid_frame['min_time_to_final'] = [min_time.loc[((min_time['X'] == Grid_frame['X'][i]) & (min_time['Y'] == Grid_frame['Y'][i]))]['min_time'].values[0] for i in range(len(Grid_frame))]
Grid_frame['time_in_final'] = Grid_frame.groupby(['flightID'])['timestamp'].transform('max')

add_time = Grid_frame.groupby(['flightID'])[['flightID','timestamp','X','Y','min_time_to_final','time_in_final']].head(1)
add_time['time_to_final'] = add_time['time_in_final'] - add_time['timestamp']
add_time['additional_time'] = add_time['time_to_final'] - add_time['min_time_to_final']
max_add_time = add_time['additional_time'].max()
min_add_time = add_time['additional_time'].min()
avg_add_time = add_time['additional_time'].mean()
median_add_time = add_time['additional_time'].median()
s2_add_time = add_time['additional_time'].std()

sequence_pressure = pd.read_csv('Output_files\sequence_pressure_ESGG_c3.csv', 
header=0,
sep=','
)


seq_effort = sequence_pressure[['time_to_final','pressure','quantile05','quantile95']]

seq_effort_fin = seq_effort.groupby(['time_to_final'])[['time_to_final','quantile05','quantile95']].head(1)
seq_effort_fin['quantile_width'] = seq_effort_fin['quantile95'] - seq_effort_fin['quantile05']

if seq_effort_fin.loc[(seq_effort_fin['time_to_final'] == 30)]['quantile_width'].empty == True:
    quantile_width_t0 = 0
else:
    quantile_width_t0 = int(seq_effort_fin.loc[(seq_effort_fin['time_to_final'] == 30)]['quantile_width'])
   
#quantile_width_t0 = seq_effort_fin.loc[(seq_effort_fin['time_to_final'] == 30)]['quantile_width']
seq_effort_fin['quantile_width_t0'] = int(quantile_width_t0)
seq_effort_fin['seq_effort'] = seq_effort_fin['quantile_width'] - seq_effort_fin['quantile_width_t0']

seq_effort_fin = seq_effort_fin.sort_values(by=['time_to_final'])

seq_effort_fin = seq_effort_fin.reset_index(drop=True)
SE_max = abs(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (900))]['seq_effort'].max())
SE_min = seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (900))]['seq_effort'].min()
SE_avg = round(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (900))]['seq_effort'].mean(),2)
SE_median = round(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (900))]['seq_effort'].median(),2)
SE_std = round(seq_effort_fin.loc[(seq_effort_fin.time_to_final <= (900))]['seq_effort'].std(),2)

fig, ax = plt.subplots(1, 1)
plot = seq_effort_fin.plot(x="time_to_final", y="seq_effort", title="Metering effort A",kind="line",figsize=(8,6),ax=ax)
#plot.set_xticklabels(xlabels)
plot.set_xlabel("Minimum time to final",fontsize=19)
plot.set_ylabel("Metering effort",fontsize=19)
ax.set_xlim([0,900])                                                              
ax.set_ylim([-4,3])
plt.savefig('Plots\sequencing_effort_ESGG_c3.jpg',bbox_inches="tight")
plt.show() 


