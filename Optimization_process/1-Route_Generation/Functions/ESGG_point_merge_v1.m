function [F_burn_TMA,F_burn_CDO,rwy] = ESGG_point_merge_v1(flight_file,ac_type,plot_on_off,callsign_save,date,cruise_alt,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,icao_type,wtc,entry_point,PM_profile,IF,IF_stop,powered_descent,descent_angle,IAS_start_CDO,IAS_restriction_CDO,alt_start_CDO,export_wpts)
screen =  get(0,'ScreenSize');
time_23 = 0;
day_before = 0;
rwy = [];

% ----------------------------- COORDINATES ----------------------------- %

% Arlanda TMA Coordinates
sthlm_TMA_lat = [60.29944 60.26611 59.88278 60.03528 59.67361 59.59944 59.255 59.04194 58.8325 58.7525 58.58306 58.61639 58.96611 58.97861 59.01194 59.04944 59.32389 59.74944 60.23278 60.29944];
sthlm_TMA_lon = [18.21306 18.55472 18.84694 19.31361 19.82806 19.27361 18.96833 18.75472 18.53944 18.45722 17.93278 17.45694 17.40778 17.22333 16.70778 16.26778 16.31833 16.44667 17.59667 18.21306];

% Arlanda entry points coordinates
NILUG_lat = 58.81583;
NILUG_lon = 17.88472;
HMR_lat = 60.279301;
HMR_lon = 18.391600;
XILAN_lat = 59.65931;
XILAN_lon = 19.07606;
ELTOK_lat = 59.82444;
ELTOK_lon = 16.98992;

% Arlanda RWY coordinates
zero_one_L_lon = 17.913222;
zero_one_L_lat = 59.637253;
zero_one_R_lon = 17.950744;
zero_one_R_lat = 59.626397;
one_nine_L_lon = 17.958744;
one_nine_L_lat = 59.648469;
one_nine_R_lon = 17.923767;
one_nine_R_lat = 59.666400;
two_six_lon = 17.979156;
two_six_lat = 59.663897;
zero_eight_lon = 17.936133;
zero_eight_lat = 59.658419;

% Arlanda FAP/FAF locations (approximated)
FAP_01L_lon = 17.86972222;
FAP_01L_lat = 59.51666667;
FAP_19R_lon = 17.9675;
FAP_19R_lat = 59.78639;
FAP_26_lon = 18.2125;
FAP_26_lat = 59.69333;
FAP_01R_lon = 17.88;
FAP_01R_lat = 59.43028;
FAP_19L_lon = 18.00278;
FAP_19L_lat = 59.76944;
FAF_08_lon = 17.69833;
FAF_08_lat = 59.63444;

% Arlanda 01L/01R STARs
ELTOK_7M_lat = dms2degrees([59 49 28.0;59 47 26.2;59 41 47.2;59 32 20.3]);
ELTOK_7M_lon = dms2degrees([016 59 23.7;017 10 35.3;017 14 41.3;017 21 30.1]);

HMR_5M_lat = dms2degrees([60 16 45.5;60 00 59.7;59 44 52.2;59 31 54.1]);
HMR_5M_lon = dms2degrees([018 23 29.7;018 22 11.1;018 20 52.3;018 12 12.0]);

NILUG_2M_lat = dms2degrees([58 48 57;59 05 51.6;59 31 54.1]);
NILUG_2M_lon = dms2degrees([017 53 05;018 09 07.3;018 12 12.0]);

XILAN_4M_lat = dms2degrees([59 39 33.5;59 36 16.0;59 31 54.1]);
XILAN_4M_lon = dms2degrees([019 04 33.8;018 41 42.3;018 12 12.0]);

% Arlanda 19L/19R STARs

ELTOK_7P_lat = dms2degrees([59 49 28.0;59 50 23.1;59 44 45]);
ELTOK_7P_lon = dms2degrees([016 59 23.7;017 15 21.7;017 35 25]);

HMR_4P_lat = dms2degrees([60 16 45.5;60 05 05.1;59 53 46.5]);
HMR_4P_lon = dms2degrees([018 23 29.7;018 21 49.1;018 20 12.9]);

NILUG_2P_lat = dms2degrees([58 48 57;59 05 51.6;59 31 54.1;59 53 46.5]);
NILUG_2P_lon = dms2degrees([017 53 05;018 09 07.3;018 12 12.0;018 20 12.9]);

XILAN_5P_lat = dms2degrees([59 39 33.5;59 36 16.0;59 31 54.1]);
XILAN_5P_lon = dms2degrees([019 04 33.8;018 41 42.3;018 12 12.0]);

% Arlanda 08 STARs

ELTOK_7S_lat = dms2degrees([59 49 28.0;59 50 23.1;59 44 45]);
ELTOK_7S_lon = dms2degrees([016 59 23.7;017 15 21.7;017 35 25]);

HMR_5S_lat = dms2degrees([60 16 45.5;60 00 59.7;59 44 52.2;59 31 54.1]);
HMR_5S_lon = dms2degrees([018 23 29.7;018 22 11.1;018 20 52.3;018 12 12.0]);

NILUG_2S_lat = dms2degrees([58 48 57;59 05 51.6;59 31 54.1]);
NILUG_2S_lon = dms2degrees([017 53 05;018 09 07.3;018 12 12.0]);

XILAN_4S_lat = dms2degrees([59 39 33.5;59 36 16.0;59 31 54.1]);
XILAN_4S_lon = dms2degrees([019 04 33.8;018 41 42.3;018 12 12.0]);

% Arlanda 26 STARs

ELTOK_4T_lat = dms2degrees([59 49 28.0;59 51 43.5;59 53 46.51]);
ELTOK_4T_lon = dms2degrees([016 59 23.7;017 39 46.7;018 20 12.9]);

HMR_4T_lat = dms2degrees([60 16 45.5;60 05 05.1;59 53 46.51]);
HMR_4T_lon = dms2degrees([018 23 29.7;018 21 49.1;018 20 12.9]);

NILUG_2T_lat = dms2degrees([58 48 57;59 05 51.6;59 31 54.1]);
NILUG_2T_lon = dms2degrees([017 53 05;018 09 07.3;018 12 12.0]);

XILAN_5T_lat = dms2degrees([59 39 33.5;59 36 16.0;59 31 54.1]);
XILAN_5T_lon = dms2degrees([019 04 33.8;018 41 42.3;018 12 12.0]);

% Dublin TMA coordinates
% Dublin_TMA_lat = [53.9167 53.7672 53.0975 52.7594 52.3333 52.6139 52.7594 53.0908 53.7522 54.1619 53.9167];
% Dublin_TMA_lon = [-5.5000 -5.5000 -5.5000 -5.5000 -5.5000 -6.6169 -6.8333 -7.3333 -7.3333 -6.7606 -5.5000];

% if strcmp(airport,'EIDW')
%     circle_center_lat = 53.42;
%     circle_center_lon = -6.27;
% elseif strcmp(airport,'ENGM')
%     circle_center_lat = dms2degrees([60 12 10]);
%     circle_center_lon = dms2degrees([11 05 02]);
% end
% radius = 200; % NM
% distUnits = 'm';
% arclen = rad2deg(1852*radius/earthRadius(distUnits));
% c = 1;
% for i = 0:1:360
%     [circle_TMA_lat(c),circle_TMA_lon(c)] = reckon(circle_center_lat, circle_center_lon,arclen,i);
%     c = c + 1;
% end
c = [];

% Dublin_TMA_lat = circle_TMA_lat;
% Dublin_TMA_lon = circle_TMA_lon;
% oslo_TMA_lat = circle_TMA_lat;
% oslo_TMA_lon = circle_TMA_lon;

% Dublin entry points coordinates
ABLIN_lat = 52.7828;
BAGOS_lat = 53.6800;
BALMI_lat = 54.1412;
BOYNE_lat = 53.7671;
BUNED_lat = 52.6228;
LIPGO_lat = 53.0639;
NIMAT_lat = 53.9650;
OLAPO_lat = 53.7803;
OSGAR_lat = 53.0494;
SUTEX_lat = 52.8244;
VATRY_lat = 52.5544;
ABLIN_lon = -4.9925;
BAGOS_lon = -5.5;
BALMI_lon = -6.6511;
BOYNE_lon = -5.5;
BUNED_lon = -6.6301;
LIPGO_lon = -5.5;
NIMAT_lon = -5.7421;
OLAPO_lon = -7.2946;
OSGAR_lon = -7.2702;
SUTEX_lon = -6.9304;
VATRY_lon = -5.5;

% Dublin RWY coordinates
eidw_lon_10R = dms2degrees([-06 17 24.27]);
eidw_lat_10R = dms2degrees([53 25 20.75]);
eidw_lon_28L = dms2degrees([-06 15 02.08]);
eidw_lat_28L = dms2degrees([53 25 12.94]);
eidw_lon_16 = dms2degrees([-06 15 43.12]);
eidw_lat_16 = dms2degrees([53 26 13.16]);
eidw_lon_34 = dms2degrees([-06 14 58.54]);
eidw_lat_34 = dms2degrees([53 25 11.66]);

% Vienna TMA coordinates
% vienna_TMA_lat = [48.7869 48.7339 48.2864 48.1267 47.8739 47.5028 47.2939 47.2395 47.7082 48.0066 48.5436 48.7150 48.8143 48.7869];
% vienna_TMA_lon = [15.9854 15.7247 15.4078 15.3864 15.6594 16.0503 16.2683 16.4347 17.0932 17.1607 16.9543 16.9061 16.5407 15.9854];


% vienna_TMA_lat = [48.7869 48.7339 48.2864 48.1267 47.8739 47.5028 47.2939 47.2395 47.7082 48.5436 48.715 48.8143 48.7869];
% vienna_TMA_lon = [15.9854 15.7247 15.4078 15.3864 15.6594 16.0503 16.2683 16.4347 17.35 16.9543 16.9061 16.5407 15.9854];

circle_center_lat = 48.11;
circle_center_lon = 16.59;
radius = 50; % NM
distUnits = 'm';
arclen = rad2deg(1852*radius/earthRadius(distUnits));
c = 1;
for i = 0:1:360
    [circle_TMA_lat(c),circle_TMA_lon(c)] = reckon(circle_center_lat, circle_center_lon,arclen,i);
    c = c + 1;
end

vienna_TMA_lat = circle_TMA_lat;
vienna_TMA_lon = circle_TMA_lon;

% Vienna RWY coordinates
loww_lon_11 = dms2degrees([16 32 00.09]);
loww_lat_11 = dms2degrees([48 07 22.13]);
loww_lon_29 = dms2degrees([16 34 32.27]);
loww_lat_29 = dms2degrees([48 06 32.57]);
loww_lon_16 = dms2degrees([16 34 41.40]);
loww_lat_16 = dms2degrees([48 07 11.22]);
loww_lon_34 = dms2degrees([16 35 28.82]);
loww_lat_34 = dms2degrees([48 05 19.07]);

% Vienna entry points coordinates
NERDU_lat = dms2degrees([48 28 53.39]);
NERDU_lon = dms2degrees([16 05 57.34]);
MABOD_lat = dms2degrees([48 34 28.41]);
MABOD_lon = dms2degrees([16 41 24.35]);
BALAD_lat = dms2degrees([47 46 00.21]);
BALAD_lon = dms2degrees([16 14 02.56]);
PESAT_lat = dms2degrees([47 42 53.75]);
PESAT_lon = dms2degrees([17 03 11.37]);

% Landvetter TMA Coordinates
goteborg_TMA_lat = [58.7661 58.7328 58.5169 58.2953 58.0969 57.7672 57.2275 56.9856 57.2136 57.7514 58.1278 58.6456 58.4653 58.7661];
goteborg_TMA_lon = [12.4975 13.1639 13.3244 13.3244 13.2769 13.1992 12.6958 11.7661 11.5828 11.1406 11.4503 12.2956 11.9975 12.4975];

% Landvetter entry points coordinates
ARQUS_lat = dms2degrees([57 05 45.0]);
ARQUS_lon = dms2degrees([012 55 43.1]);
KELIN_lat = dms2degrees([58 14 36.9]);
KELIN_lon = dms2degrees([012 03 15.0]);
LOBBI_lat = dms2degrees([57 19 05.0]);
LOBBI_lon = dms2degrees([011 29 53.0]);
RISMA_lat = dms2degrees([57 02 31.0]);
RISMA_lon = dms2degrees([011 58 45.0]);
MAKUR_lat = dms2degrees([57 25 47.0]);
MAKUR_lon = dms2degrees([011 24 25.0]);
NEGIL_lat = dms2degrees([58 15 04.8]);
NEGIL_lon = dms2degrees([012 37 31.2]);
MOXAM_lat = dms2degrees([58 31 52.9]);
MOXAM_lon = dms2degrees([013 18 50.1]);

% Landvetter entry points coordinates (new entry points 2021)


% -------------------------------------------------------------

% Landvetter RWY coordinates
zero_three_lon = 12.26771;
zero_three_lat = 57.64952;
two_one_lon = 12.29193;
two_one_lat = 57.67615;

% Vienna RWY 11 transitions
BALAD_3K_lat = dms2degrees([47 46 00.21;47 55 46.40;48 01 09.57;48 04 42.08;48 07 15.12;48 09 25.86;48 11 36.21;48 13 46.17;48 18 16.47;48 16 06.33;48 14 01.04]);
BALAD_3K_lon = dms2degrees([16 14 02.56;16 26 39.74;16 30 35.57;16 21 43.48;16 15 18.46;16 08 35.23;16 01 51.44;15 55 07.08;15 58 21.58;16 05 06.38;16 11 25.92]);

MABOD_4K_lat = dms2degrees([48 34 28.41;48 19 06.20;48 18 25.63;48 20 36.35;48 22 46.68;48 18 16.47;48 16 06.33;48 14 01.04]);
MABOD_4K_lon = dms2degrees([16 41 24.35;16 26 21.72;16 15 06.57;16 08 21.89;16 01 36.63;15 58 21.58;16 05 06.38;16 11 25.92]);

NERDU_4K_lat = dms2degrees([48 28 53.39;48 24 21.00;48 19 06.20;48 18 25.63;48 20 36.35;48 22 46.68;48 18 16.47;48 16 06.33;48 14 01.04]);
NERDU_4K_lon = dms2degrees([16 05 57.34;16 24 16.00;16 26 21.72;16 15 06.57;16 08 21.89;16 01 36.63;15 58 21.58;16 05 06.38;16 11 25.92]);

PESAT_4K_lat = dms2degrees([47 42 53.75;47 54 30.00;48 01 09.57;48 04 42.08;48 07 15.12;48 09 25.86;48 11 36.21;48 13 46.17;48 18 16.47;48 16 06.33;48 14 01.04]);
PESAT_4K_lon = dms2degrees([17 03 11.37;16 39 59.00;16 30 35.57;16 21 43.48;16 15 18.46;16 08 35.23;16 01 51.44;15 55 07.08;15 58 21.58;16 05 06.38;16 11 25.92]);

% Vienna RWY 29 transitions
BALAD_4M_lat = dms2degrees([47 46 00.21;47 51 41.05;47 54 31.53;47 50 04.25;47 55 26.16;47 59 53.89;48 02 07.16]);
BALAD_4M_lon = dms2degrees([16 14 02.56;16 38 18.48;16 50 37.01;17 03 55.10;17 07 54.39;16 54 35.22;16 47 54.80]);

MABOD_5M_lat = dms2degrees([48 34 28.41;48 26 56.31;48 18 58.99;48 11 01.63;48 06 37.91;48 04 22.39;47 59 54.29;47 55 26.16;47 59 53.89;48 02 07.16]);
MABOD_5M_lon = dms2degrees([16 41 24.35;16 40 15.14;16 39 02.43;16 37 50.10;16 51 07.40;16 57 54.40;17 11 14.38;17 07 54.39;16 54 35.22;16 47 54.80]);

NERDU_4M_lat = dms2degrees([48 28 53.39;48 17 46.17;48 11 01.63;48 06 37.91;48 04 22.39;47 59 54.29;47 55 26.16;47 59 53.89;48 02 07.16]);
NERDU_4M_lon = dms2degrees([16 05 57.34;16 30 13.41;16 37 50.10;16 51 07.40;16 57 54.40;17 11 14.38;17 07 54.39;16 54 35.22;16 47 54.80]);

PESAT_4M_lat = dms2degrees([47 42 53.75;47 48 51.10;47 54 31.53;47 50 04.25;47 55 26.16;47 59 53.89;48 02 07.16]);
PESAT_4M_lon = dms2degrees([17 03 11.37;16 46 24.08;16 50 37.01;17 03 55.10;17 07 54.39;16 54 35.22;16 47 54.80]);

% Vienna RWY 16 transitions
BALAD_5L_lat = dms2degrees([47 46 00.21;47 52 08.28;48 00 01.58;48 06 41.40;48 13 21.01;48 21 41.30;48 27 46.61;48 32 35.64;48 31 13.99;48 26 25.53;48 22 15.23]);
BALAD_5L_lon = dms2degrees([16 14 02.56;16 29 43.88;16 50 07.89;16 45 00.42;16 39 51.68;16 36 21.20;16 33 46.76;16 31 44.11;16 24 29.77;16 26 32.83;16 28 16.89]);

MABOD_6L_lat = dms2degrees([48 34 28.41;48 28 21.00;48 14 57.85;48 13 21.01;48 21 41.30;48 27 46.61;48 32 35.64;48 31 13.99;48 26 25.53;48 22 15.23]);
MABOD_6L_lon = dms2degrees([16 41 24.35;16 43 39.00;16 48 30.52;16 39 51.68;16 36 21.20;16 33 46.76;16 31 44.11;16 24 29.77;16 26 32.83;16 28 16.89]);

NERDU_6L_lat = dms2degrees([48 28 53.39;48 17 41.38;48 19 17.45;48 25 03.52;48 29 51.86;48 31 13.99;48 26 25.53;48 22 15.23]);
NERDU_6L_lon = dms2degrees([16 05 57.34;16 13 19.97;16 21 47.40;16 19 19.46;16 17 15.76;16 24 29.77;16 26 32.83;16 28 16.89]);

PESAT_5L_lat = dms2degrees([47 42 53.75;48 00 01.58;48 06 41.40;48 13 21.01;48 21 41.30;48 27 46.61;48 32 35.64;48 31 13.99;48 26 25.53;48 22 15.23]);
PESAT_5L_lon = dms2degrees([17 03 11.37;16 50 07.89;16 45 00.42;16 39 51.68;16 36 21.20;16 33 46.76;16 31 44.11;16 24 29.77;16 26 32.83;16 28 16.89]);

% Vienna RWY 34 transitions
BALAD_3N_lat = dms2degrees([47 46 00.21;47 52 59.15;47 54 20.48;47 49 31.73;47 44 42.93;47 39 54.06;47 41 14.66;47 46 03.63;47 50 52.53;47 55 40.56]);
BALAD_3N_lon = dms2degrees([16 14 02.56;16 25 10.61;16 32 19.84;16 34 20.29;16 36 20.37;16 38 20.04;16 45 27.78;16 43 28.71;16 41 29.29;16 39 32.50]);

MABOD_4N_lat = dms2degrees([48 34 28.41;48 27 47.10;48 16 15.72;48 06 38.15;47 57 01.81;47 52 12.81;47 47 23.75;47 42 34.67;47 41 14.66;47 46 03.63;47 50 52.53;47 55 40.56]);
MABOD_4N_lon = dms2degrees([16 41 24.35;16 33 46.60;16 38 38.30;16 42 40.10;16 46 39.46;16 48 38.67;16 50 37.51;16 52 36.02;16 45 27.78;16 43 28.71;16 41 29.29;16 39 32.50]);

NERDU_4N_lat = dms2degrees([48 28 53.39;48 27 47.10;48 16 15.72;48 06 38.15;47 57 01.81;47 52 12.81;47 47 23.75;47 42 34.67;47 41 14.66;47 46 03.63;47 50 52.53;47 55 40.56]);
NERDU_4N_lon = dms2degrees([16 05 57.34;16 33 46.60;16 38 38.30;16 42 40.10;16 46 39.46;16 48 38.67;16 50 37.51;16 52 36.02;16 45 27.78;16 43 28.71;16 41 29.29;16 39 32.50]);

PESAT_4N_lat = dms2degrees([47 42 53.75;47 52 13.30;47 58 41.50;47 57 01.81;47 52 12.81;47 47 23.75;47 42 34.67;47 41 14.66;47 46 03.63;47 50 52.53;47 55 40.56]);
PESAT_4N_lon = dms2degrees([17 03 11.37;16 58 42.74;16 55 35.34;16 46 39.46;16 48 38.67;16 50 37.51;16 52 36.02;16 45 27.78;16 43 28.71;16 41 29.29;16 39 32.50]);

% Dublin RWY 28L PMS
PMS_common_28L_1_lat = dms2degrees([53 46 49.0;53 42 33.9;53 39 53.5;53 38 21.0;53 37 42.7;53 34 18.6;53 29 25.8;53 23 47.5;53 18 12.9;53 13 46.9;53 24 11.0]);
PMS_common_28L_1_lon = dms2degrees([-007 17 40.6;-006 36 19.2;-006 11 29.8;-005 57 33.2;-005 45 57.3;-005 38 14.1;-005 33 14.3;-005 31 41.1;-005 33 46.6;-005 38 44.4;-005 56 44.1]);

PMS_common_28L_2_lat = dms2degrees([52 49 27.7;53 00 09.7;53 10 16.5;53 09 19.0;53 08 29.3;53 11 52.3;53 17 22.5;53 24 03.7;53 30 46.6;53 36 21.3;53 24 11.0]);
PMS_common_28L_2_lon = dms2degrees([-006 55 49.3;-006 39 40.0;-006 22 00.7;-006 03 35.1;-005 48 22.5;-005 38 27.7;-005 31 39.8;-005 29 10.1;-005 31 26.4;-005 38 06.9;-005 56 44.1]);

PMS_28L_1_lat = dms2degrees([52 46 58.0;52 59 48.0;53 03 50.1;53 07 39.3;53 11 52.3]);
PMS_28L_1_lon = dms2degrees([-004 59 33.0;-005 22 39.0;-005 30 00.0 ;-005 34 00.8;-005 38 27.7]);

PMS_28L_2_lat = dms2degrees([54 08 28.5;53 42 33.9]);
PMS_28L_2_lon = dms2degrees([-006 39 04.0;-006 36 19.2]);

PMS_28L_3_lat = dms2degrees([53 57 54.1;53 37 42.7]);
PMS_28L_3_lon = dms2degrees([-005 44 31.7;-005 45 57.3]);

PMS_28L_4_lat = dms2degrees([53 46 01.6;53 41 03.1;53 37 42.7]);
PMS_28L_4_lon = dms2degrees([-005 30 00.0;-005 39 34.0;-005 45 57.3]);

PMS_28L_5_lat = dms2degrees([53 40 48.0;53 41 03.1;53 37 42.7]);
PMS_28L_5_lon = dms2degrees([-005 30 00.0;-005 39 34.0;-005 45 57.3]);

PMS_28L_6_lat = dms2degrees([52 33 16.0;53 08 29.3]);
PMS_28L_6_lon = dms2degrees([-005 30 00.0;-005 48 22.5]);

PMS_28L_7_lat = dms2degrees([52 37 21.9;53 00 09.7]);
PMS_28L_7_lon = dms2degrees([-006 37 48.2;-006 39 40.0]);

PMS_28L_8_lat = dms2degrees([53 02 57.9;53 00 09.7]);
PMS_28L_8_lon = dms2degrees([-007 16 12.8;-006 39 40.0]);

MAXEV_lat = dms2degrees([53 24 33]);
MAXEV_lon = dms2degrees([-006 03 17]);

% Dublin RWY 10R PMS
PMS_common_10R_1_lat = dms2degrees([53 40 48.0;53 38 43.0;53 35 34.1;53 33 46.7;53 38 56.0;53 41 53.9;53 41 49.0;53 38 42.8;53 33 29.1;53 31 16.6]);
PMS_common_10R_1_lon = dms2degrees([-005 30 00.0;-005 45 53.1;-006 09 21.6;-006 22 26.4;-006 27 09.6;-006 35 41.5;-006 45 34.9;-006 53 58.4;-006 58 27.2;-006 40 23.6]);

PMS_common_10R_2_lat = dms2degrees([53 03 50.1;53 08 08.9;53 14 30.7;53 17 38.9;53 13 03.3;53 10 59.5;53 12 02.3;53 15 54.2;53 21 55.8]);
PMS_common_10R_2_lon = dms2degrees([-005 30 00.0;-005 48 05.4;-006 12 35.6;-006 24 50.8;-006 30 56.5;-006 40 05.6;-006 49 42.6;-006 57 04.5;-006 41 44.5]);

PMS_10R_1_lat = dms2degrees([53 46 01.6;53 38 43.0]);
PMS_10R_1_lon = dms2degrees([-005 30 00.0;-005 45 53.1]);

PMS_10R_2_lat = dms2degrees([53 57 54.1;53 38 43.0]);
PMS_10R_2_lon = dms2degrees([-005 44 31.7;-005 45 53.1]);

PMS_10R_3_lat = dms2degrees([54 08 28.5;53 49 03.5;53 41 53.9]);
PMS_10R_3_lon = dms2degrees([-006 39 04.0;-006 35 54.8;-006 35 41.5]);

PMS_10R_4_lat = dms2degrees([53 46 49.0;53 49 03.5;53 41 53.9]);
PMS_10R_4_lon = dms2degrees([-007 17 40.6;-006 35 54.8;-006 35 41.5]);

PMS_10R_5_lat = dms2degrees([52 49 27.7;53 00 09.7]);
PMS_10R_5_lon = dms2degrees([-006 55 49.3;-006 39 40.0]);

PMS_10R_6_lat = dms2degrees([52 37 21.9;53 00 09.7;53 06 30.5;53 13 03.3]);
PMS_10R_6_lon = dms2degrees([-006 37 48.2;-006 39 40.0;-006 26 52.1;-006 30 56.5]);

PMS_10R_7_lat = dms2degrees([52 33 16.0;53 08 08.9]);
PMS_10R_7_lon = dms2degrees([-005 30 00.0;-005 48 05.4]);

PMS_10R_8_lat = dms2degrees([53 02 57.9;53 00 09.7]);
PMS_10R_8_lon = dms2degrees([-007 16 12.8;-006 39 40.0]);

GANET_lat = dms2degrees([53 26 06]);
GANET_lon = dms2degrees([-006 31 34]);

% Dublin RWY 34 PMS
PMS_common_34_1_lat = [PMS_common_28L_1_lat(1:5);dms2degrees([53 15 25.3;53 13 27.4;53 17 17])];
PMS_common_34_1_lon = [PMS_common_28L_1_lon(1:5);dms2degrees([-005 58 53.4;-006 06 32.4;-006 09 17])];

PMS_common_34_2_lat = [PMS_common_28L_2_lat(1:5);dms2degrees([53 13 27.4;53 17 17])];
PMS_common_34_2_lon = [PMS_common_28L_2_lon(1:5);dms2degrees([-006 06 32.4;-006 09 17])];

PMS_34_1_lat = dms2degrees([53 03 50.1;53 08 29.3]);
PMS_34_1_lon = dms2degrees([-005 30 00.0;-005 48 22.5]);

PMS_34_2_lat = PMS_28L_2_lat;
PMS_34_2_lon = PMS_28L_2_lon;

