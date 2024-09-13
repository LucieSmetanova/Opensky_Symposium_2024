## TT FUL DATASET SERVER
# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sklearn.preprocessing
import seaborn as sns
from itertools import product
from datetime import datetime
#function for triangle calculation 
import math

# Continue with the same try-except block to log errors

flights = pd.read_csv('Cluster Data/osn_ESGG_states_TMA_rwy03_2019_04_cluster2.csv', 
header=0,
sep=' '
) 
name_str = 'osn_ESGG_dataset'

#list_col_names = ['x','xx','flightID', 'sequence', 'timestamp', 'lat', 'lon', 'rawAltitude', 'baroAltitude', 'velocity','endDate','date','datetime','month']
#flights.columns = list_col_names

flights_filtered = flights.copy()
print(flights_filtered.head(1))
flights_filtered['time_obj'] = flights_filtered['timestamp'].transform(lambda x: datetime.utcfromtimestamp(x))
flights_filtered['time'] = flights_filtered['time_obj'].transform(lambda x: int(x.strftime('%H%M%S')))
#pd.DataFrame(flights_filtered).to_csv(r'C:\Users\lucsm87\Desktop\TMA-KPI Project\PHD\Opensky_data\flights_filtered.csv')

# for this dataset where we have only part of data I need to add border values

if name_str[4:8] == 'ESGG':
    ATM = flights_filtered
    df1 = pd.DataFrame({"flightID":['xxx'],"sequence":[0],"timestamp":[0],"lat":[58.7661], "lon":[13.3244],"rawAltitude":[0],"baroAltitude":[0],"velocity":[0],"endDate":[0]})
    #ATM = ATM.append(df1,ignore_index = True)
    ATM = pd.concat([ATM,df1],ignore_index=True)
    df2 = pd.DataFrame({"flightID":['xxx'],"sequence":[0],"timestamp":[0],"lat":[56.9856], "lon":[11.1406],"rawAltitude":[0],"baroAltitude":[0],"velocity":[0],"endDate":[0]})
    #ATM = ATM.append(df2,ignore_index = True)
    ATM = pd.concat([ATM,df2],ignore_index=True)
    grid_x = 71
    grid_y = 107



lon = ATM['lon']                                                                    # extracting longotide and latitude from the array
lat = ATM['lat']
lon = np.array(lon)
lat = np.array(lat)
# CHOOSING THE GRANULARITY OF THE GRID!!! 
# First, creating list of X and Y for min.time plots (list creating function, used lower)
def createList(r1, r2): 
    return [item for item in range(r1, r2+1)] 

def distance(p11,p12,p21,p22):
    return math.hypot(p11-p21, p12-p22)


lon_norm = sklearn.preprocessing.minmax_scale(lon, feature_range=(0, grid_x),copy=True)  # standardizing data into given range
lat_norm = sklearn.preprocessing.minmax_scale(lat, feature_range=(0, grid_y),copy=True)

ATM['lon_norm'] = lon_norm            # copying standardized data column to the end of an array
ATM['lat_norm'] = lat_norm            # copying standardized data column to the end of an array

#### EIDW POLYGON
def takeClosest(num,collection):
   return min(collection,key=lambda x:abs(x-num))

