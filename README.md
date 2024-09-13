# Opensky_Symposium_2024
 Data and codes needed to reproduce Opensky 2024 publication

 The codes are set to work directly in the folder and output to the prepared files. The initial cluster for calculations is cluster 5 as contains less aircraft and gives quicker results.

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