PMS_34_3_lat = PMS_28L_3_lat;
PMS_34_3_lon = PMS_28L_3_lon;

PMS_34_4_lat = PMS_28L_4_lat;
PMS_34_4_lon = PMS_28L_4_lon;

PMS_34_5_lat = PMS_28L_5_lat;
PMS_34_5_lon = PMS_28L_5_lon;

PMS_34_6_lat = PMS_28L_6_lat;
PMS_34_6_lon = PMS_28L_6_lon;

PMS_34_7_lat = PMS_28L_7_lat;
PMS_34_7_lon = PMS_28L_7_lon;

PMS_34_8_lat = PMS_28L_8_lat;
PMS_34_8_lon = PMS_28L_8_lon;

ABDOX_lat = dms2degrees([53 17 17]);
ABDOX_lon = dms2degrees([-006 09 17]);

% Dublin RWY 16 PMS
GARTI_lat = dms2degrees([53 34 13]);
GARTI_lon = dms2degrees([-006 21 32]);

PMS_common_16_1_lat = dms2degrees([53 46 49.0;53 42 01;53 38 03.3;53 37 40.0;53 34 13]);
PMS_common_16_1_lon = dms2degrees([-007 17 40.6;-006 44 17.2;-006 31 35.5;-006 24 03.7;-006 21 32]);

PMS_common_16_2_lat = dms2degrees([53 37 42.7;53 40 29.0;53 37 40.0]);
PMS_common_16_2_lon = dms2degrees([-005 45 57.3;-006 16 55.0;-006 24 03.7]);

PMS_16_1_lat = dms2degrees([53 40 48.0;53 41 03.1;53 37 42.7]);
PMS_16_1_lon = dms2degrees([-005 30 00.0;-005 39 34.0;-005 45 57.3]);

PMS_16_2_lat = dms2degrees([53 46 01.6;53 41 03.1;53 37 42.7]);
PMS_16_2_lon = dms2degrees([-005 30 00.0;-005 39 34.0;-005 45 57.3]);

PMS_16_3_lat = dms2degrees([52 37 21.9;53 00 09.7;53 10 16.5;53 17 15.0]);
PMS_16_3_lon = dms2degrees([-006 37 48.2;-006 39 40.0;-006 22 00.7;-006 18 27.0]);

PMS_16_4_lat = dms2degrees([53 03 50.1;53 08 08.9;53 17 15.0]);
PMS_16_4_lon = dms2degrees([-005 30 00.0;-005 48 05.4;-006 18 27.0]);

PMS_16_5_lat = dms2degrees([53 57 54.1;53 37 42.7]);
PMS_16_5_lon = dms2degrees([-005 44 31.7;-005 45 57.3]);

PMS_16_6_lat = dms2degrees([52 33 16.0;53 08 08.9;53 17 15.0]);
PMS_16_6_lon = dms2degrees([-005 30 00.0;-005 48 05.4;-006 18 27.0]);

PMS_16_7_lat = dms2degrees([53 02 57.9;53 00 09.7;53 10 16.5;53 17 15.0]);
PMS_16_7_lon = dms2degrees([-007 16 12.8;-006 39 40.0;-006 22 00.7;-006 18 27.0]);

PMS_16_8_lat = dms2degrees([52 49 27.7;53 00 09.7;53 10 16.5;53 17 15.0;53 37 36.3;53 42 01.0]);
PMS_16_8_lon = dms2degrees([-006 55 49.3;-006 39 40.0;-006 22 00.7;-006 18 27.0;-006 37 17.1;-006 44 17.2]);

% OSLO
        IF_lat = dms2degrees([57 28 51.85]);
        IF_lon = dms2degrees([012 06 55.41]);
        % 
        % NY708 = [ ];
switch IF_stop
    case 'OGRAS'
        IF_lat = dms2degrees([59 59 37.33]);
        IF_lon = dms2degrees([10 57 51.01]);
    case 'NOSLA'
        IF_lat = dms2degrees([59 59 01.16]);
        IF_lon = dms2degrees([10 59 51.24]);
end

% oslo_TMA_lat = [59.7097
% 59.3667
% 59.8333
% 59.8906
% 60.2236
% 60.4039
% 60.5
% 60.7125
% 60.875
% 60.7972
% 60.8778
% 60.9389
% 60.925
% 60.7292
% 59.7097
% ];
% 
% oslo_TMA_lon = [9.59556
% 11.7944
% 11.8494
% 12.0989
% 12.3611
% 12.3394
% 12.3417
% 12.2917
% 11.8292
% 11.6958
% 11.0722
% 10.95
% 10.5583
% 10.1
% 9.59556
% ];

% -------------------------- GLOBAL VARIABLES --------------------------- %

global p_0 a_0 T_0 rho_0 g_0 R k beta_T_less H_p_trop ft_to_m NM_to_m T_trop_ISA p_trop_ISA delta_T coord_min_to_deg ms_to_kt m_to_ft deg_to_min Vd_des_1 Vd_des_2 Vd_des_3 Vd_des_4 C_v_min m_to_NM kt_to_ms

a_0 = 340.294;                  % speed of sound at MSL in standard atmosphere [m/s]
p_0 = 101325;                   % standard atmospheric pressure at MSL [Pa]
T_0 = 288.15;                   % standard atmospheric temperature at MSL [K]
rho_0 = 1.225;                  % standard atmospheric density at MSL [kg/m^3]
g_0 = 9.80665;                  % gravitational acceleration [m/s^2]
R = 287.05287;                  % real gas constant for air [m^2 /(K * s^2 )]
k = 1.4;                        % adiabatic index of air [-]
beta_T_less = -0.0065;          % ISA temperature gradient with altitude below the tropopause [K/m]
H_p_trop = 11000;               % Tropopause altitude in ISA conditions [m]
ft_to_m = 0.3048;               % ft to m conversion factor [-]
NM_to_m = 1852;                 % NM to m conversion factor [-] 
m_to_NM = 1/1852;               % m to NM conversion factor [-]
T_trop_ISA = 216.65;            % Tropopause temperature in ISA conditions [K]
p_trop_ISA = 22632.0401;        % Tropopause temperature in ISA conditions [Pa]
delta_T = 0;                    % Temperature ISA deviation [K]
coord_min_to_deg = 0.0166666667;% Minutes to degrees conversion factor for coordinates [-] 
ms_to_kt = 1.9438444924406;     % m/s to kt conversion factor [-]
kt_to_ms = 0.5144444;           % kt to m/s conversion factor [-]
m_to_ft = 3.2808;               % m to ft conversion factor [-]
deg_to_min = 0.0166666667;      % degrees to minutes facotr (coordinates) [-]
Vd_des_1 = 5;                   % BADA descent speed increment <1000 ft [kt]
Vd_des_2 = 10;                  % BADA descent speed increment <1500 ft [kt]
Vd_des_3 = 20;                  % BADA descent speed increment <2000 ft [kt]
Vd_des_4 = 50;                  % BADA descent speed increment <3000 ft [kt]
C_v_min = 1.23;                 % BADA minimum speed coefficient

% ---------------------------- TMA SELECTOR ----------------------------- %

if strcmp(airport,'ESSA')
    TMA_lat = sthlm_TMA_lat;
    TMA_lon = sthlm_TMA_lon;
elseif strcmp(airport,'ESGG')
    TMA_lat = goteborg_TMA_lat;
    TMA_lon = goteborg_TMA_lon;
elseif strcmp(airport,'EIDW')
    TMA_lat = Dublin_TMA_lat;
    TMA_lon = Dublin_TMA_lon;
elseif strcmp(airport,'LOWW')
    TMA_lat = vienna_TMA_lat;
    TMA_lon = vienna_TMA_lon;
elseif strcmp(airport,'ENGM')
    TMA_lat = oslo_TMA_lat;
    TMA_lon = oslo_TMA_lon;
end

% --------------------------- FUNCTION CALLS ---------------------------- %

% BADA .xml data
[S,M_max,C_D_scalar,d,bf,mlw,L_HV,a,f,kink_point,b,p,c,ti,fi,engine_type,C_L_max_BADA,W_P_max,n_eng,D_P,eta_max,C_L_max_landing,CAS1_descent,CAS2_descent,M_descent] = read_bada_xml(ac_type,BADA_dir,mlw_factor);

if strcmp(csv_data_source,'DDR') == 0
    [flight_file, rocd, baro_vert_rate,mach_LFV,unix_time] = csv_2_so6(flight_file,DDR_dir,csv_data_source,fr24_dir,down_sample,rate,remove_zero_length,remove_alt_outliers,alt_diff_thr,alt_fill_option,callsign,search_callsign,LFV_dir,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option);
end

% so6 DDR Data
[time_start, time_end, alt_start, alt_end, segment_length,lat_start, lon_start, lat_end, lon_end,GS_OS_start,GS_OS_end] = read_so6(flight_file,DDR_dir);

% Time samples of the flight
[time_duration,time_start,time_end] = calculate_time(time_start, time_end);

% Start time of samples expressed in hours
hours_start = calculate_hours(time_start);

% Total duration of descent [sec]
total_dur = calculate_total_dur(time_duration);

% % Tropopause temperature
% T_trop = calculate_T_trop TEMPORARLY NOT IN USE
% 
% % Tropopause pressure
% p_trop = calculate_p_trop TEMPORARLY NOT IN USE

% ISA temperature
T_ISA = calculate_T_ISA(alt_start);

% ISA pressure and pressure ratio
[pressure, pressure_ratio] = calculate_pressure(alt_start,T_ISA);

% Temperature and wind components from .nc file
[T_calc,u_calc,v_calc,T_nc,u_nc,v_nc,longitude,latitude,time,level,time_23,day_before] = calculate_t_u_v(hours_start,lon_start,lat_start,nc_file_T_w_alt,pressure,nc_dir,unix_time);

% Temperature ratio
T_calc_ratio = calculate_T_calc_ratio(T_calc);

% Density
[rho, rho_ratio] = calculate_rho(pressure,T_calc);

% Mach stall at landing
[M_stall,pressure_stall,T_stall,rho_stall] = calculate_M_stall(mlw,S,C_L_max_landing);

% TAS stall at landing
TAS_stall = calculate_TAS_stall(M_stall,T_stall);

% CAS stall at landing
CAS_stall = calculate_CAS(pressure_stall,rho_stall,TAS_stall);

% Ground speed
% GS = calculate_GS(time_duration,segment_length); %OLD
GS = GS_OS_start;

% Wind speed and wind direction based on .nc file
[wind_speed,wind_dir] = calculate_wind(v_calc,u_calc);

% dh/dt
dh_dt = calculate_dh_dt(alt_start,alt_end,time_duration,smooth_ROD,smooth_ROD_k,smooth_ROD_option);

% Flight track (course)
flight_track = calculate_track(lon_start,lat_start,lon_end,lat_end,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option);

% Wind component (head or tail)
wind_comp = calculate_wind_component(flight_track,wind_dir);

% True airspeed
TAS = calculate_TAS(GS,wind_comp,wind_speed,smooth_TAS,smooth_TAS_k,smooth_TAS_option,total_dur,extrapolate_TAS_start,extrapolate_TAS_end,TAS_diff_thr,TAS_brake_point);

% Calibrated airspeed
CAS = calculate_CAS(pressure,rho,TAS);

% dv/dt
dv_dt = calculate_dv_dt(TAS,time_duration);

% Mach number
M = calculate_Mach(TAS,T_calc);

% Total temperature ratio
total_T_ratio = calculate_total_T_ratio(T_calc_ratio,M);

% Propeller efficiency
if strcmp(engine_type,'TURBOPROP')
    eta = calculate_eta(eta_max,W_P_max,n_eng,rho_ratio,D_P,TAS);
end

% Max lift coefficient (C_L max)
C_L_max = calculate_C_L_max(M,bf,C_L_max_BADA);

% Lift coefficient (C_L)
C_L = calculate_C_L(mlw,pressure_ratio,S,M,C_L_max); 

% Drag coefficient (C_D)
C_D = calculate_C_D(M,C_L,d,C_D_scalar);

% Drag
D = calculate_drag(pressure_ratio,S,M,C_D);

% Thrsut coefficient idle
C_T_idle = calculate_C_T_idle(pressure_ratio,M,ti,engine_type,T_calc_ratio);

% Thrust idle
Thr_idle = calculate_Thr_idle(pressure_ratio,mlw,C_T_idle);

% Throttle parameter
T_param = calculate_T_param(pressure_ratio,M,b,p,c,kink_point,T_calc,total_T_ratio,engine_type,T_calc_ratio);

% Power coefficient
if strcmp(engine_type,'TURBOPROP')
   C_P_MCMB = calculate_C_P_MCMB(W_P_max,eta,pressure_ratio,mlw,a,M,T_param);
else
    C_P_MCMB = [];
end

% Thrust coefficient MCMB
C_T_MCMB = calculate_C_T_MCMB(M,a,T_param,engine_type,C_P_MCMB);

% Thurst MCMB
Thr_MCMB = calculate_Thr_MCMB(pressure_ratio,mlw,C_T_MCMB);

% Thrust
Thr = calculate_thrust(mlw,TAS,dh_dt,dv_dt,D,Thr_idle,Thr_MCMB);

% Thrust coefficient
C_T = calculate_C_T(Thr,pressure_ratio,mlw);

if strcmp(engine_type,'TURBOPROP')
   C_P = calculate_C_P(M,C_T);
else
    C_P = [];
end

% Idle fuel coefficient
C_F_idle = calculate_C_F_idle(fi,M,pressure_ratio,T_calc_ratio,engine_type);

% Fuel coefficient
C_F = calculate_C_F(C_T,C_P,M,f,C_F_idle,engine_type);

% Fuel flow
F = calculate_F(pressure_ratio,T_calc_ratio,mlw,L_HV,C_F);

% Distance to go
dtg = calculate_dtg(segment_length);

% TMA entry
[TMA_entry_lon,TMA_entry_lat] = calculate_TMA_entry(lon_start,lat_start,TMA_lat,TMA_lon);

% FAP time
if strcmp(end_calculation,'user_alt')
    [user_alt_end_time,FAP_message] = calculate_FAP_time(alt_start,total_dur,FAP_alt);
else
    user_alt_end_time = 0;
end

% FAP entry coordinates
[FAP_entry_lon,FAP_entry_lat] = calculate_FAP_entry_coord(FAP_01L_lat,FAF_08_lat,FAP_19R_lat,FAP_19L_lat,FAP_26_lat,FAP_01R_lat,FAP_01L_lon,FAF_08_lon,FAP_19R_lon,FAP_19L_lon,FAP_26_lon,FAP_01R_lon,lon_start,lat_start,end_calculation,total_dur,user_alt_end_time,IF_lat,IF_lon);

% FAP entry time
if strcmp(end_calculation,'FAP')
    [FAP_entry_time,FAP_message] = calculate_FAP_entry_time(lon_start,lat_start,FAP_entry_lon,FAP_entry_lat,total_dur,alt_start,FAP_alt);
else
    FAP_entry_time = user_alt_end_time;
end
    
% TMA entry time
TMA_entry_time = calculate_interp_entry(lon_start,lat_start,TMA_entry_lon, TMA_entry_lat,total_dur);

% Total fuel consumption during descent
[F_burn_tot, F_burn_TMA,TMA_time_vector,TMA_fuel_vector,F_burn_time_TMA] = calculate_F_burn(F,total_dur,TMA_entry_time,FAP_entry_time);

% Time from TMA to FAP alt
time_in_TMA = calculate_time_in_TMA(TMA_time_vector);

% Altitude in TMA
alt_in_TMA = calculate_alt_in_TMA(alt_start,TMA_time_vector,total_dur);

% Distance in TMA
[dist_in_TMA,dtg_in_TMA] = calculate_dist_in_TMA(TMA_entry_time,FAP_entry_time,total_dur,dtg,TMA_time_vector);

% M_in_TMA
M_in_TMA = calculate_M_in_TMA(M,TMA_time_vector,total_dur);

% TAS_in_TMA
TAS_in_TMA = calculate_TAS_in_TMA(TAS,TMA_time_vector,total_dur);

% TAS_in_TMA
GS_in_TMA = calculate_GS_in_TMA(GS,TMA_time_vector,total_dur);

% CAS in_TMA
CAS_in_TMA = calculate_CAS_in_TMA(CAS,TMA_time_vector,total_dur);

% dt/dt_in_TMA
dh_dt_in_TMA = calculate_dh_dt_in_TMA(dh_dt,TMA_time_vector,total_dur);

% Coordinates in TMA
[lon_TMA,lat_TMA] = coord_in_TMA(lat_start,lon_start,TMA_time_vector,total_dur);

% Thrust in TMA
Thr_TMA = calculate_Thr_in_TMA(Thr,total_dur,TMA_time_vector);

% CL in TMA
C_L_TMA = calculate_C_L_in_TMA(C_L,total_dur,TMA_time_vector);

% CD in TMA
C_D_TMA = calculate_C_D_in_TMA(C_D,total_dur,TMA_time_vector);

% Wind comp in TMA
wind_comp_in_TMA = calculate_wind_comp_in_TMA(wind_comp,total_dur,TMA_time_vector);

% Wind dir in TMA
wind_dir_in_TMA = calculate_wind_dir_in_TMA(wind_dir,total_dur,TMA_time_vector);

% Flight track in TMA
flight_track_in_TMA = calculate_flight_track_in_TMA(flight_track,total_dur,TMA_time_vector);

% Wind speed in TMA
wind_speed_in_TMA = calculate_wind_speed_in_TMA(wind_speed,total_dur,TMA_time_vector);

% Absolute time at end option
time_at_FAP = calculate_time_at_FAP(total_dur,hours_start,TMA_time_vector);

% Absolute time at TMA entry
time_at_TMA = calculate_time_at_TMA(total_dur,hours_start,TMA_time_vector);

% UNIX time in TMA
unix_time_in_TMA = calculate_unix_time_in_TMA(total_dur,TMA_time_vector,time_at_FAP,time_at_TMA,date,unix_time);

if strcmp(airport,'LOWW')
    [LOWW_transition_lat_1,LOWW_transition_lon_1,LOWW_transition_lat_2,LOWW_transition_lon_2,LOWW_transition_lat_3,LOWW_transition_lon_3,LOWW_transition_lat_4,LOWW_transition_lon_4,rwy] = find_loww_rwy(lon_TMA,lat_TMA,BALAD_3K_lat,BALAD_3K_lon,MABOD_4K_lat,MABOD_4K_lon,NERDU_4K_lat,NERDU_4K_lon,PESAT_4K_lat,PESAT_4K_lon,BALAD_4M_lat,BALAD_4M_lon,MABOD_5M_lat,MABOD_5M_lon,NERDU_4M_lat,NERDU_4M_lon,PESAT_4M_lat,PESAT_4M_lon,BALAD_5L_lat,BALAD_5L_lon,MABOD_6L_lat,MABOD_6L_lon,NERDU_6L_lat,NERDU_6L_lon,PESAT_5L_lat,PESAT_5L_lon,BALAD_3N_lat,BALAD_3N_lon,MABOD_4N_lat,MABOD_4N_lon,NERDU_4N_lat,NERDU_4N_lon,PESAT_4N_lat,PESAT_4N_lon);
elseif strcmp(airport,'EIDW')
    [PMS_lat_1,PMS_lat_2,PMS_lat_3,PMS_lat_4,PMS_lat_5,PMS_lat_6,PMS_lat_7,PMS_lat_8,PMS_lat_9,PMS_lat_10,PMS_lon_1,PMS_lon_2,PMS_lon_3,PMS_lon_4,PMS_lon_5,PMS_lon_6,PMS_lon_7,PMS_lon_8,PMS_lon_9,PMS_lon_10,rwy] = find_eidw_rwy(lon_TMA,lat_TMA,PMS_common_10R_1_lat,PMS_common_10R_1_lon,PMS_common_10R_2_lat,PMS_common_10R_2_lon,PMS_10R_1_lat,PMS_10R_1_lon,PMS_10R_2_lat,PMS_10R_2_lon,PMS_10R_3_lat,PMS_10R_3_lon,PMS_10R_4_lat,PMS_10R_4_lon,PMS_10R_5_lat,PMS_10R_5_lon,PMS_10R_6_lat,PMS_10R_6_lon,PMS_10R_7_lat,PMS_10R_7_lon,PMS_10R_8_lat,PMS_10R_8_lon,PMS_common_28L_1_lat,PMS_common_28L_1_lon,PMS_common_28L_2_lat,PMS_common_28L_2_lon,PMS_28L_1_lat,PMS_28L_1_lon,PMS_28L_2_lat,PMS_28L_2_lon,PMS_28L_3_lat,PMS_28L_3_lon,PMS_28L_4_lat,PMS_28L_4_lon,PMS_28L_5_lat,PMS_28L_5_lon,PMS_28L_6_lat,PMS_28L_6_lon,PMS_28L_7_lat,PMS_28L_7_lon,PMS_28L_8_lat,PMS_28L_8_lon,MAXEV_lat,MAXEV_lon,GANET_lat,GANET_lon,PMS_common_34_1_lat,PMS_common_34_1_lon,PMS_common_34_2_lat,PMS_common_34_2_lon,PMS_34_1_lat,PMS_34_1_lon,PMS_34_2_lat,PMS_34_2_lon,PMS_34_3_lat,PMS_34_3_lon,PMS_34_4_lat,PMS_34_4_lon,PMS_34_5_lat,PMS_34_5_lon,PMS_34_6_lat,PMS_34_6_lon,PMS_34_7_lat,PMS_34_7_lon,PMS_34_8_lat,PMS_34_8_lon,PMS_common_16_1_lat,PMS_common_16_1_lon,PMS_common_16_2_lat,PMS_common_16_2_lon,PMS_16_1_lat,PMS_16_1_lon,PMS_16_2_lat,PMS_16_2_lon,PMS_16_3_lat,PMS_16_3_lon,PMS_16_4_lat,PMS_16_4_lon,PMS_16_5_lat,PMS_16_5_lon,PMS_16_6_lat,PMS_16_6_lon,PMS_16_7_lat,PMS_16_7_lon,PMS_16_8_lat,PMS_16_8_lon,ABDOX_lat,ABDOX_lon,GARTI_lat,GARTI_lon);  
elseif strcmp(airport,'ESSA')
    [IAF_1_lat,IAF_1_lon,IAF_2_lat,IAF_2_lon,ELTOK_STAR_lat,ELTOK_STAR_lon,HMR_STAR_lat,HMR_STAR_lon,NILUG_STAR_lat,NILUG_STAR_lon,XILAN_STAR_lat,XILAN_STAR_lon,rwy] = find_essa_rwy(lon_start(end),lat_start(end),ELTOK_7M_lat,ELTOK_7M_lon,HMR_5M_lat,HMR_5M_lon,NILUG_2M_lat,NILUG_2M_lon,XILAN_4M_lat,XILAN_4M_lon,ELTOK_7P_lat,ELTOK_7P_lon,HMR_4P_lat ,HMR_4P_lon,NILUG_2P_lat,NILUG_2P_lon,XILAN_5P_lat,XILAN_5P_lon,ELTOK_7S_lat,ELTOK_7S_lon,HMR_5S_lat,HMR_5S_lon,NILUG_2S_lat,NILUG_2S_lon,XILAN_4S_lat,XILAN_4S_lon,ELTOK_4T_lat,ELTOK_4T_lon,HMR_4T_lat,HMR_4T_lon,NILUG_2T_lat,NILUG_2T_lon,XILAN_5T_lat,XILAN_5T_lon,zero_one_L_lon,zero_one_L_lat,zero_one_R_lon,zero_one_R_lat,one_nine_L_lon,one_nine_L_lat,one_nine_R_lon,one_nine_R_lat,two_six_lon,two_six_lat,zero_eight_lon,zero_eight_lat,FAP_01L_lat,FAP_01L_lon,FAP_01R_lat,FAP_01R_lon,FAP_19R_lat,FAP_19R_lon,FAP_19L_lat,FAP_19L_lon,FAP_26_lat,FAP_26_lon,FAF_08_lat,FAF_08_lon,lat_TMA(end),lon_TMA(end));
elseif strcmp(airport,'ESGG')
    [rwy] = find_esgg_rwy(lat_TMA(end),lon_TMA(end));
end






%  data
if export == 1
    file_name = export_data(time_in_TMA,TMA_fuel_vector,alt_in_TMA,flight_file,export_dir,csv_data_source,M_in_TMA,TAS_in_TMA,CAS_in_TMA,dh_dt_in_TMA,dtg_in_TMA,search_callsign,callsign,lat_TMA,lon_TMA,C_L_TMA,C_D_TMA,Thr_TMA,callsign_save,ac_type,airport,date,unix_time,F_burn_TMA,TMA_time_vector,unix_time_in_TMA,F_burn_time_TMA,icao_type,wtc,rwy);
else
    file_name = [];
end

if CAS_match == 1
    CAS_start = CAS_in_TMA(1);
    if CAS_start < 230*kt_to_ms
        CAS_start = 230*kt_to_ms;
    end
else
    CAS_start = 1000;
end

% Create CDO
if CDO == 1
    [t_CDO,cum_dist_CDO,alt_CDO,F_CDO,M_CDO,TAS_CDO,CAS_CDO,ROCD_CDO,lat_CDO,lon_CDO,F_burn_CDO,Dist_CDO,Time_CDO,wind_speed_CDO,wind_dir_CDO,flight_track_CDO,wind_comp_CDO] = CDO_profile_predictor(lat_TMA,lon_TMA,mlw_factor,ac_type,BADA_dir,dist_in_TMA,alt_in_TMA,time_at_FAP,wind_temp,latitude,longitude,T_nc,u_nc,v_nc,level,time,cruise_alt,Vd_des_1,Vd_des_2,Vd_des_3,Vd_des_4,CAS_stall,C_v_min,CAS1_descent,CAS2_descent,M_descent,file_name,export_dir_CDO,kt_per_sec_reduce,export,time_23,CAS_start,callsign_save,airport,date,unix_time,unix_time_in_TMA,icao_type,day_before,wtc,rwy,entry_point,PM_profile,IF,powered_descent,descent_angle,IAS_start_CDO,IAS_restriction_CDO,alt_start_CDO,export_wpts);
    if plot_both == 1
        wind_temp = 0;
        [t_CDO_2,cum_dist_CDO_2,alt_CDO_2,F_CDO_2,M_CDO_2,TAS_CDO_2,CAS_CDO_2,ROCD_CDO_2,lat_CDO_2,lon_CDO_2,F_burn_CDO_2,Dist_CDO_2,Time_CDO_2,wind_speed_CDO_2,wind_dir_CDO_2,flight_track_CDO_2,wind_comp_CDO_2] = CDO_profile_predictor(lat_TMA,lon_TMA,mlw_factor,ac_type,BADA_dir,dist_in_TMA,alt_in_TMA,time_at_FAP,nc_dir,wind_temp,latitude,longitude,T_nc,u_nc,v_nc,level,time,cruise_alt,Vd_des_1,Vd_des_2,Vd_des_3,Vd_des_4,CAS_stall,C_v_min,CAS1_descent,CAS2_descent,M_descent,file_name,export_dir_CDO,kt_per_sec_reduce,0,time_23,CAS_start,callsign_save,airport,date,unix_time,unix_time_in_TMA,icao_type,day_before,wtc,rwy,entry_point,PM_profile,IF,powered_descent,descent_angle,IAS_start_CDO,IAS_restriction_CDO,alt_start_CDO,export_wpts);
    end