if name_str[4:8] == 'ESGG':
    polygon_lat = [58.7661, 58.7328, 58.5169, 58.2953, 58.0969, 57.7672, 57.2275, 56.9856, 57.2136, 57.7514, 58.1278, 58.6456, 58.4653, 58.7661]
    polygon_lat_norm = pd.Series([])
    polygon_lon = [12.4975, 13.1639, 13.3244, 13.3244, 13.2769, 13.1992, 12.6958, 11.7661, 11.5828, 11.1406, 11.4503, 12.2956, 11.9975, 12.4975]
    polygon_lon_norm = pd.Series([])
    pd.DataFrame(ATM).to_csv('Output_files/ATM.csv')

    for i in polygon_lat:
        if ATM.loc[(ATM['lat'] == i)].empty == True:
            i = takeClosest(i, ATM['lat'])
            value = ATM.loc[(ATM['lat'] == i)]['lat_norm'].head(1).item()
        else:
            value = ATM.loc[(ATM['lat'] == i)]['lat_norm'].head(1).item()
        #polygon_lat_norm = polygon_lat_norm.append(pd.Series([value]))
        polygon_lat_norm = pd.concat([polygon_lat_norm,pd.Series([value])],ignore_index=True)
        
    for i in polygon_lon:
        if ATM.loc[(ATM['lon'] == i)].empty == True:
            i = takeClosest(i, ATM['lon'])
            value = ATM.loc[(ATM['lon'] == i)]['lon_norm'].head(1).item()
        else:
            value = ATM.loc[(ATM['lon'] == i)]['lon_norm'].head(1).item()
        #polygon_lon_norm = polygon_lon_norm.append(pd.Series([value]))
        polygon_lon_norm = pd.concat([polygon_lon_norm,pd.Series([value])],ignore_index=True)
    
    ESGG_polygon = pd.concat([polygon_lat_norm, polygon_lon_norm], axis=1)
    ESGG_polygon.columns = ['lat_norm','lon_norm']
    ESGG_polygon = ESGG_polygon.reset_index(drop = True)
    area_fin = pd.Series([])
    for i in range(len(ESGG_polygon)-1):
        a1 = ESGG_polygon['lon_norm'][i]
        a2 = ESGG_polygon['lat_norm'][i]
        b1 = ESGG_polygon['lon_norm'][i+1]
        b2 = ESGG_polygon['lat_norm'][i+1]
        c1 = 12
        c2 = 58
        side_a = distance(a1, a2, b1, b2)
        side_b = distance(b1,b2,c1,c2)
        side_c = distance(c1,c2,a1,a2)
        s = 0.5 * ( side_a + side_b + side_c)
        area_triangle = math.sqrt(s * (s - side_a) * (s - side_b) * (s - side_c))
        #area_fin = area_fin.append(pd.Series([area_triangle]))
        area_fin = pd.concat([area_fin,pd.Series([area_triangle])],ignore_index=True)
    total_TMA = area_fin.sum()
    pd.DataFrame(ESGG_polygon).to_csv('Output_files/ESGG_polygon.csv')


pd.DataFrame(ATM).to_csv('Output_files/ATM_LOWW_TT.csv')
print('POLYGONS DONE')
# ==================================== SELECTING SUBSET OF DATA =========================================
airport = name_str[4:8]
week = name_str[28:33]
runway = name_str[34:]
name3 = 'subsets_' + airport + '_' +week + '_' + runway + 'above_25'
gran = str(grid_y)+'x'+str(grid_x)


is_the_day = ATM
is_the_day.drop(is_the_day[is_the_day['flightID'] == 'xxx'].index, inplace = True)
is_the_day = is_the_day.reset_index()
is_the_day = is_the_day.drop(list(is_the_day)[0:1], axis=1)
Grid_frame = is_the_day
print('DATA SELECTION DONE')
# ================================= PLOT OF FLIGHT TRAJECTORIES ============================================

# fig, ax = plt.subplots(figsize=(6,9))
# for i, g in Grid_frame.groupby(['flightID','endDate']):
#     g.plot(x='lon_norm', y='lat_norm', ax=ax, label=str(i))
# #plt.title(str(title) + ' number of flights:' + str(number_of_flights))
# ax.xaxis.set_ticks(np.arange(0, grid_x+1, 5))  ## GRID CHANGE !!! 
# ax.yaxis.set_ticks(np.arange(0, grid_y+1, 5))
# plt.xlabel('X - coordinates')
# plt.ylabel('Y - coordinates')
# plt.xticks(fontsize=16)
# plt.yticks(fontsize=16)

# if name_str[4:8] == 'EIDW':
#     plot1 = EIDW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()
    
# elif name_str[4:8] == 'LOWW':
#     plot1 = LOWW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()
    
# elif name_str[4:8] == 'ESSA':
#     plot1 = ESSA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()

# else:
#     axes = plt.gca()
#     axes.set_xlim([0,grid_x])                                                               #setting limits for axes
#     axes.set_ylim([0,grid_y])

