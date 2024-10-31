import pandas as pd

PMus = pd.read_csv('Output_files/ESGG_points.csv', 
header=None,
sep=' '
) 
list_col_names = ['s','flightID','last_star','first_star']
PMus.columns = list_col_names
PMus = PMus.drop(['s'], axis=1)



def set_value(row):
    if (row['last_star'] == 'w1' and row['first_star'] == 'w3') or (row['last_star'] == 'e1' and row['first_star'] == 'e3'):
        return 40
    elif (row['last_star'] == 'w1' and row['first_star'] != 'w3') or (row['last_star'] == 'e1' and row['first_star'] != 'e3'):
        return 0
    elif row['last_star'] == 'w6' or row['last_star'] == 'e6':
        return 0
    elif (row['last_star'] == 'w3' and row['first_star'] != 'w6') or (row['last_star'] == 'e3' and row['first_star'] != 'e6'):
        return 0
    elif (row['last_star'] == 'w3' and row['first_star'] == 'w6') or (row['last_star'] == 'e3' and row['first_star'] == 'e6'):
        return 60
    elif row['last_star'] == 'w5' or row['last_star'] == 'e5':
        return 20
    elif row['last_star'] == 'w4' or row['last_star'] == 'e4':
        return 40
    elif (row['last_star'] == 'w2' and row['first_star'] != 'w3' ) or (row['last_star'] == 'e2' and row['first_star'] != 'e3'):
        return 80
    elif (row['last_star'] == 'w2' and row['first_star'] == 'w3') or (row['last_star'] == 'e2' and row['first_star'] == 'e3'):
        return 20
    else:
        return 'Low'

PMus['util'] = PMus.apply(set_value, axis=1)

       

percent_100 = (len(PMus[PMus['util']==100])/len(PMus))*100
percent_80 = (len(PMus[PMus['util']==80])/len(PMus))*100
percent_60 = (len(PMus[PMus['util']==60])/len(PMus))*100
percent_40 = (len(PMus[PMus['util']==40])/len(PMus))*100
percent_20 = (len(PMus[PMus['util']==20])/len(PMus))*100 
percent_0 = (len(PMus[PMus['util']==0])/len(PMus))*100
print('_________________')
print('Whole PM ',percent_100)
print('PM 80% ',percent_80)
print('PM 60% ',percent_60)
print('PM 40% ',percent_40)
print('PM 20% ', percent_20)
print('PM only start ',percent_0)   
print('Number of aircraft: ',len(PMus))    
    