else
    F_burn_CDO = [];
end
if plot_on_off == 1
title_text = [callsign_save,' - ',icao_type,' - ',rwy];
% ----------------------------- PLOTTING -------------------------------- %
close all

% Coordinates to plot
for i = 1:max(size(lon_start))
    lon_plot(2*i-1) = lon_start(i);
    lon_plot(2*i) = lon_end(i);
    lat_plot(2*i-1) = lat_start(i);
    lat_plot(2*i) = lat_end(i);
end

% Flip t_CDO
if CDO == 1
    t_CDO = flip(t_CDO);
elseif plot_both == 1
    t_CDO = flip(t_CDO);
    t_CDO_2 = flip(t_CDO_2);
end

%%% FIGURE 1 %%%
h = figure(1);

% Mach
subplot(6,2,1) 
hold on
plot(time_in_TMA/60,M_in_TMA)
ylim([0 ceil((max(sort(M_in_TMA)))/0.1)*0.1])
yticks(0:0.1:ceil((max(sort(M_in_TMA)))/0.1)*0.1)
if CDO == 1
    plot(t_CDO/60,M_CDO)  
    ylim([0 ceil((max(sort([M_in_TMA;M_CDO'])))/0.1)*0.1])
    yticks(0:0.1:ceil((max(sort([M_in_TMA;M_CDO'])))/0.1)*0.1)
end
if plot_both == 1
    plot(t_CDO_2/60,M_CDO_2)
    ylim([0 ceil((max(sort([M_in_TMA;M_CDO';M_CDO_2'])))/0.1)*0.1])
    yticks(0:0.1:ceil((max(sort([M_in_TMA;M_CDO';M_CDO_2'])))/0.1)*0.1)
end
xlabel('Time to final [min]')
ylabel('M [-]')
set(gca,'Xdir','reverse')
if plot_both == 1
    legend('Actual trajectory','CDO trajectory','CDO trajectory (ISA)','Position',[0.466 0.94 0.1 0.05]);
elseif CDO == 1
    legend('Actual trajectory','CDO trajectory')
end
grid on
legend('boxoff')

subplot(6,2,2) 
hold on
plot(dtg_in_TMA,(M_in_TMA))
ylim([0 ceil((max(sort(M_in_TMA)))/0.1)*0.1])
yticks(0:0.1:ceil((max(sort(M_in_TMA)))/0.1)*0.1)
if CDO == 1
    plot(cum_dist_CDO,(M_CDO))
    ylim([0 ceil((max(sort([M_in_TMA;M_CDO'])))/0.1)*0.1])
    yticks(0:0.1:ceil((max(sort([M_in_TMA;M_CDO'])))/0.1)*0.1)
end
if plot_both == 1
   plot(cum_dist_CDO_2,(M_CDO_2)) 
   ylim([0 ceil((max(sort([M_in_TMA;M_CDO';M_CDO_2'])))/0.1)*0.1])
   yticks(0:0.1:ceil((max(sort([M_in_TMA;M_CDO';M_CDO_2'])))/0.1)*0.1)
end
xlabel('Distance to go [NM]')
ylabel('M [-]')
set(gca,'Xdir','reverse')
grid on

% TAS
subplot(6,2,3) 
hold on
plot(time_in_TMA/60,TAS_in_TMA*ms_to_kt)
ylim([0 ceil((max(sort(TAS_in_TMA.*ms_to_kt)))/100)*100])
yticks(0:100:ceil((max(sort(TAS_in_TMA*ms_to_kt)))/100)*100)
if CDO == 1
    plot(t_CDO/60,TAS_CDO*ms_to_kt)
    ylim([0 ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt])))/100)*100)
end
if plot_both == 1
    plot(t_CDO_2/60,TAS_CDO_2*ms_to_kt)
    ylim([0 ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt;TAS_CDO_2'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt;TAS_CDO_2'.*ms_to_kt])))/100)*100)
end
xlabel('Time to final [min]')
ylabel('TAS [kt]')
set(gca,'Xdir','reverse')
grid on

subplot(6,2,4) 
hold on
plot(dtg_in_TMA,(TAS_in_TMA*ms_to_kt))
ylim([0 ceil((max(sort(TAS_in_TMA.*ms_to_kt)))/100)*100])
yticks(0:100:ceil((max(sort(TAS_in_TMA*ms_to_kt)))/100)*100)
if CDO == 1
    plot(cum_dist_CDO,(TAS_CDO*ms_to_kt))
    ylim([0 ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt])))/100)*100)
end
if plot_both == 1
    plot(cum_dist_CDO_2,(TAS_CDO_2*ms_to_kt))
    ylim([0 ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt;TAS_CDO_2'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([TAS_in_TMA.*ms_to_kt;TAS_CDO'.*ms_to_kt;TAS_CDO_2'.*ms_to_kt])))/100)*100)
end
xlabel('Distance to go [NM]')
ylabel('TAS [kt]')
set(gca,'Xdir','reverse')
grid on

% CAS
subplot(6,2,5) 
hold on
plot(time_in_TMA/60,CAS_in_TMA*ms_to_kt)
ylim([0 ceil((max(sort(CAS_in_TMA.*ms_to_kt)))/100)*100])
yticks(0:100:ceil((max(sort(CAS_in_TMA*ms_to_kt)))/100)*100)
if CDO == 1
    plot(t_CDO/60,CAS_CDO*ms_to_kt)
    ylim([0 ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt])))/100)*100)
end
if plot_both == 1
    plot(t_CDO_2/60,CAS_CDO_2*ms_to_kt)
    ylim([0 ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt;CAS_CDO_2'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt;CAS_CDO_2'.*ms_to_kt])))/100)*100)
end
xlabel('Time to final [min]')
ylabel('CAS [kt]')
set(gca,'Xdir','reverse')
grid on

subplot(6,2,6) 
hold on
plot(dtg_in_TMA,(CAS_in_TMA*ms_to_kt))
ylim([0 ceil((max(sort(CAS_in_TMA.*ms_to_kt)))/100)*100])
yticks(0:100:ceil((max(sort(CAS_in_TMA*ms_to_kt)))/100)*100)
if CDO == 1
    plot(cum_dist_CDO,(CAS_CDO*ms_to_kt))
    ylim([0 ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt])))/100)*100])
    yticks(0:100:ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt])))/100)*100)
end
if plot_both == 1
     plot(cum_dist_CDO_2,(CAS_CDO_2*ms_to_kt))
     ylim([0 ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt;CAS_CDO_2'.*ms_to_kt])))/100)*100])
     yticks(0:100:ceil((max(sort([CAS_in_TMA.*ms_to_kt;CAS_CDO'.*ms_to_kt;CAS_CDO_2'.*ms_to_kt])))/100)*100)
end
xlabel('Distance to go [NM]')
ylabel('CAS [kt]')
set(gca,'Xdir','reverse')
grid on

% Altitude
subplot(6,2,7)
hold on
plot(time_in_TMA/60,alt_in_TMA)
ylim([0 ceil((max(sort(alt_in_TMA)))/50)*50])
yticks(0:50:ceil((max(sort(alt_in_TMA)))/50)*50)
if CDO == 1
    plot(t_CDO/60,alt_CDO*3.2808/100)
    ylim([0 ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100])))/50)*50])
    yticks(0:50:ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100])))/50)*50)
end
if plot_both == 1
    plot(t_CDO_2/60,alt_CDO_2*3.2808/100)
    ylim([0 ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100;alt_CDO_2'*3.2808/100])))/50)*50])
    yticks(0:50:ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100;alt_CDO_2'*3.2808/100])))/50)*50)
    
end
xlabel('Time to final [min]')
ylabel('Alt [FL]')
set(gca,'Xdir','reverse')
grid on

subplot(6,2,8)
hold on
plot(dtg_in_TMA,(alt_in_TMA))
ylim([0 ceil((max(sort(alt_in_TMA)))/50)*50])
yticks(0:50:ceil((max(sort(alt_in_TMA)))/50)*50)
if CDO == 1
    plot(cum_dist_CDO,(alt_CDO*3.2808/100))
    ylim([0 ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100])))/50)*50])
    yticks(0:50:ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100])))/50)*50)
end
if plot_both == 1
    plot(cum_dist_CDO_2,(alt_CDO_2*3.2808/100))
    ylim([0 ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100;alt_CDO_2'*3.2808/100])))/50)*50])
    yticks(0:50:ceil((max(sort([alt_in_TMA;alt_CDO'*3.2808/100;alt_CDO_2'*3.2808/100])))/50)*50)
end
xlabel('Distance to go [NM]')
ylabel('Alt [FL]')
set(gca,'Xdir','reverse')
grid on

% RoD
subplot(6,2,9)
hold on
plot(time_in_TMA/60,dh_dt_in_TMA*60*3.2808)
ylim([floor((min(sort(dh_dt_in_TMA*60*3.2808)))/500)*500 500])
yticks(floor((min(sort(dh_dt_in_TMA*60*3.2808)))/500)*500:500:500)
if CDO == 1
    plot(t_CDO/60,ROCD_CDO*60*3.2808)
    ylim([floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808])))/500)*500 500])
    yticks(floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808])))/500)*500:500:500)
end
if plot_both == 1
    plot(t_CDO_2/60,ROCD_CDO_2*60*3.2808)
    ylim([floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808;ROCD_CDO_2'*60*3.2808])))/500)*500 500])
    yticks(floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808;ROCD_CDO_2'*60*3.2808])))/500)*500:500:500)
end
xlabel('Time to final [min]')
ylabel('ROD [ft/min]')
set(gca,'Xdir','reverse')
% yticks([floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808])))/500)*500:500:500])
grid on

subplot(6,2,10)
hold on
plot(dtg_in_TMA,(dh_dt_in_TMA*60*3.2808))
ylim([floor((min(sort(dh_dt_in_TMA*60*3.2808)))/500)*500 500])
yticks(floor((min(sort(dh_dt_in_TMA*60*3.2808)))/500)*500:500:500)
if CDO == 1
    plot(cum_dist_CDO,(ROCD_CDO*60*3.2808))
    ylim([floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808])))/500)*500 500])
    yticks(floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808])))/500)*500:500:500)
end
if plot_both == 1
    plot(cum_dist_CDO_2,(ROCD_CDO_2*60*3.2808))
    ylim([floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808;ROCD_CDO_2'*60*3.2808])))/500)*500 500])
    yticks(floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808;ROCD_CDO_2'*60*3.2808])))/500)*500:500:500)
end
xlabel('Distance to go [NM]')
ylabel('ROD [ft/min]')
set(gca,'Xdir','reverse')
% yticks([floor((min(sort([dh_dt_in_TMA*60*3.2808;ROCD_CDO'*60*3.2808])))/500)*500:500:500])
grid on

% Fuel burn
subplot(6,2,11)
hold on
plot(time_in_TMA/60,TMA_fuel_vector*3600)
ylim([0 ceil((max(sort(TMA_fuel_vector*3600)))/500)*500])
yticks(0:500:ceil((max(sort(TMA_fuel_vector*3600)))/500)*500)
if CDO == 1
    plot(t_CDO/60,F_CDO*3600)
    ylim([0 ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600])))/500)*500])
    yticks(0:500:ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600])))/500)*500)
end
if plot_both == 1
    plot(t_CDO_2/60,F_CDO_2*3600)
    ylim([0 ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600;F_CDO_2'*3600])))/500)*500])
    yticks(0:500:ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600;F_CDO_2'*3600])))/500)*500)
end
xlabel('Time to final [min]')
ylabel('Fuel flow [kg/h]')
set(gca,'Xdir','reverse')

grid on

subplot(6,2,12)
hold on
plot(dtg_in_TMA,(TMA_fuel_vector*3600))
yticks(0:500:ceil((max(sort(TMA_fuel_vector*3600)))/500)*500)
if CDO == 1
ylim([0 ceil((max(sort(TMA_fuel_vector*3600)))/500)*500])
    plot(cum_dist_CDO,(F_CDO*3600))
    ylim([0 ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600])))/500)*500])
    yticks(0:500:ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600])))/500)*500)
end
if plot_both == 1
    plot(cum_dist_CDO_2,(F_CDO_2*3600))
    ylim([0 ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600;F_CDO_2'*3600])))/500)*500])
    yticks(0:500:ceil((max(sort([TMA_fuel_vector*3600;F_CDO'*3600;F_CDO_2'*3600])))/500)*500)
end
xlabel('Distance to go [NM]')
ylabel('Fuel flow [kg/h]')
set(gca,'Xdir','reverse')
grid on
sgtitle(title_text)
set(h, 'Position', [0 43 screen(3)/1.7 screen(4)*0.913]);
saveas(h,sprintf('%s %s_%s_%s_%s_%s_%s.png',export_dir_figures,callsign_save,icao_type,airport,date,num2str(PM_profile),'fig1'));

%%% FIGURE 2 %%%

h2 = figure(2);

% Map of stockholm TMA and route
geoplot(TMA_lat,TMA_lon,'Color','#1870A2')
geobasemap(map_type)
hold on
if strcmp(airport,'ESSA')
%     geoplot([NILUG_lat ELTOK_lat HMR_lat XILAN_lat NILUG_lat],[NILUG_lon ELTOK_lon HMR_lon XILAN_lon NILUG_lon],'k--')
    geoplot([NILUG_lat ELTOK_lat XILAN_lat HMR_lat],[NILUG_lon ELTOK_lon XILAN_lon HMR_lon],'k^','LineWidth',2)
    geoplot([zero_one_L_lat,one_nine_R_lat],[zero_one_L_lon,one_nine_R_lon],'k')
    geoplot([zero_one_R_lat,one_nine_L_lat],[zero_one_R_lon,one_nine_L_lon],'k')
    geoplot([zero_eight_lat,two_six_lat],[zero_eight_lon,two_six_lon],'k')
%     geoplot([FAP_01L_lat FAF_08_lat FAP_19R_lat FAP_19L_lat FAP_26_lat FAP_01R_lat FAP_01L_lat],[FAP_01L_lon FAF_08_lon FAP_19R_lon FAP_19L_lon FAP_26_lon FAP_01R_lon FAP_01L_lon],'k--')
    geoplot(FAP_01L_lat,FAP_01L_lon,'k*','MarkerSize',5)
    geoplot(FAP_19R_lat,FAP_19R_lon,'k*','MarkerSize',5)
    geoplot(FAP_26_lat,FAP_26_lon,'k*','MarkerSize',5)
    geoplot(FAP_01R_lat,FAP_01R_lon,'k*','MarkerSize',5)
    geoplot(FAP_19L_lat,FAP_19L_lon,'k*','MarkerSize',5)
    geoplot(FAF_08_lat,FAF_08_lon,'k*','MarkerSize',5)
    text(59.68,19.17,'XILAN')
    text(60.30,18.49,'HMR')
    text(59.76,16.82,'ELTOK')
    text(58.75,17.78,'NILUG')
    geoplot(ELTOK_STAR_lat,ELTOK_STAR_lon,'k--o','Color','#797979')
    geoplot(HMR_STAR_lat,HMR_STAR_lon,'k--o','Color','#797979')
    geoplot(NILUG_STAR_lat,NILUG_STAR_lon,'k--o','Color','#797979')
    geoplot(XILAN_STAR_lat,XILAN_STAR_lon,'k--o','Color','#797979')
    geoplot(IAF_1_lat,IAF_1_lon,'k^','LineWidth',2)
    geoplot(IAF_2_lat,IAF_2_lon,'k^','LineWidth',2)
elseif strcmp(airport,'ESGG')
    geoplot([zero_three_lat,two_one_lat],[zero_three_lon,two_one_lon],'k')
    geoplot([ARQUS_lat KELIN_lat LOBBI_lat RISMA_lat MAKUR_lat NEGIL_lat MOXAM_lat],[ARQUS_lon KELIN_lon LOBBI_lon RISMA_lon MAKUR_lon NEGIL_lon MOXAM_lon],'k^','LineWidth',2)
    text(57.12,13,'ARQUS')
    text(58.25,11.7,'KELIN')
    text(57.32,11.15,'LOBBI')
    text(57.03,12.05,'RISMA')
    text(57.43,11.03,'MAKUR')
    text(58.54,13.35,'MOXAM')
    text(58.25,12.7,'NEGIL')
elseif strcmp(airport,'EIDW')
    geoplot([ABLIN_lat BAGOS_lat BALMI_lat BOYNE_lat BUNED_lat LIPGO_lat NIMAT_lat OLAPO_lat OSGAR_lat SUTEX_lat VATRY_lat],[ABLIN_lon BAGOS_lon BALMI_lon BOYNE_lon BUNED_lon LIPGO_lon NIMAT_lon OLAPO_lon OSGAR_lon SUTEX_lon VATRY_lon],'k^','LineWidth',2)
    text(52.79,-4.93,'ABLIN')
    text(53.685,-5.44,'BAGOS')
    text(54.17,-6.58,'BAMLI')
    text(53.775,-5.44,'BOYNE')
    text(52.63,-6.58,'BUNED')
    text(53.075,-5.44,'LIPGO')
    text(53.98,-5.68,'NIMAT')
    text(53.79,-7.68,'OLAPO')
    text(53.06,-7.68,'OSGAR')
    text(52.84,-7.3,'SUTEX')
    text(52.56,-5.44,'VATRY')
    geoplot([eidw_lat_10R eidw_lat_28L],[eidw_lon_10R eidw_lon_28L],'k','LineWidth',2)
    geoplot([eidw_lat_16 eidw_lat_34],[eidw_lon_16 eidw_lon_34],'k','LineWidth',2)
    geoplot(PMS_lat_1,PMS_lon_1,'k--o','Color','#797979')
    geoplot(PMS_lat_2,PMS_lon_2,'k--o','Color','#797979')
    geoplot(PMS_lat_3,PMS_lon_3,'k--o','Color','#797979')
    geoplot(PMS_lat_4,PMS_lon_4,'k--o','Color','#797979')
    geoplot(PMS_lat_5,PMS_lon_5,'k--o','Color','#797979')
    geoplot(PMS_lat_6,PMS_lon_6,'k--o','Color','#797979')
    geoplot(PMS_lat_7,PMS_lon_7,'k--o','Color','#797979')
    geoplot(PMS_lat_8,PMS_lon_8,'k--o','Color','#797979')
    geoplot(PMS_lat_9,PMS_lon_9,'k--o','Color','#797979')
    geoplot(PMS_lat_10,PMS_lon_10,'k--o','Color','#797979')
elseif strcmp(airport,'LOWW')
    geoplot([NERDU_lat MABOD_lat BALAD_lat PESAT_lat],[NERDU_lon MABOD_lon BALAD_lon PESAT_lon],'k^','LineWidth',2)
    text(48.54,15.98,'NERDU')
    text(48.63,16.57,'MABOD')
    text(47.83,16.13,'BALAD')
    text(47.73,17.12,'PESAT')
    geoplot([loww_lat_11 loww_lat_29],[loww_lon_11 loww_lon_29],'k','LineWidth',2)
    geoplot([loww_lat_16 loww_lat_34],[loww_lon_16 loww_lon_34],'k','LineWidth',2)
    geoplot(LOWW_transition_lat_1,LOWW_transition_lon_1,'k--o','Color','#797979')
    geoplot(LOWW_transition_lat_2,LOWW_transition_lon_2,'k--o','Color','#797979')
    geoplot(LOWW_transition_lat_3,LOWW_transition_lon_3,'k--o','Color','#797979')
    geoplot(LOWW_transition_lat_4,LOWW_transition_lon_4,'k--o','Color','#797979')
    elseif strcmp(airport,'ESGG')
        % INSERT ESGG PLOT DATA HERE!
end
geoplot(TMA_entry_lat,TMA_entry_lon,'ro','LineWidth',1)
geoplot(lat_plot,lon_plot,'k','LineWidth',1)
geoplot(lat_CDO,lon_CDO,'b','LineWidth',1)
geoplot(lat_CDO(1),lon_CDO(1),'bo')
geoplot(FAP_entry_lat,FAP_entry_lon,'ro','LineWidth',1)
title(title_text)
set(h2, 'Position', [screen(3)/1.7+3 43 800 600]);

saveas(h2,sprintf('%s %s_%s_%s_%s_%s_%s.png',export_dir_figures,callsign_save,icao_type,airport,date,num2str(PM_profile),'fig3'));

%%% FIGURE 3 %%%

h3 = figure(3);

% Wind component
subplot(4,2,1)
plot(time_in_TMA/60,wind_comp_in_TMA)
hold on
if CDO == 1
    plot(t_CDO/60,wind_comp_CDO)
end
if plot_both == 1
    plot(t_CDO_2/60,wind_comp_CDO_2)
end
xlabel('Time to final [min]')
ylabel('Wind comp [-]')
set(gca,'Xdir','reverse')
grid on

subplot(4,2,2)
plot(dtg_in_TMA,wind_comp_in_TMA)
hold on
if CDO == 1
    plot(cum_dist_CDO,wind_comp_CDO) 
end
if plot_both == 1
    plot(cum_dist_CDO_2,wind_comp_CDO_2) 
end
xlabel('Distance to go [NM]')
ylabel('Wind comp [-]')
set(gca,'Xdir','reverse')
grid on

% Wind speed
subplot(4,2,3)
plot(time_in_TMA/60,wind_speed_in_TMA*ms_to_kt)
hold on
if CDO == 1
    plot(t_CDO/60,wind_speed_CDO*ms_to_kt)
end
if plot_both == 1
    plot(t_CDO_2/60,wind_speed_CDO_2*ms_to_kt)
end
xlabel('Time to final [min]')
ylabel('Wind speed [kt]')
set(gca,'Xdir','reverse')
grid on

subplot(4,2,4)
plot(dtg_in_TMA,wind_speed_in_TMA*ms_to_kt)
hold on
if CDO == 1
    plot(cum_dist_CDO,wind_speed_CDO*ms_to_kt) 
end
if plot_both == 1
    plot(cum_dist_CDO_2,wind_speed_CDO_2*ms_to_kt) 
end
xlabel('Distance to go [NM]')
ylabel('Wind speed [kt]')
set(gca,'Xdir','reverse')
grid on

% Wind direction
subplot(4,2,5)
plot(time_in_TMA/60,wind_dir_in_TMA)
hold on
if CDO == 1
    plot(t_CDO/60,wind_dir_CDO)
end
if plot_both == 1
    plot(t_CDO_2/60,wind_dir_CDO_2)
end
xlabel('Time to final [min]')
ylabel('Wind dir [deg]')
set(gca,'Xdir','reverse')
grid on

subplot(4,2,6)
plot(dtg_in_TMA,wind_dir_in_TMA)
hold on
if CDO == 1
    plot(cum_dist_CDO,wind_dir_CDO) 
end
if plot_both == 1
    plot(cum_dist_CDO_2,wind_dir_CDO_2) 
end
xlabel('Distance to go [NM]')
ylabel('Wind dir [deg]')
set(gca,'Xdir','reverse')
grid on

% Flight track
subplot(4,2,7)
plot(time_in_TMA/60,flight_track_in_TMA)
hold on
if CDO == 1
    plot(t_CDO/60,flight_track_CDO)
end
if plot_both == 1
    plot(t_CDO_2/60,flight_track_CDO_2)
end
xlabel('Time to final [min]')
ylabel('Flight track [deg]')
set(gca,'Xdir','reverse')
grid on

subplot(4,2,8)
plot(dtg_in_TMA,flight_track_in_TMA)
hold on
if CDO == 1
    plot(cum_dist_CDO,flight_track_CDO) 
end
if plot_both == 1
    plot(cum_dist_CDO_2,flight_track_CDO_2) 
end
xlabel('Distance to go [NM]')
ylabel('Flight track [deg]')
set(gca,'Xdir','reverse')
grid on
sgtitle(title_text)
% set(h3, 'Position', [screen(3)/2 (screen(4)/2)+100 800 550]);
set(h3, 'Position', [screen(3)/1.7+3 729 800 627]);
saveas(h3,sprintf('%s %s_%s_%s_%s_%s_%s.png',export_dir_figures,callsign_save,icao_type,airport,date,num2str(PM_profile),'fig2'));


% figure(4)
% plot(time_in_TMA,GS_in_TMA*ms_to_kt,'g')
% hold on
% plot(time_in_TMA,TAS_in_TMA*ms_to_kt,'r')
% set(gca,'Xdir','reverse')
end
end
% ----------------------------- FUNCTIONS ------------------------------- %

function [file_name, rocd_LFV, baro_vert_rate_LFV, mach_LFV,unix_time] = csv_2_so6(flight_file,DDR_dir,csv_data_source,fr24_dir,down_sample,rate,remove_zero_length,remove_alt_outliers,alt_diff_thr,alt_fill_option,callsign,search_callsign,LFV_dir,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option)

global m_to_ft deg_to_min

txt = flight_file;

% % Read .csv
if strcmp(csv_data_source,'OS')
    
    % Read single flight from OS file
    if search_callsign == 1
        index_flight = find(cellfun('length',regexp(txt,callsign)) == 1);
        txt = txt(index_flight,:);
    end

% Downsample option
if down_sample == 1
    last_row = txt{end,:};
    txt = downsample(txt,rate);
    blanks_txt = find(txt{end} == ' ');
    if str2num(txt{end}(blanks_txt(3)+1:blanks_txt(4)-1)) == str2num(last_row(blanks_txt(3)+1:blanks_txt(4)-1)) && str2num(txt{end}(blanks_txt(4)+1:blanks_txt(5)-1)) == str2num(last_row(blanks_txt(4)+1:blanks_txt(5)-1))
    else
        txt{end+1,:} = last_row;
    end
     
end

for d = 1:max(size(txt))
    curr_txt = txt{d};
    blanks = find(curr_txt == ' ');
    lon(d,1) = (str2num(curr_txt((blanks(4)+1):blanks(5)-1)));
    lat(d,1) = (str2num(curr_txt((blanks(3)+1):blanks(4)-1))) ;    
end

% Remove zero length option
if remove_zero_length == 1
    id = 2;
    save(1) = 1;
    for e = 1:max(size(txt)-1)
        diff_lon(e) = lon(e+1) - lon(e); 
        diff_lat(e) = lat(e+1) - lat(e); 
        if (diff_lon(e) ~= 0 || diff_lat(e) ~= 0)
            save(id) = e + 1;
            id = id + 1;
        end  
    end
    txt = txt(save);
end
lat = lat(save);
lon = lon(save);

% Smooth lat/lon option
if smooth_lat_lon == 1
    lat = smoothdata(lat,smooth_lat_lon_option,smooth_lat_lon_k);
    lon = smoothdata(lon,smooth_lat_lon_option,smooth_lat_lon_k);
end

% Extract data from .csv file
for i = 1:max(size(txt)-1)
    curr_txt = txt{i};
    next_txt = txt{i+1};
    curr_blanks = find(curr_txt == ' ');
    next_blanks = find(next_txt == ' ');
    if max(size(curr_blanks)) == 9
        curr_txt = curr_txt(1:curr_blanks(9)-1);
        next_txt = next_txt(1:next_blanks(9)-1);
    end
    curr_time = datestr(str2double(curr_txt((curr_blanks(2)+1):(curr_blanks(3)-1)))/86400 + datenum('1/1/1970'));
    next_time = datestr(str2double(next_txt((next_blanks(2)+1):(next_blanks(3)-1)))/86400 + datenum('1/1/1970'));
    unix_time(i,1) = str2double(curr_txt((curr_blanks(2)+1):(curr_blanks(3)-1)));
    time_start(i,1) = str2double(curr_time([13:14,16:17,19:20]));
    time_end(i,1) = str2double(next_time([13:14,16:17,19:20]));
    alt_start(i,1) = (str2num(curr_txt((curr_blanks(5)+1):(curr_blanks(6)-1))))*m_to_ft/100;
    alt_end(i,1) = (str2num(next_txt((next_blanks(5)+1):(next_blanks(6)-1))))*m_to_ft/100;
    lat_start(i,1) = lat(i);
    lat_end(i,1) = lat(i+1);
    lon_start(i,1) = lon(i);
    lon_end(i,1) = lon(i+1);
    length(i,1) = lldistkm([lat_start(i,1) lon_start(i,1)],[lat_end(i,1) lon_end(i,1)])*(1000/1852);
    try
        date_start(i,1) = (str2num(curr_txt((curr_blanks(7)+1):end)));
        date_end(i,1) = (str2num(next_txt((next_blanks(7)+1):end)));
    catch
        date_start(i,1) = (str2num(curr_txt((curr_blanks(8)+1):end)));
        date_end(i,1) = (str2num(next_txt((next_blanks(8)+1):end)));
    end
    GS_OS_start(i,1) = str2num(curr_txt(curr_blanks(7)+1:curr_blanks(8)-1));
    GS_OS_end(i,1) = str2num(next_txt(next_blanks(7)+1:next_blanks(8)-1));
end
% for j = 2:max(size(unix_time))
%     if unix_time(j,1) < unix_time(j-1,1)
%         unix_time(j,1) = unix_time(j,1) + 86400;
%         pause
%     end
% end
% format long
% max(unix_time)

% Remove alt outliers option
if remove_alt_outliers == 1
    for a = 1:max(size(alt_start))
        alt_diff(a) = alt_start(a) - alt_end(a);
    end
    alt_diff_id = find(abs(alt_diff) > alt_diff_thr/100);    
    for b = alt_diff_id
        alt_end(b) = NaN;
        alt_start(b+1) = NaN;
    end
    if max(size(alt_start)) > max(size(alt_end))
        alt_start = alt_start(1:end-1);
    end
end

alt_start = fillmissing(alt_start,alt_fill_option);
alt_end = fillmissing(alt_end,alt_fill_option);

% Conversion of coordinates to minutes
lon_start = lon_start./deg_to_min; 
lat_start = lat_start./deg_to_min;
lon_end = lon_end./deg_to_min;
lat_end = lat_end./deg_to_min;

% Create zero columns for .so6 file
zero_col = zeros((max(size(lon_start))),1);

% Set LFV data parameters to empty
rocd_LFV = [];
baro_vert_rate_LFV = [];
mach_LFV = [];
    
elseif strcmp(csv_data_source,'FR')
    [num,txt,raw] = xlsread([fr24_dir,flight_file]);
    
    for i = 1:max(size(txt))
    curr_txt = txt{i};
    if i<max(size(txt))
        next_txt = txt{i+1};
    end
    commas_curr = find(curr_txt == ',');
    commas_next = find(next_txt == ',');
    time_start_pos_curr = commas_curr(1) + 12;
    time_end_pos_curr = time_start_pos_curr + 7;
    time_start_pos_next = commas_next(1) + 12;
    time_end_pos_next = time_start_pos_next + 7;
    
    time_start{i,1} = curr_txt(time_start_pos_curr:time_end_pos_curr);
    time_colons = find(time_start{i,1} == ':');
    time_start{i,1} = time_start{i,1}([1:time_colons(1)-1,(time_colons(1)+1):(time_colons(2)-1),(time_colons(2)+1):end]);
    time_end{i,1} = next_txt(time_start_pos_next:time_end_pos_next);
    time_colons = find(time_end{i,1} == ':');
    time_end{i,1} = time_end{i,1}([1:time_colons(1)-1,(time_colons(1)+1):(time_colons(2)-1),(time_colons(2)+1):end]);
    
    alt_start(i,1) = (str2num(curr_txt((commas_curr(5)+1):(commas_curr(6)-1))));
    alt_end(i,1) =   (str2num(next_txt((commas_next(5)+1):(commas_next(6)-1))));
    lat_start(i,1) = (str2num(curr_txt((commas_curr(3)+2):commas_curr(4))));
    lat_end(i,1) = (str2num(next_txt((commas_next(3)+2):commas_next(4))));
    lon_start(i,1) = (str2num(curr_txt((commas_curr(4)+1):commas_curr(5)-2)));
    lon_end(i,1) = (str2num(next_txt((commas_next(4)+1):commas_next(5)-2)));
    length(i,1) = lldistkm([lat_start(i,1) lon_start(i,1)],[lat_end(i,1) lon_end(i,1)]);
    date_start{i,1} = curr_txt(commas_curr(1)+1:commas_curr(1)+10);
    date_line = find(date_start{i,1} == '-');
    date_start{i,1} = date_start{i,1}([3:date_line(1)-1,(date_line(1)+1):(date_line(2)-1),(date_line(2)+1):end]);
    date_end{i,1} = (next_txt(commas_next(1)+1:commas_next(1)+10));
    date_line = find(date_end{i,1} == '-');
    date_end{i,1} = date_end{i,1}([3:date_line(1)-1,(date_line(1)+1):(date_line(2)-1),(date_line(2)+1):end]);
    end

zero_col = zeros((max(size(txt))-1),1);
lon_start = lon_start(1:end-1)./0.0166666667;
lat_start = lat_start(1:end-1)./0.0166666667;
lon_end = lon_end(1:end-1)./0.0166666667;
lat_end = lat_end(1:end-1)./0.0166666667;
time_start = str2double(time_start(1:end-1));
time_end = str2double(time_end(1:end-1));
length = (length(1:end-1))*(1000/1852);
alt_start = alt_start(1:end-1)./100;
alt_end = alt_end(1:end-1)./100;
date_start = str2double(date_start(1:end-1));
date_end = str2double(date_end(1:end-1));
    rocd_LFV = [];
    baro_vert_rate_LFV = [];
    mach_LFV = [];

elseif strcmp(csv_data_source,'LFV')
    
    json_file = jsondecode(fileread([LFV_dir,flight_file]));
 
    lat_lon = [json_file.plots.I062_105];
 
    lat = [lat_lon.lat];
    lon = [lat_lon.lon];

    alt = [json_file.plots.I062_136];
    alt = [alt.measured_flight_level];

    rocd = [json_file.plots.I062_220];
    rocd_LFV = [rocd.rocd];

    subitems = [json_file.plots.I062_380];
    baro_vert_rate = [subitems.subitem13];
    baro_vert_rate_LFV = [baro_vert_rate.baro_vert_rate];

    IAS = [subitems.subitem26];
    IAS = [IAS.ias];

    M = [subitems.subitem27];
    M = [M.mach];

    mag_hdg = [subitems.subitem3];
    mag_hdg = [mag_hdg.mag_hdg];

    time = json_file.plots;
    time = [time.time_of_track];
    time = strsplit(time,'2020');
    time = time(2:end);
   
    for i = 1:(max(size(lat))-1)
        time_start_raw = char(time(i));
        time_end_raw = char(time(i+1));
        T_id_curr = find(time_start_raw == 'T');
        time_start_raw = time_start_raw(T_id_curr+1:end);
        time_start(i,1) = str2double(time_start_raw([1:2,4:5,7:end]));
        T_id_next = find(time_end_raw == 'T');
        time_end_raw = time_end_raw(T_id_next+1:end);
        time_end(i,1) = str2double(time_end_raw([1:2,4:5,7:end]));
        alt_start(i,1) = alt(i);
        alt_end(i,1) = alt(i+1);
        lat_start(i,1) = lat(i)./0.0166666667;
        lat_end(i,1) = lat(i+1)./0.0166666667;
        lon_start(i,1) = lon(i)./0.0166666667;
        lon_end(i,1) = lon(i+1)./0.0166666667;
        length(i,1) = lldistkm([lat(i) lon(i)],[lat(i+1) lon(i+1)]);
        zero_col = zeros(max(size(lat)-1),1);
    end
    
 length = length.*(1000/1852);
    
date_start = zero_col;
date_end = zero_col;
mach_LFV = M;
end

file_name = 'temp.so6';

% file_name = [(flight_file(1:end-4)),'.so6'];
path = [DDR_dir,file_name];
fid = fopen( path, 'wt' );

% size(zero_col)
% size(time_start)
% size(time_end)
% size(alt_start)
% size(alt_end)
% size(date_start)
% size(date_end)
% size(lat_start)
% size(lat_end)
% size(lon_start)
% size(lon_end)
% size(length)
% pause

% FIX TO WORK WITH LFV DATA!!!
fprintf(fid, '%f %f %f %f %d %d %f %f %f %f %d %d %f %f %f %f %f %f %f %f %f %f\n', [zero_col(:),zero_col(:),zero_col(:),zero_col(:),time_start(:),time_end(:),alt_start(:),alt_end(:),zero_col(:),zero_col(:),date_start(:),date_end(:),lat_start(:),lon_start(:),lat_end(:),lon_end(:),zero_col(:),zero_col(:),length(:),zero_col(:),GS_OS_start(:),GS_OS_end(:)].');
% fprintf(fid, '%f %f %f %f %.2f %.2f %f %f %f %f %d %d %f %f %f %f %f %f %f %f\n', [zero_col(:),zero_col(:),zero_col(:),zero_col(:),time_start(:),time_end(:),alt_start(:),alt_end(:),zero_col(:),zero_col(:),date_start(:),date_end(:),lat_start(:),lon_start(:),lat_end(:),lon_end(:),zero_col(:),zero_col(:),length(:),zero_col(:),].');
fclose(fid);

end

function [time_start, time_end, alt_start, alt_end, segment_length,lat_start, lon_start, lat_end, lon_end,GS_OS_start,GS_OS_end] = read_so6(filename,DDR_dir)
global coord_min_to_deg
path = [DDR_dir,filename];
fid = fopen(path);
flight_data = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');

time_start = flight_data{5};
time_end = flight_data{6};
alt_start = str2double(flight_data{7});
alt_end = str2double(flight_data{8});
segment_length = str2double(flight_data{19});
lat_start = str2double(flight_data{13}).*coord_min_to_deg;
lon_start = str2double(flight_data{14}).*coord_min_to_deg;
lat_end = str2double(flight_data{15}).*coord_min_to_deg;
lon_end = str2double(flight_data{16}).*coord_min_to_deg;
GS_OS_start = str2double(flight_data{21});
GS_OS_end = str2double(flight_data{22});
% TEST!!! 
segment_length(end) = 0;
fclose(fid);
end

function [S,M_max,C_D_scalar,d,bf,mlw,L_HV,a,f,kink_point,b,p,c,ti,fi,engine_type,C_L_max_BADA,W_P_max,n_eng,D_P,eta_max,C_L_max_landing,CAS1_descent,CAS2_descent,M_descent] = read_bada_xml(ac_type,bada_dir,mlw_factor)
bada_path = [bada_dir,ac_type,'\',(ac_type),'.xml'];
bada_file = xml2struct(bada_path);

engine_type = char(struct2cell(bada_file.bada40_colon_ACM.type));
S = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.S));
M_max = bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.DPM_clean.M_max;
C_D_scalar = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.DPM_clean.scalar));
d = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.DPM_clean.CD_clean.d)),15,1));
C_L_max_landing = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{end}.LGDN.BLM.CL_max));
CAS1_descent = str2double(struct2cell(bada_file.bada40_colon_ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase{end}.CAS1));
CAS2_descent = str2double(struct2cell(bada_file.bada40_colon_ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase{end}.CAS2));
M_descent = str2double(struct2cell(bada_file.bada40_colon_ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase{end}.M));

