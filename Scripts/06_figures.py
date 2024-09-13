import pandas as pd                                               #library for data manipulation and analysis
import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "Times New Roman"
import numpy as np
import seaborn as sns
from datetime import datetime

def takeClosest(num,collection):
   return min(collection,key=lambda x:abs(x-num))


name_str = 'osn_ESGG'

if name_str == 'osn_LOWW_dataset_TT':
    grid_x = 71
    grid_y = 94

if name_str == 'osn_EIDW_dataset_TT':
    grid_x = 75
    grid_y = 109
   
if name_str == 'osn_EIDW_dataset_PM':
    grid_x = 100
    grid_y = 100
    
    
if name_str == 'osn_EIDW_dataset_TT_50NM_rwy':
    grid_x = 200
    grid_y = 200
    
if name_str == 'osn_ESSA_dataset_TT':
    grid_x = 103
    grid_y = 109
    
if name_str == 'osn_ENGM_dataset_TT':
    grid_x = 100
    grid_y = 100
    
if name_str == 'osn_ESGG':
    grid_x = 71 
    grid_y = 107


Grid_frame = pd.read_csv('Output_files\Grid_frame_ESGG_c5.csv', 
header=0,
sep=','
) 

Grid_frame2 = pd.read_csv('Output_files\Grid_frame2_ESGG_c5.csv', 
header=0,
sep=','
) 

ESGG_polygon = pd.read_csv('Output_files\ESGG_polygon.csv', 
header=0,
sep=','
) 


min_time = pd.read_csv('Output_files\min_time_ESGG_c5.csv', 
header=0,
sep=','
) 

min_time_result = pd.read_csv('Output_files\min_time_result_ESGG_c5.csv', 
header=0,
sep=','
) 

min_times = pd.read_csv('Output_files\min_times_ESGG_c5.csv', 
header=0,
sep=','
) 

# fig, ax = plt.subplots(figsize=(9,9))
# for i, g in Grid_frame.groupby(['flightID','endDate']):
#     g.plot(x='lon_norm', y='lat_norm', ax=ax, label=str(i))
# #plt.title(str(title) + ' number of flights:' + str(number_of_flights))
# ax.xaxis.set_ticks(np.arange(0, grid_x+1, 5))  ## GRID CHANGE !!! 
# ax.yaxis.set_ticks(np.arange(0, grid_y+1, 5))
# ax.xaxis.label.set_visible(False)
# ax.yaxis.label.set_visible(False)
# plt.xlabel('X - coordinates')
# plt.ylabel('Y - coordinates')
# plt.xticks(fontsize=16)
# plt.yticks(fontsize=16)

# if name_str[4:8] == 'EIDW':
#     circle_center_lat = 53.42
#     circle_center_lon = 6.27
#     circle_center_lat_norm = Grid_frame.loc[(Grid_frame['lat'] == takeClosest(circle_center_lat, Grid_frame['lat']))]['lat_norm'].values[0]
#     circle_center_lon_norm = Grid_frame.loc[(Grid_frame['lon'] == takeClosest(-circle_center_lon, Grid_frame['lon']))]['lon_norm'].values[0]
#     plot1 = EIDW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     radius = 50
#     circle1 = plt.Circle((circle_center_lon_norm, circle_center_lat_norm), radius, color='r', fill = False)
#     ax.add_patch(circle1)
#     axes = plt.gca()
#     #axes.set_xlim([-30,130])                                                              
#     #axes.set_ylim([-30,130])

    
# elif name_str[4:8] == 'LOWW':
#     plot1 = LOWW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()
    
# elif name_str[4:8] == 'ESSA':
#     plot1 = ESSA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()

# elif name_str[4:8] == 'ENGM':
#     plot1 = ENGM_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()

# else:
#     axes = plt.gca()
#     axes.set_xlim([0,grid_x])                                                               #setting limits for axes
#     axes.set_ylim([0,grid_y])

# axes.legend().set_visible(False)
# axes.grid()
# plt.savefig('Plots\traj_ESGG_c5.jpg',bbox_inches="tight")
# plt.show()

# using another axis labels than the plot gives
x_labels = range(0,grid_x+1,5)
y_labels = range(0,grid_y+1,5)
new_ticks_X = np.linspace(0,grid_x,5)
new_ticks_Y = np.linspace(0,grid_y,5)

