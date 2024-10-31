import pandas as pd                                               #library for data manipulation and analysis
import matplotlib.pyplot as plt
import numpy as np
import sklearn.preprocessing
import seaborn as sns
from itertools import product
import os
from datetime import datetime
#import statistics
import math

#--------------- FOR OPTIMIZED TRAJECTORIES ---------------------------

flights = pd.read_csv('Data/ESGG_190410_optimized_trajectories_with_IDs.csv', 
header=None,
sep=','
) 
list_col_names = ['time_to_go', 'timestamp','flightID','dist_to_go','MACH','TAS','CAS','baroAltitude', 'velocity','lat','lon','CL','CD','fuel_flow','fuel_burnt','thrust','smd']
flights.columns = list_col_names
flights1 = flights
#--------------------- IF ACTUAL TRAJECTORIES, USE THIS INSTEAD -------------
# flights = pd.read_csv('Data/ESGG_190410_actual_trajectories_with_IDs.csv', 
# header=None,
# sep=','
# ) 
# list_col_names = ['time_to_go', 'timestamp','flightID','dist_to_go','MACH','TAS','CAS','baroAltitude', 'velocity','lat','lon','CL','CD','fuel_flow','fuel_burnt','thrust']
# flights.columns = list_col_names
# flights1 = flights
#--------------- FOR OPTIMIZATION EVALUATION PER CLUSTER----------------
# df = pd.read_csv('osn_ESGG_states_TMA_rwy03_2019_04_cluster6.csv', 
# header=0,
# sep=' '
# ) 

# ids = df['flightID'].unique()

# flights1 = flights[flights['flightID'].isin(ids)]
#-------------------------------------------------------------------------

TMA_polygon = pd.read_csv('Data/ESGG_polygon.csv', 
header=0,
sep=','
) 


flights_filtered = flights1.copy()
flights_filtered['time_obj'] = flights_filtered['timestamp'].transform(lambda x: datetime.utcfromtimestamp(x))
flights_filtered['time'] = flights_filtered['time_obj'].transform(lambda x: int(x.strftime('%H%M%S')))
#pd.DataFrame(flights_filtered).to_csv(r'C:\Users\lucsm87\Desktop\TMA-KPI Project\PHD\Opensky_data\flights_filtered.csv')

# change for specific airport (ESGG TMA now)
grid_x = 71
grid_y = 107
total_TMA = grid_x*grid_y
ATM = flights_filtered 
df1 = pd.DataFrame({"flightID":['xxx'],"sequence":[0],"timestamp":[0],"lat":[58.7661], "lon":[13.3244],"rawAltitude":[0],"baroAltitude":[0],"velocity":[0],"endDate":[0]})
ATM = pd.concat([ATM,df1],ignore_index=True)
df2 = pd.DataFrame({"flightID":['xxx'],"sequence":[0],"timestamp":[0],"lat":[56.9856], "lon":[11.1406],"rawAltitude":[0],"baroAltitude":[0],"velocity":[0],"endDate":[0]})
ATM = pd.concat([ATM,df2],ignore_index=True)


lon = ATM['lon']                                                                    # extracting longotide and latitude from the array
lat = ATM['lat']
lon = np.array(lon)
lat = np.array(lat)
# First, creating list of X and Y for min.time plots (list creating function, used lower)
def createList(r1, r2): 
    return [item for item in range(r1, r2+1)] 

def distance(p11,p12,p21,p22):
    return math.hypot(p11-p21, p12-p22)


lon_norm = sklearn.preprocessing.minmax_scale(lon, feature_range=(0, grid_x),copy=True)  # standardizing data into given range
lat_norm = sklearn.preprocessing.minmax_scale(lat, feature_range=(0, grid_y),copy=True)

ATM['lon_norm'] = lon_norm            # copying standardized data column to the end of an array
ATM['lat_norm'] = lat_norm            # copying standardized data column to the end of an array


ATM.drop(ATM[ATM['flightID'] == 'xxx'].index, inplace = True)#### EIDW POLYGON
def takeClosest(num,collection):
   return min(collection,key=lambda x:abs(x-num))


#==================================== SELECTING SUBSET OF DATA =========================================

column_names = ['Date', 'Hour_start', 'Time_to_final','Metering_effort']
metering_effort_EIDW = pd.DataFrame(columns=column_names)
column_names = ['Date', 'Hour_start', 'Time_to_final','Sequencing_effort']
sequencing_effort_EIDW = pd.DataFrame(columns=column_names)
for m in range(190410,190411,1):
    column_names = ["time","date","total_a/c","min","max","average","median","std"]
    statistic_add_t = pd.DataFrame(columns = column_names)
    column_names = ["time","date","total_a/c","entry_throughput","time_in_TMA_(s)_min","time_in_TMA_(s)_max","time_in_TMA_(s)_avg","time_in_TMA_(s)_median","dist_in_TMA_(nm)_min","dist_in_TMA_(nm)_max","dist_in_TMA_(nm)_avg","dist_in_TMA_(nm)_median","min_time_(s)_max","min_time_(s)_avg","min_time_(s)_median","SD_(s)_min","SD_(s)_max","SD_(s)_avg","SD_(s)_median","SD_(s)_std","Quantile_width","SE_max","SE_min","SE_avg","SE_median","SE_std","throughput_(#a/c)_max","throughput_(#a/c)_avg","throughput_(#a/c)_median","throughput_(#a/c)_std","ME_min","ME_max","ME_avg","ME_median","ME_std","SP_(#a/c)_max","SP_(#a/c)_avg","SP_(#a/c)_median","SP_(#a/c)_std"]
    statistic = pd.DataFrame(columns = column_names)
    for j in range(0,240000,240000):
        date = m
        date_start= date
        date_end = m
        start_hour =j
        end_hour =j+240000
        date_str = str(date)
        start_str = str(start_hour)[0:2]
        end_str = str(end_hour)[0:2]
        month = date_str[2:4] 
        if len(start_str) == 6:
            start = start_str[:2]
        else:
            start = start_str[:1]
        if len(end_str) == 6:
            end = end_str[:2]
        else:
            end = end_str[:1]
            