try
    bf = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.BLM_clean.CL_clean.bf)),5,1));
catch
    bf = [];
end
mlw = str2double(struct2cell(bada_file.bada40_colon_ACM.ALM.DLM.MLW));
mlw = mlw*mlw_factor;
L_HV = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.LHV));

if strcmp(engine_type,'JET')
    b = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.MCMB.flat_rating.b)),36,1));
    p = [];
    eta_max = [];
    a = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.CT.a)),36,1));
    f = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.CF.f)),25,1));
    kink_point = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TFM.MCMB.kink));
    c = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.MCMB.temp_rating.c)),45,1)); % 36,1
    ti = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.LIDL.CT.ti)),12,1));
    fi = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.LIDL.CF.fi)),9,1));
    if isempty(bf)
        C_L_max_BADA = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.BLM.CL_max));
    else
        C_L_max_BADA = [];
    end
    W_P_max = [];
    n_eng = [];
    D_P = [];
    
elseif strcmp(engine_type,'TURBOPROP')
    p = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.MCMB.rating.p)),36,1));
    D_P = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TPM.prop_dia));
    eta_max = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TPM.max_eff));
    n_eng = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.n_eng)); 
    W_P_max = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TPM.MCMB.max_power));
    b = [];
    a = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.CP.a)),36,1));
    f = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.CF.f)),25,1));
    kink_point = [];
    c = [];
    ti = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.LIDL.CT.ti)),32,1));
    fi = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.LIDL.CF.fi)),14,1));
    C_L_max_BADA = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.BLM.CL_max));
end

end

function [time_duration,time_start,time_end] = calculate_time(time_start, time_end)
sec_per_day = 86400;

for i = 1:max(size(time_start))
    curr_time_start = char(time_start(i));
    if max(size(curr_time_start)) == 6
        time_start{i} = [curr_time_start(1:2),':',curr_time_start(3:4),':',curr_time_start(5:6)];
    elseif max(size(curr_time_start)) == 5
        time_start{i} = ['0',curr_time_start(1),':',curr_time_start(2:3),':',curr_time_start(4:5)];
    elseif max(size(curr_time_start)) == 4
        time_start{i} = ['00',':',curr_time_start(1:2),':',curr_time_start(3:4)];
    elseif max(size(curr_time_start)) == 3
        time_start{i} = ['00',':','0',curr_time_start(1),':',curr_time_start(2:3)];
    elseif max(size(curr_time_start)) == 2
        time_start{i} = ['00',':','00',':',curr_time_start(1:2)];
    elseif max(size(curr_time_start)) == 1
        time_start{i} = ['00',':','00',':','0',curr_time_start(1)];
    end
end

timeFractionalDays = datenum(time_start);
timeDayFraction = mod(timeFractionalDays,1);

timeInSeconds_start = timeDayFraction .* sec_per_day;

for j = 2:max(size(timeInSeconds_start))
   if timeInSeconds_start(j) < timeInSeconds_start(j-1)
       timeInSeconds_start(j) = timeInSeconds_start(j) + sec_per_day;
   end
end

for i = 1:max(size(time_end))
    curr_time_end = char(time_end(i));   
    if max(size(curr_time_end)) == 6
        time_end{i} = [curr_time_end(1:2),':',curr_time_end(3:4),':',curr_time_end(5:6)];
    elseif max(size(curr_time_end)) == 5
        time_end{i} = ['0',curr_time_end(1),':',curr_time_end(2:3),':',curr_time_end(4:5)];
    elseif max(size(curr_time_end)) == 4
        time_end{i} = ['00',':',curr_time_end(1:2),':',curr_time_end(3:4)];
    elseif max(size(curr_time_end)) == 3
        time_end{i} = ['00',':','0',curr_time_end(1),':',curr_time_end(2:3)];
    elseif max(size(curr_time_end)) == 2
        time_end{i} = ['00',':','00',':',curr_time_end(1:2)];
    elseif max(size(curr_time_end)) == 1
        time_end{i} = ['00',':','00',':','0',curr_time_end(1)];
    end
end

timeFractionalDays = datenum(time_end);
timeDayFraction = mod(timeFractionalDays,1);
timeInSeconds_end = timeDayFraction .* sec_per_day;

for j = 2:max(size(timeInSeconds_end))
   if timeInSeconds_end(j) < timeInSeconds_end(j-1)
       timeInSeconds_end(j) = timeInSeconds_end(j) + sec_per_day;
   end
end

time_duration = timeInSeconds_end - timeInSeconds_start;
% TEST!!!
time_duration(end) = 0;
end

function hours_start = calculate_hours(time_start)
[Y, M, D, H, MN, S] = datevec(time_start);
hours_start = H + MN/60 + S/3600;

for j = 2:max(size(hours_start))
   if hours_start(j) < hours_start(j-1)
       hours_start(j) = hours_start(j) + 24;
   end
end

end

function total_dur = calculate_total_dur(time_duration)
total_dur(1) = 0;
total_dur(2) = time_duration(1);
for i = 1:max(size(time_duration))-2
   total_dur(i+2) =  time_duration(i+1) + total_dur(i+1);
end
end

function GS = calculate_GS(time_duration,segment_length)
global NM_to_m
GS = segment_length.*NM_to_m./time_duration;
end

function wind_comp = calculate_wind_component(flight_track,wind_dir)
for i = 1:max(size(wind_dir))
    if flight_track(i) >= wind_dir(i) 
        difference = flight_track(i) - wind_dir(i);
        if difference >= 0 && difference <=90
            wind_comp(i,1) = -(1 - difference/90);
        elseif difference > 90 && difference <=180
            difference = difference - 90;
            wind_comp(i,1) = difference/90;
        elseif difference > 180 && difference <=270
            difference = difference - 180;
            wind_comp(i,1) = 1 - difference/90;
        elseif difference > 270 && difference <=359.999999999999
            difference = difference - 270;
            wind_comp(i,1) = -difference/90;
        end
    elseif flight_track(i) < wind_dir(i) 
        difference = wind_dir(i) - flight_track(i);
        if difference >= 0 && difference <=90
            wind_comp(i,1) = -(1 - difference/90);
        elseif difference > 90 && difference <=180
            difference = difference - 90;
            wind_comp(i,1) = difference/90;
        elseif difference > 180 && difference <=270
            difference = difference - 180;
            wind_comp(i,1) = 1 - difference/90;
        elseif difference > 270 && difference <=359.999999999999
            difference = difference - 270;
            wind_comp(i,1) = -difference/90;
        end
    end
end
end

function TAS = calculate_TAS(GS,wind_comp,wind_speed,smooth_TAS,smooth_TAS_k,smooth_TAS_option,total_dur,extrapolate_TAS_start,extrapolate_TAS_end,TAS_diff_thr,TAS_brake_point)

TAS = GS - wind_comp.*wind_speed;

if smooth_TAS == 1
    TAS = smoothdata(TAS,smooth_TAS_option,smooth_TAS_k);
end

for i = 1:(max(size(TAS))-1)
   TAS_diff(i) = TAS(i+1) - TAS(i);
end