min_min_time = min_time_result.min_time.min()
max_min_time = min_time_result.min_time.max()
avg_min_time = round(min_time_result.min_time.mean())
median_min_time = round(min_time_result.min_time.median())
s2_min_time = round(min_time_result.min_time.std())

min_times = min_times.drop(list(min_times)[0:1], axis=1)
# value = min_times.max()[0]
# if value < 2500:
#     min_times.replace({value: 2500}, inplace=True)
# else:
#     min_times.replace({value: 3000}, inplace=True)
#min_times.replace({2100: 3000}, inplace=True)

# making my own colormap
import matplotlib.colors
cmap = matplotlib.colors.LinearSegmentedColormap.from_list("", ["midnightblue","navy","teal","darkcyan","mediumseagreen","limegreen","yellowgreen","yellow","white","white"])
cmap2 = matplotlib.colors.LinearSegmentedColormap.from_list("", ["black","maroon","darkred","firebrick","red","r","darkorange","orange","gold","yellow","white","white"])
cmap3 = matplotlib.colors.LinearSegmentedColormap.from_list("", ["black","maroon","darkred","firebrick","red","r","darkorange","orange","gold","yellow","white","white","lightcyan","paleturquoise","powderblue","lightblue","lightskyblue","skyblue","skyblue","darkturquoise","c","c","darkcyan","darkcyan","teal","darkslategrey","white","white"])
cmap4 = matplotlib.colors.LinearSegmentedColormap.from_list("", ['white','yellow','gold','orange','darkorange','r','red','firebrick','darkred','maroon','black',"black"])
cmap5 = matplotlib.colors.LinearSegmentedColormap.from_list("", ['crimson','orangered','orange','lemonchiffon','lightyellow','greenyellow','palegreen','mediumturquoise','cornflowerblue','royalblue','rebeccapurple','white'])

# heatmap plot of minimum time
fig, ax = plt.subplots(figsize=(11,9))
#sns.heatmap(min_times,cmap=cmap5,cbar_kws={'label': 'Minimum time [seconds]'},yticklabels=5,xticklabels=5,vmin=0, vmax=1600, ax=ax)
sns.heatmap(min_times,cmap=cmap5,cbar_kws={'label': 'Minimum time [seconds]'},yticklabels=1,xticklabels=1,vmin=0, vmax=1000, ax=ax)
ax.invert_yaxis()
ax.xaxis.label.set_visible(False)
ax.yaxis.label.set_visible(False)


if name_str[4:8] == 'EIDW':
#    ax.set_xlim([35,110])                                                               #setting limits for axes
#    ax.set_ylim([0,120])
    circle_center_lat = 53.42
    circle_center_lon = 6.27
    circle_center_lat_norm = Grid_frame.loc[(Grid_frame['lat'] == takeClosest(circle_center_lat, Grid_frame['lat']))]['lat_norm'].values[0]
    circle_center_lon_norm = Grid_frame.loc[(Grid_frame['lon'] == takeClosest(-circle_center_lon, Grid_frame['lon']))]['lon_norm'].values[0]
    plot1 = ESGG_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    radius = 100
    circle1 = plt.Circle((circle_center_lon_norm, circle_center_lat_norm), radius, color='r', fill = False)
    ax.add_patch(circle1)
    ax.set_xlim([0,grid_x])                                                               #setting limits for axes
    ax.set_ylim([0,grid_y])
    axes = plt.gca()
    
if name_str[4:8] == 'ESSA':
    ax.set_xlim([0,grid_x])                                                               #setting limits for axes
    ax.set_ylim([0,grid_y])
  #  plot1 = ESSA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    axes = plt.gca()
if name_str[4:8] == 'ESGG':
    ax.set_xticklabels(list(range(0, grid_x, 1)),fontsize=17) 
    ax.set_yticklabels(list(range(0,grid_y,1)),fontsize=17) 
    for index, label in enumerate(ax.xaxis.get_ticklabels()):
        if index % 5 != 0:
            label.set_visible(False)
    for index, label in enumerate(ax.yaxis.get_ticklabels()):
        if index % 5 != 0:
            label.set_visible(False)
    plot1 = ESGG_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    
