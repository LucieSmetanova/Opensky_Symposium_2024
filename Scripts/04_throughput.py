import pandas as pd                                               #library for data manipulation and analysis
import matplotlib.pyplot as plt
import numpy as np
import datetime
#from shapely.geometry import Polygon

#function for triangle are calculation 


min_time = pd.read_csv('Output_files/min_time_ESGG_c5.csv', 
header=0,
sep=','
) 

Grid_frame = pd.read_csv('Output_files/Grid_frame_ESGG_c5.csv', 
header=0,
sep=','
) 


# =============================== THROUGHPUT CALCULATION ==============================================
# making time to final samples 30s
step_seconds = 30
referenceMinimumTime = list(range(0, 900, step_seconds))
referenceMinimumTime = pd.Series(referenceMinimumTime, name='referenceMinimumTime')
# making just a dataframe with information we need and assigning minimum time to final to each X,Y combination
min_time_to_f =pd.Series([])

frame = Grid_frame[['flightID','timestamp','endDate','X','Y']]
for i in range(len(frame)):
    x = frame['X'][i]
    y = frame['Y'][i]
    min_time_to_f[i] = min_time.loc[((min_time['X'] == x) & (min_time['Y'] == y))]['min_time'].values[0]
    
frame.insert(3, "min_time_to_final", min_time_to_f)
 
print('FRAME DONE')
pd.DataFrame(frame).to_csv('Output_files/frame_ESGG_c5.csv')

   
# making datatime timestamp for end hour
date_str = '190401'
start_str = '0'
end_str = '240000'
year = '2019'
import time 
if len(start_str) == 6:
    b = datetime.datetime(int(year), int(date_str[2:4]), int(date_str[4:6]), int(start_str[:2]), int(start_str[2:4]), int(start_str[4:6]))
if len(start_str) == 1:
    b = datetime.datetime(int(year), int(date_str[2:4]), int(date_str[4:6]), int(start_str[:2]))
if len(start_str) == 5:
    b = datetime.datetime(int(year), int(date_str[2:4]), int(date_str[4:6]), int(start_str[:1]), int(start_str[1:3]), int(start_str[3:5]))
    
tuple = b.timetuple() 
# regarding the time change for summer and winter time. The summer time was from 25.3. until 28.10. in the year 2018
if int(date_str[2:]) >= 325 and int(date_str[2:]) <= 1028:
    timestamp_start = time.mktime(tuple)+ 7200
else:
    timestamp_start = time.mktime(tuple)+ 3600

#preparing an empty dataframe for results
column_names = ["time_interval_start","time_interval_end","time_to_final","throughput"]
throughput = pd.DataFrame(columns = column_names)

column_names = ["interval_nr","time_interval_start","time_interval_end","total_throughput"]
total_throughput = pd.DataFrame(columns = column_names)

column_names = ["flightID","timestamp","time", "X", "min_time_to_final","Y","interval_nr"]
flights_in_interval = pd.DataFrame(columns = column_names)

# making 5 minute time intervals from the hour subset (1 minute time steps)
days =  190430 - 190401 + 1
hours = (240000 - 0)/10000*days
number_of_intervals = int(55*hours+1)