if extrapolate_TAS_end == 1
    last_neg_TAS_diff = max(find(TAS_diff < 0));
    TAS = TAS(1:last_neg_TAS_diff);
    TAS_time = total_dur(1:last_neg_TAS_diff);
    TAS_extrap = interp1(TAS_time,TAS,total_dur((last_neg_TAS_diff+1):end),'linear','extrap');
    TAS = [TAS;TAS_extrap'];
elseif extrapolate_TAS_end == 2
    TAS = interp1([total_dur(1:TAS_brake_point) total_dur(end)],[TAS(1:TAS_brake_point);TAS(end)]',total_dur');
end

if extrapolate_TAS_start == 1
    TAS_thr_ID = min(find(TAS_diff > -TAS_diff_thr));
    TAS = TAS(TAS_thr_ID:end);
    TAS_time = [];
    TAS_time = total_dur(TAS_thr_ID:end);
    TAS_extrap = [];
    TAS_extrap = interp1(TAS_time,TAS,total_dur(1:(TAS_thr_ID-1)),'linear','extrap');
    TAS = [TAS_extrap';TAS];
end
end

function CAS = calculate_CAS(pressure,rho,TAS)
global p_0 rho_0 k
u = (k-1)/k;
CAS = (((2/u).*(p_0/rho_0)).*((1+(pressure./p_0).*((1+u/2.*rho./pressure.*TAS.^2).^(1/u)-1)).^u-1)).^0.5;
end

function [rho, rho_ratio] = calculate_rho(pressure,T_calc)
global R rho_0
rho = pressure./(R.*T_calc);
rho_ratio = rho./rho_0;
end


function [M_stall,pressure_stall,T_stall,rho_stall] = calculate_M_stall(mlw,S,C_L_max_landing)
global p_0 g_0 k R
pressure_stall(1) = 97717;
pressure_stall(2) = 95952;
pressure_stall(3) = 94213;
pressure_stall(4) = 90812;
T_stall(1) = 286.1688; % ISA temp at 1000 ft
T_stall(2) = 285.1782; % ISA temp at 1500 ft
T_stall(3) = 284.1876; % ISA temp at 2000 ft
T_stall(4) = 282.2064; % ISA temp at 3000 ft
rho_stall = pressure_stall./(R.*T_stall);

pressure_ratio_stall(1) = pressure_stall(1)/p_0; % ratio at 1000 ft
pressure_ratio_stall(2) = pressure_stall(2)/p_0; % ratio at 1500 ft  
pressure_ratio_stall(3) = pressure_stall(3)/p_0; % ratio at 2000 ft
pressure_ratio_stall(4) = pressure_stall(4)/p_0; % ratio at 3000 ft

M_stall = sqrt((2*mlw*g_0)./(pressure_ratio_stall*p_0*k*S*C_L_max_landing));
end

function TAS_stall = calculate_TAS_stall(M_stall,T_stall)
global k R
TAS_stall = M_stall.*sqrt(k*R.*T_stall);
end

function [wind_speed,wind_dir] = calculate_wind(v_calc,u_calc)
wind_speed = sqrt(v_calc.^2 + u_calc.^2);

theta = acosd(u_calc./wind_speed);

for i = 1:max(size(u_calc))
    if (u_calc(i) > 0 && v_calc(i) > 0) || (u_calc(i) < 0 && v_calc(i) > 0)
        wind_dir(i,1) = 270 - theta(i);
    elseif u_calc(i) < 0 && v_calc(i) < 0
        wind_dir(i,1) = theta(i) - 90;
    elseif u_calc(i) > 0 && v_calc(i) < 0
        wind_dir(i,1) = 270 + theta(i);
    elseif u_calc(i) == 0 && v_calc(i) == 0
        wind_dir(i,1) = 0;
    elseif u_calc(i) > 0 && v_calc(i) == 0
        wind_dir(i,1) = 270;
    elseif u_calc(i) < 0 && v_calc(i) == 0
        wind_dir(i,1) = 90;
    elseif u_calc(i) == 0 && v_calc(i) > 0
        wind_dir(i,1) = 180;
    elseif u_calc(i,1) == 0 && v_calc(i) < 0
        wind_dir(i,1) = 0;
    end
end

% for i=1:max(size(u_calc))
%    hold off
%    plot([0 u_calc(i)],[0 0])
%    hold on
%    plot([0 0],[0 v_calc(i)])
%    ylim([-15 15])
%    xlim([-15 15])
%    grid on
%    wind_dir(i,1)
%    pause
% end
end

function [pressure, pressure_ratio] = calculate_pressure(alt_start,T_ISA)
global g_0 beta_T_less R H_p_trop T_0 ft_to_m p_0 delta_T p_trop_ISA

for i = 1:max(size(alt_start))
   if alt_start(i) < H_p_trop/ft_to_m/100
       pressure(i,1) = p_0*((T_ISA(i) - delta_T)/T_0)^-(g_0/(beta_T_less*R));
   else
       pressure(i,1) = p_trop_ISA*exp(-(g_0/(R*(T_0+beta_T_less*H_p_trop)))*((alt_start(i)*100*ft_to_m)-H_p_trop));
   end
end
pressure_ratio = pressure./p_0;
end

% function T_trop = calculate_T_trop
% global T_trop_ISA delta_T
% T_trop = T_trop_ISA + delta_T;
% end
% 
% function p_trop = calculate_p_trop
% global p_0 delta_T g_0 beta_T_less R T_trop_ISA T_0
% p_trop = p_0*((T_trop_ISA - delta_T)/T_0)^-(g_0/(beta_T_less*R));
% end

function [T_calc,u_calc,v_calc,T_nc,u_nc,v_nc,longitude,latitude,time,level,time_23,day_before] = calculate_t_u_v(hours_start,lon_start,lat_start,nc_file,pressure,nc_dir,unix_time)
nc_path = [nc_dir,nc_file];

latitude = ncread(nc_path,'latitude');
longitude = ncread(nc_path,'longitude');
latitude = double(latitude);
longitude = double(longitude);

T_nc = ncread(nc_path,'t');
u_nc = ncread(nc_path,'u');
v_nc = ncread(nc_path,'v');
level = ncread(nc_path,'pressure_level');
time = ncread(nc_path,'valid_time');
time = double(time);
level = double(level);
time = datetime(time,'ConvertFrom','posixtime','Format','dd-MMM-yyyy HH:mm:ss');
time = cellstr(time);
% time
for i = 1:max(size(time))
    curr_time = time{i};
    colons = find(curr_time == ':');
    time_h(i) = str2num(curr_time(colons(1)-2:colons(1)-1));
end
% pause
%%%%NOT NEEDED NOW
% lat_id = find(latitude>=floor(min(lat_start))&latitude<=ceil(max(lat_start)));
% lon_id = find(longitude>=floor(min(lon_start))&longitude<=ceil(max(lon_start)));
% 
% latitude = latitude(lat_id);
% longitude = longitude(lon_id);

% T_nc = T_nc(lon_id,lat_id,:,:);
% u_nc = u_nc(lon_id,lat_id,:,:);
% v_nc = v_nc(lon_id,lat_id,:,:);
%%%%

[nd_1,nd_2,nd_3,nd_4] = ndgrid(longitude,latitude,level,time_h);

start_date = datestr(unix_time(1)/86400 + datenum('1/1/1970'),'yymmdd');

plus_23 = find(hours_start >= 23);

if ~isempty(plus_23)
    if strcmp(date,start_date) == 1
        hours_start(:) = 23;
        time_23 = 1;
        day_before = 0;
    else
        hours_start(:) = 0;
        time_23 = 1;
        day_before = 1;
    end
else
    time_23 = 0;
    day_before = 0;
end

T_calc = interpn(nd_1,nd_2,nd_3,nd_4,T_nc,lon_start,lat_start,pressure./100,hours_start);
u_calc = interpn(nd_1,nd_2,nd_3,nd_4,u_nc,lon_start,lat_start,pressure./100,hours_start);
v_calc = interpn(nd_1,nd_2,nd_3,nd_4,v_nc,lon_start,lat_start,pressure./100,hours_start);

T_calc = fillmissing(T_calc,'linear','EndValues','extrap');
v_calc = fillmissing(v_calc,'linear','EndValues','extrap');
u_calc = fillmissing(u_calc,'linear','EndValues','extrap');

end

function flight_track = calculate_track(lon_start,lat_start,lon_end,lat_end,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option)
d_lon = lon_end-lon_start;
d_lat = lat_end-lat_start;

for i = 1:max(size(d_lon))
    if d_lon(i) >= 0 && d_lat(i) >= 0
        flight_track(i) = atand(d_lon(i)./d_lat(i));
    elseif d_lon(i) < 0 && d_lat(i) < 0
        flight_track(i) = abs(atand(d_lon(i)./d_lat(i))) + 180;
    elseif d_lon(i) >= 0 && d_lat(i) < 0
        flight_track(i) = abs(atand(d_lat(i)./d_lon(i))) + 90;
    elseif d_lon(i) < 0 && d_lat(i) >= 0
        flight_track(i) = abs(atand(d_lat(i)./d_lon(i))) + 270;
    end
end
flight_track = reshape(flight_track,i,1);

if smooth_flight_track == 1
    flight_track = smoothdata(flight_track,smooth_flight_track_option,smooth_flight_track_k);
end
end

function dh_dt = calculate_dh_dt(alt_start,alt_end,time_duration,smooth_ROD,smooth_ROD_k,smooth_ROD_option)
global ft_to_m
alt_diff = alt_end-alt_start;
dh_dt = (alt_diff*100*ft_to_m)./time_duration;
dh_dt(2:end) = dh_dt(1:(end-1));
dh_dt(1) = dh_dt(2);

if smooth_ROD == 1
    dh_dt = smoothdata(dh_dt,smooth_ROD_option,smooth_ROD_k);
end
end

function dv_dt = calculate_dv_dt(TAS,time_duration)
for i = 1:(max(size(TAS))-1)
    dv_dt(i+1,1) = (TAS(i+1) - TAS(i))./time_duration(i);
end
dv_dt(1,1) = dv_dt(2,1);

if max(size(TAS)) == 1
    dv_dt = 0;
end
end

function T_ISA = calculate_T_ISA(alt_start)
global T_0 beta_T_less H_p_trop ft_to_m delta_T T_trop_ISA
for i = 1:max(size(alt_start))
    if alt_start(i) < H_p_trop/ft_to_m/100
        T_ISA(i,1) = T_0 + delta_T + beta_T_less*alt_start(i)*100*ft_to_m;
    else
        T_ISA(i,1) = T_trop_ISA;
    end
end
end

function T_calc_ratio = calculate_T_calc_ratio(T_calc)
global T_0 delta_T
T_calc_ratio = T_calc./(T_0 + delta_T);
end

function M = calculate_Mach(TAS,T_calc)
global k R
sound_speed = sqrt(k*R*T_calc);
M = TAS./sound_speed;
end

function C_L_max = calculate_C_L_max(M,bf,C_L_max_BADA)
if isempty(bf)
    C_L_max = [];
    C_L_max(1:max(size(M)),1) = C_L_max_BADA;
else
    C_L_max = bf(1) + bf(2).*M + bf(3).*M.^2 + bf(4).*M.^3 + bf(5).*M.^4;
end
end

function total_T_ratio = calculate_total_T_ratio(T_calc_ratio,M)
global k
total_T_ratio = T_calc_ratio .* (1 + (M.^2 * (k-1))/2);
end

function C_D = calculate_C_D(M,C_L,d,C_D_scalar)
C_0 = d(1) + d(2)./((1-M.^2).^(1/2)) + d(3)./(1-M.^2) + d(4)./((1-M.^2).^(3/2)) + d(5)./((1-M.^2).^2);
C_2 = d(6) + d(7)./((1-M.^2).^(3/2)) + d(8)./((1-M.^2).^3) + d(9)./((1-M.^2).^(9/2)) + d(10)./((1-M.^2).^6);
C_6 = d(11) + d(12)./((1-M.^2).^7) + d(13)./((1-M.^2).^(15/2)) + d(14)./((1-M.^2).^8) + d(15)./((1-M.^2).^(17/2));
C_D = C_D_scalar *(C_0 + (C_2.*C_L.^2) + (C_6.*C_L.^6));
end

function C_L = calculate_C_L(mlw,pressure_ratio,S,M,C_L_max) 
global k g_0 p_0
C_L = (2*mlw*g_0)./(pressure_ratio*p_0*k*S.*M.^2);

for i = 1:max(size(C_L))
   if C_L(i) > C_L_max(i)
       C_L(i) = C_L_max(i);
   end
end
end

function D = calculate_drag(pressure_ratio,S,M,C_D)
global p_0 k
D = (1/2).*pressure_ratio.*p_0*k*S.*(M.^2).*C_D;
end

function C_T_idle = calculate_C_T_idle(pressure_ratio,M,ti,engine_type,T_calc_ratio)
if strcmp(engine_type,'JET')
    C_T_idle = ti(1)*pressure_ratio.^-1 + ti(2) + ti(3).*pressure_ratio + ti(4).*pressure_ratio.^2 ...
        + (ti(5).*pressure_ratio.^-1 + ti(6) + ti(7)*pressure_ratio + ti(8)*pressure_ratio.^2).*M ...
        + (ti(9).*pressure_ratio.^-1 + ti(10) + ti(11).*pressure_ratio + ti(12).*pressure_ratio.^2).*M.^2;
elseif strcmp(engine_type,'TURBOPROP')
    C_T_idle = ti(1)*pressure_ratio.^-1 + ti(2) + ti(3).*pressure_ratio + ti(4).*pressure_ratio.^2 ...
       + (ti(5).*pressure_ratio.^-1 + ti(6) + ti(7)*pressure_ratio + ti(8)*pressure_ratio.^2).*M ...
       + (ti(9).*pressure_ratio.^-1 + ti(10) + ti(11).*pressure_ratio + ti(12).*pressure_ratio.^2).*M.^2 ...
       + ti(13).*T_calc_ratio.^(1/2) + ti(14).*T_calc_ratio + ti(15).*T_calc_ratio.^(-1/2) + ti(16).*T_calc_ratio.^2 ...
       + (ti(17).*pressure_ratio.^(-1) + ti(18).*pressure_ratio + ti(19).*pressure_ratio.^2 + ti(20).*M + ti(21).*M.^2).*T_calc_ratio.^(-1/2)...
       + ti(22).*M.^(-1) + ti(23).*M.^(-1).*pressure_ratio + ti(24).*M.^3 ...
       + (ti(25).*M + ti(26).*M.^2 + ti(27) + ti(28).*M.*(pressure_ratio.^(-1))).*T_calc_ratio.^(-1)...
       + ti(29).*M.*pressure_ratio.^(-1).*T_calc_ratio.^(-2) + ti(30).*(M.^2).*(pressure_ratio.^(-1)).*(T_calc_ratio.^(-2)) + ti(31).*(M.^2).*(pressure_ratio.^(-1)).*(T_calc_ratio.^(-1/2)) + ti(32).*pressure_ratio.*(T_calc_ratio.^(-1));  
end
end

function Thr_idle = calculate_Thr_idle(pressure_ratio,m,C_T_idle)
global g_0
Thr_idle = pressure_ratio*m*g_0.*C_T_idle;
end

function T_param = calculate_T_param(pressure_ratio,M,b,p,c,kink_point,T_calc,total_T_ratio,engine_type,T_calc_ratio)
global T_0
if strcmp(engine_type,'JET')
    for i = 1:max(size(pressure_ratio))
        if T_calc(i) <= T_0 + kink_point
        T_param(i,1) = b(1) + b(2)*M(i) + b(3)*M(i)^2 + b(4)*M(i)^3 + b(5)*M(i)^4 + b(6)*M(i)^5 ...
        + (b(7) + b(8)*M(i) + b(9)*M(i)^2 + b(10)*M(i)^3 + b(11)*M(i)^4 + b(12)*M(i)^5)*pressure_ratio(i) ...
        + (b(13) + b(14)*M(i) + b(15)*M(i)^2 + b(16)*M(i)^3 + b(17)*M(i)^4 + b(18)*M(i)^5)*pressure_ratio(i)^2 ...
        + (b(19) + b(20)*M(i) + b(21)*M(i)^2 + b(22)*M(i)^3 + b(23)*M(i)^4 + b(24)*M(i)^5)*pressure_ratio(i)^3 ...
        + (b(25) + b(26)*M(i) + b(27)*M(i)^2 + b(28)*M(i)^3 + b(29)*M(i)^4 + b(30)*M(i)^5)*pressure_ratio(i)^4 ...
        + (b(31) + b(32)*M(i) + b(33)*M(i)^2 + b(34)*M(i)^3 + b(35)*M(i)^4 + b(36)*M(i)^5)*pressure_ratio(i)^5;
        else  
        T_param(i,1) = c(1) + c(2)*M(i) + c(3)*M(i)^2 + c(4)*M(i)^3 + c(5)*M(i)^4 + c(6)*M(i)^5 ...
        + (c(7) + c(8)*M(i) + c(9)*M(i)^2 + c(10)*M(i)^3 + c(11)*M(i)^4 + c(12)*M(i)^5)*total_T_ratio(i) ...
        + (c(13) + c(14)*M(i) + c(15)*M(i)^2 + c(16)*M(i)^3 + c(17)*M(i)^4 + c(18)*M(i)^5)*total_T_ratio(i)^2 ...
        + (c(19) + c(20)*M(i) + c(21)*M(i)^2 + c(22)*M(i)^3 + c(23)*M(i)^4 + c(24)*M(i)^5)*total_T_ratio(i)^3 ...
        + (c(25) + c(26)*M(i) + c(27)*M(i)^2 + c(28)*M(i)^3 + c(29)*M(i)^4 + c(30)*M(i)^5)*total_T_ratio(i)^4 ...
        + (c(31) + c(32)*M(i) + c(33)*M(i)^2 + c(34)*M(i)^3 + c(35)*M(i)^4 + c(36)*M(i)^5)*total_T_ratio(i)^5;
        end
    end
elseif strcmp(engine_type,'TURBOPROP')
        T_param = p(1) + p(2).*M + p(3).*M.^2 + p(4).*M.^3 + p(5).*M.^4 + p(6).*M.^5 ...
        + (p(7) + p(8).*M + p(9).*M.^2 + p(10).*M.^3 + p(11).*M.^4 + p(12).*M.^5).*T_calc_ratio ...
        + (p(13) + p(14).*M + p(15).*M.^2 + p(16).*M.^3 + p(17).*M.^4 + p(18).*M.^5).*T_calc_ratio.^2 ...
        + (p(19) + p(20).*M + p(21).*M.^2 + p(22).*M.^3 + p(23).*M.^4 + p(24).*M.^5).*T_calc_ratio.^3 ...
        + (p(25) + p(26).*M + p(27).*M.^2 + p(28).*M.^3 + p(29).*M.^4 + p(30).*M.^5).*T_calc_ratio.^4 ...
        + (p(31) + p(32).*M + p(33).*M.^2 + p(34).*M.^3 + p(35).*M.^4 + p(36).*M.^5).*T_calc_ratio.^5;        
end
end

function eta = calculate_eta(eta_max,W_P_max,n_eng,rho_ratio,D_P,TAS)
global rho_0
a_eta = ones(size(TAS));
b_eta = zeros(size(TAS));
c_eta = (n_eng/W_P_max).*rho_ratio.*rho_0.*(D_P.^2).*(pi/2).*(TAS.^3).*eta_max;
d_eta = -((n_eng/W_P_max).*rho_ratio.*rho_0.*(D_P.^2).*(pi/2).*(TAS.^3).*eta_max^2);

for i = 1:max(size(TAS))
    eta_roots{i} = roots([a_eta(i) b_eta(i) c_eta(i) d_eta(i)]);
    eta(i,:) = eta_roots{i}(3);
end
end

function C_P_MCMB = calculate_C_P_MCMB(W_P_max,eta,pressure_ratio,mlw,a,M,T_param)
global g_0 a_0
C_P_MCMB_gen = a(1) + a(2).*M + a(3).*M.^2 + a(4).*M.^3 + a(5).*M.^4 + a(6).*M.^5 ...
    + (a(7) + a(8).*M + a(9).*M.^2 + a(10).*M.^3 + a(11).*M.^4 + a(12).*M.^5).*T_param ...
    + (a(13) + a(14).*M + a(15).*M.^2 + a(16).*M.^3 + a(17).*M.^4 + a(18).*M.^5).*T_param.^2 ...
    + (a(19) + a(20).*M + a(21).*M.^2 + a(22).*M.^3 + a(23).*M.^4 + a(24).*M.^5).*T_param.^3 ...
    + (a(25) + a(26).*M + a(27).*M.^2 + a(28).*M.^3 + a(29).*M.^4 + a(30).*M.^5).*T_param.^4 ...
    + (a(31) + a(32).*M + a(33).*M.^2 + a(34).*M.^3 + a(35).*M.^4 + a(36).*M.^5).*T_param.^5;

C_P_MCMB_max = W_P_max*eta.*pressure_ratio.^(-1).*(g_0*mlw).^(-1).*(a_0).^(-1);

C_P_MCMB = min(C_P_MCMB_gen,C_P_MCMB_max);
end

function C_T_MCMB = calculate_C_T_MCMB(M,a,T_param,engine_type,C_P_MCMB)
if strcmp(engine_type,'JET')
    C_T_MCMB = a(1) + a(2).*M + a(3).*M.^2 + a(4).*M.^3 + a(5).*M.^4 + a(6).*M.^5 ...
        + (a(7) + a(8).*M + a(9).*M.^2 + a(10).*M.^3 + a(11).*M.^4 + a(12).*M.^5).*T_param ...
        + (a(13) + a(14).*M + a(15).*M.^2 + a(16).*M.^3 + a(17).*M.^4 + a(18).*M.^5).*T_param.^2 ...
        + (a(19) + a(20).*M + a(21).*M.^2 + a(22).*M.^3 + a(23).*M.^4 + a(24).*M.^5).*T_param.^3 ...
        + (a(25) + a(26).*M + a(27).*M.^2 + a(28).*M.^3 + a(29).*M.^4 + a(30).*M.^5).*T_param.^4 ...
        + (a(31) + a(32).*M + a(33).*M.^2 + a(34).*M.^3 + a(35).*M.^4 + a(36).*M.^5).*T_param.^5;
elseif strcmp(engine_type,'TURBOPROP')
    C_T_MCMB = C_P_MCMB./M;
end
end

function Thr_MCMB = calculate_Thr_MCMB(pressure_ratio,m,C_T_MCMB)
global g_0
Thr_MCMB = pressure_ratio.*m*g_0.*C_T_MCMB;
end

function Thr = calculate_thrust(m,TAS,dh_dt,dv_dt,D,Thr_idle,Thr_MCMB)
global g_0
Thr = ((m*g_0)./TAS).*dh_dt + m*dv_dt + D;
for i = 1:max(size(Thr))
   if Thr(i) < Thr_idle(i)
       Thr(i) = Thr_idle(i);
   elseif Thr(i) > Thr_MCMB(i)
       Thr(i) = Thr_MCMB(i);
   end
end
end

function C_T = calculate_C_T(Thr,pressure_ratio,m)
global g_0
C_T = Thr./(pressure_ratio.*m*g_0);
end

function C_P = calculate_C_P(M,C_T)
C_P = C_T.*M;
end

function C_F_idle = calculate_C_F_idle(fi,M,pressure_ratio,T_calc_ratio,engine_type)
if strcmp(engine_type,'JET')
C_F_idle = ((fi(1) + fi(2).*pressure_ratio + fi(3).*pressure_ratio.^2) ...
    + (fi(4) + fi(5).*pressure_ratio + fi(6).*pressure_ratio.^2).*M ...
    + (fi(7) + fi(8).*pressure_ratio + fi(9).*pressure_ratio.^2).*M.^2).*(pressure_ratio.^-1).*(T_calc_ratio.^-(1/2));

elseif strcmp(engine_type,'TURBOPROP')
C_F_idle = ((fi(1) + fi(2).*pressure_ratio + fi(3).*pressure_ratio.^2) ...
    + (fi(4) + fi(5).*pressure_ratio + fi(6).*pressure_ratio.^2).*M ...
    + (fi(7) + fi(8).*pressure_ratio + fi(9).*pressure_ratio.^2).*M.^2 ...
    + (fi(10).*T_calc_ratio + fi(11).*T_calc_ratio.^2 + fi(12).*M.*T_calc_ratio + fi(13).*M.*pressure_ratio.*T_calc_ratio.^(1/2) + fi(14).*M.*pressure_ratio.*T_calc_ratio)).*(pressure_ratio.^(-1)).*T_calc_ratio.^(-1/2);

end
end

function C_F = calculate_C_F(C_T,C_P,M,f,C_F_idle,engine_type)

if strcmp(engine_type,'JET')
    C_F = f(1) + f(2).*C_T + f(3).*C_T.^2 + f(4).*C_T.^3 + f(5).*C_T.^4 ...
    +  (f(6) + f(7).*C_T + f(8).*C_T.^2 + f(9).*C_T.^3 + f(10).*C_T.^4).*M ...
    + (f(11) + f(12).*C_T + f(13).*C_T.^2 + f(14).*C_T.^3 + f(15).*C_T.^4).*M.^2 ...
    + (f(16) + f(17).*C_T + f(18).*C_T.^2 + f(19).*C_T.^3 + f(20).*C_T.^4).*M.^3 ...
    + (f(21) + f(22).*C_T + f(23).*C_T.^2 + f(24).*C_T.^3 + f(25).*C_T.^4).*M.^4;

elseif strcmp(engine_type,'TURBOPROP')
    C_F = f(1) + f(2).*C_P + f(3).*C_P.^2 + f(4).*C_P.^3 + f(5).*C_P.^4 ...
    +  (f(6) + f(7).*C_P + f(8).*C_P.^2 + f(9).*C_P.^3 + f(10).*C_P.^4).*M ...
    + (f(11) + f(12).*C_P + f(13).*C_P.^2 + f(14).*C_P.^3 + f(15).*C_P.^4).*M.^2 ...
    + (f(16) + f(17).*C_P + f(18).*C_P.^2 + f(19).*C_P.^3 + f(20).*C_P.^4).*M.^3 ...
    + (f(21) + f(22).*C_P + f(23).*C_P.^2 + f(24).*C_P.^3 + f(25).*C_P.^4).*M.^4; 
end

for i = 1:max(size(C_F))
    if C_F(i) < C_F_idle(i)
        C_F(i) = C_F_idle(i);
    end
end  
end

function F = calculate_F(pressure_ratio,T_ratio,m,L_HV,C_F)
global g_0 a_0
F = pressure_ratio.*(T_ratio.^(1/2)).*g_0*m*a_0*(L_HV^-1).*C_F;
end

function [user_alt_end_time,FAP_message] = calculate_FAP_time(alt_start,total_dur,FAP_alt)
alt_higher = find(alt_start > FAP_alt/100);

alt_lower = find(alt_start < FAP_alt/100);
if isempty(alt_lower)
   user_alt_end_time = total_dur(end);
   FAP_message = 1;
else
    alt_higher = alt_higher(end);

    alt_lower = alt_lower(1);

    time_lower = total_dur(alt_lower);
    time_higher = total_dur(alt_higher);

    delta_alt = alt_start(alt_higher) - alt_start(alt_lower);
    delta_time = time_lower - time_higher;

    alt_to_loose = alt_start(alt_higher) - FAP_alt/100;
    alt_ratio = alt_to_loose/delta_alt;
    extra_time = delta_time*alt_ratio;
    
    user_alt_end_time = time_higher + extra_time;
    FAP_message = 0;
end

end

function [FAP_entry_lon,FAP_entry_lat] = calculate_FAP_entry_coord(FAP_01L_lat,FAF_08_lat,FAP_19R_lat,FAP_19L_lat,FAP_26_lat,FAP_01R_lat,FAP_01L_lon,FAF_08_lon,FAP_19R_lon,FAP_19L_lon,FAP_26_lon,FAP_01R_lon,lon_start,lat_start,end_calculation,total_dur,user_alt_end_time,IF_lat,IF_lon)

if strcmp(end_calculation,'FAP') 
%     [FAP_entry_lon, FAP_entry_lat] = polyxpoly(lon_start,lat_start,[FAP_01L_lon,FAF_08_lon,FAP_19R_lon,FAP_19L_lon,FAP_26_lon,FAP_01R_lon,FAP_01L_lon],[FAP_01L_lat,FAF_08_lat,FAP_19R_lat,FAP_19L_lat,FAP_26_lat,FAP_01R_lat,FAP_01L_lat]);
    FAP_entry_lon = IF_lon;
    FAP_entry_lat = IF_lat;
elseif strcmp(end_calculation,'user_alt')
    FAP_entry_lon = interp1(total_dur,lon_start,user_alt_end_time);
    FAP_entry_lat = interp1(total_dur,lat_start,user_alt_end_time);
end

if isnan(FAP_entry_lat)
    FAP_entry_lon = lon_start(end);
    FAP_entry_lat = lat_start(end);
end
      
if isempty(FAP_entry_lon)
    FAP_entry_lon = lon_start(end);
    FAP_entry_lat = lat_start(end);
else
    FAP_entry_lon = FAP_entry_lon(end);
    FAP_entry_lat = FAP_entry_lat(end);
end


end

function [FAP_entry_time, FAP_message] = calculate_FAP_entry_time(lon_start,lat_start,FAP_entry_lon,FAP_entry_lat,total_dur,alt_start,FAP_alt)

for i = 1:max(size(lon_start))
     distance(i) = sqrt((lon_start(i) - FAP_entry_lon)^2 + (lat_start(i) - FAP_entry_lat)^2);
end

distance_sort = sort(distance');
min_distance = distance_sort(1:2);
close_coord_1 = find(distance == min_distance(1));

if alt_start(end)*100 > FAP_alt
    FAP_entry_time = total_dur(end);
    FAP_message = 1;
else
    close_coord_1 = close_coord_1(1);
    close_coord_2 = find(distance == min_distance(2));
    close_coord_2 = close_coord_2(1);
    total_distance = close_coord_1 + close_coord_2;
    ratio_distance = close_coord_1/total_distance;
    FAP_entry_time = total_dur(close_coord_1) + (total_dur(close_coord_2) - total_dur(close_coord_1))*ratio_distance;
    FAP_message = [];
end

end

function [TMA_entry_lon, TMA_entry_lat] = calculate_TMA_entry(lon_start,lat_start,TMA_lat,TMA_lon)
[in,on] = inpolygon(lon_start,lat_start,TMA_lon,TMA_lat);
in = find(in == 1);
TMA_entry_lon = lon_start(in(1));
TMA_entry_lat = lat_start(in(1));
end

function TMA_entry_time = calculate_interp_entry(lon_start,lat_start,TMA_entry_lon, TMA_entry_lat,total_dur)

for i = 1:max(size(lon_start))
     distance(i) = sqrt((lon_start(i) - TMA_entry_lon)^2 + (lat_start(i) - TMA_entry_lat)^2);
end
distance_sort = sort(distance');
min_distance = distance_sort(1:2);
close_coord_1 = find(distance == min_distance(1));
close_coord_1 = close_coord_1(1);
close_coord_2 = find(distance == min_distance(2));
close_coord_2 = close_coord_2(1);
total_distance = close_coord_1 + close_coord_2;
ratio_distance = close_coord_1/total_distance;

if TMA_entry_lon == lon_start(1)
    TMA_entry_time = total_dur(1);
else
    TMA_entry_time = total_dur(close_coord_1) + (total_dur(close_coord_2) - total_dur(close_coord_1))*ratio_distance;
end

end

function [F_burn_tot, F_burn_TMA, TMA_time_vector, TMA_fuel_vector,F_burn_time_TMA] = calculate_F_burn(F,total_dur,TMA_entry_time,FAP_entry_time)
F_burn_tot = trapz(total_dur,F);

stop_time = FAP_entry_time;

time_to_incl = find((stop_time > total_dur)&(total_dur > TMA_entry_time));

F_entry = interp1(total_dur,F,TMA_entry_time);
F_FAP = interp1(total_dur,F,stop_time);

TMA_time_vector = [TMA_entry_time total_dur(time_to_incl) stop_time];
TMA_fuel_vector = [F_entry; F(time_to_incl);F_FAP];

F_burn_TMA = trapz(TMA_time_vector,TMA_fuel_vector);

for i = 2:max(size(TMA_time_vector))
    F_burn_time_TMA(i,1) = trapz(TMA_time_vector(1:i),TMA_fuel_vector(1:i));
end
F_burn_time_TMA(1) = 0;
end 

function dtg = calculate_dtg(segment_length)
for i = 1:max(size(segment_length))
    dtg(i) = sum(segment_length(i:end));
end
dtg = dtg';
end

function time_in_TMA = calculate_time_in_TMA(TMA_time_vector)

time_in_TMA(1) = 0;
time_in_TMA_flip(1) = TMA_time_vector(end) - TMA_time_vector(1);

for i = 2:max(size(TMA_time_vector))
    time_in_TMA(i) = [TMA_time_vector(i) - TMA_time_vector(i-1) + time_in_TMA(i-1)];
    time_in_TMA_flip(i) = time_in_TMA_flip(i-1) - (TMA_time_vector(i) - TMA_time_vector(i-1));
end
time_in_TMA = time_in_TMA';
time_in_TMA_flip = time_in_TMA_flip';
time_in_TMA = time_in_TMA_flip;

end

function alt_in_TMA = calculate_alt_in_TMA(alt_start,TMA_time_vector,total_dur)
alt_in_TMA = interp1(total_dur,alt_start,TMA_time_vector);
alt_in_TMA = alt_in_TMA';
end

function [dist_in_TMA, dtg_in_TMA] = calculate_dist_in_TMA(TMA_entry_time,FAP_entry_time,total_dur,dtg,TMA_time_vector)
TMA_entry_dtg = interp1(total_dur,dtg,TMA_entry_time);
FAP_entry_dtg = interp1(total_dur,dtg,FAP_entry_time);
dist_in_TMA = TMA_entry_dtg - FAP_entry_dtg;

dtg_in_TMA_unchanged = [interp1(total_dur,dtg,TMA_time_vector(1)); dtg(find(dtg < interp1(total_dur,dtg,TMA_time_vector(1)) & dtg > interp1(total_dur,dtg,TMA_time_vector(end))));interp1(total_dur,dtg,TMA_time_vector(end))];

dtg_in_TMA(1) = dtg_in_TMA_unchanged(1) - dtg_in_TMA_unchanged(end);

for k = 2:max(size(dtg_in_TMA_unchanged))
   dtg_in_TMA(k,1) = dtg_in_TMA(k-1) - (dtg_in_TMA_unchanged(k-1) - dtg_in_TMA_unchanged(k));
end

dtg_in_TMA(end) = abs(dtg_in_TMA(end));

end

function M_in_TMA = calculate_M_in_TMA(M,TMA_time_vector,total_dur)
M_in_TMA = interp1(total_dur,M,TMA_time_vector);
M_in_TMA = M_in_TMA';
end

function TAS_in_TMA = calculate_TAS_in_TMA(TAS,TMA_time_vector,total_dur)
TAS_in_TMA = interp1(total_dur,TAS,TMA_time_vector);
TAS_in_TMA = TAS_in_TMA';
end

function GS_in_TMA = calculate_GS_in_TMA(GS,TMA_time_vector,total_dur)
GS_in_TMA = interp1(total_dur,GS,TMA_time_vector);
GS_in_TMA = GS_in_TMA';
end

function CAS_in_TMA = calculate_CAS_in_TMA(CAS,TMA_time_vector,total_dur)
CAS_in_TMA = interp1(total_dur,CAS,TMA_time_vector);
CAS_in_TMA = CAS_in_TMA';
end

function dh_dt_in_TMA = calculate_dh_dt_in_TMA(dh_dt,TMA_time_vector,total_dur)
dh_dt_in_TMA = interp1(total_dur,dh_dt,TMA_time_vector);
dh_dt_in_TMA = dh_dt_in_TMA';
end

function [lon_TMA,lat_TMA] = coord_in_TMA(lat_start,lon_start,TMA_time_vector,total_dur)
lat_TMA = interp1(total_dur,lat_start,TMA_time_vector)';
lon_TMA = interp1(total_dur,lon_start,TMA_time_vector)';
end

function Thr_TMA = calculate_Thr_in_TMA(Thr,total_dur,TMA_time_vector)
Thr_TMA = interp1(total_dur,Thr,TMA_time_vector)';
end

function C_L_TMA = calculate_C_L_in_TMA(C_L,total_dur,TMA_time_vector)
C_L_TMA = interp1(total_dur,C_L,TMA_time_vector)';
end

function C_D_TMA = calculate_C_D_in_TMA(C_D,total_dur,TMA_time_vector)
C_D_TMA = interp1(total_dur,C_D,TMA_time_vector)';
end

function wind_speed_in_TMA = calculate_wind_speed_in_TMA(wind_speed,total_dur,TMA_time_vector)
wind_speed_in_TMA = interp1(total_dur,wind_speed,TMA_time_vector)';
end

function wind_comp_in_TMA = calculate_wind_comp_in_TMA(wind_comp,total_dur,TMA_time_vector)
wind_comp_in_TMA = interp1(total_dur,wind_comp,TMA_time_vector)';
end

function wind_dir_in_TMA = calculate_wind_dir_in_TMA(wind_dir,total_dur,TMA_time_vector)
wind_dir_in_TMA = interp1(total_dur,wind_dir,TMA_time_vector)';
end

function flight_track_in_TMA = calculate_flight_track_in_TMA(flight_track,total_dur,TMA_time_vector)
flight_track_in_TMA = interp1(total_dur,flight_track,TMA_time_vector)';
end

function time_at_FAP = calculate_time_at_FAP(total_dur,hours_start,time_in_TMA)
time_at_FAP = interp1(total_dur,hours_start,time_in_TMA(end));
end

function time_at_TMA = calculate_time_at_TMA(total_dur,hours_start,time_in_TMA)
time_at_TMA = interp1(total_dur,hours_start,time_in_TMA(1));
end

function unix_time_in_TMA = calculate_unix_time_in_TMA(total_dur,TMA_time_vector,time_at_FAP,time_at_TMA,date,unix_time)

hours_in_TMA(1) = time_at_TMA;

for i = 2:((max(size(TMA_time_vector)))-1)
    hours_in_TMA(i) = hours_in_TMA(i-1) + (TMA_time_vector(i) - TMA_time_vector(i-1))/3600;
end
hours_in_TMA;
hours_in_TMA(end+1) = time_at_FAP;
time_string_in_TMA = datestr(hours_in_TMA/24, 'HH:MM:SS' );

DATE = ['20',date];
for j = 1:max(size(time_string_in_TMA))
    TIME = time_string_in_TMA(j,:);
    unix_time_in_TMA(j) = posixtime( datetime(strcat(DATE, {' '}, TIME), 'InputFormat', 'yyyyMMdd HH:mm:ss') );
    
    if unix_time_in_TMA(j) > unix_time(end)
        unix_time_in_TMA(j) = unix_time_in_TMA(j) - 86400;
    end
    
    if j >= 2
        if unix_time_in_TMA(j) < unix_time_in_TMA(j-1)
            unix_time_in_TMA(j) = unix_time_in_TMA(j) + 86400;
        end
    end
end
end

function [LOWW_transition_lat_1,LOWW_transition_lon_1,LOWW_transition_lat_2,LOWW_transition_lon_2,LOWW_transition_lat_3,LOWW_transition_lon_3,LOWW_transition_lat_4,LOWW_transition_lon_4,rwy] = find_loww_rwy(lon_TMA,lat_TMA,BALAD_3K_lat,BALAD_3K_lon,MABOD_4K_lat,MABOD_4K_lon,NERDU_4K_lat,NERDU_4K_lon,PESAT_4K_lat,PESAT_4K_lon,BALAD_4M_lat,BALAD_4M_lon,MABOD_5M_lat,MABOD_5M_lon,NERDU_4M_lat,NERDU_4M_lon,PESAT_4M_lat,PESAT_4M_lon,BALAD_5L_lat,BALAD_5L_lon,MABOD_6L_lat,MABOD_6L_lon,NERDU_6L_lat,NERDU_6L_lon,PESAT_5L_lat,PESAT_5L_lon,BALAD_3N_lat,BALAD_3N_lon,MABOD_4N_lat,MABOD_4N_lon,NERDU_4N_lat,NERDU_4N_lon,PESAT_4N_lat,PESAT_4N_lon)

last_flight_point = [lon_TMA(end);lat_TMA(end)];

last_trans_point_1 = [BALAD_3K_lon(end);BALAD_3K_lat(end)];
d_rw(1) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_trans_point_1(2) last_trans_point_1(1)]);

last_trans_point_2 = [BALAD_4M_lon(end);BALAD_4M_lat(end)];
d_rw(2) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_trans_point_2(2) last_trans_point_2(1)]);