if name_str[4:8] == 'ENGM':
    #ax.set_xlim([0,grid_x])                                                               #setting limits for axes
    #ax.set_ylim([0,grid_y])
    circle_center_lat = 60.200534
    circle_center_lon = 11.0827
    circle_center_lat_norm = Grid_frame.loc[(Grid_frame['lat'] == takeClosest(circle_center_lat, Grid_frame['lat']))]['lat_norm'].values[0]
    circle_center_lon_norm = Grid_frame.loc[(Grid_frame['lon'] == takeClosest(circle_center_lon, Grid_frame['lon']))]['lon_norm'].values[0]
    radius = 50
    circle1 = plt.Circle((circle_center_lon_norm, circle_center_lat_norm), radius, color='gray', fill = False)
    ax.add_patch(circle1)
    ax.set_xticks(np.linspace(0,104,105))
    ax.set_xticklabels(list(range(0, 105, 1)),fontsize=17) 
    ax.set_yticklabels(list(range(0,grid_y+1,1)),fontsize=17) 
    for index, label in enumerate(ax.xaxis.get_ticklabels()):
        if index % 5 != 0:
            label.set_visible(False)
    for index, label in enumerate(ax.yaxis.get_ticklabels()):
        if index % 5 != 0:
            label.set_visible(False)
 #   plot1 = ENGM_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    axes = plt.gca()

if name_str[4:8] == 'LOWW':
  #  plot1 = LOWW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    axes = plt.gca()
ax.grid()
ax.legend().set_visible(False)
ax.figure.axes[-1].yaxis.label.set_size(25)
ax.figure.axes[-1].tick_params(labelsize=17) 
# ax.set_xticklabels(list(range(0, grid_x+1, 5))) 
# ax.set_yticklabels(list(range(0, grid_y+1, 5)))
# ax.set_xticks(ax.get_xticks()[::5])
# ax.set_yticks(ax.get_yticks()[::5])
plt.savefig('Plots\heatmap_ESGG_c5.jpg',bbox_inches="tight")
plt.show()

number_of_flights = Grid_frame['flightID'].nunique()

print(number_of_flights,min_min_time,max_min_time,avg_min_time,median_min_time,s2_min_time)


#################### SPACING DEVIATION ##################
# spacing_dev2 = pd.read_csv('Output_files\spacing_dev2_ESGG_c5.csv', 
# header=0,
# sep=','
# ) 

spacing_dev2 = pd.read_csv('Output_files\spacing_dev2_ESGG_c5.csv', 
header=0,
sep=','
) 

#scatter plot
new_ticks_X = np.linspace(0,900,10)
new_ticks_Y = np.linspace(-600,600,13)
spacing_dev2 = spacing_dev2.sort_values(by=['time_to_final'])
#plot of spacing deviation (scatter plot)
fig, ax = plt.subplots(1, 1)
plot = spacing_dev2.plot.scatter(x='time_to_final',y='recalculated_dev',c='pair_ID',colorbar = False,colormap='gist_rainbow',figsize=(8,6),ax=ax)
# median_intervals.plot(x='time_to_f',y='medians',color='black',linewidth=2.5,ax=ax)
spacing_dev2.plot(x='time_to_final',y='quantile95',color='black',linewidth=2.5,ax=ax)
spacing_dev2.plot(x='time_to_final',y='quantile05',color='black',linewidth=2.5,ax=ax)
#fig.suptitle('Spacing deviation ' + str(title))
plot.set_xlabel("Time to final trailer [seconds]",fontsize=19)
plot.set_ylabel("Spacing deviation [seconds]",fontsize=19)
plot.xaxis.tick_top()
ax.set_xticks(new_ticks_X)
ax.set_yticks(new_ticks_Y)
ax.set_xlim(0,900)
ax.set_ylim(-600,600)
plt.xticks(fontsize=18)
plt.yticks(fontsize=18)
plt.legend(fontsize=17)
ax.grid()
fig = plot.get_figure()
plt.savefig('Plots\spacing_dev_ESGG_c5.jpg',bbox_inches="tight")
plt.show()

#line plot
new_dev = spacing_dev2.copy()
new_dev.set_index('time_to_final', inplace=True)
# #new_dev['moving_average'] = new_dev.recalculated_dev.rolling(3).mean()
# plt.figure(figsize=(8,6))  
# new_dev.groupby('pair_ID')['recalculated_dev'].plot()
# #plt.plot(spacing_dev2.time_to_final,spacing_dev2.quantile05,color='black',linewidth=2.5)
# #plt.plot(spacing_dev2.time_to_final,spacing_dev2.quantile95,color='black',linewidth=2.5)
# plt.plot()
# #plt.title('Spacing deviation '+str(title) + '\nMax = ' + str(max_dev) + ' Min = ' + str(min_dev) + ' Average = ' + str(avg_dev) + ' Standard deviation = ' + str(s2_dev))
# axes = plt.gca()
# axes.set_xticks(new_ticks_X)
# axes.set_yticks(new_ticks_Y)
# axes.set_ylim(-600,600)
# axes.set_xlim([0,900])                                                               #setting limits for axes
# axes.grid()
# plt.savefig('Plots\spacing_dev_lineplot_ESGG_c5.jpg',bbox_inches="tight")

