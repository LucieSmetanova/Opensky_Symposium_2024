import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime
import os

############## REFERENCE CALCULATION ########
# for i in ['cluster1_no_outliers','cluster2','cluster3_no_outliers','cluster4','cluster5_no_outliers','cluster6']:
    # if i == 'cluster5_no_outliers':
        #     Grid_frame = pd.read_csv(r'C:\Users\lucsm87\Desktop\Data\ESGG\osn_ESGG_states_TMA_rwy03_'+i+'.csv', 
        #     header=None,
        #     sep=','
        #     ) 
        #     list_col_names = ['flightID', 'sequence','timestamp','lat','lon','baroAltitude','alltitude','velocity','endDate','date']
        #     Grid_frame.columns = list_col_names
    # else:
    #     Grid_frame = pd.read_csv('Cluster data'\osn_ESGG_states_TMA_rwy03_'+i+'.csv', 
    #     header=None,
    #     sep=' '
    #     ) 
    #     list_col_names = ['flightID', 'sequence','timestamp','lat','lon','baroAltitude','alltitude','velocity','endDate','date']
    #     Grid_frame.columns = list_col_names

   
 
#     Grid_frame['time_obj'] = Grid_frame['timestamp'].transform(lambda x: datetime.utcfromtimestamp(x))
#     Grid_frame['hour'] = Grid_frame['time_obj'].transform(lambda x: int(x.strftime('%H')))
    
#     Grid_frame['time_in_final'] = Grid_frame.groupby(['flightID'])['timestamp'].transform('max')
#     Grid_frame['entering_time'] = Grid_frame.groupby(['flightID'])['timestamp'].transform('min')
#     Grid_frame['time_to_final'] = Grid_frame['time_in_final'] - Grid_frame['timestamp']
    
    
#     land = Grid_frame.groupby(['flightID']).tail(1)
    
#     land_day = land[land['hour']>7]
#     land_day = land_day[land_day['hour']<=22]
    
#     ASMA_frame = Grid_frame[Grid_frame['flightID'].isin(land_day['flightID'])]
    
#     #ASMA_frame['time_in_final'] = ASMA_frame.groupby(['flightID'])['timestamp'].transform('max')
#     #ASMA_frame['entering_time'] = ASMA_frame.groupby(['flightID'])['timestamp'].transform('min')
#     #ASMA_frame['time_to_final'] = ASMA_frame['time_in_final'] - ASMA_frame['timestamp']
    
#     ASMA_arrive = ASMA_frame.groupby(['flightID']).head(1)
#     ASMA_ref = ASMA_arrive['time_to_final'].quantile(q=0.05)
#     count_ASMA = len(ASMA_arrive[ASMA_arrive['time_to_final']<=ASMA_ref])
#     print('CLUSTER NUMBER ',i)
#     print('ASMA reference time for 2019 is: ',ASMA_ref)
#     print('Number of flights holding the ASMA ref: ',count_ASMA)
#     print('\n')
#------------------------------------------------------------------
#           REFERENCE TIMES PER CLUSTERS FOR 2019
#   Cluster 1 = 489.2
#   Cluster 2 = 873
#   Cluster 3 = 488.7
#   Cluster 4 = 795.2
#   Cluster 5 = 537
#   Cluster 6 = 465
#           Reference ASMA time for the whole year 2019 all flights together
#  ASMA ref = 491
#---------------------------------------------------------------------------

   
Grid_frame = pd.read_csv('Cluster data/osn_ESGG_states_TMA_rwy03_2019_04_cluster6.csv', 
header=0,
sep=' '
) 

ASMA_ref = 465

Grid_frame['time_obj'] = Grid_frame['timestamp'].transform(lambda x: datetime.utcfromtimestamp(x))
Grid_frame['hour'] = Grid_frame['time_obj'].transform(lambda x: int(x.strftime('%H')))

Grid_frame['time_in_final'] = Grid_frame.groupby(['flightID'])['timestamp'].transform('max')
Grid_frame['entering_time'] = Grid_frame.groupby(['flightID'])['timestamp'].transform('min')
Grid_frame['time_to_final'] = Grid_frame['time_in_final'] - Grid_frame['timestamp']


frame_head = Grid_frame.groupby(['flightID']).head(1)
frame_head['ASMA_add_time'] = frame_head['time_to_final'] - ASMA_ref

ASMA_min = frame_head['ASMA_add_time'].min()
ASMA_max = frame_head['ASMA_add_time'].max()
ASMA_avg = frame_head['ASMA_add_time'].mean()
ASMA_median = frame_head['ASMA_add_time'].median()
ASMA_s2  = frame_head['ASMA_add_time'].std()

print(ASMA_min,ASMA_max,ASMA_avg,ASMA_median,ASMA_s2)
filename = 'ASMA_additoinal_time_c6.csv'
frame_head.to_csv(os.path.join('Output_files', filename), sep=' ', encoding='utf-8', float_format='%.3f', index = True, header = True)