last_trans_point_3 = [BALAD_5L_lon(end);BALAD_5L_lat(end)];
d_rw(3) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_trans_point_3(2) last_trans_point_3(1)]);

last_trans_point_4 = [BALAD_3N_lon(end);BALAD_3N_lat(end)];
d_rw(4) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_trans_point_4(2) last_trans_point_4(1)]);

min_d_rw = min(d_rw);
min_d_rw_id = find(d_rw == min_d_rw);

if min_d_rw_id == 1
    LOWW_transition_lat_1 = BALAD_3K_lat;
    LOWW_transition_lat_2 = MABOD_4K_lat;
    LOWW_transition_lat_3 = NERDU_4K_lat;
    LOWW_transition_lat_4 = PESAT_4K_lat;
    
    LOWW_transition_lon_1 = BALAD_3K_lon;
    LOWW_transition_lon_2 = MABOD_4K_lon;
    LOWW_transition_lon_3 = NERDU_4K_lon;
    LOWW_transition_lon_4 = PESAT_4K_lon;
    rwy = '11';
elseif min_d_rw_id == 2
    LOWW_transition_lat_1 = BALAD_4M_lat;
    LOWW_transition_lat_2 = MABOD_5M_lat;
    LOWW_transition_lat_3 = NERDU_4M_lat;
    LOWW_transition_lat_4 = PESAT_4M_lat;
    
    LOWW_transition_lon_1 = BALAD_4M_lon;
    LOWW_transition_lon_2 = MABOD_5M_lon;
    LOWW_transition_lon_3 = NERDU_4M_lon;
    LOWW_transition_lon_4 = PESAT_4M_lon;
    rwy = '29';
elseif min_d_rw_id == 3
    LOWW_transition_lat_1 = BALAD_5L_lat;
    LOWW_transition_lat_2 = MABOD_6L_lat;
    LOWW_transition_lat_3 = NERDU_6L_lat;
    LOWW_transition_lat_4 = PESAT_5L_lat;
    
    LOWW_transition_lon_1 = BALAD_5L_lon;
    LOWW_transition_lon_2 = MABOD_6L_lon;
    LOWW_transition_lon_3 = NERDU_6L_lon;
    LOWW_transition_lon_4 = PESAT_5L_lon;
    rwy = '16';
elseif min_d_rw_id == 4
    LOWW_transition_lat_1 = BALAD_3N_lat;
    LOWW_transition_lat_2 = MABOD_4N_lat;
    LOWW_transition_lat_3 = NERDU_4N_lat;
    LOWW_transition_lat_4 = PESAT_4N_lat;
    
    LOWW_transition_lon_1 = BALAD_3N_lon;
    LOWW_transition_lon_2 = MABOD_4N_lon;
    LOWW_transition_lon_3 = NERDU_4N_lon;
    LOWW_transition_lon_4 = PESAT_4N_lon;
    rwy = '34';
end
end

function [PMS_lat_1,PMS_lat_2,PMS_lat_3,PMS_lat_4,PMS_lat_5,PMS_lat_6,PMS_lat_7,PMS_lat_8,PMS_lat_9,PMS_lat_10,PMS_lon_1,PMS_lon_2,PMS_lon_3,PMS_lon_4,PMS_lon_5,PMS_lon_6,PMS_lon_7,PMS_lon_8,PMS_lon_9,PMS_lon_10,rwy] = find_eidw_rwy(lon_TMA,lat_TMA,PMS_common_10R_1_lat,PMS_common_10R_1_lon,PMS_common_10R_2_lat,PMS_common_10R_2_lon,PMS_10R_1_lat,PMS_10R_1_lon,PMS_10R_2_lat,PMS_10R_2_lon,PMS_10R_3_lat,PMS_10R_3_lon,PMS_10R_4_lat,PMS_10R_4_lon,PMS_10R_5_lat,PMS_10R_5_lon,PMS_10R_6_lat,PMS_10R_6_lon,PMS_10R_7_lat,PMS_10R_7_lon,PMS_10R_8_lat,PMS_10R_8_lon,PMS_common_28L_1_lat,PMS_common_28L_1_lon,PMS_common_28L_2_lat,PMS_common_28L_2_lon,PMS_28L_1_lat,PMS_28L_1_lon,PMS_28L_2_lat,PMS_28L_2_lon,PMS_28L_3_lat,PMS_28L_3_lon,PMS_28L_4_lat,PMS_28L_4_lon,PMS_28L_5_lat,PMS_28L_5_lon,PMS_28L_6_lat,PMS_28L_6_lon,PMS_28L_7_lat,PMS_28L_7_lon,PMS_28L_8_lat,PMS_28L_8_lon,MAXEV_lat,MAXEV_lon,GANET_lat,GANET_lon,PMS_common_34_1_lat,PMS_common_34_1_lon,PMS_common_34_2_lat,PMS_common_34_2_lon,PMS_34_1_lat,PMS_34_1_lon,PMS_34_2_lat,PMS_34_2_lon,PMS_34_3_lat,PMS_34_3_lon,PMS_34_4_lat,PMS_34_4_lon,PMS_34_5_lat,PMS_34_5_lon,PMS_34_6_lat,PMS_34_6_lon,PMS_34_7_lat,PMS_34_7_lon,PMS_34_8_lat,PMS_34_8_lon,PMS_common_16_1_lat,PMS_common_16_1_lon,PMS_common_16_2_lat,PMS_common_16_2_lon,PMS_16_1_lat,PMS_16_1_lon,PMS_16_2_lat,PMS_16_2_lon,PMS_16_3_lat,PMS_16_3_lon,PMS_16_4_lat,PMS_16_4_lon,PMS_16_5_lat,PMS_16_5_lon,PMS_16_6_lat,PMS_16_6_lon,PMS_16_7_lat,PMS_16_7_lon,PMS_16_8_lat,PMS_16_8_lon,ABDOX_lat,ABDOX_lon,GARTI_lat,GARTI_lon)

last_flight_point = [lon_TMA(end);lat_TMA(end)];

last_point_1 = [GANET_lon;GANET_lat];
d_rw(1) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_point_1(2) last_point_1(1)]);

last_point_2 = [MAXEV_lon;MAXEV_lat];
d_rw(2) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_point_2(2) last_point_2(1)]);

last_point_3 = [ABDOX_lon;ABDOX_lat];
d_rw(3) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_point_3(2) last_point_3(1)]);

last_point_4 = [GARTI_lon;GARTI_lat];
d_rw(4) = lldistkm([last_flight_point(2) last_flight_point(1)],[last_point_4(2) last_point_4(1)]);

min_d_rw = min(d_rw);
min_d_rw_id = find(d_rw == min_d_rw);

if min_d_rw_id == 1
    PMS_lat_1 = PMS_common_10R_1_lat;
    PMS_lat_2 = PMS_common_10R_2_lat;
    PMS_lat_3 = PMS_10R_1_lat;
    PMS_lat_4 = PMS_10R_2_lat;
    PMS_lat_5 = PMS_10R_3_lat;
    PMS_lat_6 = PMS_10R_4_lat;
    PMS_lat_7 = PMS_10R_5_lat;
    PMS_lat_8 = PMS_10R_6_lat; 
    PMS_lat_9 = PMS_10R_7_lat;
    PMS_lat_10 = PMS_10R_8_lat; 
    
    PMS_lon_1 = PMS_common_10R_1_lon;
    PMS_lon_2 = PMS_common_10R_2_lon;
    PMS_lon_3 = PMS_10R_1_lon;
    PMS_lon_4 = PMS_10R_2_lon;
    PMS_lon_5 = PMS_10R_3_lon;
    PMS_lon_6 = PMS_10R_4_lon;
    PMS_lon_7 = PMS_10R_5_lon;
    PMS_lon_8 = PMS_10R_6_lon; 
    PMS_lon_9 = PMS_10R_7_lon;
    PMS_lon_10 = PMS_10R_8_lon; 
    
    rwy = '10R';
elseif min_d_rw_id == 2
    PMS_lat_1 = PMS_common_28L_1_lat;
    PMS_lat_2 = PMS_common_28L_2_lat;
    PMS_lat_3 = PMS_28L_1_lat;
    PMS_lat_4 = PMS_28L_2_lat;
    PMS_lat_5 = PMS_28L_3_lat;
    PMS_lat_6 = PMS_28L_4_lat;
    PMS_lat_7 = PMS_28L_5_lat;
    PMS_lat_8 = PMS_28L_6_lat; 
    PMS_lat_9 = PMS_28L_7_lat;
    PMS_lat_10 = PMS_28L_8_lat; 
    
    PMS_lon_1 = PMS_common_28L_1_lon;
    PMS_lon_2 = PMS_common_28L_2_lon;
    PMS_lon_3 = PMS_28L_1_lon;
    PMS_lon_4 = PMS_28L_2_lon;
    PMS_lon_5 = PMS_28L_3_lon;
    PMS_lon_6 = PMS_28L_4_lon;
    PMS_lon_7 = PMS_28L_5_lon;
    PMS_lon_8 = PMS_28L_6_lon; 
    PMS_lon_9 = PMS_28L_7_lon;
    PMS_lon_10 = PMS_28L_8_lon; 
    
    rwy = '28L';
elseif min_d_rw_id == 3
    PMS_lat_1 = PMS_common_34_1_lat;
    PMS_lat_2 = PMS_common_34_2_lat;
    PMS_lat_3 = PMS_34_1_lat;
    PMS_lat_4 = PMS_34_2_lat;
    PMS_lat_5 = PMS_34_3_lat;
    PMS_lat_6 = PMS_34_4_lat;
    PMS_lat_7 = PMS_34_5_lat;
    PMS_lat_8 = PMS_34_6_lat; 
    PMS_lat_9 = PMS_34_7_lat;
    PMS_lat_10 = PMS_34_8_lat; 
    
    PMS_lon_1 = PMS_common_34_1_lon;
    PMS_lon_2 = PMS_common_34_2_lon;
    PMS_lon_3 = PMS_34_1_lon;
    PMS_lon_4 = PMS_34_2_lon;
    PMS_lon_5 = PMS_34_3_lon;
    PMS_lon_6 = PMS_34_4_lon;
    PMS_lon_7 = PMS_34_5_lon;
    PMS_lon_8 = PMS_34_6_lon; 
    PMS_lon_9 = PMS_34_7_lon;
    PMS_lon_10 = PMS_34_8_lon; 
    
    rwy = '34';
elseif min_d_rw_id == 4
    PMS_lat_1 = PMS_common_16_1_lat;
    PMS_lat_2 = PMS_common_16_2_lat;
    PMS_lat_3 = PMS_16_1_lat;
    PMS_lat_4 = PMS_16_2_lat;
    PMS_lat_5 = PMS_16_3_lat;
    PMS_lat_6 = PMS_16_4_lat;
    PMS_lat_7 = PMS_16_5_lat;
    PMS_lat_8 = PMS_16_6_lat; 
    PMS_lat_9 = PMS_16_7_lat;
    PMS_lat_10 = PMS_16_8_lat; 
    
    PMS_lon_1 = PMS_common_16_1_lon;
    PMS_lon_2 = PMS_common_16_2_lon;
    PMS_lon_3 = PMS_16_1_lon;
    PMS_lon_4 = PMS_16_2_lon;
    PMS_lon_5 = PMS_16_3_lon;
    PMS_lon_6 = PMS_16_4_lon;
    PMS_lon_7 = PMS_16_5_lon;
    PMS_lon_8 = PMS_16_6_lon; 
    PMS_lon_9 = PMS_16_7_lon;
    PMS_lon_10 = PMS_16_8_lon; 
    
    rwy = '16';
end

end

function [IAF_1_lat,IAF_1_lon,IAF_2_lat,IAF_2_lon,ELTOK_STAR_lat,ELTOK_STAR_lon,HMR_STAR_lat,HMR_STAR_lon,NILUG_STAR_lat,NILUG_STAR_lon,XILAN_STAR_lat,XILAN_STAR_lon,rwy] = find_essa_rwy(lon_end,lat_end,ELTOK_7M_lat,ELTOK_7M_lon,HMR_5M_lat,HMR_5M_lon,NILUG_2M_lat,NILUG_2M_lon,XILAN_4M_lat,XILAN_4M_lon,ELTOK_7P_lat,ELTOK_7P_lon,HMR_4P_lat ,HMR_4P_lon,NILUG_2P_lat,NILUG_2P_lon,XILAN_5P_lat,XILAN_5P_lon,ELTOK_7S_lat,ELTOK_7S_lon,HMR_5S_lat,HMR_5S_lon,NILUG_2S_lat,NILUG_2S_lon,XILAN_4S_lat,XILAN_4S_lon,ELTOK_4T_lat,ELTOK_4T_lon,HMR_4T_lat,HMR_4T_lon,NILUG_2T_lat,NILUG_2T_lon,XILAN_5T_lat,XILAN_5T_lon,zero_one_L_lon,zero_one_L_lat,zero_one_R_lon,zero_one_R_lat,one_nine_L_lon,one_nine_L_lat,one_nine_R_lon,one_nine_R_lat,two_six_lon,two_six_lat,zero_eight_lon,zero_eight_lat,FAP_01L_lat,FAP_01L_lon,FAP_01R_lat,FAP_01R_lon,FAP_19R_lat,FAP_19R_lon,FAP_19L_lat,FAP_19L_lon,FAP_26_lat,FAP_26_lon,FAF_08_lat,FAF_08_lon,lat_TMA,lon_TMA)

if ((lat_end < dms2degrees([59 38 30])) && (dms2degrees([17 44 50]) < lon_end) && (lon_end < dms2degrees([17 57 50])))
    numerator = abs((zero_one_L_lon - FAP_01L_lon) * (FAP_01L_lat - lat_end(end)) - (FAP_01L_lon - lon_end(end)) * (zero_one_L_lat - FAP_01L_lat));
    denominator = sqrt((zero_one_L_lon - FAP_01L_lon) ^ 2 + (zero_one_L_lat - FAP_01L_lat) ^ 2);
    distance(1) = numerator ./ denominator;
    numerator = abs((zero_one_R_lon - FAP_01R_lon) * (FAP_01R_lat - lat_end(end)) - (FAP_01R_lon - lon_end(end)) * (zero_one_R_lat - FAP_01R_lat));
    denominator = sqrt((zero_one_R_lon - FAP_01R_lon) ^ 2 + (zero_one_R_lat - FAP_01R_lat) ^ 2);
    distance(2) = numerator ./ denominator;
    if distance(1) < distance(2)
    ELTOK_STAR_lat = ELTOK_7M_lat;
    ELTOK_STAR_lon = ELTOK_7M_lon;
    HMR_STAR_lat = HMR_5M_lat;
    HMR_STAR_lon = HMR_5M_lon;
    NILUG_STAR_lat = NILUG_2M_lat;
    NILUG_STAR_lon = NILUG_2M_lon;
    XILAN_STAR_lat = XILAN_4M_lat;
    XILAN_STAR_lon = XILAN_4M_lon;
    rwy = '01L';
    IAF_1_lat = dms2degrees([59 32 20.3]);
    IAF_1_lon = dms2degrees([017 21 30.1]);
    IAF_2_lat = dms2degrees([59 31 54.1]);
    IAF_2_lon = dms2degrees([018 12 12.0]);  
    else
    ELTOK_STAR_lat = ELTOK_7M_lat;
    ELTOK_STAR_lon = ELTOK_7M_lon;
    HMR_STAR_lat = HMR_5M_lat;
    HMR_STAR_lon = HMR_5M_lon;
    NILUG_STAR_lat = NILUG_2M_lat;
    NILUG_STAR_lon = NILUG_2M_lon;
    XILAN_STAR_lat = XILAN_4M_lat;
    XILAN_STAR_lon = XILAN_4M_lon;
    rwy = '01R';
    IAF_1_lat = dms2degrees([59 32 20.3]);
    IAF_1_lon = dms2degrees([017 21 30.1]);
    IAF_2_lat = dms2degrees([59 31 54.1]);
    IAF_2_lon = dms2degrees([018 12 12.0]);   
    end   
elseif ((lat_end > dms2degrees([59 38 30])) && (dms2degrees([17 54 00]) < lon_end) && (lon_end < dms2degrees([18 02 00])))
    numerator = abs((one_nine_L_lon - FAP_19L_lon) * (FAP_19L_lat - lat_end(end)) - (FAP_19L_lon - lon_end(end)) * (one_nine_L_lat - FAP_19L_lat));
    denominator = sqrt((one_nine_L_lon - FAP_19L_lon) ^ 2 + (one_nine_L_lat - FAP_19L_lat) ^ 2);
    distance(1) = numerator ./ denominator;
    numerator = abs((one_nine_R_lon - FAP_19R_lon) * (FAP_19R_lat - lat_end(end)) - (FAP_19R_lon - lon_end(end)) * (one_nine_R_lat - FAP_19R_lat));
    denominator = sqrt((one_nine_R_lon - FAP_19R_lon) ^ 2 + (one_nine_R_lat - FAP_19R_lat) ^ 2);
    distance(2) = numerator ./ denominator;
    if distance(1) > distance(2)
    ELTOK_STAR_lat = ELTOK_7P_lat;
    ELTOK_STAR_lon = ELTOK_7P_lon;
    HMR_STAR_lat = HMR_4P_lat;
    HMR_STAR_lon = HMR_4P_lon;
    NILUG_STAR_lat = NILUG_2P_lat;
    NILUG_STAR_lon = NILUG_2P_lon;
    XILAN_STAR_lat = XILAN_5P_lat;
    XILAN_STAR_lon = XILAN_5P_lon;
    rwy = '19R';
    IAF_1_lat = dms2degrees([59 44 45]);
    IAF_1_lon = dms2degrees([017 35 25]);
    IAF_2_lat = dms2degrees([59 53 46.5]);
    IAF_2_lon = dms2degrees([018 20 12.9]);   
    else
    ELTOK_STAR_lat = ELTOK_7P_lat;
    ELTOK_STAR_lon = ELTOK_7P_lon;
    HMR_STAR_lat = HMR_4P_lat;
    HMR_STAR_lon = HMR_4P_lon;
    NILUG_STAR_lat = NILUG_2P_lat;
    NILUG_STAR_lon = NILUG_2P_lon;
    XILAN_STAR_lat = XILAN_5P_lat;
    XILAN_STAR_lon = XILAN_5P_lon;
    rwy = '19L';
    IAF_1_lat = dms2degrees([59 44 45]);
    IAF_1_lon = dms2degrees([017 35 25]);
    IAF_2_lat = dms2degrees([59 53 46.5]);
    IAF_2_lon = dms2degrees([018 20 12.9]);  
    end   
elseif lon_TMA > dms2degrees([18 00 00])
  ELTOK_STAR_lat = ELTOK_4T_lat;
    ELTOK_STAR_lon = ELTOK_4T_lon;
    HMR_STAR_lat = HMR_4T_lat;
    HMR_STAR_lon = HMR_4T_lon;
    NILUG_STAR_lat = NILUG_2T_lat;
    NILUG_STAR_lon = NILUG_2T_lon;
    XILAN_STAR_lat = XILAN_5T_lat;
    XILAN_STAR_lon = XILAN_5T_lon;
    rwy = '26';
    IAF_1_lat = dms2degrees([59 31 54.1]);
    IAF_1_lon = dms2degrees([018 12 12.0]);
    IAF_2_lat = dms2degrees([59 53 46.5]);
    IAF_2_lon = dms2degrees([018 20 12.9]);  
elseif lon_TMA < dms2degrees([18 00 00])
    ELTOK_STAR_lat = ELTOK_7S_lat;
    ELTOK_STAR_lon = ELTOK_7S_lon;
    HMR_STAR_lat = HMR_5S_lat;
    HMR_STAR_lon = HMR_5S_lon;
    NILUG_STAR_lat = NILUG_2S_lat;
    NILUG_STAR_lon = NILUG_2S_lon;
    XILAN_STAR_lat = XILAN_4S_lat;
    XILAN_STAR_lon = XILAN_4S_lon;
    IAF_1_lat = dms2degrees([59 44 45]);
    IAF_1_lon = dms2degrees([017 35 25]);
    IAF_2_lat = dms2degrees([59 31 54.1]);
    IAF_2_lon = dms2degrees([018 12 12.0]);
    rwy = '08';
end
end

function [rwy] = find_esgg_rwy(lat_TMA,lon_TMA)
if lat_TMA > dms2degrees([57 40 00])
    rwy = '21';
else
    rwy = '03';
end
end

function [file_name] = export_data(time_in_TMA,TMA_fuel_vector,alt_in_TMA,flight_file,export_dir,csv_data_source,M_in_TMA,TAS_in_TMA,CAS_in_TMA,dh_dt_in_TMA,dtg_in_TMA,search_callsign,callsign,lat_TMA,lon_TMA,C_L_TMA,C_D_TMA,Thr_TMA,callsign_save,ac_type,airport,date,unix_time,F_burn_TMA,TMA_time_vector,unix_time_in_TMA,F_burn_time_TMA,icao_type,wtc,rwy)
global m_to_ft ms_to_kt

if length(wtc) >= 1 && length(rwy) >= 1
    file_name = [callsign_save,'_',icao_type,'_',wtc,'_',airport,'_',rwy,'_',date];
elseif length(wtc) >= 1
    file_name = [callsign_save,'_',icao_type,'_',wtc,'_',airport,'_',date];
elseif length(rwy) >= 1
    file_name = [callsign_save,'_',icao_type,'_',airport,'_',rwy,'_',date];
else
    file_name = [callsign_save,'_',icao_type,'_',airport,'_',date];
end

if max(size(dtg_in_TMA)) < max(size(time_in_TMA))
    dtg_in_TMA(end+1) = 0;
end

final_time = [zeros(max(size(time_in_TMA))-1,1)];
final_time(1:end+1,1) = unix_time(end);

F_tot = [zeros(max(size(time_in_TMA))-1,1)];
F_tot(end+1,1) = F_burn_TMA;

