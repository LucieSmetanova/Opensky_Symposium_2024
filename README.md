# Opensky_Symposium_2024
 Data and codes needed to reproduce Opensky 2024 publication

 The codes are set to work directly in the folder and output to the prepared files. 
 Output/Input file names require changes when calculating for different clusters

 This repository is divided into two subfolders, "Optimization Evaluation" and "Per Cluster Evaluation"

 ## Per Cluster Evaluation 
Contains folder with cluster data, scripts needed and pre-prepared folders for output figures and files
Flow of the calculations is based on the sequence of the codes. 

Description of the scripts:
01_subset_selection_min_time.py - calculates the minimum time to final and the horizontal spread from the initial datasets
02_spacing_deviation_ESGG - calculates the spacing deviation
03_sequence_pressure - calculates the sequence pressure metric
04_throughput - calculates the throughput metric
05_metering_effort - metering effort calculation
06_figures - takes the output files from the scripts above and plots the Figures used in the paper
07_ESGG_horizontal - calculates the distance in TMA metric
08_ESGG_vertical_PIs_by_flight - calculates the vertical metrics (time on levels, time in TMA) for each flight
09_ESGG_vertical_PIs_by_hour - calculates vertical metrics for each hour
10_Opensky24_add_time_seq_effort - calculates the additional time in TMA for each flight and the sequencing effort
11_ASMA_additional_time - calculates the ASMA additional time for this data subset with commented section of the reference ASMA time calculation
12_sequencing_effort - calculation and plotting of the sequencing effort metric

## Optimization Evaluation
Contains folder with Data needed for the performance evaluation of the optimized arrival routes and folder for output of the codes

Description of the scripts:
01_performance_evaluation - evaluate the sequencing and metering efficiency 
02_ASMA_additional_time - calculates the ASMA additional time for this data subset with commented section of the reference ASMA time calculation
03_PM_utilization_calc1 - provides information about the first PM waypoint and the last one for each aircraft
04_PM_utilization_calc2 - provides percentage of the PM sequencing legs utilization