# plt.show() 

#Smoothed line plot
xx = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(15).mean()
zz = xx.reset_index(drop = True)
xx2 = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(10).mean()
zz2 = xx2.reset_index(drop = True)
xx3 = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(5).mean()
zz3 = xx3.reset_index(drop = True)
xx4 = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(6, min_periods=1).mean()
zz4 = xx4.reset_index(drop = True)
new_dev = new_dev.sort_values(by=['pair_ID','interval_nr'],ascending=[True, False])
new_dev = new_dev.reset_index()
new_dev['moving_average'] = zz
new_dev['moving_average_2'] = zz2
new_dev['moving_average_3'] = zz3
new_dev['moving_average_4'] = zz4
grouped = new_dev.groupby(['pair_ID'])
moving_av_final = pd.Series([])
for name, group in grouped:
    last_value = group['moving_average'][14+(91*(name[0]-1))]
    values = np.linspace(0,last_value,14)
    for row_index, row in group.iterrows():
        if group['time_to_final'][row_index] > 130:
            moving_av_final[row_index] = group['moving_average'][row_index]    
        elif group['time_to_final'][row_index] == 0:
            moving_av_final[row_index] =  values[0]
        elif group['time_to_final'][row_index] == 10:
            moving_av_final[row_index] =  values[1]
        elif group['time_to_final'][row_index] == 20:
            moving_av_final[row_index] =  values[2]
        elif group['time_to_final'][row_index] == 30:
            moving_av_final[row_index] =  values[3]
        elif group['time_to_final'][row_index] == 40:
            moving_av_final[row_index] =  values[4]
        elif group['time_to_final'][row_index] == 50:
            moving_av_final[row_index] =  values[5]
        elif group['time_to_final'][row_index] == 60:
            moving_av_final[row_index] =  values[6]
        elif group['time_to_final'][row_index] == 70:
            moving_av_final[row_index] =  values[7]
        elif group['time_to_final'][row_index] == 80:
            moving_av_final[row_index] =  values[8]
        elif group['time_to_final'][row_index] == 90:
            moving_av_final[row_index] =  values[9]
        elif group['time_to_final'][row_index] == 100:
            moving_av_final[row_index] =  values[10]
        elif group['time_to_final'][row_index] == 110:
            moving_av_final[row_index] =  values[11]
        elif group['time_to_final'][row_index] == 120:
            moving_av_final[row_index] =  values[12]
        elif group['time_to_final'][row_index] == 10:
            moving_av_final[row_index] =  values[1]
        elif group['time_to_final'][row_index] == 130:
            moving_av_final[row_index] =  values[13]

    # elif new_dev['time_to_final'][i] < 130 and new_dev['time_to_final'][i] > 80:
    #     moving_av_final[i] = new_dev['moving_average_2'][i]
    # elif new_dev['time_to_final'][i] < 80 and new_dev['time_to_final'][i] > 30:
    #     moving_av_final[i] = new_dev['moving_average_3'][i]
    # elif new_dev['time_to_final'][i] == 30:
    #     moving_av_final[i] = new_dev['moving_average_3'][i+1]
    # else:
    #    moving_av_final[i] = new_dev['recalculated_dev'][i] 
        
#new_dev['moving_av_final'] = moving_av_final
new_dev['moving_av_final'] = new_dev['moving_average_4']

# column_names = ["pairID","xnew","ynew"]
# smooth = pd.DataFrame(columns = column_names)


# from scipy.interpolate import make_interp_spline, BSpline
# groups = new_dev.groupby('pair_ID')
# for name,group in groups:
#     x_val = group['time_to_final']
#     y_val = group['recalculated_dev'] 
#     xnew = np.linspace(900,0,5)
#     spl = make_interp_spline(x_val,y_val, k=3)
#     y_smooth = spl(xnew)
#     df = pd.DataFrame({'pairID':name,'xnew':xnew,'ynew':y_smooth})
#     smooth =smooth.append(df,ignore_index = True)


