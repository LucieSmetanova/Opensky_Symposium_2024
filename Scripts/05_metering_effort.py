################## METERING EFFORT FIGURES - SAME AS FIGURE 5 FROM AIAA PAPER ###########
import pandas as pd                                               #library for data manipulation and analysis

throughput = pd.read_csv('Output_files/throughput_ESGG_c5.csv', 
header=0,
sep=','
) 


# metering effort is at figure 4 they simply calculate the range (= envelope = dispercion), which is simply a difference between 90th-10th percentiles at each time point (I called it 90th percentile width if you remember, never mind). Just look at any point in x axis in Figure 4 and calculate the difference between the top number on the 90th percentile line and the bottom one on the 10th percentile. In our case, please use 95th and 5-th percentiles as we did in previous work, just for consistency. Having this number for each time to final we can either compare it to the corresponding value at the final (30s time point closest to the final), and obtaining Figure 5a, or comparing to the t-30s value, the one on the previous time period, and obtain the Figure 5b. Comparing I mean decreasing by this value Thr (t) - Thr (30s) for Fig 5a and Thr (t) - Thr (t-30s) for Fig 5b.
metering_effort = throughput[['time_to_final','interval_nr','throughput']]
metering_effort['quantile05'] = metering_effort.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.05))
metering_effort['quantile95'] = metering_effort.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.95))

metering_effort_fin = metering_effort.groupby(['time_to_final'])[['time_to_final','quantile05','quantile95']].head(1)
metering_effort_fin['quantile_width'] = metering_effort_fin['quantile95'] - metering_effort_fin['quantile05']

quantile_width_t0 = int(metering_effort_fin.loc[(metering_effort['time_to_final'] == 30)]['quantile_width'])

metering_effort_fin['metering_effort_a'] = metering_effort_fin['quantile_width'] - quantile_width_t0

metering_effort_fin = metering_effort_fin.sort_values(by=['time_to_final'])

metering_effort_fin = metering_effort_fin.reset_index(drop=True)


metering_effort_b = []

for i in range(len(metering_effort_fin)):
    start_effort = metering_effort_fin['quantile_width'][0]
    if metering_effort_fin['time_to_final'][i] == 30:
        value = metering_effort_fin['quantile_width'][i] - metering_effort_fin['quantile_width'][0]
        #metering_effort_b.append(value)
        metering_effort_b = pd.concat([metering_effort_b,pd.Series([value])])
    else:
        value = metering_effort_fin['quantile_width'][i] - metering_effort_fin['quantile_width'][i-1]
        #metering_effort_b.append(value)
        metering_effort_b = pd.concat([metering_effort_b,pd.Series([value])])

metering_effort_fin['metering_effort_b'] = metering_effort_b

metering_effort_fin = metering_effort_fin.sort_values(by=['time_to_final'])


max_mefA = abs(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].max())
min_mefA = metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].min()
avg_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].mean(),2)
s2_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].std(),2)

######### PLOTTING ##############  
################## MOVING AVERAGE #############
# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(3).mean()

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Metering_effort_A_'+str(name)+'_MOVING_AVERAGE_90s.jpg',bbox_inches="tight")

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(4).mean()

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Metering_effort_A_'+str(name)+'_MOVING_AVERAGE_120s.jpg',bbox_inches="tight")

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(5).mean()

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Metering_effort_A_'+str(name)+'_MOVING_AVERAGE_150s.jpg',bbox_inches="tight")

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(7).mean()

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Metering_effort_A_'+str(name)+'_MOVING_AVERAGE_210s.jpg',bbox_inches="tight")

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(10).mean()

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Metering_effort_A_'+str(name)+'_MOVING_AVERAGE_300s.jpg',bbox_inches="tight")


# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(17).mean()

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Metering_effort_A_'+str(name)+'_MOVING_AVERAGE_510s.jpg',bbox_inches="tight")

pd.DataFrame(metering_effort_fin).to_csv('Output_files/metering_effort_fin_ESGG_c5.csv')

max_mefA = abs(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].max())
min_mefA = metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].min()
avg_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].mean(),2)
median_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].median(),2)
s2_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].std(),2)

print(max_mefA,min_mefA,avg_mefA,median_mefA,s2_mefA)