#        is_the_day = ATM
        is_the_hour = ATM
        #is_the_day['start'] = is_the_day.groupby(['flightID','endDate'])['time'].transform('min')
        # is_the_day = is_the_day.loc[((is_the_day['endDate'] >= date_start) & (is_the_day['endDate'] <= date_end))]
        # in_interval = is_the_day.loc[((is_the_day['time'] >= start_hour) & (is_the_day['time'] <= end_hour))]
        # in_interval = in_interval.groupby('flightID')['flightID'].head(1)
        # is_the_hour = pd.DataFrame()
        # for i in in_interval:
        #     df1 = is_the_day.loc[(is_the_day['flightID'] == i)]
        #     is_the_hour = is_the_hour.append(df1,ignore_index = True)
        
        # # only for the number of flights computaion (also just a dataframe from the array)
        if is_the_hour.empty:
            #Grid_frame = pd.DataFrame.from_records(is_the_day)
            print('NO FLIGHTS THIS HOUR')
            #import sys
            #sys.exit()
            continue
        else:
            Grid_frame = pd.DataFrame.from_records(is_the_hour)    
            number_of_flights = Grid_frame['flightID'].nunique()
            
            Grid_frame['endDate']=m
            # ================================= PLOT OF FLIGHT TRAJECTORIES ============================================
            fig, ax = plt.subplots(figsize=(9,9))
            for i, g in Grid_frame.groupby(['flightID']):#,'endDate']):
                g.plot(x='lon_norm', y='lat_norm', ax=ax, label=str(i))
            ax.xaxis.set_ticks(np.arange(0, grid_x+1, 5))  ## GRID CHANGE !!! 
            ax.yaxis.set_ticks(np.arange(0, grid_y+1, 5))
            ax.xaxis.label.set_visible(False)
            plt.xticks(fontsize=16)
            plt.yticks(fontsize=16)
            
            plot1 = TMA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
            # circle_center_lat = 60.200534
            # circle_center_lon = 11.0827
            # circle_center_lat_norm = Grid_frame.loc[(Grid_frame['lat'] == takeClosest(circle_center_lat, Grid_frame['lat']))]['lat_norm'].values[0]
            # circle_center_lon_norm = Grid_frame.loc[(Grid_frame['lon'] == takeClosest(circle_center_lon, Grid_frame['lon']))]['lon_norm'].values[0]
            plot1 = TMA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
            # radius = 150
            # circle1  = plt.Circle((circle_center_lon_norm, circle_center_lat_norm), radius, color='r', fill = False)
            # ax.add_patch(circle1)
            ax.xaxis.label.set_visible(False)
            axes = plt.gca()
            #axes.set_xlim([0,grid_x])                                                              
            #axes.set_ylim([0,grid_y])
    
            axes.legend().set_visible(False)
            axes.grid()
            plt.savefig('Output_files/_traj_numofflights_'+str(number_of_flights)+'_optim.jpg',bbox_inches="tight")
            plt.show()
                #================================= CALCULATION OF MINIMUM TIME TO GO FOR EACH CELL ===========================================           
    
            Grid_frame['X'] = [math.ceil(x) for x in Grid_frame['lon_norm']]
            Grid_frame['Y'] = [math.ceil(x) for x in Grid_frame['lat_norm']]
            
            Grid_frame.loc[Grid_frame['X'] > grid_x, 'X'] = grid_x
            Grid_frame.loc[Grid_frame['Y'] > grid_y, 'Y'] = grid_y

            print('XY DONE')
            # extracting only columns which I am going to use in the next steps to ensure lower CPU usage during computation
            Grid_frame2 = Grid_frame[['flightID', 'timestamp','endDate','X','Y']].copy()  
            
            # trying to  make a list of x,y combinations and their minimum time to final values
            Grid_frame2['time_in_final'] = Grid_frame2.groupby(['flightID','endDate'])['timestamp'].transform('max')
            Grid_frame2['entering_time'] = Grid_frame2.groupby(['flightID','endDate'])['timestamp'].transform('min')
            
            number_of_flights = Grid_frame2['flightID'].nunique()
            Grid_frame2['time_to_final'] = Grid_frame2['time_in_final'] - Grid_frame2['timestamp']
            
            grouped = Grid_frame2.groupby(['X', 'Y'],as_index=False)
            min_time = grouped.agg({'time_to_final': 'min'})
            min_time = min_time.rename(columns={"time_to_final": "min_time"})
            min_time_result = min_time.copy()
            occupancy_count = len(min_time_result)
            
            # finding overlaps for each flight (which aircraft were present during flight of a given aircraft)    
            flight = Grid_frame2.groupby(['flightID','endDate']).head(1)
            flight.index=range(0,len(flight))
            flight['flight_nr'] = range(1,len(flight)+1)
    
            # ============================ MINIMUM TIME VISUALISATION=================================================
            # making dataset with all combinations of x,y to assure good plots
            X = createList(1,grid_x)
            Y = createList(1,grid_y)
            
            min_time_list = pd.DataFrame(list(product(X, Y)), columns=['X', 'Y'])
            
            min_time = pd.merge(min_time, min_time_list, on=['X', 'Y'],how='outer')
            fillnans = min_time.min_time.max() + 850
            min_time = min_time.fillna(fillnans)
            total_area = len(min_time)
            occupancy_percent = round(occupancy_count/(total_TMA/100),2)
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
            min_times = min_time.pivot(index="y_half", columns="x_half", values="min_time_rounded")
            
            min_time2 = min_time[['X','Y','min_time']]
            Grid_frame = pd.merge(Grid_frame,min_time2,how='left',on=['X','Y'])
            Grid_frame = Grid_frame.rename(columns={'min_time': 'min_time_to_final'})
            Grid_frame['time_in_final'] = Grid_frame.groupby(['flightID'])['timestamp'].transform('max')

           
            #the same for PM structure polygon
            # lat_PM = [53.7803,54.1412,53.7094,53.6392,53.9650,53.6285,53.7671,53.5718,53.4031,53.1979,53.1276,53.0639,52.9967,52.7828,52.5544,53.1415,53.1713,53.0027,53.0494,52.8244,52.6228,53.420333,53.4225]
            # lon_PM = [7.2946,6.6511,6.6053,5.9592,5.7421,5.7659,5.5,5.6373,5.9456,5.6409,5.5669,5.5,5.3775,4.9925,5.5,5.8063,6.3669,6.6611,7.2702,6.9304,6.6301,6.2505,6.29]
            # lat_PM_n = pd.Series([])
            # lon_PM_n = pd.Series([])
            # for i in lat_PM:   
            #     if Grid_frame.loc[(round(Grid_frame['lat'],3) == round(i,3))].empty == True:
            #         i = takeClosest(i, Grid_frame['lat'])
            #         value = Grid_frame.loc[(Grid_frame['lat'] == i)]['lat_norm'].head(1).item()
            #     else:
            #         value = Grid_frame.loc[(round(Grid_frame['lat'],3) == round(i,3))]['lat_norm'].head(1).item()
            #     lat_PM_n = lat_PM_n.append(pd.Series([value]))
                
            # for i in lon_PM:
            #     if Grid_frame.loc[(round(Grid_frame['lon'],3) == round(-i,3))].empty == True:
            #         i = takeClosest(-i, Grid_frame['lon'])
            #         value = Grid_frame.loc[(Grid_frame['lon'] == i)]['lon_norm'].head(1).item()
            #     else:
            #         value = Grid_frame.loc[(round(Grid_frame['lon'],3) == round(-i,3))]['lon_norm'].head(1).item()
            #     lon_PM_n = lon_PM_n.append(pd.Series([value]))
            # lat_PM_n = lat_PM_n.reset_index(drop = True)
            # lon_PM_n = lon_PM_n.reset_index(drop = True)
            
            # #Now the RTs
            # RT1_lat = [lat_PM_n[0],lat_PM_n[2],lat_PM_n[3],lat_PM_n[5],lat_PM_n[7],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT2_lat = [lat_PM_n[1],lat_PM_n[2],lat_PM_n[3],lat_PM_n[5],lat_PM_n[7],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT3_lat = [lat_PM_n[4],lat_PM_n[5],lat_PM_n[7],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT4_lat = [lat_PM_n[6],lat_PM_n[5],lat_PM_n[7],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT5_lat = [lat_PM_n[18],lat_PM_n[17],lat_PM_n[16],lat_PM_n[15],lat_PM_n[9],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT6_lat = [lat_PM_n[19],lat_PM_n[17],lat_PM_n[16],lat_PM_n[15],lat_PM_n[9],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT7_lat = [lat_PM_n[20],lat_PM_n[17],lat_PM_n[16],lat_PM_n[15],lat_PM_n[9],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT8_lat = [lat_PM_n[14],lat_PM_n[15],lat_PM_n[9],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            # RT9_lat = [lat_PM_n[13],lat_PM_n[12],lat_PM_n[11],lat_PM_n[10],lat_PM_n[9],lat_PM_n[8],lat_PM_n[21],lat_PM_n[22]]
            
            # RT1_lon = [lon_PM_n[0],lon_PM_n[2],lon_PM_n[3],lon_PM_n[5],lon_PM_n[7],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT2_lon = [lon_PM_n[1],lon_PM_n[2],lon_PM_n[3],lon_PM_n[5],lon_PM_n[7],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT3_lon = [lon_PM_n[4],lon_PM_n[5],lon_PM_n[7],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT4_lon = [lon_PM_n[6],lon_PM_n[5],lon_PM_n[7],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT5_lon = [lon_PM_n[18],lon_PM_n[17],lon_PM_n[16],lon_PM_n[15],lon_PM_n[9],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT6_lon = [lon_PM_n[19],lon_PM_n[17],lon_PM_n[16],lon_PM_n[15],lon_PM_n[9],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT7_lon = [lon_PM_n[20],lon_PM_n[17],lon_PM_n[16],lon_PM_n[15],lon_PM_n[9],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT8_lon = [lon_PM_n[14],lon_PM_n[15],lon_PM_n[9],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            # RT9_lon = [lon_PM_n[13],lon_PM_n[12],lon_PM_n[11],lon_PM_n[10],lon_PM_n[9],lon_PM_n[8],lon_PM_n[21],lon_PM_n[22]]
            

            
    # # TRAJECTORY PLOT
    #         fig, ax = plt.subplots(figsize=(9,9))
    #         for i, g in Grid_frame.groupby(['flightID','endDate']):
    #             g.plot(x='lon_norm', y='lat_norm', ax=ax, label=str(i))
    #         ax.xaxis.set_ticks(np.arange(0, grid_x+1, 5))  ## GRID CHANGE !!! 
    #         ax.yaxis.set_ticks(np.arange(0, grid_y+1, 5))
    #         ax.xaxis.label.set_visible(False)
    #         plt.xticks(fontsize=16)
    #         plt.yticks(fontsize=16)
    #         if name_str[4:8] == 'EIDW':
    #             plot1 = EIDW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    #             circle_center_lat = 53.42
    #             circle_center_lon = 6.27
    #             circle_center_lat_norm = ATM.loc[(ATM['lat'] == takeClosest(circle_center_lat, ATM['lat']))]['lat_norm'].values[0]
    #             circle_center_lon_norm = ATM.loc[(ATM['lon'] == takeClosest(-circle_center_lon, ATM['lon']))]['lon_norm'].values[0]
    #             plot1 = EIDW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    #             radius = 50
    #             circle1  = plt.Circle((circle_center_lon_norm, circle_center_lat_norm), radius, color='r', fill = False)
    #             ax.add_patch(circle1)
    #             ax.xaxis.label.set_visible(False)
    #             axes = plt.gca()
    #             axes.set_xlim([0,100])                                                              
    #         elif name_str[4:8] == 'LOWW':
    #             plot1 = LOWW_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    #             axes = plt.gca()
    #         elif name_str[4:8] == 'ESSA':
    #             plot1 = ESSA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
    #             axes = plt.gca()
    #         else:
    #             axes = plt.gca()
    #             axes.set_xlim([0,grid_x])                                                               #setting limits for axes
    #             axes.set_ylim([0,grid_y])
    #         axes.legend().set_visible(False)
    #         axes.grid()
    #         plt.savefig(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\_trajectory'+str(name)+'numofflights_'+str(number_of_flights)+'FULL_HEATMAP__optim.jpg',bbox_inches="tight")
    #         plt.show()
            
    # INTER-ARRIVAL TIMES STATISTIC    
            # frame_head = frame_res.groupby(['flightID']).head(1)
            # interarr_time = frame_head.sort_values(['timestamp'],ascending=False).reset_index(drop = True)
            # interarr_time['difference'] = interarr_time['timestamp'].diff()*(-1)
            # interarr_time2 = interarr_time.dropna()
           
   
            # if interarr_time2.empty == True:
            #     intertime_min = 'not reached'
            #     intertime_max = 'not reached'
            #     intertime_avg = 'not reached'
            #     intertime_std = 'not reached'
            #     intertime_median = 'not reached'

            # else:
            #     intertime_min = interarr_time2.difference.min()
            #     intertime_max = interarr_time2.difference.max()
            #     intertime_avg = round(interarr_time2.difference.mean())
            #     intertime_median = interarr_time2.difference.median()
            #     intertime_std = interarr_time2.difference.std()
            #     if math.isnan(intertime_std) == True:
            #         intertime_std = 0
    
            # pd.DataFrame(interarr_time).to_csv(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name}\\interarr_time'+str(name2)+'FULL_HEATMAP_.csv')
    
    
    # # MINIMUM TIME TO FINAL 
            x_labels = range(0,grid_x+6,5)
            y_labels = range(0,grid_y+1,5)
            # new_ticks_X = np.linspace(0,grid_x+6,5)
            # new_ticks_Y = np.linspace(0,grid_y+1,5)
            
            min_min_time = min_time_result.min_time.min()
            max_min_time = min_time_result.min_time.max()
            avg_min_time = round(min_time_result.min_time.mean())
            s2_min_time = round(min_time_result.min_time.std())
            median_min_time = round(min_time_result.min_time.median())
            # making my own colormap
            import matplotlib.colors
            cmap = matplotlib.colors.LinearSegmentedColormap.from_list("", ["midnightblue","navy","teal","darkcyan","mediumseagreen","limegreen","yellowgreen","yellow","white","white"])
            cmap2 = matplotlib.colors.LinearSegmentedColormap.from_list("", ["black","maroon","darkred","firebrick","red","r","darkorange","orange","gold","yellow","white","white"])
            cmap3 = matplotlib.colors.LinearSegmentedColormap.from_list("", ["black","maroon","darkred","firebrick","red","r","darkorange","orange","gold","yellow","white","white","lightcyan","paleturquoise","powderblue","lightblue","lightskyblue","skyblue","skyblue","darkturquoise","c","c","darkcyan","darkcyan","teal","darkslategrey","white","white"])
            cmap4 = matplotlib.colors.LinearSegmentedColormap.from_list("", ['white','yellow','gold','orange','darkorange','r','red','firebrick','darkred','maroon','black',"black"])
            cmap5 = matplotlib.colors.LinearSegmentedColormap.from_list("", ['crimson','orangered','orange','lemonchiffon','lightyellow','greenyellow','palegreen','mediumturquoise','cornflowerblue','royalblue','rebeccapurple','white'])
            
            # heatmap plot of minimum time
            fig, ax = plt.subplots(figsize=(11,9))
            sns.heatmap(min_times,cmap=cmap5,cbar_kws={'label': 'Minimum time [seconds]'},yticklabels=1,xticklabels=1,vmin=0, vmax=1000, ax=ax)
            ax.invert_yaxis()
            ax.xaxis.label.set_visible(False)
            ax.yaxis.label.set_visible(False)
            #ax.set_ylim([0,100])                                                              
            # circle_center_lat = 60.200534
            # circle_center_lon = 11.0827
            # circle_center_lat_norm = ATM.loc[(ATM['lat'] == takeClosest(circle_center_lat, ATM['lat']))]['lat_norm'].values[0]
            # circle_center_lon_norm = ATM.loc[(ATM['lon'] == takeClosest(circle_center_lon, ATM['lon']))]['lon_norm'].values[0]
            # plot1 = TMA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
            # radius = 150
            # circle1 = plt.Circle((circle_center_lon_norm, circle_center_lat_norm), radius, color='r', fill = False)
            # ax.add_patch(circle1)
            plot1 = TMA_polygon.plot(x="lon_norm", y="lat_norm",color = 'black', linewidth=2,kind="line",ax=ax)
            axes = plt.gca()
            ax.grid()
            ax.legend().set_visible(False)
            #ax.set_xlim([0,300]) 
            # ax.xaxis.set_ticks(np.arange(0, grid_x+1, 5))  ## GRID CHANGE !!! 
            # ax.yaxis.set_ticks(np.arange(0, grid_y+1, 5))
            # ax.set_xticklabels([*range(0, grid_x+1, 5)]) 
            # ax.set_yticklabels([*range(0, grid_y+1, 5)]) 
            ax.set_xticklabels(list(range(0, grid_x, 1)),fontsize=17) 
            ax.set_yticklabels(list(range(0,grid_y,1)),fontsize=17) 
            for index, label in enumerate(ax.xaxis.get_ticklabels()):
                if index % 5 != 0:
                    label.set_visible(False)
            for index, label in enumerate(ax.yaxis.get_ticklabels()):
                if index % 5 != 0:
                    label.set_visible(False)
            ax.figure.axes[-1].yaxis.label.set_size(25)
            ax.figure.axes[-1].tick_params(labelsize=17) 
            plt.savefig('Output_files/heatmap_optim.jpg',bbox_inches="tight")
            plt.show()
    
    # #SPACING DEVIATION
            flight = flight.sort_values(by=['time_in_final'])
            flight.index=range(0,len(flight))
            if number_of_flights > 1:
                column_names = ["leader","leader_nr", "trailer", "trailer_nr"]
                pairs = pd.DataFrame(columns = column_names)
                for i in range(len(flight)):
                    if i == (len(flight) - 1):
                        pass
                    else:
                        pair=pd.DataFrame({"leader":[flight.flightID[i]],"leader_nr":[flight.flight_nr[i]],"trailer":[flight.flightID[i+1]],"trailer_nr":[flight.flight_nr[i+1]]})
                        # pairs = pairs.append(pair,ignore_index = True)
                        pairs = pd.concat([pairs,pair],ignore_index=True)
                pair_nr = range(1,len(pairs)+1,1)
                pairs.insert(4,"pair_nr",pair_nr)
                interval_start = pd.Series([])
                for i in range(len(pairs)):
                    interval_start[i] = int(flight.loc[(flight.flight_nr == pairs.trailer_nr[i])]['entering_time'])
                    
                interval_start.index = range(0,len(interval_start))
                interval_end = pd.Series([])
                for i in range(len(pairs)):
                    interval_end[i] = int(flight.loc[(flight.flight_nr == pairs.trailer_nr[i])]['time_in_final'])
                pairs.insert(5,"interval_start",interval_start)
                pairs.insert(6,"interval_end",interval_end)
                
                time_separation = pd.Series([])
                for i in range(len(flight)-1):
                    time_separation[i] = abs(flight.time_in_final[i] - flight.time_in_final[i+1])
                pairs.insert(7,"time_sep",time_separation)
                
                column_names = ["pair_ID","time_to_final", "leader_X", "leader_Y","trailer_X","trailer_Y"]
                spacing_dev2 = pd.DataFrame(columns = column_names)
                n = Grid_frame.groupby('flightID').size().min()
                timestamps_2 = [*range(0, 900, 10)] 
                timestamps_2 = pd.Series(timestamps_2, name='timestamp')
                df1 = [900]
                df2 = pd.Series(df1, name='timestamp')
                # timestamps_2 = timestamps_2.append(df2,ignore_index = True)
                timestamps_2 = pd.concat([timestamps_2,df2],ignore_index=True)
                timestamps_2 = timestamps_2.reset_index()
                timestamps_2 = timestamps_2.drop(list(timestamps_2)[0], axis=1)
                timestamps_2 = timestamps_2.sort_values(by=['timestamp'],ascending = False)
                timestamps_2 = timestamps_2.reset_index()
                timestamps_2 = timestamps_2.drop(list(timestamps_2)[0], axis=1)
                column_names = ["leader_err","trailer_err"]
                error_spd = pd.DataFrame(columns = column_names)
                Grid_frame2['flightID'] = Grid_frame2['flightID'].astype(str)
                for i in range(len(pairs)):
                    for j in timestamps_2.timestamp:
                        leader_time = takeClosest(j,Grid_frame2.loc[(Grid_frame2['flightID'] == str(pairs.leader[i]))]['time_to_final'])
                        trailer_time = takeClosest(j,Grid_frame2.loc[(Grid_frame2['flightID'] == str(pairs.trailer[i]))]['time_to_final'])
                        leader_x = Grid_frame2.loc[((Grid_frame2['time_to_final']==int(leader_time)) & (Grid_frame2['flightID']==str(pairs.leader[i])))]['X']
                        leader_y = Grid_frame2.loc[((Grid_frame2['time_to_final']==int(leader_time)) & (Grid_frame2['flightID']==str(pairs.leader[i])))]['Y']
                        trailer_x = Grid_frame2.loc[((Grid_frame2['time_to_final']==int(trailer_time)) & (Grid_frame2['flightID']==str(pairs.trailer[i])))]['X']
                        trailer_y = Grid_frame2.loc[((Grid_frame2['time_to_final']==int(trailer_time)) & (Grid_frame2['flightID']==str(pairs.trailer[i])))]['Y']
                        df1 = pd.DataFrame({"pair_ID":[pairs.pair_nr[i]],"time_to_final":[j],"leader_X":[int(leader_x.values[0])],"leader_Y":[int(leader_y.values[0])],"trailer_X":[int(trailer_x.values[0])],"trailer_Y":[int(trailer_y.values[0])]})
                        # spacing_dev2 = spacing_dev2.append(df1,ignore_index = True)
                        spacing_dev2 = pd.concat([spacing_dev2,df1],ignore_index=True)
                
                error_spd['error_fin'] = error_spd['leader_err']+error_spd['trailer_err']
                
                # calculation of spacing deviation for each pair   
                spacing_dev2.insert(6,"sp_d_sec","")   
                spacing_dev2 = spacing_dev2.reset_index(drop=True)
                for i in range(len(spacing_dev2)):
                    min_time_trailer = int(min_time.loc[((min_time['X'] == spacing_dev2['trailer_X'][i]) & (min_time['Y'] == spacing_dev2['trailer_Y'][i]))]['min_time'])  
                    min_time_leader = int(min_time.loc[((min_time['X'] == spacing_dev2['leader_X'][i]) & (min_time['Y'] == spacing_dev2['leader_Y'][i]))]['min_time'])
                    spacing_dev2.sp_d_sec[i] = int(min_time_trailer - min_time_leader) 
                
                # numbering intervals for easier orientation in the dataframe
                spacing_dev2.insert(7,"interval_nr","")
                spacing_dev2.interval_nr = spacing_dev2.groupby(['pair_ID'])['pair_ID'].cumcount()
                # method 2 as well but final deviations to zero
                last_dev = pd.Series([])
                zyx= [] # empty array for final point time for each row
                zyx = spacing_dev2.groupby('pair_ID').tail(1)
                zyx = zyx[['pair_ID', 'sp_d_sec']].copy() 
                zyx.index=range(0,len(zyx))
                #assignment of final time to each row
                for i in range(len(spacing_dev2)):
                    for j in range(len(zyx)):
                        if spacing_dev2.pair_ID[i] == zyx.pair_ID[j]:
                            last_dev[i] = zyx.sp_d_sec[j]
                spacing_dev2.insert(8, "last_dev", last_dev)
                
                recalculated_dev = pd.Series([])
                for i in range(len(spacing_dev2)):
                    recalculated_dev[i] = spacing_dev2.sp_d_sec[i] - spacing_dev2.last_dev[i]
                spacing_dev2.insert(9,"recalculated_dev",recalculated_dev)
                # making range for intervals
                # time_to_final_groups = range(0,1100,100)
                # intervals = pd.Series([])
                # # making a dataframe with intervals
                # for i in range(len(time_to_final_groups)-1):
                #     intervals[i] = pd.Interval(time_to_final_groups[i],time_to_final_groups[i+1],closed='both')
                # intervals[10] = pd.Interval(0,0,closed='both')
                # intervals = intervals.sort_values()
                # intervals = intervals.reset_index()
                # intervals = intervals.drop(list(intervals)[0], axis=1)
        
                spacing_dev2['quantile05'] = spacing_dev2.groupby(['time_to_final'])['recalculated_dev'].transform(lambda x: x.quantile(.05))
                spacing_dev2['quantile95'] = spacing_dev2.groupby(['time_to_final'])['recalculated_dev'].transform(lambda x: x.quantile(.95))
                max_dev = abs(spacing_dev2.loc[(spacing_dev2.time_to_final <= (900))]['recalculated_dev'].max())
                min_dev = spacing_dev2.loc[(spacing_dev2.time_to_final <= 900)]['recalculated_dev'].min()
                avg_dev = round(spacing_dev2.loc[(spacing_dev2.time_to_final <= (900))]['recalculated_dev'].mean(),2)
                median_dev = round(spacing_dev2.loc[(spacing_dev2.time_to_final <= (900))]['recalculated_dev'].median(),2)
                s2_dev = round(spacing_dev2.loc[(spacing_dev2.time_to_final <= (900))]['recalculated_dev'].std(),2)
                # calculation of quantile width
                spacing_dev2['quantile_width'] = spacing_dev2.quantile95 - spacing_dev2.quantile05
                quantile_width = spacing_dev2.loc[(spacing_dev2.time_to_final <= (900))]['quantile_width'].max()
                
                new_ticks_X = np.linspace(0,900,10)
                new_ticks_Y = np.linspace(-600,600,13)
                spacing_dev2 = spacing_dev2.sort_values(by=['time_to_final'])
                #plot of spacing deviation (scatter plot)
                title='Max = ' + str(max_dev) + ' Min = ' + str(min_dev) + ' Average = ' + str(avg_dev) + ' Standard deviation = ' + str(s2_dev)
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
                plt.savefig('Output_files/_spacing_deviation_scatter__optim.jpg',bbox_inches="tight")
                plt.show()
                
                # SMOOTHED LINE PLOT
                new_dev = spacing_dev2.copy()
                new_dev.set_index('time_to_final', inplace=True)
                xx = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(15).mean()
                zz = xx.reset_index(drop = True)
                xx2 = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(10).mean()
                zz2 = xx2.reset_index(drop = True)
                xx3 = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(5).mean()
                zz3 = xx3.reset_index(drop = True)
                xx4 = new_dev.groupby(['pair_ID'])['recalculated_dev'].rolling(15, min_periods=1).mean()
                zz4 = xx4.reset_index(drop = True)
                new_dev = new_dev.sort_values(by=['pair_ID','interval_nr'],ascending=[True, False])
                new_dev = new_dev.reset_index()
                new_dev['moving_average'] = zz
                new_dev['moving_average_2'] = zz2
                new_dev['moving_average_3'] = zz3
                new_dev['moving_average_4'] = zz4
                grouped = new_dev.groupby(['pair_ID'])
                moving_av_final = pd.Series([])
                for n, group in grouped:
                    last_value = group['moving_average'][14+(91*(n[0]-1))]
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
                
                new_dev['moving_av_final'] = new_dev['moving_average_4']
                new_dev['quantile05_ma'] = new_dev.groupby(['time_to_final'])['moving_av_final'].transform(lambda x: x.quantile(.05))
                new_dev['quantile95_ma'] = new_dev.groupby(['time_to_final'])['moving_av_final'].transform(lambda x: x.quantile(.95))
                new_dev = new_dev.sort_values(by=['time_to_final'])
                new_dev.set_index('time_to_final', inplace=True)
                plt.figure(figsize=(8,6))  
                new_dev.groupby('pair_ID')['moving_av_final'].plot()
                new_dev['quantile05_ma'].plot(color='black',linewidth=2.5)
                new_dev['quantile95_ma'].plot(color='black',linewidth=2.5)
                plt.plot()
                axes = plt.gca()
                axes.set_xticks(new_ticks_X)
                axes.set_yticks(new_ticks_Y)
                axes.set_xlabel("Time to final trailer [seconds]",fontsize=19)
                axes.set_ylabel("Spacing deviation [seconds]",fontsize=19)
                axes.set_ylim(-600,600)
                axes.set_xlim([0,900])                                                               #setting limits for axes
                axes.grid()
                plt.savefig('Output_files/_spacing_deviation_smooth__optim.jpg',bbox_inches="tight")
                plt.show() 

            else:
                max_dev = 0
                min_dev = 0
                avg_dev = 0
                median_dev = 0
                s2_dev = 0

    # THROUGHPUT
            # making time to final samples 30s
            step_seconds = 30
            referenceMinimumTime = [*range(0, (1100), step_seconds)] 
            referenceMinimumTime = pd.Series(referenceMinimumTime, name='referenceMinimumTime')
            min_time_to_f =pd.Series([])
            frame = Grid_frame[['flightID','timestamp','endDate','X','Y']]
            frame['min_time_to_final'] = [min_time.loc[((min_time['X'] == frame['X'][i]) & (min_time['Y'] == frame['Y'][i]))]['min_time'].values[0] for i in range(len(frame))]
            # making datatime timestamp for end hour
            date_str = str(date)
            start_str = str(start_hour)
            end_str = str(end_hour)
            year = '20' + date_str[:2] 
            import time 
            if len(start_str) == 6:
                b = datetime(int(year), int(date_str[2:4]), int(date_str[4:6]), int(start_str[:2]), int(start_str[2:4]), int(start_str[4:6]))
            if len(start_str) == 1:
                b = datetime(int(year), int(date_str[2:4]), int(date_str[4:6]), int(start_str[:2]))
            if len(start_str) == 5:
                b = datetime(int(year), int(date_str[2:4]), int(date_str[4:6]), int(start_str[:1]), int(start_str[1:3]), int(start_str[3:5]))
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
            days = date_end - date_start + 1
            # if days > 7:
            #     days = 7
            # else:
            #     pass
            hours = (end_hour - start_hour)/10000*days
            number_of_intervals = int(55*hours+1)
            for n in range(0,number_of_intervals,1):
                    time_interval_start = timestamp_start + n*60
                    time_interval_end = time_interval_start + 5*60
                    flights_in_interval1 = frame.loc[((frame['timestamp'] >= time_interval_start) & (frame['timestamp'] <= time_interval_end))]
                    flights_in_interval_grouped = flights_in_interval1.groupby(['flightID']).head(1)
                    flights_in_interval1['interval_nr'] = n
                    # flights_in_interval = flights_in_interval.append(flights_in_interval1,ignore_index = True)
                    flights_in_interval = pd.concat([flights_in_interval,flights_in_interval1],ignore_index=True)
                    flightCount = len(flights_in_interval_grouped)
                    df1 = pd.DataFrame({'interval_nr':[n],'time_interval_start':[str(time_interval_start)[:10]],'time_interval_end':[str(time_interval_end)[:10]],'total_throughput':[flightCount]})
                    # total_throughput =total_throughput.append(df1,ignore_index = True)
                    total_throughput = pd.concat([total_throughput,df1],ignore_index=True)
                    for t in referenceMinimumTime:
                        t_end = t + step_seconds
                        if t_end == 1000:
                            inConditions = flights_in_interval1.loc[(flights_in_interval1['min_time_to_final'] >= t)]
                        else:
                            inConditions = flights_in_interval1.loc[((flights_in_interval1['min_time_to_final'] >= t) & (flights_in_interval1['min_time_to_final'] <= t_end))]
                        dataCount = len(inConditions.groupby(['flightID']).groups.keys())
                        df = pd.DataFrame({'interval_nr':[n],'time_interval_start':[str(time_interval_start)[:10]],'time_interval_end':[str(time_interval_end)[:10]],'time_to_final':[t_end],'throughput':[dataCount]})
                        # throughput =throughput.append(df,ignore_index = True)
                        throughput = pd.concat([throughput,df],ignore_index=True)
            
            throughput = throughput.loc[(throughput['throughput'] > 0)]
            throughput = throughput.reset_index()
            throughput = throughput.drop(list(throughput)[0], axis=1)
            throughput['quantile05'] = throughput.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.05))
            throughput['quantile95'] = throughput.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.95))
            
            #band = 900
            
            # if throughput.loc[((throughput['time_to_final'] >= band) & (throughput['time_to_final'] <= (band + 100)))].empty == True:
            #     entry_throughput = 0
            # elif throughput.loc[((throughput['time_to_final'] >= band) & (throughput['time_to_final'] <= (band + 100)))].empty == False:
            #     entry_throughput = throughput.loc[((throughput['time_to_final'] >= band) & (throughput['time_to_final'] <= (band + 100)))]['quantile95'].max()
            
            entry_throughput = throughput.loc[((throughput['time_to_final'] >= 900) & (throughput['time_to_final'] <= (900)))]['quantile95'].max()
            if math.isnan(entry_throughput) == True:
                entry_throughput = 0
        
            max_thr = abs(throughput.loc[(throughput.time_to_final <= (900))]['throughput'].max())
            min_thr = throughput.loc[(throughput.time_to_final <= (900))]['throughput'].min()
            avg_thr = throughput.loc[(throughput.time_to_final <= (900))]['throughput'].mean()
            median_thr = throughput.loc[(throughput.time_to_final <= (900))]['throughput'].median()
            s2_thr = throughput.loc[(throughput.time_to_final <= (900))]['throughput'].std()
    
            sta = int(start_hour/100)
            end = int(end_hour/100)
            x_labels = [*range(sta, end, 5)]
            x_labels = [str(x) for x in x_labels] 
            x_labels = [x[:2]+':'+x[2:] for x in x_labels]
            fig, ax = plt.subplots(1, 1)
            plot = total_throughput.plot(x="interval_nr", y="total_throughput", kind="bar",figsize=(8,6),ax=ax) 
            plot.set_xlabel("Interval start",fontsize=19)
            plot.set_ylabel("Total throughput",fontsize=19)
            plt.savefig('Output_files/total_throughput_optim.jpg',bbox_inches="tight")
            throughput = throughput.loc[(throughput['time_to_final'] <= 600)]
            #throughput plot
            new_ticks_X = np.linspace(0,600,7)
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
            ax.set_xlim([0,600])
            ax.set_ylim([0,12])
            ax.set_xticks(new_ticks_X)
            ax.set_yticks(new_ticks_Y)
            plt.legend(["The 5th and 95th Quantiles"],fontsize=23)
            plt.xticks(fontsize=19)
            plt.yticks(fontsize=19)
            ax.set_xticklabels(list(range(0, 700, 100)),fontsize=19) 
            fig = plot.get_figure()
            plt.savefig('Output_files/throughput_optim.jpg',bbox_inches="tight")
            plt.show()
            
    #METERING EFFORT
            metering_effort = throughput[['time_to_final','interval_nr','throughput']]
            
            metering_effort['quantile05'] = metering_effort.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.05))
            metering_effort['quantile95'] = metering_effort.groupby(['time_to_final'])['throughput'].transform(lambda x: x.quantile(.95))
            metering_effort_fin = metering_effort.groupby(['time_to_final'])[['time_to_final','quantile05','quantile95']].head(1)
            metering_effort_fin['quantile_width'] = metering_effort_fin['quantile95'] - metering_effort_fin['quantile05']
            if metering_effort_fin.loc[(metering_effort['time_to_final'] == 30)]['quantile_width'].empty == True:
                quantile_width_t0 = 0
            else:
                quantile_width_t0 = int(metering_effort_fin.loc[(metering_effort['time_to_final'] == 30)]['quantile_width'])
            metering_effort_fin['metering_effort_a'] = metering_effort_fin['quantile_width'] - quantile_width_t0
            metering_effort_fin = metering_effort_fin.sort_values(by=['time_to_final'])
            metering_effort_fin = metering_effort_fin.reset_index(drop=True)
            metering_effort_fin = metering_effort_fin.sort_values(by=['time_to_final'])
                
            max_mefA = abs(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= (900))]['metering_effort_a'].max())
            min_mefA = metering_effort_fin.loc[(metering_effort_fin.time_to_final <= (900))]['metering_effort_a'].min()
            avg_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= (900))]['metering_effort_a'].mean(),2)
            median_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= (900))]['metering_effort_a'].median(),2)
            s2_mefA = round(metering_effort_fin.loc[(metering_effort_fin.time_to_final <= (900))]['metering_effort_a'].std(),2)
             
            
            metering_effort_fin['Date'] = m
            metering_effort_fin['Hour_start'] = start_hour
            aa = metering_effort_fin[['Date','Hour_start','time_to_final','metering_effort_a']]
            aa = aa.rename(columns={'time_to_final': 'Time_to_final','metering_effort_a': 'Metering_effort'})
            # metering_effort_EIDW = metering_effort_EIDW.append(aa) 
            metering_effort_EIDW = pd.concat([metering_effort_EIDW,aa],ignore_index=True)
            ##### 90th quantile statistics for Karim ####
            q_low = metering_effort_fin["metering_effort_a"].quantile(0.05)
            q_hi  = metering_effort_fin["metering_effort_a"].quantile(0.95)
            
            met_eff_filtered = metering_effort_fin[(metering_effort_fin["metering_effort_a"] < q_hi) & (metering_effort_fin["metering_effort_a"] > q_low)]
            
            max_mefA = q_hi
            min_mefA = q_low
            avg_mefA = round(met_eff_filtered.loc[(met_eff_filtered.time_to_final <= (900))]['metering_effort_a'].mean(),2)
            median_mefA = round(met_eff_filtered.loc[(met_eff_filtered.time_to_final <= (900))]['metering_effort_a'].median(),2)
            s2_mefA = round(met_eff_filtered.loc[(met_eff_filtered.time_to_final <= (900))]['metering_effort_a'].std(),2)

            ################## MOVING AVERAGE #############
            metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(3).mean()
            metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])
            
            fig, ax = plt.subplots(1, 1)
            plot = metering_effort_fin.plot(x="time_to_final", y="metering_effort_a", title="Metering effort A",kind="line",figsize=(8,6),ax=ax)
            #plot.set_xticklabels(xlabels)
            plot.set_xlabel("Minimum time to final",fontsize=19)
            plot.set_ylabel("Metering effort",fontsize=19)
            ax.set_xlim([0,900])                                                              
            ax.set_ylim([-2,2.5])
            plt.savefig('Output_files/met_effort__optim.jpg',bbox_inches="tight")
            
            
            fig, ax = plt.subplots(1, 1)
            plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 90 seconds",kind="line",figsize=(8,6),ax=ax)
            #plot.set_xticklabels(xlabels)
            plot.set_xlabel("Minimum time to final",fontsize=19)
            plot.set_ylabel("Metering effort",fontsize=19)
            ax.set_xlim([0,900])                                                              
            ax.set_ylim([-1,1])
            plt.savefig('Output_files/Metering_effort_moving_avg_90s__optim.jpg',bbox_inches="tight")
            
            metering_effort_fin['moving_average'] = metering_effort_fin.metering_effort_a.rolling(4).mean()
            metering_effort_fin = metering_effort_fin.fillna(metering_effort_fin['moving_average'][metering_effort_fin['moving_average'].notna().idxmax()])
            
            fig, ax = plt.subplots(1, 1)
            plot = metering_effort_fin.plot(x="time_to_final", y="moving_average", title="Metering effort A moving average 120 seconds",kind="line",figsize=(8,6),ax=ax)
            #plot.set_xticklabels(xlabels)
            plot.set_xlabel("Minimum time to final",fontsize=19)
            plot.set_ylabel("Metering effort",fontsize=19)
            plt.savefig('Output_files/Metering_effort_moving_avg_120s__optim.jpg',bbox_inches="tight")
            
    #SEQUENCE PRESSURE
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
                    # sequence_pressure = sequence_pressure.append(df1,ignore_index = True)
                    sequence_pressure = pd.concat([sequence_pressure,df1],ignore_index=True)
            sec = 2*60  
            # calculation of time to final for each flightID in sequence pressute dataframe        
            time_to_final = pd.Series([])
            for i in range(len(sequence_pressure)):
                time = sequence_pressure.timestamp[i]
                flightID = sequence_pressure.flightID[i]
                time_to_final[i] = int(Grid_frame2.loc[((Grid_frame2['timestamp']== takeClosest(time,Grid_frame2.loc[(Grid_frame2['flightID'] == flightID)]['timestamp'])) & (Grid_frame2['flightID'] == flightID) )]['time_to_final'].values[0])
            
            sequence_pressure.insert(3,"time_to_final",time_to_final) 
            sequence_pressure['time_to_final_round'] = sequence_pressure['time_to_final'].round(-1)
            sequence_pressure['quantile05'] = sequence_pressure.groupby(['time_to_final_round'])['pressure'].transform(lambda x: x.quantile(.05,interpolation='nearest'))
            sequence_pressure['quantile95'] = sequence_pressure.groupby(['time_to_final_round'])['pressure'].transform(lambda x: x.quantile(.95,interpolation='nearest'))
            min_seq_pr = sequence_pressure.loc[(sequence_pressure.time_to_final <= (900))]["pressure"].min()
            max_seq_pr = sequence_pressure.loc[(sequence_pressure.time_to_final <= (900))]["pressure"].max()
            avg_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= (900))]["pressure"].mean(),2)
            median_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= (900))]["pressure"].median(),2)
            s2_seq_pr = round(sequence_pressure.loc[(sequence_pressure.time_to_final <= (900))]["pressure"].std(),2)
            
            # if sequence_pressure.loc[((sequence_pressure['time_to_final_round'] >= band) & (sequence_pressure['time_to_final_round'] <= (band + 100)))].empty == True:
            #     entry_seq_p = 0
            # elif sequence_pressure.loc[((sequence_pressure['time_to_final_round'] >= band) & (sequence_pressure['time_to_final_round'] <= (band + 100)))].empty == False:
            #     entry_seq_p = sequence_pressure.loc[((sequence_pressure['time_to_final_round'] >= band) & (sequence_pressure['time_to_final_round'] <= (band + 100)))]['quantile95'].max()
            
            new_ticks_X = np.linspace(0,900,10)
            new_ticks_Y = np.linspace(0,6,7)
            sequence_pressure = sequence_pressure.sort_values(by=['time_to_final'])
            fig, ax = plt.subplots(1, 1)
            plot = sequence_pressure.plot.scatter(x='time_to_final',y='pressure',c='flight_nr',colorbar = False, colormap='gist_rainbow',figsize=(8,6),ax=ax)
            plot.xaxis.tick_top()
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
            plt.savefig('Output_files/Sequence_pressure__optim.jpg',bbox_inches="tight")

                
            #SEQUENCING EFFORT
            # spacing_dev2 = pd.read_csv(r'C:\Users\lucsm87\Desktop\TMA-KPI Project\PHD\TMA - KPI\Data\spacing_dev2_EIDW_TT_new2.csv', 
            # header=0,
            # sep=','
            # ) 
        
        
        
            seq_effort = spacing_dev2[['time_to_final','recalculated_dev','quantile05','quantile95']]
        
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
        
            if number_of_flights <= 1:
                SE_max = 0
                SE_min = 0
                SE_avg = 0
                SE_median = 0
                SE_std = 0


            seq_effort_fin['Date'] = m
            seq_effort_fin['Hour_start'] = start_hour
            bb = seq_effort_fin[['Date','Hour_start','time_to_final','seq_effort']]
            bb = bb.rename(columns={'time_to_final': 'Time_to_final','seq_effort': 'Sequencing_effort'})
            # sequencing_effort_EIDW = sequencing_effort_EIDW.append(bb) 
            sequencing_effort_EIDW = pd.concat([sequencing_effort_EIDW,bb],ignore_index=True)
            
    # # TIME IN TMA (CIRCLE)
            Grouped_data=Grid_frame.groupby(by='flightID')['timestamp'].agg(['first','last'])
            Grouped_data['time_in_TMA']=Grouped_data['last']-Grouped_data['first'] 
            pd.DataFrame(Grouped_data).to_csv('Output_files/time_in_TMA.csv')
    
            time_in_TMA_min = Grouped_data['time_in_TMA'].min()
            time_in_TMA_max = Grouped_data['time_in_TMA'].max()
            time_in_TMA_avg = round(Grouped_data['time_in_TMA'].mean(),2)
            time_in_TMA_median = round(Grouped_data['time_in_TMA'].median(),2)
            time_in_TMA_std = round(Grouped_data['time_in_TMA'].std(),2)
    
    
    
    # # DISTANCE IN TMA (CIRCLE)
            from geopy.distance import great_circle
            Grid_frame['point'] =  Grid_frame[['lat','lon']].values.tolist()
           
            distance = pd.Series([])
            for i in range(len(Grid_frame)-1):
                distance[i] = great_circle(Grid_frame['point'][i],Grid_frame['point'][i+1]).nm
            Grid_frame['distance'] = distance
            Grid_frame.loc[Grid_frame.groupby('flightID')['distance'].tail(1).index, 'distance'] = 0
            
            Grid_frame["cum_sum_dist"]=Grid_frame.groupby(['flightID'])['distance'].cumsum(axis=0)
            
            dist_in_TMA = Grid_frame.groupby(['flightID'])[['flightID','cum_sum_dist']].tail(1)
            pd.DataFrame(dist_in_TMA).to_csv('Output_files/distance_in_TMA_optim.csv')
    
            dist_in_TMA_min = dist_in_TMA['cum_sum_dist'].min()
            dist_in_TMA_max = dist_in_TMA['cum_sum_dist'].max()
            dist_in_TMA_avg = round(dist_in_TMA['cum_sum_dist'].mean(),2)
            dist_in_TMA_median = round(dist_in_TMA['cum_sum_dist'].median(),2)
            dist_in_TMA_std = round(dist_in_TMA['cum_sum_dist'].std(),2)
            
            #num_res = frame_res['flightID'].nunique()
            
            # ================ ADDITIONAL TIME IN TMA ============
            add_time = Grid_frame.groupby(['flightID'])[['flightID','timestamp','X','Y','min_time_to_final','time_in_final']].head(1)
            add_time['time_to_final'] = add_time['time_in_final'] - add_time['timestamp']
            add_time['additional_time'] = add_time['time_to_final'] - add_time['min_time_to_final']
            #pd.DataFrame(add_time).to_csv(f'C:\\Users\\lucsm87\\Desktop\\TMA-KPI Project\\PHD\\TMA - KPI\\Plots\\Subsets\\{name3}\\{name2}\\Additional_time\\Additional_time_'+start_str+'-'+end_str+'.csv')
            max_add_time = add_time['additional_time'].max()
            min_add_time = add_time['additional_time'].min()
            avg_add_time = add_time['additional_time'].mean()
            median_add_time = add_time['additional_time'].median()
            s2_add_time = add_time['additional_time'].std()


            name4 = start_str + '_'+ end_str
            min_time_app = [name4,date,number_of_flights,min_add_time,max_add_time,avg_add_time,median_add_time,s2_add_time]
            statistic_add_t.loc[len(statistic_add_t)] = min_time_app

    
    # SAVE STATISTICS RESULTS
            start_str = str(start_hour)
            end_str = str(end_hour)
            if len(start_str) > 5:
                start_str_s = start_str[0:2]
            else:
                start_str_s = start_str[0:1]
            if len(end_str) > 5:
                end_str_s = end_str[0:2]
            else:
                end_str_s = end_str[0:1]
            name4 = start_str_s + '_'+ end_str_s
            min_time_app = [name4,str(m),number_of_flights,entry_throughput,time_in_TMA_min,time_in_TMA_max,time_in_TMA_avg,time_in_TMA_median,dist_in_TMA_min, dist_in_TMA_max,dist_in_TMA_avg,dist_in_TMA_median,max_min_time,avg_min_time,median_min_time,min_dev,max_dev,avg_dev,median_dev,s2_dev,quantile_width,SE_max,SE_min,SE_avg,SE_median,SE_std,max_thr,avg_thr,median_thr,s2_thr,min_mefA,max_mefA,avg_mefA,median_mefA,s2_mefA,max_seq_pr,avg_seq_pr,median_seq_pr,s2_seq_pr]
            #min_time_app = [name4,str(m),number_of_flights,num_600,num_700,num_800,num_900,num_1000,num_1100,num_res,band,intertime_min,intertime_max,intertime_avg,intertime_median,intertime_std,entry_throughput,time_in_TMA_min,time_in_TMA_max,time_in_TMA_avg,time_in_TMA_median,dist_in_TMA_min, dist_in_TMA_max,dist_in_TMA_avg,dist_in_TMA_median,max_min_time,avg_min_time,median_min_time,min_dev,max_dev,avg_dev,median_dev,s2_dev,quantile_width,SE_max,SE_min,SE_avg,SE_median,SE_std,max_thr,avg_thr,median_thr,s2_thr,min_mefA,max_mefA,avg_mefA,median_mefA,s2_mefA,max_seq_pr,avg_seq_pr,median_seq_pr,s2_seq_pr]
            #min_time_app = [name4,str(m),number_of_flights,num_600,num_700,num_800,num_900,num_1000,num_1100,band,entry_throughput,max_thr,avg_thr,median_thr,s2_thr,min_mefA,max_mefA,avg_mefA,median_mefA,s2_mefA]
            statistic.loc[len(statistic)] = min_time_app
            # spacing_app = [name,'Spacing_deviation',min_dev,max_dev,avg_dev,s2_dev,quantile_width,'-','-','-', '-']
            # statistic.loc[len(statistic)] = spacing_app
            # seq_app = [name,'Sequence_pressure',min_seq_pr,max_seq_pr,avg_seq_pr,s2_seq_pr,'-','-','-','-', '-']
            # statistic.loc[len(statistic)] = seq_app
            # throug_app = [name,'Throughput',min_thr,max_thr,avg_thr,s2_thr,'-','-','-','-', '-']
            # statistic.loc[len(statistic)] = throug_app
            # metef_app = [name,'Metering_effort',min_mefA,max_mefA,avg_mefA,s2_mefA,'-','-','-','-', '-']
            # statistic.loc[len(statistic)] = metef_app
            # TMAdist_app = [name,'Distance_in_TMA',dist_in_TMA_min,dist_in_TMA_max,dist_in_TMA_avg,dist_in_TMA_std,'-','-','-','-', '-']
            # statistic.loc[len(statistic)] = TMAdist_app
            # TMAtime_app = [name,'Time_in_TMA',time_in_TMA_min,time_in_TMA_max,time_in_TMA_avg,time_in_TMA_std,'-','-','-','-', '-']
            # statistic.loc[len(statistic)] = TMAtime_app
            # interarr_app = [name,'Inter-arrival_times',intertime_min,intertime_max,intertime_avg,intertime_std,'-','-','-','-', '-']
            # statistic.loc[len(statistic)] = interarr_app
            
    pd.DataFrame(statistic).to_csv('Output_files/statistic_optim.csv')
    pd.DataFrame(statistic_add_t).to_csv('Output_files/add_time_optim.csv')

pd.DataFrame(metering_effort_EIDW).to_csv('Output_files/met_effort_optim.csv')
pd.DataFrame(sequencing_effort_EIDW).to_csv('Output_files/seq_effort_optim.csv')
