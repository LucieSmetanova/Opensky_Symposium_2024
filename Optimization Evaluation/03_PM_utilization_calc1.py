import numpy as np
import pandas as pd
from shapely.geometry import Point
from shapely.geometry.polygon import Polygon
import time
import os
start_time = time.time()



flights1 = pd.read_csv(os.path.join('Data', 'ESGG_190410_optimized_trajectories_with_IDs.csv'), sep=',',header=None)

list_col_names = ['sequence', 'timestamp','flightID','dist_to_go','MACH','TAS','CAS','baroAltitude', 'velocity','lat','lon','CL','CD','fuel_flow','fuel_burnt','thrust','xx']
flights1.columns = list_col_names




def dms2dd(as_string):
    degrees = int(as_string[:2])
    minutes = int(as_string[2:4])
    seconds = float(as_string[4:8])
    lat_dd = float(degrees) + float(minutes)/60 + float(seconds)/(60*60)
    degrees = int(as_string[10:13])
    minutes = int(as_string[13:15])
    seconds = float(as_string[15:19])
    lon_dd = float(degrees) + float(minutes)/60 + float(seconds)/(60*60)

    return lat_dd, lon_dd

W1_lat, W1_lon = 57.3463, 11.8244
W1_circle_center = Point(W1_lon,W1_lat)
W2_lat, W2_lon = 57.3942, 11.7305
W2_circle_center = Point(W2_lon,W2_lat)
W3_lat, W3_lon = 57.4505, 11.6846
W3_circle_center = Point(W3_lon,W3_lat)
W4_lat, W4_lon = 57.5120, 11.6795
W4_circle_center = Point(W4_lon,W4_lat)
W5_lat, W5_lon = 57.5702, 11.7163
W5_circle_center = Point(W5_lon,W5_lat)
W6_lat, W6_lon = 57.6172, 11.7901
W6_circle_center = Point(W6_lon,W6_lat)

E1_lat, E1_lon = 57.2743, 12.1007
E1_circle_center = Point(E1_lon,E1_lat)
E2_lat, E2_lon = 57.2644, 12.2282
E2_circle_center = Point(E2_lon,E2_lat)
E3_lat, E3_lon = 57.2801, 12.3381
E3_circle_center = Point(E3_lon,E3_lat)
E4_lat, E4_lon = 57.3162, 12.4301
E4_circle_center = Point(E4_lon,E4_lat)
E5_lat, E5_lon = 57.3679, 12.4919
E5_circle_center = Point(E5_lon,E5_lat)
E6_lat, E6_lon = 57.4282, 12.5147
E6_circle_center = Point(E6_lon,E6_lat)

EMP_lat, EMP_lon = 57.2700, 12.1130
EMP_circle_center = Point(EMP_lon,EMP_lat)
WMP_lat, WMP_lon = 57.2930, 11.5800
WMP_circle_center = Point(WMP_lon,WMP_lat)



E = [E6_circle_center,E5_circle_center,E4_circle_center,E3_circle_center,E2_circle_center,E1_circle_center]
W = [W6_circle_center,W5_circle_center,W4_circle_center,W3_circle_center,W2_circle_center,W1_circle_center]

En = ['E6','E5','E4','E3','E2','E1']
Wn = ['W6','W5','W4','W3','W2','W1']


import pandas as pd

def filter_points_in_circle_df(df, center, radius):
    x_center, y_center = center
    # Calculate the squared distance from the center for each point
    return df[((df['lon'] - x_center)**2 + (df['lat'] - y_center)**2) <= radius**2]


fl_in_W = filter_points_in_circle_df(flights1, (WMP_lon,WMP_lat), 0.07)['flightID'].unique()
fl_in_E = filter_points_in_circle_df(flights1, (EMP_lon,EMP_lat), 0.07)['flightID'].unique()

flightsW = flights1[flights1['flightID'].isin(fl_in_W)]
flightsE = flights1[flights1['flightID'].isin(fl_in_E)]

entry_w6 = filter_points_in_circle_df(flights1, (W6_lon,W6_lat), 0.06)['flightID'].unique()
entry_w3 = filter_points_in_circle_df(flights1, (W3_lon,W3_lat), 0.06)['flightID'].unique()
entry_w1 = filter_points_in_circle_df(flights1, (W1_lon,W1_lat), 0.06)['flightID'].unique()
entry_E6 = filter_points_in_circle_df(flights1, (E6_lon,E6_lat), 0.06)['flightID'].unique()
entry_E3 = filter_points_in_circle_df(flights1, (E3_lon,E3_lat), 0.06)['flightID'].unique()
entry_E1 = filter_points_in_circle_df(flights1, (E1_lon,E1_lat), 0.06)['flightID'].unique()

w1_w6=set(entry_w1).intersection(set(entry_w6))
w1_w3=set(entry_w1).intersection(set(entry_w3))
w3_w6=set(entry_w3).intersection(set(entry_w6))
e1_e6=set(entry_E1).intersection(set(entry_E6))
e1_e3=set(entry_E1).intersection(set(entry_E3))
e3_e6=set(entry_E3).intersection(set(entry_E6))

number_of_flights = flights1['flightID'].nunique()
number_of_catched = len(entry_w6)+len(entry_w3)+len(entry_w1)+len(entry_E6)+len(entry_E3)+len(entry_E1)-len(w1_w6)-len(w1_w3)-len(w3_w6)-len(e1_e6)-len(e1_e3)-len(e3_e6)
if number_of_flights != number_of_catched:
    raise ValueError("Number of flights does not match!")