new_dev['quantile05_ma'] = new_dev.groupby(['time_to_final'])['moving_av_final'].transform(lambda x: x.quantile(.05))
new_dev['quantile95_ma'] = new_dev.groupby(['time_to_final'])['moving_av_final'].transform(lambda x: x.quantile(.95))
new_dev = new_dev.sort_values(by=['time_to_final'])

new_dev['quantile_width'] = new_dev.quantile95_ma - new_dev.quantile05_ma
quantile_width_600 = new_dev.loc[(new_dev.time_to_final <= 600)]['quantile_width'].max()

new_dev = new_dev.loc[(new_dev['time_to_final'] <= 600)]
new_dev.set_index('time_to_final', inplace=True)
plt.figure(figsize=(8,6))  
new_dev.groupby('pair_ID')['moving_av_final'].plot(label='_nolegend_')
new_dev['quantile05_ma'].plot(color='black',linewidth=2.5, label = 'Quantile 5',legend = True)
new_dev['quantile95_ma'].plot(color='black',linewidth=2.5, label = 'Quantile 95', legend = True)
# new_dev['quantile05_ma'].plot(color='black',linewidth=2.5)
# new_dev['quantile95_ma'].plot(color='black',linewidth=2.5)
plt.plot()
plt.legend(["The 5th and 95th Quantiles"],fontsize=23)
#plt.title('Spacing deviation '+str(title) + '\nMax = ' + str(max_dev) + ' Min = ' + str(min_dev) + ' Average = ' + str(avg_dev) + ' Standard deviation = ' + str(s2_dev))
axes = plt.gca()
axes.set_xticks(np.linspace(0,600,7))
axes.set_yticks(np.linspace(-600,600,13))
axes.set_xlabel("Time to final trailer [seconds]",fontsize=23)
axes.set_ylabel("Spacing deviation [seconds]",fontsize=23)
axes.set_ylim(-600,600)
axes.set_xlim(0,600) 
axes.xaxis.set_tick_params(labelsize=19)
axes.yaxis.set_tick_params(labelsize=19)
#axes.legend(fontsize=17)                                                              #setting limits for axes
axes.grid()
plt.savefig('Plots\spacing_dev_smooth_ESGG_c5.jpg',bbox_inches="tight")
plt.show() 


max_dev = abs(spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['recalculated_dev'].max())
min_dev = spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['recalculated_dev'].min()
avg_dev = round(spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['recalculated_dev'].mean(),2)
median_dev = round(spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['recalculated_dev'].median(),2)
s2_dev = round(spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['recalculated_dev'].std(),2)
quantile_width = spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['quantile_width'].max()



print(max_dev,min_dev,avg_dev,median_dev,s2_dev)
print(quantile_width)
#print(quantile_width_600)

################# SEQUENCE PRESSURE ###########################
sequence_pressure = pd.read_csv('Output_files\sequence_pressure_ESGG_c5.csv', 
header=0,
sep=','
) 


new_ticks_X = np.linspace(0,900,10)
new_ticks_Y = np.linspace(0,6,7)
sequence_pressure = sequence_pressure.sort_values(by=['time_to_final'])
# scatter plot of sequence pressure
fig, ax = plt.subplots(1, 1)
plot = sequence_pressure.plot.scatter(x='time_to_final',y='pressure',c='flight_nr',colorbar = False, colormap='gist_rainbow',figsize=(8,6),ax=ax)
plot.xaxis.tick_top()
#median_intervals.plot(x='time_to_f',y='medians',color='black',linewidth=2.5,ax=ax)
sequence_pressure.plot(x='time_to_final',y='quantile95',color='black',linewidth=1.5,ax=ax)
sequence_pressure.plot(x='time_to_final',y='quantile05',color='black',linewidth=1.5,ax=ax)
ax.grid()
plot.set_xlabel("Time to final [seconds]",fontsize=19)
plot.set_ylabel("Sequence pressure [num of flights]",fontsize=19)
ax.set_xlim(0,900)
ax.set_xticks(new_ticks_X)
ax.set_yticks(new_ticks_Y)
plt.xticks(fontsize=18)
plt.yticks(fontsize=18)
plt.legend(fontsize=17)
fig = plot.get_figure()
plt.savefig('Plots\sequence_press_ESGG_c5.jpg',bbox_inches="tight")
plt.show() 