path = [export_dir,file_name,'.csv'];
fid = fopen( path, 'wt' );
fprintf(fid,'%.0f %.0f %.0f %.3f %.3f %.1f %.1f %.0f %.0f %.5f %.5f %.3f %.3f %.5f %.3f %.0f\n',[time_in_TMA,unix_time_in_TMA',final_time,dtg_in_TMA,M_in_TMA,TAS_in_TMA*ms_to_kt,CAS_in_TMA*ms_to_kt,alt_in_TMA*100,dh_dt_in_TMA*m_to_ft*60,lat_TMA,lon_TMA,C_L_TMA,C_D_TMA,TMA_fuel_vector,F_burn_time_TMA,Thr_TMA]');
fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%% CDO PROFILE PREDICTOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [t,cum_dist,alt,F,M,TAS,CAS,ROCD,lat_CDO,lon_CDO,F_burn_CDO,Dist_CDO,Time_CDO,wind_speed,wind_dir,flight_track,wind_comp] = CDO_profile_predictor(lat_TMA,lon_TMA,mlw_factor,ac_type,BADA_dir,dist_in_TMA,alt_in_TMA,time_at_FAP,wind_temp_on_off,latitude,longitude,T_nc,u_nc,v_nc,level,time,cruise_alt,Vd_des_1,Vd_des_2,Vd_des_3,Vd_des_4,CAS_stall,C_v_min,CAS1_descent,CAS2_descent,M_descent,file_name,export_dir_CDO,kt_per_sec_reduce,export,time_23,CAS_start,callsign_save,airport,date,unix_time,unix_time_in_TMA,icao_type,day_before,wtc,rwy,entry_point,PM_profile,IF,powered_descent,descent_angle,IAS_start_CDO,IAS_restriction_CDO,alt_start_CDO,export_wpts)


powered_CDO = powered_descent;

global beta_T_less R H_p_trop T_0 ft_to_m p_0 delta_T T_trop_ISA p_trop_ISA k g_0 a_0 kt_to_ms rho_0 ms_to_kt m_to_ft m_to_NM
ARQUS = [dms2degrees([57 05 45.0]) dms2degrees([12 55 43.1])];
RISMA = [dms2degrees([57 02 31]) dms2degrees([11 58 45])];
VADIN = [dms2degrees([57 08 16]) dms2degrees([011 38 38])];
DETNA = [dms2degrees([57 35 15.4]) dms2degrees([11 04 08.6])];
SABAK = [dms2degrees([58 10 35.6]) dms2degrees([11 38 33.8])];
MAXIV = [dms2degrees([57 57 17.2]) dms2degrees([12 10 15.7])];
KELIN = [dms2degrees([58 14 36.9]) dms2degrees([12 03 15])];
NEGIL = [dms2degrees([58 15 04.8]) dms2degrees([12 37 31.2])];
LUKAX = [dms2degrees([57 42 48.9]) dms2degrees([13 08 54.2])];
MOXAM = [dms2degrees([58 31 52.9]) dms2degrees([13 18 50.1])];
NY708 = [dms2degrees([57 28 51.85]) dms2degrees([012 06 55.41])];
JANNA = [dms2degrees([57 29 17.49]) dms2degrees([011 59 06.65])];
SW110 = [dms2degrees([57 20 46.7390]) dms2degrees([011 49 27.9031])];
SW120 = [dms2degrees([57 23 38.9424]) dms2degrees([011 43 49.7257])];
SW130 = [dms2degrees([57 27 01.7913]) dms2degrees([011 41 04.5163])];
SW140 = [dms2degrees([57 30 43.0414]) dms2degrees([011 40 46.0733])];
SW150 = [dms2degrees([57 34 12.7455]) dms2degrees([011 42 58.5413])];
SW160 = [dms2degrees([57 37 02.0864]) dms2degrees([011 47 24.3713])];
LOMAK = [dms2degrees([57 25 47]) dms2degrees([011 24 25.0])];
MARIA = [dms2degrees([57 25 49.62]) dms2degrees([012 12 23.06])];
SE210 = [dms2degrees([57 16 27.3512]) dms2degrees([012 06 02.6084])];
SE220 = [dms2degrees([57 15 51.9281]) dms2degrees([012 13 41.4419])];
SE230 = [dms2degrees([57 16 48.4724]) dms2degrees([012 20 16.9936])];
SE240 = [dms2degrees([57 18 58.3513]) dms2degrees([012 25 48.4921])];
SE250 = [dms2degrees([57 22 04.4563]) dms2degrees([012 29 30.7181])];
SE260 = [dms2degrees([57 25 41.4847]) dms2degrees([012 30 52.9506])];
SE290 = [dms2degrees([57 21 04.1801]) dms2degrees([012 28 33.3428])];
NE390 = [dms2degrees([58 01 21.53]) dms2degrees([013 07 48.13])];
JANNE = [dms2degrees([58 15 35.99]) dms2degrees([013 18 57.33])];
VARGA = [dms2degrees([58 03 11.44]) dms2degrees([012 46 27.67])];



lon_add = 0;
lat_add = 0;  
IAS_restriction = IAS_restriction_CDO;
IAS_start = IAS_start_CDO;
alt(1) = alt_start_CDO;
delay = 0;
extra_points = 4;
switch entry_point
    case 'E1'
        lat = ([NY708(1);MARIA(1);SE210(1);SE220(1);SE230(1);SE240(1);SE250(1);SE260(1);lat_TMA(1)]);
        lon = ([NY708(2);MARIA(2);SE210(2);SE220(2);SE230(2);SE240(2);SE250(2);SE260(2);lon_TMA(1)]);
        lon_condition = -5.806;
        lat_condition = 53.14;
        level_alt = 7000;
        stop_add = 5;
    case 'E2'
        lat = ([NY708(1);MARIA(1);SE210(1);SE220(1);SE230(1);57.2349;lat_TMA(1)]);
        lon = ([NY708(2);MARIA(2);SE210(2);SE220(2);SE230(2);12.3768;lon_TMA(1)]);       
        lon_condition = -5.766;
        lat_condition = 53.63;
        level_alt = 8000;
        stop_add = 3;
    case 'E3'
        lat = ([NY708(1);MARIA(1);SE210(1);lat_TMA(1)]);
        lon = ([NY708(2);MARIA(2);SE210(2);lon_TMA(1)]);       
        lon_condition = -5.806;
        lat_condition = 53.14;
        level_alt = 7000;
        stop_add = 0;
    case 'W1'
        lat = ([NY708(1);JANNA(1);SW110(1);SW120(1);SW130(1);SW140(1);SW150(1);SW160(1);lat_TMA(1)]);
        lon = ([NY708(2);JANNA(2);SW110(2);SW120(2);SW130(2);SW140(2);SW150(2);SW160(2);lon_TMA(1)]);       
        lon_condition = -5.766;
        lat_condition = 53.63;
        level_alt = 8000;
        stop_add = 5;
    case 'W2'
        % lat = ([NY708(1);JANNA(1);SW110(1);SW120(1);SW130(1);57.4395;lat_TMA(1)]);
        % lon = ([NY708(2);JANNA(2);SW110(2);SW120(2);SW130(2);11.5952;lon_TMA(1)]);    
        lat = ([NY708(1);JANNA(1);SW110(1);SW120(1);SW130(1);lat_TMA(1)]);
        lon = ([NY708(2);JANNA(2);SW110(2);SW120(2);SW130(2);lon_TMA(1)]); 
        lon_condition = -5.806;
        lat_condition = 53.14;
        level_alt = 7000;
        stop_add = 3;
    case 'W3'
        lat = ([NY708(1);JANNA(1);SW110(1);lat_TMA(1)]);
        lon = ([NY708(2);JANNA(2);SW110(2);lon_TMA(1)]);        
        lon_condition = -5.766;
        lat_condition = 53.63;
        level_alt = 8000;
        stop_add = 0;

end

% adopi_lat = lat;
% adopi_lon = lon;
if stop_add ~= 0
        for g = 1:stop_add
            if g == 1
                lon_add(1:4) = linspace(lon(g+2),lon(g+3),4);
                lat_add(1:4) = linspace(lat(g+2),lat(g+3),4);
            else
               lon_add(end+1:end+4) = linspace(lon(g+2),lon(g+3),4);
               lat_add(end+1:end+4) = linspace(lat(g+2),lat(g+3),4);
            end
           if g ~= stop_add
              lon_add(end) = [];
              lat_add(end) = [];
           end
        end
end
% geoplot(lat_add,lon_add,'go')
% drawnow
% hold on
        % lon_add(1) = [];
        % lat_add(1) = [];
%         clf

%         plot(lon_add,lat_add,'r')
%         pause
%         clf
        
%         geoplot(lat_add,lon_add,'ro')
%         hold on
%         geoplot(lat,lon,'k')
%         pause
% lat_add
% lon_add

% geoplot(lat_add,lon_add,'ro-')
% pause

if PM_profile <= 3
    lon(3) = lon_add(PM_profile);
    lat(3) = lat_add(PM_profile);
%     lon(2) = lon(1);
%     lat(2) = lat(1);
elseif PM_profile <= 6
    lon(4) = lon_add(PM_profile);
    lat(4) = lat_add(PM_profile);
    lon(3) = lon(2);
    lat(3) = lat(2);
    lon(2) = lon(1);
    lat(2) = lat(1);
    lon(1) = [];
    lat(1) = [];
elseif PM_profile <= 9
    lon(5) = lon_add(PM_profile);
    lat(5) = lat_add(PM_profile);
    lon(4) = lon(2);
    lat(4) = lat(2);
    lon(3) = lon(1);
    lat(3) = lat(1);
    lon(2) = [];
    lat(2) = [];
    lon(1) = [];
    lat(1) = [];
elseif PM_profile <= 12
    lon(6) = lon_add(PM_profile);
    lat(6) = lat_add(PM_profile);
    lon(5) = lon(2);
    lat(5) = lat(2);
    lon(4) = lon(1);
    lat(4) = lat(1);
    lon(3) = [];
    lat(3) = [];
    lon(2) = [];
    lat(2) = [];
    lon(1) = [];
    lat(1) = [];
elseif PM_profile <= 15
    lon(7) = lon_add(PM_profile);
    lat(7) = lat_add(PM_profile);
    lon(6) = lon(2);
    lat(6) = lat(2);
    lon(5) = lon(1);
    lat(5) = lat(1);
    lon(4) = [];
    lat(4) = [];
    lon(3) = [];
    lat(3) = [];
    lon(2) = [];
    lat(2) = [];
    lon(1) = [];
    lat(1) = [];
elseif PM_profile <= 18
    lon(8) = lon_add(PM_profile);
    lat(8) = lat_add(PM_profile);
    lon(7) = lon(2);
    lat(7) = lat(2);
    lon(6) = lon(1);
    lat(6) = lat(1);
    lon(5) = [];
    lat(5) = [];
    lon(4) = [];
    lat(4) = [];
    lon(3) = [];
    lat(3) = [];
    lon(2) = [];
    lat(2) = [];
    lon(1) = [];
    lat(1) = [];
elseif PM_profile == 20
    lat(3) = lat(10);
    lon(3) = lon(10);
    lat(4) = lat(11);
    lon(4) = lon(11);
    lat(5:end) = [];
    lon(5:end) = [];
    level_alt = 0;
elseif PM_profile == 21
    lat(3) = lat(9);
    lon(3) = lon(9);
    lat(4) = lat(10);
    lon(4) = lon(10);
    lat(5) = lat(11);
    lon(5) = lon(11);
    lat(6:end) = [];
    lon(6:end) = [];
    level_alt = 0;
elseif PM_profile == 22
    lat(3) = lat(8);
    lon(3) = lon(8);
    lat(4) = lat(9);
    lon(4) = lon(9);
    lat(5) = lat(10);
    lon(5) = lon(10);
    lat(6) = lat(11);
    lon(6) = lon(11);
    lat(7:end) = [];
    lon(7:end) = [];
    level_alt = 0;
end
% geoplot(lat,lon,'ro-')
% drawnow
% pause
% hold on
if strcmp(entry_point,'BELGU') == 1
%     geoplot([dms2degrees([60 53 20.00]);dms2degrees([60 26 08.40]);dms2degrees([60 16 51.69])],[dms2degrees([10 28 25.00]);dms2degrees([10 18 18.90]);dms2degrees([10 16 42.90])],'ro')
elseif strcmp(entry_point,'INREX') == 1
%     geoplot([dms2degrees([60 46 00.00]);dms2degrees([60 13 07.00]);dms2degrees([60 04 03.92])],[dms2degrees([12 08 19.00]);dms2degrees([11 58 11.00]);dms2degrees([11 51 13.55])],'ro');
end
% geoplot([lat(end-1) lat(end-2) lat(end-3)],[lon(end-1) lon(end-2) lon(end-3)],'ro')
% pause
clf
% plot(lon,lat)
% pause
% close all
% figure(20)
% geoplot(lat,lon,'ro-')
% hold on
% pause

lon_orig = lon;
lat_orig = lat;

for a = 1:(max(size(lat))-1)
    dist_lat_lon(a) = lldistkm([lat(a) lon(a)],[lat(a+1) lon(a+1)])*1000/1852;
end

add_lon = 0;
add_lat = 0;
for h = 1:(length(lat)-1)
   amount = floor(dist_lat_lon(h));
   add_lon(end:(end+(amount*6)-1)) = linspace(lon(h),lon(h+1),amount*6);
   add_lat(end:(end+(amount*6)-1)) = linspace(lat(h),lat(h+1),amount*6);
%    add_lon = add_lon(1:end-1);
%    add_lat = add_lat(1:end-1);
end
lon = add_lon;
lat = add_lat;
dist_lat_lon = [];

% figure(1)
% clf
% plot(lon,lat,'Color',[rand(1) rand(1) rand(1)])
% hold on
% plot(adopi_lon,adopi_lat,'o')
% lat 
% lon
% hold on
% pause

for i = 1:max(size(lon))-1
   dist_TMA(i) = lldistkm([lat(i) lon(i)],[lat(i+1) lon(i+1)])*1000/1852;
end
TMA_dist = sum(dist_TMA);


for a = 1:(max(size(lat))-1)
    dist_lat_lon(a) = lldistkm([lat(a) lon(a)],[lat(a+1) lon(a+1)])*1000/1852;
end

cum_dist_lat_lon = zeros(max(size(lat)),1);
cum_dist_lat_lon(2:end) =  cumsum(dist_lat_lon);

% alt_in_TMA = alt_in_TMA*100*ft_to_m;
% end_alt = alt_in_TMA(end); %
reduce_1_IAS = (C_v_min*CAS_stall(1)*ms_to_kt+Vd_des_1); %[kt]
reduce_2_IAS = (C_v_min*CAS_stall(2)*ms_to_kt+Vd_des_2); %[kt]
reduce_3_IAS = (C_v_min*CAS_stall(3)*ms_to_kt+Vd_des_3); %[kt]
reduce_4_IAS = (C_v_min*CAS_stall(4)*ms_to_kt+Vd_des_4); %[kt]
reduce_5_IAS = min(CAS1_descent,220); %[kt]
reduce_6_IAS = min(CAS1_descent,250); %[kt]
reduce_7_IAS = CAS2_descent; % [kt]
% TMA_dist = dist_in_TMA; % [NM]

alt(1) = alt(1)*ft_to_m;
cruise = 0;
i = 1;
exit_2 = 0;
exit_3 = 0;
exit_4 = 0;
exit_5 = 0;
exit_6 = 0;
exit_7 = 0;

% Read BADA xml data
[mlw,L_HV,fi,ti,d,bf,S,C_D_scalar,engine_type,C_L_max_BADA,eta_max,W_P_max,n_eng,D_P,f] = read_bada_xml_CDO(ac_type,BADA_dir,mlw_factor);

CAS = [];
dist_per_hour = 0;
lon_CDO(1) = lon(1);
lat_CDO(1) = lat(1);

for g = 1:max(size(time))
    curr_time = time{g};
    colons = find(curr_time == ':');
    time_h(g) = str2num(curr_time(colons(1)-2:colons(1)-1));
end

start_time = time_at_FAP;

outside_PMS = 0;

while sum(dist_per_hour)/3600 < TMA_dist
    
%     sum(dist_per_hour)/3600
    T_ISA(i) = calculate_T_ISA_CDO(alt(i));
    
    % Flight track (course)
    flight_track(i) = calculate_track_CDO(lon_CDO,lat_CDO,i,lon,lat);

    % Pressure and pressure ratio
    [pressure(i), pressure_ratio(i)] = calculate_pressure_CDO(alt(i),T_ISA(i));

%   Temperature and wind components from .nc file
    [T_calc(i),u_calc(i),v_calc(i)] = calculate_t_u_v_CDO(start_time,lon_CDO(i),lat_CDO(i),pressure(i),latitude,longitude,T_nc,u_nc,v_nc,level,time_h,i,wind_temp_on_off,T_ISA(i),time_23,day_before);
    
    T_ratio(i) = calculate_T_ratio_CDO(T_calc(i));
%     
% try
    % Wind speed and wind direction based on .nc file
    [wind_speed(i),wind_dir(i)] = calculate_wind_CDO(v_calc(i),u_calc(i));
% catch
%     pressure(end)
%     start_time
%     lon_CDO(end)
%     lat_CDO(end)
%     u_calc(end)
%     v_calc(end)
%     
%     wind_dir
%     pause
% end

    % Wind component (head or tail)
    wind_comp(i) = calculate_wind_component_CDO(flight_track(i),wind_dir(i),wind_temp_on_off);
 
    % Density
    [rho(i), rho_ratio(i)] = calculate_rho_CDO(pressure(i),T_calc(i));
%     alt
%     level_alt
%     lon_CDO
%     lon_condition
%     lat_CDO
%     lat_condition
%     
if i == 1
   index = 1;
else
    index = i-1;
end
% alt(index)*m_to_ft
    level_segment = 0;
    if i == 1
        CAS(i) = IAS_start*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
    elseif (strcmp(entry_point,'W1') == 1 && lat_CDO(index) <= SW160(1))
        % disp('1')

            if CAS(i-1)*ms_to_kt < 220
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = IAS_restriction*kt_to_ms;
            end

        % CAS(i) = IAS_restriction*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
    elseif (strcmp(entry_point,'E1') == 1 && lat_CDO(index) <= SE260(1))
        % disp('1E')

            if CAS(i-1)*ms_to_kt < 220
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = IAS_restriction*kt_to_ms;
            end

        % CAS(i) = IAS_restriction*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));

    elseif (strcmp(entry_point,'W2') == 1 && outside_PMS == 0)
        % disp('1E')
        if lon_CDO(index) <= 11.6882
            outside_PMS = 1;
            % pause
        end

            if CAS(i-1)*ms_to_kt < 220
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = IAS_restriction*kt_to_ms;
            end

        % CAS(i) = IAS_restriction*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));

    elseif (strcmp(entry_point,'E2') == 1 && outside_PMS == 0)
        % disp('1E')
        if lon_CDO(index) >= 12.3303
            outside_PMS = 1;
            % pause
        end

            if CAS(i-1)*ms_to_kt < 220
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = IAS_restriction*kt_to_ms;
            end

        % CAS(i) = IAS_restriction*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));

    elseif (strcmp(entry_point,'E3') == 1 && outside_PMS == 0)
        % disp('1E')
        if lat_CDO(index) <= 57.2782
            outside_PMS = 1;
            % pause
        end

            if CAS(i-1)*ms_to_kt < 220
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = IAS_restriction*kt_to_ms;
            end

        % CAS(i) = IAS_restriction*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
    elseif (strcmp(entry_point,'W3') == 1 && outside_PMS == 0)
        % disp('1E')
        if lat_CDO(index) <= 57.35
            outside_PMS = 1;
            % pause
        end

            if CAS(i-1)*ms_to_kt < 220
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = IAS_restriction*kt_to_ms;
            end

        % CAS(i) = IAS_restriction*kt_to_ms;
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
    % elseif (((ceil((alt(index)*m_to_ft)/100)*100) >= level_alt) && (lat_CDO(index) < lat_condition) && (strcmp(entry_point,'ESEBA') == 0) && ((level_alt == 10000) || (level_alt == 9000))) % EIDW level_alt = 7000
        % level_segment = 1;
        % CAS(i) = IAS_restriction*kt_to_ms;
        % TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        % GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        % M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
    % elseif (((ceil((alt(index)*m_to_ft)/100)*100) >= level_alt) && (lat_CDO(index) > lat_condition) && (level_alt == 11000))  % EIDW level_alt = 8000
        % level_segment = 1;
        % CAS(i) = IAS_restriction*kt_to_ms;
        % TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        % GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        % M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
    elseif cruise == 1
        % disp('2')
         if M(i-1) == M_descent
            M(i) = M(i-1);
            TAS(i) = calculate_TAS_from_M_CDO(M(i),T_calc(i));
            GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
            CAS(i) = calculate_CAS_from_TAS_CDO(pressure(i),rho(i),TAS(i));
         else
            CAS(i) = CAS(i-1);
            TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
            GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
            M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
         end      
    elseif alt(i) < 1000*ft_to_m
        % disp('3')
        CAS(i) = min(CAS_start,reduce_1_IAS*kt_to_ms);
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif alt(i) < 1500*ft_to_m
        % disp('4')
        if i > 1 && exit_2 == 0
            if CAS(i-1)*ms_to_kt < reduce_2_IAS
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = min(CAS_start,reduce_2_IAS*kt_to_ms);
                exit_2 = 1;
            end
        else
              CAS(i) = min(CAS_start,reduce_2_IAS*kt_to_ms);
        end
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif alt(i) < 2000*ft_to_m
        % disp('5')
        if i > 1 && exit_3 == 0
            if CAS(i-1)*ms_to_kt < reduce_3_IAS
                  CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                  CAS(i) = min(CAS_start,reduce_3_IAS*kt_to_ms);
                exit_3 = 1;
            end
        else
            CAS(i) = min(CAS_start,reduce_3_IAS*kt_to_ms);
        end
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif alt(i) < 3000*ft_to_m
        % disp('6')
        if i > 1 && exit_4 == 0
            if CAS(i-1)*ms_to_kt < reduce_4_IAS
                CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                CAS(i) = min(CAS_start,reduce_4_IAS*kt_to_ms);
                exit_4 = 1;
            end
        else
            CAS(i) = min(CAS_start,reduce_4_IAS*kt_to_ms);
        end
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif alt(i) < 6000*ft_to_m
        % disp('7')
        if i > 1 && exit_5 == 0
            if CAS(i-1)*ms_to_kt < reduce_5_IAS
                CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                CAS(i) = min(CAS_start,reduce_5_IAS*kt_to_ms);
                exit_5 = 1;
            end
        else
            CAS(i) = min(CAS_start,reduce_5_IAS*kt_to_ms);
        end
        
        % if ((CAS(i)*ms_to_kt > IAS_restriction) && (alt(i-1)*m_to_ft <= level_alt))
            % CAS(i) = IAS_restriction*kt_to_ms;
        % end
        
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif alt(i) < 10000*ft_to_m
        % disp('8')
        if i > 1 && exit_6 == 0
            if CAS(i-1)*ms_to_kt < reduce_6_IAS
                CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                CAS(i) = min(CAS_start,reduce_6_IAS*kt_to_ms);
                exit_6 = 1;
            end
        else
            CAS(i) = min(CAS_start,reduce_6_IAS*kt_to_ms);
        end
        
        % if ((CAS(i)*ms_to_kt > IAS_restriction) && (alt(i-1)*m_to_ft <= level_alt))
            % CAS(i) = IAS_restriction*kt_to_ms;
        % end

        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif ((alt(i) < 11000*ft_to_m) && ((strcmp(entry_point,'RIPAM')) || (strcmp(entry_point,'LUNIP'))))
        % disp('9')
        if i > 1 && exit_6 == 0
            if CAS(i-1)*ms_to_kt < reduce_6_IAS
                CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                CAS(i) = min(CAS_start,reduce_6_IAS*kt_to_ms);
                exit_6 = 1;
            end
        else
            CAS(i) = min(CAS_start,reduce_6_IAS*kt_to_ms);
        end
        
        % if ((CAS(i)*ms_to_kt > IAS_restriction) && (alt(i-1)*m_to_ft <= level_alt))
            % CAS(i) = IAS_restriction*kt_to_ms;
        % end

        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
    elseif M(i-1) < M_descent
        % disp('10')
         if i > 1 && exit_7 == 0
            if CAS(i-1)*ms_to_kt < reduce_7_IAS
                CAS(i) = min(CAS_start + kt_per_sec_reduce*kt_to_ms,CAS(i-1) + kt_per_sec_reduce*kt_to_ms);
            else
                CAS(i) = min(CAS_start,reduce_7_IAS*kt_to_ms);
                exit_7 = 1;
            end
         else
            CAS(i) = min(CAS_start,reduce_7_IAS*kt_to_ms);
        end
        TAS(i) = calculate_TAS_from_CAS_CDO(CAS(i),pressure(i),rho(i));
        M(i) = calculate_M_from_TAS_CDO(TAS(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        
    elseif M(i-1) >= M_descent
        % disp('11')
        M(i) = M_descent;
        TAS(i) = calculate_TAS_from_M_CDO(M(i),T_calc(i));
        GS(i) = calculate_GS_from_TAS_CDO(TAS(i),wind_comp(i),wind_speed(i));
        CAS(i) = calculate_CAS_from_TAS_CDO(pressure(i),rho(i),TAS(i));
    end 

    if alt(i) >= level_alt/3.2808
        powered_CDO = 0;
    end
    


    % Propeller efficiency
    if strcmp(engine_type,'TURBOPROP')
        eta = calculate_eta_CDO(eta_max,W_P_max,n_eng,rho_ratio,D_P,TAS);
    end
    
    % Speed of sound
    sound_speed(i) = calculate_sound_speed_CDO(T_calc(i));
    
    %C_L max
    C_L_max(i) = calculate_C_L_max_CDO(M(i),bf,C_L_max_BADA);
    
    % Lift coefficient (C_L)
    C_L(i) = calculate_C_L_CDO(mlw,pressure_ratio(i),S,M(i),C_L_max(i)); 
    
    % Drag coefficient
    C_D(i) = calculate_C_D_CDO(M(i),C_L(i),d,C_D_scalar);

    % Drag
    D(i) = calculuate_drag_CDO(pressure_ratio(i),S,M(i),C_D(i));
    if powered_CDO == 1
        if max(size(TAS)) == 1
            dv_dt(1) = 0;
        else
            dv_dt(i) = -(TAS(i) - TAS(i-1));
        end
        ROCD_powered(i) = -(tand(descent_angle)*GS(i));
        Thr_idle(i) = ((mlw*g_0*ROCD_powered(i) + mlw*TAS(i)*dv_dt(i))/TAS(i)) + D(i);
        C_T_idle(i) = calculate_C_T_idle_CDO(pressure_ratio(i),M(i),ti,engine_type,T_ratio(i));
        Thr_idle_compare = calculate_Thr_idle_CDO(pressure_ratio(i),mlw,C_T_idle(i));

        if Thr_idle(i) < Thr_idle_compare
            Thr_idle(i) = Thr_idle_compare;
        end 

        if i == 3
            F(1) = F(2);
        end

        C_T(i) = calculate_C_T_CDO(Thr_idle(i),pressure_ratio(i),mlw);
        
        if strcmp(engine_type,'TURBOPROP')
            C_P(i) = calculate_C_P_CDO(M(i),C_T(i));
        else
 
            C_P(i) = 0;
        end
        
        C_F(i) = calculate_C_F_CDO(C_T(i),C_P(i),M(i),f,engine_type);
        C_F_idle = calculate_CF_idle_CDO(fi,pressure_ratio(i),M(i),T_ratio(i),engine_type);

        if C_F(i) < C_F_idle
            C_F(i) = C_F_idle;
        end

    elseif level_segment == 1
        % C_T cruise
        C_T(i) = calculate_C_T_CDO(D(i),pressure_ratio(i),mlw); 
        
        % Cruise thrust
        Thr_idle(i) = D(i);
        
        if strcmp(engine_type,'TURBOPROP')
            C_P(i) = calculate_C_P_CDO(M(i),C_T(i));
        else
 
            C_P(i) = 0;
        end
        
        C_F(i) = calculate_C_F_CDO(C_T(i),C_P(i),M(i),f,engine_type);
    elseif cruise == 0
        %C_T Idle
        C_T_idle(i) = calculate_C_T_idle_CDO(pressure_ratio(i),M(i),ti,engine_type,T_ratio(i));
    
        % Thrust idle
        Thr_idle(i) = calculate_Thr_idle_CDO(pressure_ratio(i),mlw,C_T_idle(i));
        
        C_F(i) = calculate_CF_idle_CDO(fi,pressure_ratio(i),M(i),T_ratio(i),engine_type);
    elseif cruise == 1
        % C_T cruise
        C_T(i) = calculate_C_T_CDO(D(i),pressure_ratio(i),mlw); 
        
        % Cruise thrust
        Thr_idle(i) = D(i);
        
        if strcmp(engine_type,'TURBOPROP')
            C_P(i) = calculate_C_P_CDO(M(i),C_T(i));
        else
 
            C_P(i) = 0;
        end
        
        C_F(i) = calculate_C_F_CDO(C_T(i),C_P(i),M(i),f,engine_type);
    end
    
    F(i) = calculate_fuel_flow_CDO(pressure_ratio(i),T_ratio(i),mlw,L_HV,C_F(i));
    
    dist_per_hour(i) = GS(i)*ms_to_kt;

    if M(i) == M_descent
        f_m(i) = (1 + ((k*R*beta_T_less)/(2*g_0))*M(i)^2)^-1;
    else
        f_m(i) = (1 + ((k*R*beta_T_less)/(2*g_0))*M(i)^2 + ((1 + (((k-1)/2))*M(i)^2)^(-1/(k-1)))*((1 + ((k-1)/2)*M(i)^2)^(k/(k-1))-1))^-1;
    end
    
    if powered_CDO == 1     
        ROCD(i) = ROCD_powered(i);
        alt(i+1) = alt(i) - ROCD(i);
    elseif level_segment == 1
        ROCD(i) = 0;
        alt(i+1) = level_alt*ft_to_m;
    elseif cruise == 0
        ROCD(i) = (((Thr_idle(i)-D(i))*TAS(i))/(mlw*g_0))*f_m(i);
        alt(i+1) = alt(i) - ROCD(i);
        if alt(i+1) >= cruise_alt*100*ft_to_m
            alt(i+1) = cruise_alt*100*ft_to_m;
            cruise = 1;
        end
    elseif cruise == 1
        ROCD(i) = 0;
        alt(i+1) = cruise_alt*100*ft_to_m;
    end
    
    cum_dist = cumsum(dist_per_hour/3600);

    i = i + 1; % Counter

     lat_CDO(i) = interp1(cum_dist_lat_lon,lat,cum_dist(end),'linear','extrap');
     lon_CDO(i) = interp1(cum_dist_lat_lon,lon,cum_dist(end),'linear','extrap');
     
end

unix_time_in_TMA_CDO(1) = unix_time_in_TMA(1);
for h = 1:(i-2)
    unix_time_in_TMA_CDO(h+1,1) = unix_time_in_TMA_CDO(1) + h;
end

lon_CDO = flip(lon_CDO(1:end-1));
lat_CDO = flip(lat_CDO(1:end-1));

cum_dist = flip(cumsum(dist_per_hour/3600));

TAS = flip(TAS);
CAS = flip(CAS);
GS = flip(GS);
M = flip(M);
F = flip(F);
ROCD = flip(ROCD);
alt = flip(alt(1:end-1));
C_L = flip(C_L);
C_D = flip(C_D);
Thr_idle = flip(Thr_idle);
wind_comp = flip(wind_comp);
flight_track = flip(flight_track);
wind_dir = flip(wind_dir);
wind_speed = flip(wind_speed);

t = 0:i-2;

F_burn_CDO = trapz(t,F);

for i = 2:max(size(t))
    F_burn_time_TMA_CDO(i,1) = trapz(t(1:i),F(1:i));
end
F_burn_time_TMA_CDO(1) = 0;

Dist_CDO = trapz(t,GS*ms_to_kt/3600);
Time_CDO = i/60;

if export == 1
    export_data_CDO(t,cum_dist,alt,F,M,TAS,CAS,ROCD,lat_CDO,lon_CDO,export_dir_CDO,C_L,C_D,Thr_idle,callsign_save,ac_type,airport,date,unix_time,F_burn_CDO,unix_time_in_TMA_CDO,F_burn_time_TMA_CDO,icao_type,wtc,rwy,PM_profile,lon_orig,lat_orig,delay,IF,GS,export_wpts)
end
end

%%% Functions %%%
function [mlw,L_HV,fi,ti,d,bf,S,C_D_scalar,engine_type,C_L_max_BADA,eta_max,W_P_max,n_eng,D_P,f] = read_bada_xml_CDO(ac_type,bada_dir,mlw_factor)
bada_path = [bada_dir,ac_type,'\',(ac_type),'.xml'];
bada_file = xml2struct(bada_path);

% engine_type = char(struct2cell(bada_file.bada40_colon_ACM.type));
mlw = (str2double(struct2cell(bada_file.bada40_colon_ACM.ALM.DLM.MLW)))*mlw_factor;
L_HV = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.LHV));
% ac_type = char(struct2cell(bada_file.bada40_colon_ACM.type));
% C_L_max_BADA = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.BLM.CL_max));
d = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.DPM_clean.CD_clean.d)),15,1));