flights_w1 = filter_points_in_circle_df(flights1, (W1_lon,W1_lat), 0.04)['flightID'].unique()
flights_w2 = filter_points_in_circle_df(flights1, (W2_lon,W2_lat), 0.04)['flightID'].unique()
flights_w3 = filter_points_in_circle_df(flights1, (W3_lon,W3_lat), 0.04)['flightID'].unique()
flights_w4 = filter_points_in_circle_df(flights1, (W4_lon,W4_lat), 0.04)['flightID'].unique()
flights_w5 = filter_points_in_circle_df(flights1, (W5_lon,W5_lat), 0.04)['flightID'].unique()
flights_w6 = filter_points_in_circle_df(flights1, (W6_lon,W6_lat), 0.04)['flightID'].unique()
flights_e1 = filter_points_in_circle_df(flights1, (E1_lon,E1_lat), 0.04)['flightID'].unique()
flights_e2 = filter_points_in_circle_df(flights1, (E2_lon,E2_lat), 0.04)['flightID'].unique()
flights_e3 = filter_points_in_circle_df(flights1, (E3_lon,E3_lat), 0.04)['flightID'].unique()
flights_e4 = filter_points_in_circle_df(flights1, (E4_lon,E4_lat), 0.04)['flightID'].unique()
flights_e5 = filter_points_in_circle_df(flights1, (E5_lon,E5_lat), 0.04)['flightID'].unique()
flights_e6 = filter_points_in_circle_df(flights1, (E6_lon,E6_lat), 0.04)['flightID'].unique()


last_w1 = [item for item in flights_w1 if item not in set(flights_w2) | set(flights_w3) | set(flights_w4) | set(flights_w5) | set(flights_w6)]
last_w3 = [item for item in flights_w3 if item not in set(flights_w2) | set(flights_w1)]   
last_w6 = [item for item in flights_w6 if item not in set(flights_w2) | set(flights_w1) | set(flights_w4) | set(flights_w5) | set(flights_w3)]
last_e3 = [item for item in flights_e3 if item not in set(flights_e2) | set(flights_e1)]   
last_e1 = [item for item in flights_e1 if item not in set(last_e3) | set(flights_e4) | set(flights_e5) | set(flights_e6)]
last_e6 = [item for item in flights_e6 if item not in set(flights_e2) | set(flights_e1) | set(flights_e4) | set(flights_e5) | set(flights_e3)]   

w2_w1 = set(flights_w2).intersection(set(flights_w1))
w2_w3 = set(flights_w2).intersection(set(flights_w3))
w2_w6 = set(flights_w2).intersection(set(flights_w6))
if not(w2_w1):
    last_w2 = flights_w2
w4_w3 = set(flights_w3).intersection(set(flights_w4))
last_w4 = [item for item in set(flights_w4).intersection(set(flights_w6)) if item not in set(w4_w3)]
w5_w4 = set(flights_w5).intersection(set(flights_w4))
last_w5 = [item for item in set(flights_w5).intersection(set(flights_w6)) if item not in set(w5_w4)]
e2_e1 = set(flights_e2).intersection(set(flights_e1))
e2_e3 = set(flights_e2).intersection(set(flights_e3))
e2_e6 = set(flights_e2).intersection(set(flights_e6))
if e2_e3==e2_e1 and not(e2_e6):
    last_e2 = []
elif e2_e3!=e2_e1 and not(e2_e6):
    last_e2 = set(e2_e3).symmetric_difference(e2_e1)
e4_e3 = set(flights_e3).intersection(set(flights_e4))
last_e4 = [item for item in set(flights_e4).intersection(set(flights_e6)) if item not in set(e4_e3)]
e5_e4 = set(flights_e5).intersection(set(flights_e4))
last_e5 = [item for item in set(flights_e5).intersection(set(flights_e6)) if item not in set(e5_e4)]

first_w1 = last_w1
first_w3 =[item for item in flights_w3 if item not in set(flights_w6)] 
first_w6 = flights_w6
first_e1 = [item for item in flights_e1 if item not in set(flights_e3) | set(flights_e6)]
first_e3 = [item for item in flights_e3 if item not in set(flights_e6)]
first_e6 = flights_e6

number_of_firsts = len(first_w6)+len(first_w3)+len(first_w1)+len(first_e6)+len(first_e3)+len(first_e1)


number_of_lasts = len(last_w6)+len(last_w5)+len(last_w4)+len(last_w3)+len(last_w2)+len(last_w1)+len(last_e6)+len(last_e5)+len(last_e4)+len(last_e3)+len(last_e2)+len(last_e1)
if number_of_flights != number_of_lasts or number_of_flights != number_of_firsts:
    raise ValueError("Number of flights and last starts does not match!")

PM_usage = pd.DataFrame(columns=['flightID','last_star'])
PM_usage2 = pd.DataFrame(columns=['flightID','first_star'])

for i,j in zip([last_w1,last_w2,last_w3,last_w4,last_w5,last_w6,last_e1,last_e2,last_e3,last_e4,last_e5,last_e6],['w1','w2','w3','w4','w5','w6','e1','e2','e3','e4','e5','e6']):
    x = [item for item in i]
    df = pd.DataFrame({'flightID': x, 'last_star': j},index=range(len(i)))
    PM_usage=pd.concat([PM_usage,df],ignore_index=True)


for i,j in zip([first_w1,first_w3,first_w6,first_e1,first_e3,first_e6],['w1','w3','w6','e1','e3','e6']):
    x = [item for item in i]
    df = pd.DataFrame({'flightID': x, 'first_star': j},index=range(len(i)))
    PM_usage2=pd.concat([PM_usage2,df],ignore_index=True)

PM_usage_fin = PM_usage.merge(PM_usage2, how='left', on='flightID')

filename = "ESGG_points.csv"
PM_usage_fin.to_csv(os.path.join('Output_files', filename), sep=' ', encoding='utf-8', float_format='%.3f', index = True, header = False)