min_seq_pr = sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].min()
max_seq_pr = sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].max()
avg_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].mean(),2)
median_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].median(),2)
s2_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= 900)]["pressure"].std(),2)

print(max_seq_pr,min_seq_pr,avg_seq_pr,median_seq_pr,s2_seq_pr)

##################  THROUGHPUT ####################
# total_throughput = pd.read_csv('Output_files\total_throughput_ESGG_c5.csv', 
# header=0,
# sep=','
# ) 

throughput = pd.read_csv('Output_files\throughput_ESGG_c5.csv', 
header=0,
sep=','
) 


#Total throughput plot
# sta = int(0/100)
# end = int(240000/100)
# x_labels = [*range(sta, end, 20)]
# x_labels = [str(x) for x in x_labels] 
# x_labels = [x[:2]+':'+x[2:] for x in x_labels]
# fig, ax = plt.subplots(1, 1)
# plot = total_throughput.plot(x="interval_nr", y="total_throughput",kind="bar",figsize=(8,6),ax=ax) 
# plot.set_xlabel("Interval start",fontsize=19)
# plot.set_ylabel("Total throughput",fontsize=19)
# #plot.set_xticklabels(x_labels)
# plt.savefig('Plots\total_throughput_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

throughput = throughput.loc[(throughput['time_to_final'] <= 600)]
#throughput plot
new_ticks_X = np.linspace(0,15,4)
new_ticks_Y = np.linspace(0,12,13)
fig, ax = plt.subplots(1, 1)
plot = throughput.plot.scatter(x='time_to_final',y='throughput',c='interval_nr',colorbar = False, colormap='gist_rainbow',figsize=(8,6),label='_nolegend_',ax=ax)
plot.xaxis.tick_top()
#median_intervals.plot(x='time_to_f',y='medians',color='black',linewidth=2.5,ax=ax)
throughput.sort_values(by=['time_to_final']).plot(x='time_to_final',y='quantile05',color='dodgerblue',linewidth=2.5,ax=ax)
throughput.sort_values(by=['time_to_final']).plot(x='time_to_final',y='quantile95',color='dodgerblue',linewidth=2.5,ax=ax)
#fig.suptitle('Sequence pressure, '+str(title) + ', interval [s] ' +str(sec))
ax.grid()
plot.set_xlabel("Time to final [seconds]",fontsize=23)
plot.set_ylabel("Throughput",fontsize=23)
ax.set_xlim(0,600)
ax.set_ylim([0,12])
#ax.set_xticks(new_ticks_X)
ax.set_yticks(new_ticks_Y)
plt.legend(["The 5th and 95th Quantiles"],fontsize=23)
plt.xticks(fontsize=19)
plt.yticks(fontsize=19)
fig = plot.get_figure()
plt.savefig('Plots\throughput_ESGG_c5.jpg',bbox_inches="tight")
plt.show() 

max_thr = abs(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].max())
min_thr = throughput.loc[(throughput.time_to_final <= 900)]['throughput'].min()
avg_thr = round(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].mean(),2)
median_thr = round(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].median(),2)
s2_thr = round(throughput.loc[(throughput.time_to_final <= 900)]['throughput'].std(),2)

print(max_thr,min_thr,avg_thr,median_thr,s2_thr)
    
################# METERING EFFORT ######################
metering_effort_fin = pd.read_csv('Output_files\metering_effort_fin_ESGG_c5.csv', 
header=0,
sep=','
) 

metering_effort_less_points = pd.DataFrame()

for i in [30,120,300,600,900]:
    met_ef = metering_effort_fin.loc[(metering_effort_fin['time_to_final'] == i)]
    #metering_effort_less_points = metering_effort_less_points.append(met_ef,ignore_index = True)
    metering_effort_less_points = pd.concat([metering_effort_less_points,met_ef],ignore_index = True)
    
    
max_mefA = abs(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].max())
min_mefA = metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].min()
avg_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].mean(),2)
median_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].median(),2)
s2_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= 900)]['metering_effort_a'].std(),2)
 
metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(3).mean()
metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