try
    bf = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.BLM_clean.CL_clean.bf)),5,1));
    C_L_max_BADA = [];
catch
    bf = []; 
    C_L_max_BADA = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.BLM.CL_max));
end

S = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.S));
C_D_scalar = str2double(struct2cell(bada_file.bada40_colon_ACM.AFCM.Configuration{1}.LGUP.DPM_clean.scalar));
engine_type = char(struct2cell(bada_file.bada40_colon_ACM.type));

if strcmp(engine_type,'JET')
    fi = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.LIDL.CF.fi)),9,1));
    ti = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.LIDL.CT.ti)),12,1));
    eta_max =[];
    W_P_max = [];
    n_eng = [];
    D_P = [];
    f = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TFM.CF.f)),25,1));
elseif strcmp(engine_type,'TURBOPROP')
    fi = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.LIDL.CF.fi)),14,1));
    ti = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.LIDL.CT.ti)),32,1));
    eta_max = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TPM.max_eff));
    W_P_max = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TPM.MCMB.max_power));
    n_eng = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.n_eng)); 
    D_P = str2double(struct2cell(bada_file.bada40_colon_ACM.PFM.TPM.prop_dia));
    f = str2double(reshape(struct2cell(cell2mat(bada_file.bada40_colon_ACM.PFM.TPM.CF.f)),25,1));
end
end

function [pressure, pressure_ratio] = calculate_pressure_CDO(alt,T_ISA)

global g_0 beta_T_less R H_p_trop T_0 p_0 delta_T p_trop_ISA

if alt < H_p_trop
    pressure = p_0*((T_ISA - delta_T)/T_0)^-(g_0/(beta_T_less*R));
else
   pressure = p_trop_ISA*exp(-(g_0/(R*(T_0+beta_T_less*H_p_trop)))*((alt)-H_p_trop));
end
pressure_ratio = pressure./p_0;
end

function flight_track = calculate_track_CDO(lon_CDO,lat_CDO,i,lon,lat)
if max(size(lon_CDO)) == 1
        d_lon = lon(1)-lon(2);
        d_lat = lat(1)-lat(2);
else
    d_lon = lon_CDO(i-1)-lon_CDO(i);
    d_lat = lat_CDO(i-1)-lat_CDO(i);
end

for i = 1:max(size(d_lon))
    if d_lon(i) >= 0 && d_lat(i) >= 0
        flight_track(i) = atand(d_lon(i)./d_lat(i));
    elseif d_lon(i) < 0 && d_lat(i) < 0
        flight_track(i) = abs(atand(d_lon(i)./d_lat(i))) + 180;
    elseif d_lon(i) >= 0 && d_lat(i) < 0
        flight_track(i) = abs(atand(d_lat(i)./d_lon(i))) + 90;
    elseif d_lon(i) < 0 && d_lat(i) >= 0
        flight_track(i) = abs(atand(d_lat(i)./d_lon(i))) + 270;
    end
end

flight_track = reshape(flight_track,i,1);

% flight_track = smoothdata(flight_track,'rlowess',1);


end

function [T_calc,u_calc,v_calc] = calculate_t_u_v_CDO(start_time,lon_CDO,lat_CDO,pressure,latitude,longitude,T_nc,u_nc,v_nc,level,time_h,i,wind_temp_on_off,T_ISA,time_23,day_before)
if wind_temp_on_off == 1
    
    if time_23 == 1
        if day_before == 0
            start_time = 23;
        else
            start_time = 0;
        end
    else
        start_time = start_time-(i/3600);
    end

    [nd_1,nd_2,nd_3,nd_4] = ndgrid(longitude,latitude,level,time_h);
%     longitude
%     latitude
%     start_time
%     lon_CDO
%     lat_CDO
%     pressure
% %     pause
    T_calc = interpn(nd_1,nd_2,nd_3,nd_4,T_nc,lon_CDO,lat_CDO,pressure/100,start_time);
    u_calc = interpn(nd_1,nd_2,nd_3,nd_4,u_nc,lon_CDO,lat_CDO,pressure/100,start_time);
    v_calc = interpn(nd_1,nd_2,nd_3,nd_4,v_nc,lon_CDO,lat_CDO,pressure/100,start_time);
    % pause

    T_calc = fillmissing(T_calc,'linear','EndValues','extrap');
    v_calc = fillmissing(v_calc,'linear','EndValues','extrap');
    u_calc = fillmissing(u_calc,'linear','EndValues','extrap');

else    
    T_calc = T_ISA;
    u_calc = 0;
    v_calc = 0;
end
end

function [wind_speed,wind_dir] = calculate_wind_CDO(v_calc,u_calc)
wind_speed = sqrt(v_calc.^2 + u_calc.^2);

theta = acosd(u_calc./wind_speed);

for i = 1:max(size(u_calc))
    if (u_calc(i) > 0 && v_calc(i) > 0) || (u_calc(i) < 0 && v_calc(i) > 0)
        wind_dir(i,1) = 270 - theta(i);
    elseif u_calc(i) < 0 && v_calc(i) < 0
        wind_dir(i,1) = theta(i) - 90;
    elseif u_calc(i) > 0 && v_calc(i) < 0
        wind_dir(i,1) = 270 + theta(i);
    elseif u_calc(i) == 0 && v_calc(i) == 0
        wind_dir(i,1) = 0;
    elseif u_calc(i) > 0 && v_calc(i) == 0
        wind_dir(i,1) = 270;
    elseif u_calc(i) < 0 && v_calc(i) == 0
        wind_dir(i,1) = 90;
    elseif u_calc(i) == 0 && v_calc(i) > 0
        wind_dir(i,1) = 180;
    elseif u_calc(i,1) == 0 && v_calc(i) < 0
        wind_dir(i,1) = 0;
    end
end
end

function wind_comp = calculate_wind_component_CDO(flight_track,wind_dir,wind_temp_on_off)
if wind_temp_on_off == 0
    wind_comp = 0;
else
    if flight_track >= wind_dir
        difference = flight_track - wind_dir;
        if difference >= 0 && difference <=90
            wind_comp = -(1 - difference/90);
        elseif difference > 90 && difference <=180
            difference = difference - 90;
            wind_comp = difference/90;
        elseif difference > 180 && difference <=270
            difference = difference - 180;
            wind_comp = 1 - difference/90;
        elseif difference > 270 && difference <=359.999999999999
            difference = difference - 270;
            wind_comp = -difference/90;
        end
    elseif flight_track < wind_dir
        difference = wind_dir - flight_track;
        if difference >= 0 && difference <=90
            wind_comp = -(1 - difference/90);
        elseif difference > 90 && difference <=180
            difference = difference - 90;
            wind_comp = difference/90;
        elseif difference > 180 && difference <=270
            difference = difference - 180;
            wind_comp = 1 - difference/90;
        elseif difference > 270 && difference <=359.999999999999
            difference = difference - 270;
            wind_comp = -difference/90;
        end
    end
end
end

function GS = calculate_GS_from_TAS_CDO(TAS,wind_comp,wind_speed)
GS = TAS + wind_comp.*wind_speed;
end

function T_ratio = calculate_T_ratio_CDO(T_calc)
global T_0 delta_T
T_ratio = T_calc./(T_0 + delta_T);
end

function T_ISA = calculate_T_ISA_CDO(alt)
global T_0 beta_T_less H_p_trop delta_T T_trop_ISA

if alt < H_p_trop
    T_ISA = T_0 + delta_T + beta_T_less*alt;
else
    T_ISA = T_trop_ISA;
end
end

function [rho, rho_ratio] = calculate_rho_CDO(pressure,T_ISA)
global R rho_0
rho = pressure./(R.*T_ISA);
rho_ratio = rho./rho_0;
end

function TAS = calculate_TAS_from_M_CDO(M_descent,T_ISA)
global k R
TAS = M_descent*sqrt(k*R*T_ISA);
end

function eta = calculate_eta_CDO(eta_max,W_P_max,n_eng,rho_ratio,D_P,TAS)
global rho_0
a_eta = ones(size(TAS));
b_eta = zeros(size(TAS));
c_eta = (n_eng/W_P_max).*rho_ratio.*rho_0.*(D_P.^2).*(pi/2).*(TAS.^3).*eta_max;
d_eta = -((n_eng/W_P_max).*rho_ratio.*rho_0.*(D_P.^2).*(pi/2).*(TAS.^3).*eta_max^2);

for i = 1:max(size(TAS))
    eta_roots{i} = roots([a_eta(i) b_eta(i) c_eta(i) d_eta(i)]);
    eta(i,:) = eta_roots{i}(3);
end
end

function C_L_max = calculate_C_L_max_CDO(M,bf,C_L_max_BADA)
if isempty(bf)
    C_L_max = C_L_max_BADA;
else
    C_L_max = bf(1) + bf(2).*M + bf(3).*M.^2 + bf(4).*M.^3 + bf(5).*M.^4;
end
end

function C_L = calculate_C_L_CDO(mlw,pressure_ratio,S,M,C_L_max) 
global k g_0 p_0
C_L = (2*mlw*g_0)./(pressure_ratio*p_0*k*S.*M.^2);

for i = 1:max(size(C_L))
   if C_L(i) > C_L_max(i)
       C_L(i) = C_L_max(i);
   end
end
end

function C_D = calculate_C_D_CDO(M,C_L,d,C_D_scalar)
C_0 = d(1) + d(2)./((1-M.^2).^(1/2)) + d(3)./(1-M.^2) + d(4)./((1-M.^2).^(3/2)) + d(5)./((1-M.^2).^2);
C_2 = d(6) + d(7)./((1-M.^2).^(3/2)) + d(8)./((1-M.^2).^3) + d(9)./((1-M.^2).^(9/2)) + d(10)./((1-M.^2).^6);
C_6 = d(11) + d(12)./((1-M.^2).^7) + d(13)./((1-M.^2).^(15/2)) + d(14)./((1-M.^2).^8) + d(15)./((1-M.^2).^(17/2));
C_D = C_D_scalar *(C_0 + (C_2.*C_L.^2) + (C_6.*C_L.^6));
end

function D = calculuate_drag_CDO(pressure_ratio,S,M,C_D)
global p_0 k
D = (1/2).*pressure_ratio.*p_0*k*S.*(M.^2).*C_D;
end

function C_T_idle = calculate_C_T_idle_CDO(pressure_ratio,M,ti,engine_type,T_calc_ratio)
if strcmp(engine_type,'JET')
    C_T_idle = ti(1)*pressure_ratio.^-1 + ti(2) + ti(3).*pressure_ratio + ti(4).*pressure_ratio.^2 ...
        + (ti(5).*pressure_ratio.^-1 + ti(6) + ti(7)*pressure_ratio + ti(8)*pressure_ratio.^2).*M ...
        + (ti(9).*pressure_ratio.^-1 + ti(10) + ti(11).*pressure_ratio + ti(12).*pressure_ratio.^2).*M.^2;
elseif strcmp(engine_type,'TURBOPROP')
    C_T_idle = ti(1)*pressure_ratio.^-1 + ti(2) + ti(3).*pressure_ratio + ti(4).*pressure_ratio.^2 ...
       + (ti(5).*pressure_ratio.^-1 + ti(6) + ti(7)*pressure_ratio + ti(8)*pressure_ratio.^2).*M ...
       + (ti(9).*pressure_ratio.^-1 + ti(10) + ti(11).*pressure_ratio + ti(12).*pressure_ratio.^2).*M.^2 ...
       + ti(13).*T_calc_ratio.^(1/2) + ti(14).*T_calc_ratio + ti(15).*T_calc_ratio.^(-1/2) + ti(16).*T_calc_ratio.^2 ...
       + (ti(17).*pressure_ratio.^(-1) + ti(18).*pressure_ratio + ti(19).*pressure_ratio.^2 + ti(20).*M + ti(21).*M.^2).*T_calc_ratio.^(-1/2)...
       + ti(22).*M.^(-1) + ti(23).*M.^(-1).*pressure_ratio + ti(24).*M.^3 ...
       + (ti(25).*M + ti(26).*M.^2 + ti(27) + ti(28).*M.*(pressure_ratio.^(-1))).*T_calc_ratio.^(-1)...
       + ti(29).*M.*pressure_ratio.^(-1).*T_calc_ratio.^(-2) + ti(30).*(M.^2).*(pressure_ratio.^(-1)).*(T_calc_ratio.^(-2)) + ti(31).*(M.^2).*(pressure_ratio.^(-1)).*(T_calc_ratio.^(-1/2)) + ti(32).*pressure_ratio.*(T_calc_ratio.^(-1));  
end
end

function Thr_idle = calculate_Thr_idle_CDO(pressure_ratio,m,C_T_idle)
global g_0
Thr_idle = pressure_ratio*m*g_0.*C_T_idle;
end

function C_T = calculate_C_T_CDO(Thr,pressure_ratio,m)
global g_0
C_T = Thr./(pressure_ratio.*m*g_0);
end

function C_P = calculate_C_P_CDO(M,C_T)
C_P = C_T.*M;
end

function C_F = calculate_C_F_CDO(C_T,C_P,M,f,engine_type)

if strcmp(engine_type,'JET')
    C_F = f(1) + f(2).*C_T + f(3).*C_T.^2 + f(4).*C_T.^3 + f(5).*C_T.^4 ...
    +  (f(6) + f(7).*C_T + f(8).*C_T.^2 + f(9).*C_T.^3 + f(10).*C_T.^4).*M ...
    + (f(11) + f(12).*C_T + f(13).*C_T.^2 + f(14).*C_T.^3 + f(15).*C_T.^4).*M.^2 ...
    + (f(16) + f(17).*C_T + f(18).*C_T.^2 + f(19).*C_T.^3 + f(20).*C_T.^4).*M.^3 ...
    + (f(21) + f(22).*C_T + f(23).*C_T.^2 + f(24).*C_T.^3 + f(25).*C_T.^4).*M.^4;

elseif strcmp(engine_type,'TURBOPROP')
    C_F = f(1) + f(2).*C_P + f(3).*C_P.^2 + f(4).*C_P.^3 + f(5).*C_P.^4 ...
    +  (f(6) + f(7).*C_P + f(8).*C_P.^2 + f(9).*C_P.^3 + f(10).*C_P.^4).*M ...
    + (f(11) + f(12).*C_P + f(13).*C_P.^2 + f(14).*C_P.^3 + f(15).*C_P.^4).*M.^2 ...
    + (f(16) + f(17).*C_P + f(18).*C_P.^2 + f(19).*C_P.^3 + f(20).*C_P.^4).*M.^3 ...
    + (f(21) + f(22).*C_P + f(23).*C_P.^2 + f(24).*C_P.^3 + f(25).*C_P.^4).*M.^4; 
end
end

function TAS = calculate_TAS_from_CAS_CDO(CAS,pressure,rho)
global p_0 rho_0 k
u = (k-1)/k;
TAS = (((2/u)*(pressure/rho))*((1+(p_0/pressure)*((1+u/2*rho_0/p_0*CAS^2)^(1/u)-1))^u-1))^0.5;
end

function M = calculate_M_from_TAS_CDO(TAS,T_ISA)
global k R
sound_speed = sqrt(k*R*T_ISA);
M = TAS./sound_speed;
end

function CAS = calculate_CAS_from_TAS_CDO(pressure,rho,TAS)
global p_0 rho_0 k
u = (k-1)/k;
CAS = (((2/u).*(p_0/rho_0)).*((1+(pressure./p_0).*((1+u/2.*rho./pressure.*TAS.^2).^(1/u)-1)).^u-1)).^0.5;
end

function CF_idle = calculate_CF_idle_CDO(fi,pressure_ratio,M,T_ratio,engine_type)
if strcmp(engine_type,'JET')
    CF_idle = ((fi(1) + fi(2).*pressure_ratio + fi(3).*pressure_ratio.^2) + (fi(4) + fi(5).*pressure_ratio + fi(6).*pressure_ratio.^2).*M + (fi(7) + fi(8).*pressure_ratio + fi(9).*pressure_ratio.^2).*M.^2).*(1./pressure_ratio).*T_ratio.^(-0.5);
elseif strcmp(engine_type,'TURBOPROP')
    CF_idle = ((fi(1) + fi(2).*pressure_ratio + fi(3).*pressure_ratio.^2) + ...
        (fi(4) + fi(5).*pressure_ratio + fi(6).*pressure_ratio.^2).*M + ...
        (fi(7) + fi(8).*pressure_ratio + fi(9).*pressure_ratio.^2).*M.^2 + ...
        fi(10).*T_ratio + fi(11).*T_ratio.^2 + fi(12).*M.*T_ratio + fi(13).*M.*pressure_ratio.*(T_ratio.^(1/2)) + fi(14).*M.*pressure_ratio.*T_ratio).*pressure_ratio.^(-1).*T_ratio.^(-1/2);
end
end

function sound_speed = calculate_sound_speed_CDO(T_ISA)
global k R
sound_speed = sqrt(k*R*T_ISA);
end

function F = calculate_fuel_flow_CDO(pressure_ratio,T_ratio,mlw,L_HV,CF_idle)
global g_0 a_0
F = pressure_ratio.*T_ratio.^(1/2).*mlw.*g_0.*a_0.*(1/L_HV).*CF_idle;
end

function export_data_CDO(t,cum_dist,alt,F,M,TAS,CAS,ROCD,lat_CDO,lon_CDO,export_dir_CDO,C_L,C_D,Thr_idle,callsign_save,ac_type,airport,date,unix_time,F_burn_CDO,unix_time_in_TMA_CDO,F_burn_time_TMA_CDO,icao_type,wtc,rwy,PM_profile,lon_orig,lat_orig,delay,IF,GS,export_wpts)
global ms_to_kt m_to_ft

% file_name = [callsign_save,'_',icao_type,'_',wtc,'_',airport,'_',rwy,'_',date];

if length(wtc) >= 1 && length(rwy) >= 1
    file_name = [callsign_save,'_',icao_type,'_',wtc,'_',airport,'_',rwy,'_',date];
elseif length(wtc) >= 1
    file_name = [callsign_save,'_',icao_type,'_',wtc,'_',airport,'_',date];
elseif length(rwy) >= 1
    file_name = [callsign_save,'_',icao_type,'_',airport,'_',rwy,'_',date];
else
    file_name = [callsign_save,'_',icao_type,'_',airport,'_',date];
end

lat_lon_PMS = [lat_orig,lon_orig];
lat_lon_CDO = [lat_CDO',lon_CDO'];

for h = 1:max(size(lat_lon_PMS))
    PMS_index(h) = dsearchn(lat_lon_CDO,lat_lon_PMS(h,:));
end
% PMS_index
% geoplot(lat_CDO(PMS_index),lon_CDO(PMS_index),'ro')
% pause

% PMS_index = PMS_index';


final_time = [zeros(max(size(t))-1,1)];
final_time(1:end+1,1) = unix_time(end);

cum_dist(end) = 0;
t = flip(t);

if export_wpts == 1
    PMS_index = flip(PMS_index');
    t = t(PMS_index);
    unix_time_in_TMA_CDO = unix_time_in_TMA_CDO(PMS_index);
    final_time = final_time(PMS_index);
    cum_dist = cum_dist(PMS_index);
    M = M(PMS_index);
    TAS = TAS(PMS_index);
    CAS = CAS(PMS_index);
    alt = alt(PMS_index);
    ROCD = ROCD(PMS_index);
    lat_CDO = lat_CDO(PMS_index);
    lon_CDO = lon_CDO(PMS_index);
    C_L = C_L(PMS_index);
    C_D = C_D(PMS_index);
    F = F(PMS_index);
    F_burn_time_TMA_CDO = F_burn_time_TMA_CDO(PMS_index);
    Thr_idle = Thr_idle(PMS_index);
    GS = GS(PMS_index);
end

unix_time_in_TMA_CDO = unix_time_in_TMA_CDO + delay;

path = [export_dir_CDO,file_name,'_CDO_',num2str(PM_profile),'_',IF,'.csv'];
fid = fopen( path, 'wt' );
% fprintf(fid,'%.0f %.0f %.1f %.1f %.2f %.2f\n',[t_export(:),alt_export(:)*3.2808,TAS_export(:)*ms_to_kt,CAS_export(:)*ms_to_kt,M_export(:),F_burn_export(:)]');
fprintf(fid,'%.0f %.0f %.0f %.3f %.3f %.1f %.1f %.0f %.0f %.5f %.5f %.3f %.3f %.5f %.3f %.0f %.1f\n',[t(:),unix_time_in_TMA_CDO(:),final_time(:),cum_dist(:),M(:),TAS(:)*ms_to_kt,CAS(:)*ms_to_kt,alt(:)*3.2808,ROCD(:)*m_to_ft*60,lat_CDO(:),lon_CDO(:),C_L(:),C_D(:),F(:),F_burn_time_TMA_CDO(:),Thr_idle(:),GS(:)*ms_to_kt]');
% fprintf(fid,'%.0f %.0f %.0f %.3f %.3f %.1f %.1f %.0f %.0f %.5f %.5f %.3f %.3f %.5f %.3f %.0f\n',[t(PMS_index),unix_time_in_TMA_CDO(PMS_index),final_time(PMS_index),cum_dist(PMS_index),M(PMS_index),TAS(PMS_index)*ms_to_kt,CAS(PMS_index)*ms_to_kt,alt(PMS_index)*3.2808,ROCD(PMS_index)*m_to_ft*60,lat_CDO(PMS_index),lon_CDO(PMS_index),C_L(PMS_index),C_D(PMS_index),F(PMS_index),F_burn_time_TMA_CDO(PMS_index),Thr_idle(PMS_index)]');

% fprintf(fid,'%.0f %.0f %.3f %.3f %.1f %.1f %0.f %.3f %.3f %.1f\n',[t(:),unix_time_in_TMA_CDO(:),cum_dist(:),M(:),TAS(:)*ms_to_kt,CAS(:)*ms_to_kt,alt(:)*3.2808,lat_CDO(:),lon_CDO(:),F_burn_time_TMA_CDO(:)]');

% fprintf(fid,'%.0f %.3f\n',[['a';t(:)],['b';cum_dist(:)]]');

fclose(fid);
end