for n in range(0,number_of_intervals,1):
        time_interval_start = timestamp_start + n*60
        time_interval_end = time_interval_start + 5*60
        flights_in_interval1 = frame.loc[((frame['timestamp'] >= time_interval_start) & (frame['timestamp'] <= time_interval_end))]
        flights_in_interval_grouped = flights_in_interval1.groupby(['flightID']).head(1)
        flights_in_interval1['interval_nr'] = n
        #flights_in_interval = flights_in_interval.append(flights_in_interval1,ignore_index = True)
        flights_in_interval = pd.concat([flights_in_interval,flights_in_interval1], ignore_index = True)
        flightCount = len(flights_in_interval_grouped)
        df1 = pd.DataFrame({'interval_nr':[n],'time_interval_start':[str(time_interval_start)[:10]],'time_interval_end':[str(time_interval_end)[:10]],'total_throughput':[flightCount]})
        #total_throughput =total_throughput.append(df1,ignore_index = True)
        total_throughput = pd.concat([total_throughput,df1],ignore_index=True)
        for t in referenceMinimumTime:
            t_end = t + step_seconds
            if t_end == 900:
                inConditions = flights_in_interval1.loc[(flights_in_interval1['min_time_to_final'] >= t)]
            else:
                inConditions = flights_in_interval1.loc[((flights_in_interval1['min_time_to_final'] >= t) & (flights_in_interval1['min_time_to_final'] <= t_end))]
            dataCount = len(inConditions.groupby(['flightID']).groups.keys())
            df = pd.DataFrame({'interval_nr':[n],'time_interval_start':[str(time_interval_start)[:10]],'time_interval_end':[str(time_interval_end)[:10]],'time_to_final':[t_end],'throughput':[dataCount]})
            #throughput =throughput.append(df,ignore_index = True)
            throughput = pd.concat([throughput,df],ignore_index=True)

# ########################## CONFIDENCE INTERVAL ############################
# # calculation of 90% confidence intervals, medians and means for intervals of spacing deviation (100 second interval)
# # making range for intervals
throughput = throughput.loc[(throughput['throughput'] > 0)]
throughput = throughput.reset_index()
throughput = throughput.drop(list(throughput)[0], axis=1)
        
throughput['quantile05'] = throughput.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.05))
throughput['quantile95'] = throughput.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.95))

max_thr = abs(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].max())
min_thr = throughput.loc[(throughput.time_to_final <= 900)]['throughput'].min()
avg_thr = round(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].mean(),2)
s2_thr = round(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].std(),2)

###########################    PLOTTING   ##############################

# # pltting total throughput in five minute intervals i (total number of a/c in given interval)
# sta = int(start_hour/100)
# end = int(end_hour/100)
# x_labels = [*range(sta, end, 5)]
# x_labels = [str(x) for x in x_labels] 
# x_labels = [x[:2]+':'+x[2:] for x in x_labels]
# fig, ax = plt.subplots(1, 1)
# plot = total_throughput.plot(x="interval_nr", y="total_throughput", kind="bar",figsize=(8,6),ax=ax) 
# plot.set_xlabel("Interval start",fontsize=19)
# plot.set_ylabel("Total throughput",fontsize=19)
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Total_throughput'+str(name)+'.jpg')

# #throughput plot
# new_ticks_X = np.linspace(0,15,4)
# new_ticks_Y = np.linspace(0,12,13)

# fig, ax = plt.subplots(1, 1)
# plot = throughput.plot.scatter(x='time_to_final',y='throughput',c='interval_nr',colorbar = False, colormap='gist_rainbow',figsize=(8,6),ax=ax)
# plot.xaxis.tick_top()
# throughput.sort_values(by=['time_to_final']).plot(x='time_to_final',y='quantile05',color='dodgerblue',linewidth=2.5,ax=ax)
# throughput.sort_values(by=['time_to_final']).plot(x='time_to_final',y='quantile95',color='dodgerblue',linewidth=2.5,ax=ax)
# ax.grid()
# plot.set_xlabel("Time to final [seconds]",fontsize=19)
# plot.set_ylabel("Throughput",fontsize=19)
# ax.set_xlim(0,900)
# ax.set_yticks(new_ticks_Y)

# plt.xticks(fontsize=18)
# plt.yticks(fontsize=18)
# plt.legend(fontsize=17)
# fig = plot.get_figure()
# plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\Throughput'+str(step_seconds)+' sec_sample '+str(name)+'_without_zeros.jpg',bbox_inches="tight")

pd.DataFrame(throughput).to_csv('Output_files/throughput_ESGG_c5.csv')
pd.DataFrame(total_throughput).to_csv('Output_files/total_throughput_ESGG_c5.csv')