fig, ax = plt.subplots(1, 1)
plot = metering_effort_fin.plot(x="time_to_final", y="metering_effort_a", title="Metering effort A",kind="line",figsize=(8,6),ax=ax)
#plot.set_xticklabels(xlabels)
plot.set_xlabel("Minimum time to final",fontsize=19)
plot.set_ylabel("Metering effort",fontsize=19)
ax.set_xlim([0,900])                                                              
ax.set_ylim([-4,3])
plt.savefig('Plots\metering_effort_ESGG_c5.jpg',bbox_inches="tight")
plt.show() 



# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 90 seconds",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# ax.set_xlim([0,900])                                                              
# ax.set_ylim([-2.5,2])
# plt.savefig('Plots\metering_effort_mov_av_90s_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(4).mean()
metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

fig, ax = plt.subplots(1, 1)
plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 120 seconds",kind="line",figsize=(8,6),ax=ax)
#plot.set_xticklabels(xlabels)
plot.set_xlabel("Minimum time to final",fontsize=19)
plot.set_ylabel("Metering effort",fontsize=19)
ax.set_xlim([0,900])                                                              
ax.set_ylim([-2.5,2])
plt.savefig('Plots\metering_effort_mov_av_120s_ESGG_c5.jpg',bbox_inches="tight")
plt.show() 

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(5).mean()
# metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 150 seconds",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# ax.set_xlim([0,900])                                                              
# ax.set_ylim([-2.5,2])
# plt.savefig('Plots\metering_effort_mov_av_150s_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(7).mean()
metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

fig, ax = plt.subplots(1, 1)
plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 210 seconds",kind="line",figsize=(8,6),ax=ax)
#plot.set_xticklabels(xlabels)
plot.set_xlabel("Minimum time to final",fontsize=19)
plot.set_ylabel("Metering effort",fontsize=19)
ax.set_xlim([0,900])                                                              
ax.set_ylim([-2.5,2])
plt.savefig('Plots\metering_effort_mov_av_210s_ESGG_c5.jpg',bbox_inches="tight")
plt.show() 

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(10).mean()
# metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 300 seconds",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# ax.set_xlim([0,900])                                                              
# ax.set_ylim([-2.5,2])
# plt.savefig('Plots\metering_effort_mov_av_300s_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(13).mean()
# metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 390 seconds",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# ax.set_xlim([0,900])                                                              
# ax.set_ylim([-2.5,2])
# plt.savefig('Plots\metering_effort_mov_av_390s_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(18).mean()
# metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 540 seconds",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# ax.set_xlim([0,900])                                                              
# ax.set_ylim([-2.5,2])
# plt.savefig('Plots\metering_effort_mov_av_540s_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

# metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(27).mean()
# metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])

# fig, ax = plt.subplots(1, 1)
# plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 810 seconds",kind="line",figsize=(8,6),ax=ax)
# #plot.set_xticklabels(xlabels)
# plot.set_xlabel("Minimum time to final",fontsize=19)
# plot.set_ylabel("Metering effort",fontsize=19)
# ax.set_xlim([0,900])                                                              
# ax.set_ylim([-2.5,2])
# plt.savefig('Plots\metering_effort_mov_av_810s_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

print(max_mefA,min_mefA,avg_mefA,median_mefA,s2_mefA)

################ DENSITY DISTRIBUTIONS
# FIGURE 2
# frame = pd.read_csv('Output_files\frame_ESGG_c5.csv', 
# header=0,
# sep=','
# ) 


