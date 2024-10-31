
# =============================== SEQUENCE PRESSURE CALCULATION ==============================================
import pandas as pd                                               #library for data manipulation and analysis

def takeClosest(num,collection):
   return min(collection,key=lambda x:abs(x-num))


flight = pd.read_csv('Output_files/flight_ESGG_c5.csv', 
header=0,
sep=','
) 

Grid_frame2 = pd.read_csv('Output_files/Grid_frame2_ESGG_c5.csv', 
header=0,
sep=','
) 


flight = flight.sort_values(by=['time_in_final'])
flight.insert(7,"flight_nr",range(1,len(flight)+1))
flight.index=range(0,len(flight))


column_names = ["flightID","flight_nr","timestamp","pressure"]
sequence_pressure = pd.DataFrame(columns = column_names)

for i in range(len(flight)):
    i_flight = range(int(flight.entering_time[i]),int(flight.time_in_final[i]),90)
    for j in i_flight:
        timestamp = takeClosest(j,Grid_frame2.loc[(Grid_frame2['flightID'] == str(flight.flightID[i]))]['timestamp'])
        X_flight = Grid_frame2.loc[((Grid_frame2.flightID == str(flight.flightID[i])) & (Grid_frame2.timestamp == int(timestamp)))]['X'].head(1).item()
        Y_flight = Grid_frame2.loc[((Grid_frame2.flightID == str(flight.flightID[i])) & (Grid_frame2.timestamp == int(timestamp)))]['Y'].head(1).item()
        frame = Grid_frame2.loc[(Grid_frame2.timestamp >= (timestamp-60))]
        frame2 = frame.loc[(frame.timestamp <=(timestamp+60))]
        frame3 = frame2[['flightID','X','Y']].copy()
        frame3 = frame3.reset_index()
        frame3 = frame3.drop(list(frame3)[0],axis=1)
        frame3.drop(frame3[frame3['X'] != int(X_flight)].index, inplace = True)
        frame3.drop(frame3[frame3['Y'] != int(Y_flight)].index, inplace = True)
        pressure =int(frame3.flightID.nunique())
        df1 = pd.DataFrame({"flightID":[str(flight.flightID[i])],"flight_nr":[flight.flight_nr[i]],"timestamp":[j],"pressure":[pressure]})
        #sequence_pressure = sequence_pressure.append(df1,ignore_index = True)
        sequence_pressure = pd.concat([sequence_pressure,df1],ignore_index=True)

sec = 2*60  

# calculation of time to final for each flightID in sequence pressute dataframe        
time_to_final = pd.Series([])
for i in range(len(sequence_pressure)):
    time = sequence_pressure.timestamp[i]
    flightID = sequence_pressure.flightID[i]
    time_to_final[i] = int(Grid_frame2.loc[((Grid_frame2['timestamp']== takeClosest(time,Grid_frame2.loc[(Grid_frame2['flightID'] == flightID)]['timestamp'])) & (Grid_frame2['flightID'] == flightID) )]['time_to_final'].values[0])

sequence_pressure.insert(3,"time_to_final",time_to_final) 

# calculation of statistical descriptions (mean and 90% confidence interval)
sequence_pressure['time_to_final_round'] = sequence_pressure['time_to_final'].round(-1)
sequence_pressure['quantile05'] = sequence_pressure.groupby(['time_to_final_round'])['pressure'].transform(lambda x: x.quantile(.05,interpolation='nearest'))
sequence_pressure['quantile95'] = sequence_pressure.groupby(['time_to_final_round'])['pressure'].transform(lambda x: x.quantile(.95,interpolation='nearest'))

min_seq_pr = sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].min()
max_seq_pr = sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].max()
avg_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].mean(),2)
s2_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].std(),2)


# new_ticks_X = np.linspace(0,900,10)
# new_ticks_Y = np.linspace(0,6,7)
# sequence_pressure = sequence_pressure.sort_values(by=['time_to_final'])
# # scatter plot of sequence pressure
# fig, ax = plt.subplots(1, 1)
# plot = sequence_pressure.plot.scatter(x='time_to_final',y='pressure',c='flight_nr',colorbar = False, colormap='gist_rainbow',figsize=(8,6),ax=ax)
# plot.xaxis.tick_top()
# #median_intervals.plot(x='time_to_f',y='medians',color='black',linewidth=2.5,ax=ax)
# sequence_pressure.plot(x='time_to_final',y='quantile95',color='black',linewidth=1.5,ax=ax)
# sequence_pressure.plot(x='time_to_final',y='quantile05',color='black',linewidth=1.5,ax=ax)
# ax.grid()
# plot.set_xlabel("Time to final [seconds]",fontsize=19)
# plot.set_ylabel("Sequence pressure [num of flights]",fontsize=19)
# ax.set_xlim(0,900)
# ax.set_xticks(new_ticks_X)
# ax.set_yticks(new_ticks_Y)
# plt.xticks(fontsize=18)
# plt.yticks(fontsize=18)
# plt.legend(fontsize=17)
# fig = plot.get_figure()
# fig.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\sequence_pressure_'+str(name)+str(date)+'.jpg',bbox_inches="tight")

pd.DataFrame(sequence_pressure).to_csv('Output_files/sequence_pressure_ESGG_c5.csv')