# axes.legend().set_visible(False)
# axes.grid()
# plt.savefig('Output_files/trajectory')

#================================= CALCULATION OF MINIMUM TIME TO GO FOR EACH CELL ===========================================
Grid_frame['X'] = [math.ceil(x) for x in Grid_frame['lon_norm']]
Grid_frame['Y'] = [math.ceil(x) for x in Grid_frame['lat_norm']]

# extracting only columns which I am going to use in the next steps to ensure lower CPU usage during computation
Grid_frame2 = Grid_frame[['flightID', 'timestamp','endDate','X','Y']].copy()  

# trying to  make a list of x,y combinations and their minimum time to final values
Grid_frame2['time_in_final'] = Grid_frame2.groupby(['flightID','endDate'])['timestamp'].transform('max')
Grid_frame2['entering_time'] = Grid_frame2.groupby(['flightID','endDate'])['timestamp'].transform('min')

number_of_flights = Grid_frame2['flightID'].nunique()
Grid_frame2['time_to_final'] = Grid_frame2['time_in_final'] - Grid_frame2['timestamp']
print('TIME TO/IN FINAL DONE')
grouped = Grid_frame2.groupby(['X', 'Y'],as_index=False)
min_time = grouped.agg({'time_to_final': 'min'})
min_time = min_time.rename(columns={"time_to_final": "min_time"})
min_time_result = min_time
occupancy_count = len(min_time_result)
print('MIN TIME PART 1 DONE')
# finding overlaps for each flight (which aircraft were present during flight of a given aircraft)    
flight = Grid_frame2.groupby(['flightID','endDate']).head(1)
flight.index=range(0,len(flight))
print('MIN TIME DONE')
# ============================ MINIMUM TIME VISUALISATION=================================================
# making dataset with all combinations of x,y to assure good plots
X = createList(1,grid_x)
Y = createList(1,grid_y)

min_time_list = pd.DataFrame(list(product(X, Y)), columns=['X', 'Y'])

min_time = pd.merge(min_time, min_time_list, on=['X', 'Y'],how='outer')
fillnans = min_time.min_time.max() + 450
min_time = min_time.fillna(fillnans)
total_area = len(min_time)
occupancy_percent = round(occupancy_count/(total_TMA/100),2)
#min_time = min_time.fillna(0)
# rounding minimum time values to nearest 50
min_time_rounded = pd.Series([])
min_time_rounded = min_time.min_time*2

for i in range(len(min_time_rounded)):
    min_time_rounded[i] = (min_time_rounded[i].round(-2))/2
    
min_time.insert(3,"min_time_rounded",min_time_rounded)

# decreasing values x,y by 0.5 for the heatmap to have all cells filled and not shifted the filling (build in function fills another way)
X_half = pd.Series([])
Y_half = pd.Series([])
X_half = min_time.X - 0.5
Y_half = min_time.Y - 0.5

# decreaing values of x,y by 1 to assure the contour plot to fill the right cells (build in function fills another way)
x_small = pd.Series([])
y_small = pd.Series([])
x_small = min_time.X - 1
y_small = min_time.Y - 1

min_time.insert(4,"x_half",X_half)
min_time.insert(5,"y_half",Y_half)

min_time.insert(6,"x_small",x_small)
min_time.insert(7,"y_small",y_small)



# making pivot tables for plotting (Y values are on the y axis, X values are at x-axis and min_time values are as Z (assigned values for color))
min_times = min_time.pivot(index="y_half",columns= "x_half",values= "min_time_rounded")
min_times2 = min_time.pivot(index="y_small",columns= "x_small", values="min_time")
min_time2 = min_time.pivot(index="Y",columns="X",values="min_time_rounded")
#fillnans = min_time.min_time.max() + 350
#min_time2 = min_time2.fillna(fillnans)

values2 = [fillnans]
min_time2.insert(grid_x,"10",fillnans)
#min_time2 = min_times2.append(values2,ignore_index=True)
min_time2 = pd.concat([min_times2,pd.Series([values2])],ignore_index=True)
min_time2 = min_time2.fillna(fillnans)
# renaming the added column for consistency with the grid granularity
min_time2.rename(columns = {'10':grid_x},  
            inplace = True)