# figure2a = frame.loc[(frame['min_time_to_final'] >= 870)]
# figure2b = frame.loc[((frame['min_time_to_final'] >= 840) & (frame['min_time_to_final'] <= 870))]
# figure2c = frame.loc[((frame['min_time_to_final'] >= 810) & (frame['min_time_to_final'] <= 840))]
# figure2d = frame.loc[((frame['min_time_to_final'] >= 780) & (frame['min_time_to_final'] <= 810))]
# figure2e = frame.loc[((frame['min_time_to_final'] >= 750) & (frame['min_time_to_final'] <= 780))]
# figure2f = frame.loc[((frame['min_time_to_final'] >= 720) & (frame['min_time_to_final'] <= 750))]
# figure2g = frame.loc[((frame['min_time_to_final'] >= 690) & (frame['min_time_to_final'] <= 720))]
# figure2h = frame.loc[((frame['min_time_to_final'] >= 660) & (frame['min_time_to_final'] <= 690))]
# figure2i = frame.loc[((frame['min_time_to_final'] >= 630) & (frame['min_time_to_final'] <= 660))]
# figure2j = frame.loc[((frame['min_time_to_final'] >= 600) & (frame['min_time_to_final'] <= 630))]
# figure2k = frame.loc[((frame['min_time_to_final'] >= 570) & (frame['min_time_to_final'] <= 600))]
# figure2l = frame.loc[((frame['min_time_to_final'] >= 540) & (frame['min_time_to_final'] <= 570))]
# figure2m = frame.loc[((frame['min_time_to_final'] >= 510) & (frame['min_time_to_final'] <= 540))]
# figure2n = frame.loc[((frame['min_time_to_final'] >= 480) & (frame['min_time_to_final'] <= 510))]
# figure2o = frame.loc[((frame['min_time_to_final'] >= 450) & (frame['min_time_to_final'] <= 480))]
# figure2p = frame.loc[((frame['min_time_to_final'] >= 420) & (frame['min_time_to_final'] <= 450))]
# figure2q = frame.loc[((frame['min_time_to_final'] >= 390) & (frame['min_time_to_final'] <= 420))]
# figure2r = frame.loc[((frame['min_time_to_final'] >= 360) & (frame['min_time_to_final'] <= 390))]
# figure2s = frame.loc[((frame['min_time_to_final'] >= 330) & (frame['min_time_to_final'] <= 360))]
# figure2t = frame.loc[((frame['min_time_to_final'] >= 300) & (frame['min_time_to_final'] <= 330))]
# figure2u = frame.loc[((frame['min_time_to_final'] >= 270) & (frame['min_time_to_final'] <= 300))]
# figure2v = frame.loc[((frame['min_time_to_final'] >= 240) & (frame['min_time_to_final'] <= 270))]
# figure2w = frame.loc[((frame['min_time_to_final'] >= 210) & (frame['min_time_to_final'] <= 240))]
# figure2x = frame.loc[((frame['min_time_to_final'] >= 180) & (frame['min_time_to_final'] <= 210))]
# figure2y = frame.loc[((frame['min_time_to_final'] >= 150) & (frame['min_time_to_final'] <= 180))]
# figure2z = frame.loc[((frame['min_time_to_final'] >= 120) & (frame['min_time_to_final'] <= 150))]
# figure2aa = frame.loc[((frame['min_time_to_final'] >= 90) & (frame['min_time_to_final'] <= 120))]
# figure2bb = frame.loc[((frame['min_time_to_final'] >= 60) & (frame['min_time_to_final'] <= 90))]
# figure2cc = frame.loc[((frame['min_time_to_final'] >= 30) & (frame['min_time_to_final'] <= 60))]
# figure2dd = frame.loc[((frame['min_time_to_final'] >= 0) & (frame['min_time_to_final'] <= 30))]
# figure2 = pd.concat([figure2a,figure2b,figure2c,figure2d,figure2e,figure2f,figure2g,figure2h,figure2i,figure2j,figure2k,figure2l,figure2m,figure2n,figure2o,figure2p,figure2q,figure2r,figure2s,figure2t,figure2u,figure2v,figure2w,figure2x,figure2y,figure2z,figure2aa,figure2bb,figure2cc,figure2dd])

# # defining function for round each number to next 100

# def roundup(x):
#     return x if x % 30 == 0 else x + 30 - x % 30

# figure2['min_time_round'] = figure2['min_time_to_final'].apply(roundup)

# figure2['time_obj'] = figure2['timestamp'].transform(lambda x: datetime.utcfromtimestamp(x))
# figure2['time'] = figure2['time_obj'].transform(lambda x: int(x.strftime('%H%M%S')))


# # assuring all the wrong rounds are correct now (only the edge values)
# figure2.loc[(figure2.min_time_round >= 900 ),'min_time_round']= 900
# figure2.loc[(figure2.min_time_round == 0 ),'min_time_round']= 30

# # taking only one record for each aircraft
# figure2_grouped = figure2.groupby(['flightID', 'min_time_round']).head(1)

# x_ticks = list(range(30,930,30))
# fig, ax = plt.subplots(1, 1)
# plot = figure2_grouped.plot(x="min_time_round", y="time",xticks = x_ticks,kind="scatter",figsize=(8,13),ax=ax)
# #plot.set_yticklabels(y_labels)
# plot.set_xlabel("Min time to final [sec]",fontsize=19)
# plot.set_ylabel("Time",fontsize=19)
# plt.savefig('Plots\figure2_ESGG_c5.jpg',bbox_inches="tight")
# plt.show() 