min_times3 = min_times2
min_times3["10"] = fillnans
#min_times3 = min_times3.append(values2, ignore_index = True)
min_times3 = pd.concat([min_times3,pd.Series([values2])],ignore_index=True)
min_times3 = min_times3.fillna(fillnans)

# renaming the added column for consistency with the grid granularity
min_times3.rename(columns = {'10':grid_x},  
            inplace = True)

# using another axis labels than the plot gives
x_labels = range(0,grid_x+1,5)
y_labels = range(0,grid_y+1,5)
new_ticks_X = np.linspace(0,grid_x,5)
new_ticks_Y = np.linspace(0,grid_y,5)

min_min_time = min_time_result.min_time.min()
max_min_time = min_time_result.min_time.max()
avg_min_time = round(min_time_result.min_time.mean())
s2_min_time = round(min_time_result.min_time.std())


# making my own colormap
import matplotlib.colors
cmap = matplotlib.colors.LinearSegmentedColormap.from_list("", ["midnightblue","navy","teal","darkcyan","mediumseagreen","limegreen","yellowgreen","yellow","white","white"])
cmap2 = matplotlib.colors.LinearSegmentedColormap.from_list("", ["black","maroon","darkred","firebrick","red","r","darkorange","orange","gold","yellow","white","white"])
cmap3 = matplotlib.colors.LinearSegmentedColormap.from_list("", ["black","maroon","darkred","firebrick","red","r","darkorange","orange","gold","yellow","white","white","lightcyan","paleturquoise","powderblue","lightblue","lightskyblue","skyblue","skyblue","darkturquoise","c","c","darkcyan","darkcyan","teal","darkslategrey","white","white"])
cmap4 = matplotlib.colors.LinearSegmentedColormap.from_list("", ['white','yellow','gold','orange','darkorange','r','red','firebrick','darkred','maroon','black',"black"])
cmap5 = matplotlib.colors.LinearSegmentedColormap.from_list("", ['crimson','orangered','orange','lemonchiffon','lightyellow','greenyellow','palegreen','mediumturquoise','cornflowerblue','royalblue','rebeccapurple','white'])

# heatmap plot of minimum time
# fig, ax = plt.subplots(figsize=(6,9))
# sns.heatmap(min_times,cmap=cmap5,cbar_kws={'label': 'Minimum time [seconds]'},yticklabels=5,xticklabels=5,vmin=0, vmax=1250, ax=ax)
# ax.invert_yaxis()

# if name_str[4:8] == 'EIDW':
# #    ax.set_xlim([35,110])                                                               #setting limits for axes
# #    ax.set_ylim([0,120])
#     plot1 = EIDW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()

# if name_str[4:8] == 'ESSA':
#     ax.set_xlim([0,grid_x])                                                               #setting limits for axes
#     ax.set_ylim([0,grid_y])
#     plot1 = ESSA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()

# if name_str[4:8] == 'LOWW':
#     plot1 = LOWW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
#     axes = plt.gca()
# ax.grid()
# ax.legend().set_visible(False)
# ax.set_xticklabels([*range(0, grid_x-2, 5)]) 
# ax.set_yticklabels([*range(0, grid_y-2, 5)]) 
# plt.savefig('Output_files/heatmap')

pd.DataFrame(min_time).to_csv('Output_files/min_time_ESGG_c5.csv')
pd.DataFrame(Grid_frame).to_csv('Output_files/Grid_frame_ESGG_c5.csv')
pd.DataFrame(Grid_frame2).to_csv('Output_files/Grid_frame2_ESGG_c5.csv')
pd.DataFrame(min_times).to_csv('Output_files/min_times_ESGG_c5.csv')
pd.DataFrame(flight).to_csv('Output_files/flight_ESGG_c5.csv')
pd.DataFrame(min_time_result).to_csv('Output_files/min_time_result_ESGG_c5.csv')
print ('ALL DONE')
print ('OCCUPANCY TOTAL')
print(total_TMA)
print('OCCUPANCY PERCENT')
print(occupancy_percent)