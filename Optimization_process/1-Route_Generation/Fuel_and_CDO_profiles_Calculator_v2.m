clear
clc
close all

% ---------------------------- DIRECTORIES ------------------------------ %

BADA_dir = 'x\ESGG_PM_opt\Route_Generation\Data\BADA\BADA_4.2\';
opensky_dir = 'x\ESGG_PM_opt\Route_Generation\Data\Trajectory\Opensky\';
fr24_dir = '';
LFV_dir = '';
DDR_dir = 'x\ESGG_PM_opt\Route_Generation\Data\Trajectory\DDR\';
nc_dir = 'x\ESGG_PM_opt\Route_Generation\Data\Weather\';
export_dir = 'x\ESGG_PM_opt\Route_Generation\Export\OS\';
export_dir_CDO = 'x\ESGG_PM_opt\Route_Generation\Export\CDO\';
export_dir_figures = 'x\ESGG_PM_opt\Route_Generation\Export\Figures\';
airframe_data_dir = 'x\ESGG_PM_opt\Route_Generation\Data\Airframe\';
function_dir = 'x\ESGG_PM_opt\Route_Generation\Functions\';

% ------------------------ SOURCE FILE SETTTINGS ------------------------ %

csv_data_source = 'OS'; % Trajectory data source: % FR = FlightRadar 24, OS = Opensky % DDR = DDR % LFV = LFV

nc_file_T_w_alt = 'esgg_weather_190410.nc';             % Weather data for temperature and wind at altitude
OS_states = 'ESGG_W2_190410.csv';                       % Opensky States file name
OS_tracks = 'osn_arrival_ESGG_tracks_2019_04_week2.csv';% Opensky Tracks file name (only required when automatically searching for the cruise altitude)
OS_ac_database = 'aircraftDatabase-2023-04.csv';        % Opensky aircraft database file name

% -------------------------- GENERAL SETTINGS --------------------------- %

profiles = [4]';

airport = 'ESGG';   % Airport

date = '190410';    % Date

start_calculation = 'TMA_boundary'; % Definition of TMA start: 'TMA_boundary' or 'entry_points_intersection'

end_calculation = 'FAP'; % Definition of trajectory end: 'FAP' or 'user_alt'

map_type = 'topographic'; % Map type for plotting

FAP_alt = 2500; % FAP alt, used when 'user_alt' is set as end of caluclation [ft]

mlw_factor = 0.9; % Aircraft mass factor, fraction of MLW

export = 1; % Export results on/off

plot_on_off = 1;    % Results plotting on/off

plot_both = 0;      % Plot also results for wind and temp off if enabled

% ---------------------------- CDO SETTINGS ----------------------------- %

CDO = 1;                % Create CDO on/off
wind_temp = 1;          % Enable .nc wind and temperature for CDO on/off
% CAS_match = 1;        % Match initial CAS
kt_per_sec_reduce = 1;  % Speed reduction for new phase [kt/sec]

% --------------------- POINT MERGE DESCENT SETTINGS -------------------- %

powered_descent = 0; % on/off                               
descent_angle = 2.34; %2.33; % degrees (only applicable if powered descent is used)

% --------------------- POINT MERGE PROFILE SETTINGS -------------------- %

entry_point = 'W2';  % Entry point of PM STAR
IF = 'W2';           % Intermediate Approach Fix for CDO generation, 'NOSLA', 'OGRAS', 'BOTH'
IF_stop = 'W2';      % Intermediate Approach Fix for OS fuel burn
profile_vector = [4];% Vector with profiles to calculate
PM_profile = 4;        % ESSA...
alt_start = 3000;       % Start altitude for CDO (only works for ENGM and ESSA so far)
IAS_start = 200;        % Start IAS (only works for ENGM and ESSA so far)
IAS_restriction = 220;  % IAS restriction on arcs   (only works for ENGM and ESSA so far)
export_wpts = 0;        % Export data for waypoints only [1] or every second [0]    (only works for ENGM and ESSA so far)

% ------------------------- DATA PRE-PROCESSING ------------------------- %

down_sample = 1;    % Downsample on/off
rate = 5;           % Downsample rate

remove_alt_outliers = 1;    % Remove altitude outliers on/off
alt_diff_thr = 500;         % What alt difference should trigger a removal [ft]
alt_fill_option = 'linear'; % Altitude fill option

remove_zero_length = 1;     % Remove zero length segment on/off

smooth_TAS = 1;                 % Smooth TAS
smooth_TAS_k = 30;              % Smooth TAS parameter
smooth_TAS_option = 'rlowess';  % Smooth TAS method

smooth_flight_track = 0;                % Smooth flight track
smooth_flight_track_k = 5;              % Smooth flight track parameter
smooth_flight_track_option = 'rlowess'; % Smooth flight track method

smooth_ROD = 1;                 % Smooth rate of descent
smooth_ROD_k = 10;              % Smooth rate of descent parameter
smooth_ROD_option = 'rlowess';  % Smooth rate of descent method5

smooth_lat_lon = 1;                 % Smooth coordinates on/off
smooth_lat_lon_k = 10;              % Smooth coordinates parameter
smooth_lat_lon_option = 'rlowess';  % Smooth coordinates method

extrapolate_TAS_end = 0;    % Extrapolate TAS at the end of a trajectory (may solve unrealistic speed increases just before FAP)
TAS_brake_point = 310;      % Extrapolation brake point [kt]  

extrapolate_TAS_start = 0;  % Extrapolate TAS at the beginning of a trajectory
TAS_diff_thr = 0.5; %       % TAS difference threshold [kt]

%-------------------------------------------------------------------------%

fprintf('%s\n','--------------------------------------')
fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
fprintf('%s\n','--------------------------------------')

fcn = input(['Please select what kind of calculations you want to perform:',...
        '\n',...
       '\n[1] Fuel calculation and CDO generation',...
       '\n[2] Fuel calculation and CDO generation for clusters',...
       '\n[3] Fuel calculation and PM CDO generation for EIDW',...
       '\n[4] Fuel calculation and PM CDO generation for ENGM',...
       '\n[5] Fuel calculation and PM CDO generation for ESSA',...
       '\n[6] Fuel calculation and PM CDO generation for ESGG',...
       '\n[7] Fuel calculation and CDO generation for ESSA (OPT@ATM)',...
       '\n',...
       '\nEnter selection here: ']);
clc
fprintf('%s\n','--------------------------------------')
fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
fprintf('%s\n','--------------------------------------')

mode = input('Single [S] or Multiple [M] mode? ','s');
clc
if strcmp(mode,'M')
    search_callsign = 0;
    callsign = [];
%     fprintf('%s\n','          INPUT ')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %s\n','Airport:',airport)
    fprintf('%s %s\n','OS States file:',  OS_states)
    fprintf('%s %s\n','OS Tracks file:',  OS_tracks)
    fprintf('%s %s\n','a/c database file:',OS_ac_database)
    fprintf('%s %s\n','Weather file:',    nc_file_T_w_alt)
    fprintf('%s %s\n','Date:',    date)
%     fprintf('%s\n','')
    fprintf('%s\n','--------------------------------------')
    answer = input('Data correct [Y/N]? :','s');
    if strcmp(answer,'N')
        clc
        fprintf('%s\n','CHANGE FILES!')
        return
    end
elseif strcmp(mode,'S')
    search_callsign = 1;
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
%     fprintf('%s\n','          INPUT ')
%     fprintf('%s\n','--------------------------------')
    fprintf('%s %s\n','Airport:',airport)
    fprintf('%s %s\n','OS States file:',  OS_states)
    fprintf('%s %s\n','Weather file:',    nc_file_T_w_alt)
    fprintf('%s %s\n','Date:',    date)
%     fprintf('%s\n','')
    fprintf('%s\n','--------------------------------------')
    answer = input('Input data correct [Y/N]?:','s');
    if strcmp(answer,'N')
        clc
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','CHANGE FILES!')
        return
    end
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','READING FILES... ')
    [num,OS_states,raw] = xlsread([opensky_dir,OS_states]);
        clc
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
        fprintf('%s\n','--------------------------------------')
        callsign = input('Enter callsign: ','s');
        clc
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
        fprintf('%s\n','--------------------------------------')
        match_CAS_answer = input('Match CAS [Y/N]?: ','s');
        if strcmp(match_CAS_answer,'Y')
            CAS_match = 1;
        elseif strcmp(match_CAS_answer,'N')
            CAS_match = 0;
        end
        clc
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
        fprintf('%s\n','--------------------------------------')
        match_ac_type = input('Match a/c type to database [Y/N]? ','s');
        clc
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
        fprintf('%s\n','--------------------------------------')
        search_cruise_alt = input('Find cruise alt [Y/N]? ','s');
        if strcmp(match_ac_type,'N')
            clc
            fprintf('%s\n','--------------------------------------')
            fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
            fprintf('%s\n','--------------------------------------')
            ac_type = input('Enter ICAO a/c type designator: ','s');
            callsigns{3} = ac_type;
            
        
%         fprintf('%s\n','SEARCHING MATCHING BADA MODEL...')

        callsigns = find_BADA_model(callsigns);
        ac_type = callsigns{4};
        fprintf('%s %s\n','Selected BADA model: ',callsigns{4})
        fprintf('%s\n','--------------------------------------')
        correct = input('Correct [Y/N]? ','s');
        ac_type = callsigns{4};
        
        elseif strcmp(match_ac_type,'Y')
        clc
        fprintf('%s\n','--------------------------------------')
        fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
        fprintf('%s\n','--------------------------------------')
    
            fprintf('%s\n','SEARCHING ICAO A/C TYPE DESIGNATOR... ')
            [num,OS_tracks,raw] = xlsread([opensky_dir,OS_tracks]);
            [num,OS_ac_database,raw] = xlsread([airframe_data_dir,OS_ac_database]);
            callsigns = find_ac_type(OS_states,OS_tracks,OS_ac_database,callsign,airframe_data_dir);
            callsigns = find_BADA_model(callsigns);
            ac_type = callsigns{4};
            
            if isempty(callsigns{2})
                fprintf('%s\n','--------------------------------------')
                fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
                fprintf('%s\n','--------------------------------------')
                clc
               fprintf('%s\n','ICAO 24 not found') 
               ac_type = input('Enter a/c type: ','s');
               callsigns{3} = ac_type;
            elseif isempty(callsigns{3})
                clc
                fprintf('%s\n','Aircraft not found in database!') 
                fprintf('%s %s\n','ICAO 24 = ',callsigns{2}) 
                ac_type = input('Enter a/c type: ','s');
                callsigns{3} = ac_type;
            elseif ~isempty(callsigns{3})
                clc
                
                fprintf('%s\n','--------------------------------------')
                fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
                fprintf('%s\n','--------------------------------------')
                ac_type = callsigns{3};
                fprintf('%s %s\n','ICAO 24 bit adress: ',callsigns{2}) 
                fprintf('%s %s\n','ICAO a/c type designator: ',callsigns{3}) 
                fprintf('%s %s\n','Selected BADA model: ',callsigns{4})
                fprintf('%s\n','--------------------------------------')
                correct = input('Correct [Y/N]? ','s');
                ac_type = callsigns{4};
                if strcmp(correct,'N')
                    ac_type = input('Enter a/c type: ','s');
                end
            end

        end

%     pause

        if strcmp(search_cruise_alt,'N')
                clc
                fprintf('%s\n','--------------------------------------')
                fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
                fprintf('%s\n','--------------------------------------')
            cruise_alt = str2double(input('Enter cruise alt [ft]: ','s'));
        elseif strcmp(search_cruise_alt,'Y')
                clc
                fprintf('%s\n','--------------------------------------')
                fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
                fprintf('%s\n','--------------------------------------')
                fprintf('%s\n','SEARCHING CRUISE ALT...')
            if strcmp(class(OS_tracks),'char')
                [num,OS_tracks,raw] = xlsread([opensky_dir,OS_tracks]);
            end
             cruise_alt = find_cruise_alt(OS_tracks,[],[],date,callsign);
             cruise_alt = cell2mat(cruise_alt(5));
             callsigns{1,5} = cruise_alt;
            
            
            
            clc
            fprintf('%s\n','--------------------------------------')
            fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
            fprintf('%s\n','--------------------------------------')
            fprintf('%s %.0f %s\n','Cruise ALT: ',cruise_alt,' ft') 
            fprintf('%s\n','--------------------------------------')
                correct = input('Correct [Y/N]? ','s');
                if strcmp(correct,'N')
                    ac_type = input('Enter cruise ALT: ','s');
                end
            

          clc
        end
end
clc
% fprintf('%s\n','--------------------------')

% ----------------------------------------------------------------------- %
% ------------------------------- RUNNING... ---------------------------- %
% ----------------------------------------------------------------------- %

addpath(function_dir);

if strcmp(mode,'M')
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','READING FILES...')

    [num,OS_tracks,raw] = xlsread([opensky_dir,OS_tracks]);
    [num,OS_states,raw] = xlsread([opensky_dir,OS_states]);
    [num,OS_ac_database,raw] = xlsread([airframe_data_dir,OS_ac_database]);
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')   
    fprintf('%s\n','SEARCHING A/C TYPES...')
    callsigns = find_ac_type(OS_states,OS_tracks,OS_ac_database,[],airframe_data_dir);
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','SEARCHING CRUISE ALT...')
    intervals_states = find_intervals_states(callsigns,OS_states);
    intervals_tracks = find_intervals_tracks(callsigns,OS_tracks,date);
    callsigns = find_cruise_alt(OS_tracks,intervals_tracks,callsigns,date,[]);
    
    [callsigns,BADA_list] = fill_empty_model(callsigns,airframe_data_dir);

    fprintf('%s\n','MATCHING BADA MODELS...')
%     fprintf('%s\n','--------------------------')
    callsigns = find_BADA_model(callsigns);
    
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    match_CAS_answer = input('Match CAS [Y/N]?: ','s');
    if strcmp(match_CAS_answer,'Y')
        CAS_match = 1;
    elseif strcmp(match_CAS_answer,'N')
        CAS_match = 0;
    end
    

    c = 1;
    error_list = [];
    BADA_list = [];

%     [callsigns,BADA_list] = fill_empty_model(callsigns);
    clc
    
    elapsed_time = [];
    clc
    
    size_callsigns = size(callsigns);
    PM_profile_size = size_callsigns(1);

    for i = 1: PM_profile_size
%         callsigns
%         pause
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    tic
    fprintf('%s\n','             CALCULATING...')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %s\n','Callsign:',callsigns{i,1});
    fprintf('%s %s\n','Actual a/c type:',callsigns{i,3});
    fprintf('%s %s\n','BADA a/c type:',callsigns{i,4});
    fprintf('%s\n','--------------------------------------')
    size_callsigns = size(callsigns);
    fprintf('%.0f %s %.0f\n',i,'of',size_callsigns(1));
    if i >= 2
        fprintf('%s\n','--------------------------------------')
        fprintf('%s %s\n','Estimated time left:',time_left);
    end
        try
            switch fcn
                case 1
                    [F_burn_TMA,F_burn_CDO,rwy,NOx_emission_TMA,NOx_CDO_tot,HC_CDO_tot,CO_emission_TMA,CO_CDO_tot] = OS_CDO_v1(OS_states(intervals_states(i,1):intervals_states(i,2)),callsigns{i,4},plot_on_off,callsigns{i,1},date,(callsigns{i,5})/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{i,3},callsigns{i,6});
                case 2
                    [F_burn_TMA,F_burn_CDO,rwy] = OS_CDO_clusters_v1(OS_states(intervals_states(i,1):intervals_states(i,2)),callsigns{i,4},plot_on_off,callsigns{i,1},date,(callsigns{i,5})/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{i,3},callsigns{i,6});
                case 3
                    [F_burn_TMA,F_burn_CDO,rwy] = EIDW_point_merge_v1(OS_states(intervals_states(i,1):intervals_states(i,2)),callsigns{i,4},plot_on_off,callsigns{i,1},date,(callsigns{i,5})/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{i,3},callsigns{i,6},entry_point,PM_profile);
                case 4
                    [F_burn_TMA,F_burn_CDO,rwy] = ENGM_point_merge_v2_cruise_speed(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile,IF,IF_stop,export_wpts);

                case 6
            % for PM_profile = profile_vector
            PM_profile = profiles(i);
                % ac_type = char(callsigns(i,4));
                % cruise_alt = str2num(string(callsigns(i,5)));
                [F_burn_TMA,F_burn_CDO,rwy] = ESGG_point_merge_v1(OS_states(intervals_states(i,1):intervals_states(i,2)),callsigns{i,4},plot_on_off,callsigns{i,1},date,(callsigns{i,5})/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{i,3},[],entry_point,PM_profile,IF,IF_stop,powered_descent,descent_angle,IAS_start,IAS_restriction,alt_start,export_wpts);
            % pause
            % end
            end
            Fuel(i,1) = F_burn_TMA;
            Fuel(i,2) = F_burn_CDO;
            rwy_counter{i} = rwy;
        catch 
            fprintf('%s\n','--------------------------------------')
            fprintf('%s %s %s\n','ERROR WHEN PROCESSING FLIGHT',callsigns{i,1},'!');
            error_list{c,1} = i;
            error_list{c,2} = callsigns{i,1};
            error_list{c,3} = callsigns{i,3};
            if strcmp(callsigns{i,4},'N/A')
                error_list{c,4} = 'A/C TYPE MISSING';
            end
            c = c + 1;
            pause(2)
        end
    elapsed_time(i) = toc;

    time_left = (((max(size(callsigns)))-i)*mean(elapsed_time))/60;

    time_left = datestr( time_left/1440, 'HH:MM:SS' );

        clc
    end
    
%     [C,ia,ic] = unique(rwy_counter);
%     a_counts = accumarray(ic,1);
    
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','        CALCULATIONS COMPLETED!')
    fprintf('%s\n','--------------------------------------')
    
if numel(error_list) >= 1
    fprintf('%s\n','The following flights could not be calculated:')
%     fprintf('%s\n','--------------------------------------')
    error_list
end
if numel(BADA_list) >= 1
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','The following a/c types are missing in matching list:')
%     fprintf('%s\n','--------------------------------------')
    BADA_list
end
    
    

    OS = sum(Fuel(:,1));
    CDO = sum(Fuel(:,2));
    diff = OS-CDO;
    diff = diff/OS;
    
elseif strcmp(mode,'S')
    if fcn == 4
        if strcmp(IF,'BOTH') == 1
            vec = 1:2;
        elseif strcmp(IF,'NOSLA') == 1
            vec = 1;
        elseif strcmp(IF,'OGRAS') == 1
            vec = 2;
        end

    for g = vec
        switch g
            case 1
                IF = 'NOSLA';
            case 2
                IF = 'OGRAS';
        end
% 
    for PM_profile = profile_vector

%     IF
%     PM_profile
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','             CALCULATING...')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %s\n','Callsign:',callsign);
    fprintf('%s %s\n','BADA a/c type:',ac_type);
    fprintf('%s\n','--------------------------------------')
        
        disp('Currently processing:')
        disp(['IF: ',IF])
        disp(['Profile: ',num2str(PM_profile)])
            [F_burn_TMA,F_burn_CDO,rwy] = ENGM_point_merge_v2_cruise_speed(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile,IF,IF_stop,powered_descent,descent_angle,IAS_start,IAS_restriction,alt_start,export_wpts);

%     pause
    end
    end


    elseif fcn == 3
% 
    for PM_profile = profile_vector

%     IF
%     PM_profile
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','             CALCULATING...')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %s\n','Callsign:',callsign);
    fprintf('%s %s\n','BADA a/c type:',ac_type);
    fprintf('%s\n','--------------------------------------')
        
        disp('Currently processing:')
        disp(['IF: ',IF])
        disp(['Profile: ',num2str(PM_profile)])
            [F_burn_TMA,F_burn_CDO,rwy]= EIDW_point_merge_v1(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile);

%     pause
    end
    
    else
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','             CALCULATING...')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %s\n','Callsign:',callsign);
    fprintf('%s %s\n','BADA a/c type:',ac_type);
    fprintf('%s\n','--------------------------------------')
    switch fcn
        case 1
            [F_burn_TMA,F_burn_CDO,rwy,NOx_emission_TMA,NOx_CDO_tot,HC_emission_TMA,HC_CDO_tot,CO_emission_TMA,CO_CDO_tot] = OS_CDO_v1(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[]);
        case 2
            [F_burn_TMA,F_burn_CDO,rwy] = OS_CDO_clusters_v1(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[]);
        case 3
%             [F_burn_TMA,F_burn_CDO,rwy] = EIDW_point_merge_v1(OS_states,callsigns{i,4},plot_on_off,callsigns{i,1},date,(callsigns{i,5})/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{i,3},callsigns{i,6});
            [F_burn_TMA,F_burn_CDO,rwy]= EIDW_point_merge_v1(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile);
        case 5
            [F_burn_TMA,F_burn_CDO,rwy,F_burn_time_TMA_CDO] = ESSA_point_merge_v1(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile,IF,IF_stop,powered_descent,descent_angle,IAS_start,IAS_restriction,alt_start,export_wpts);
            
        case 6
            for PM_profile = profile_vector
                [F_burn_TMA,F_burn_CDO,rwy] = ESGG_point_merge_v1(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile,IF,IF_stop,powered_descent,descent_angle,IAS_start,IAS_restriction,alt_start,export_wpts);
            % pause
            end
        case 7
            [F_burn_TMA,F_burn_CDO,rwy,F_burn_time_TMA_CDO] = ESSA_opt_at_ATM(OS_states,ac_type,plot_on_off,callsign,date,cruise_alt/100,BADA_dir,fr24_dir,LFV_dir,DDR_dir,nc_dir,export_dir,export_dir_CDO,nc_file_T_w_alt,csv_data_source,down_sample,rate,remove_alt_outliers,alt_diff_thr,alt_fill_option,remove_zero_length,smooth_TAS,smooth_TAS_k,smooth_TAS_option,smooth_flight_track,smooth_flight_track_k,smooth_flight_track_option,smooth_ROD,smooth_ROD_k,smooth_ROD_option,smooth_lat_lon,smooth_lat_lon_k,smooth_lat_lon_option,extrapolate_TAS_end,TAS_brake_point,extrapolate_TAS_start,TAS_diff_thr,start_calculation,end_calculation,map_type,search_callsign,callsign,airport,FAP_alt,mlw_factor,export,CDO,wind_temp,plot_both,kt_per_sec_reduce,CAS_match,export_dir_figures,callsigns{1,3},[],entry_point,PM_profile,IF,IF_stop,powered_descent,descent_angle,IAS_start,IAS_restriction,alt_start,export_wpts);

    end

    end
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %.1f %s\n','OS fuel burn: ',F_burn_TMA,'kg') 
    fprintf('%s %.1f %s\n','CDO fuel burn: ',F_burn_CDO,'kg') 
    diff = ((F_burn_TMA-F_burn_CDO)/F_burn_TMA)*100;
    fprintf('%s %.1f %s\n','Possible fuel reduction',diff,'%')
    fprintf('%s\n','--------------------------------------')
    % if NOx_emission_TMA ~= 0
    %     fprintf('%s %.3f %s\n','OS NOx emission: ',NOx_emission_TMA,'kg') 
    %     fprintf('%s %.3f %s\n','CDO NOx emission: ',NOx_CDO_tot,'kg')
    %     diff = ((NOx_emission_TMA-NOx_CDO_tot)/NOx_emission_TMA)*100;
    %     fprintf('%s %.3f %s\n','Possible NOx emission reduction',diff,'%')
    %     fprintf('%s\n','--------------------------------------')
    %     fprintf('%s %.3f %s\n','OS HC emission: ',HC_emission_TMA,'kg') 
    %     fprintf('%s %.3f %s\n','CDO HC emission: ',HC_CDO_tot,'kg')
    %     diff = ((HC_emission_TMA-HC_CDO_tot)/HC_emission_TMA)*100;
    %     fprintf('%s %.3f %s\n','Possible HC emission reduction',diff,'%')
    %     fprintf('%s\n','--------------------------------------')
    %     fprintf('%s %.3f %s\n','OS CO emission: ',CO_emission_TMA,'kg') 
    %     fprintf('%s %.3f %s\n','CDO CO emission: ',CO_CDO_tot,'kg')
    %     diff = ((CO_emission_TMA-CO_CDO_tot)/CO_emission_TMA)*100;
    %     fprintf('%s %.3f %s\n','Possible CO emission reduction',diff,'%')
    %     fprintf('%s\n','--------------------------------------')
    % else
    %     disp('OpenAP not able to caluclate emissions for the selected aircraft type.')
    % end
%     pause
% end
%     end
end

% ------------------------------- FUNCTIONS ----------------------------- %

function callsigns = find_ac_type(OS_states,OS_tracks,OS_ac_database,single_callsign,airframe_data_dir)
[a,list,d] = xlsread([airframe_data_dir,'missing_ac_list.csv']);
if ~isempty(single_callsign)
    callsigns{1,1} = single_callsign;
    state = OS_states{1};
    date = state(1:6);
else
    for i = 1:max(size(OS_states))
        state = OS_states{i};
        blanks = find(state == ' ');
        callsign = state(7:blanks(1)-1);
        date = state(1:6);
        callsigns{i,1} = callsign;
    end

    callsigns = unique(callsigns);
end


for i = 1:max(size(callsigns))  

   Index = find(contains(OS_tracks,callsigns{i})) 
   rows = OS_tracks(Index)
   Index = find(contains(rows,date))
   rows = rows(Index)
   callsigns{i}
   flight = rows{1};
   blanks = find(flight == ' ');
   icao24 = flight(blanks(5)+1:blanks(6)-1);
   
   if strcmp(icao24,date)
       icao24 = flight(blanks(4)+1:blanks(5)-1);
   end
   
   callsigns{i,2} = icao24;
   try
        Index = find(contains(OS_ac_database,icao24));
        row = OS_ac_database{Index};
        commas = find(row == ',');
        ac_type = row(commas(5)+2:commas(6)-2);
        
        if isempty(ac_type)         
            index = find(cellfun('length',regexp(list,callsigns{i,2})) == 1);
            if ~isempty(index)
                row = char(list(index,:));
                blanks = find(row == ' ');
                ac_type = row(blanks(end)+1:blanks(end)+4);
                callsigns{i,3} = ac_type;
            else
%                 callsigns{i,3} = icao24;
            end     
        else
            callsigns{i,3} = ac_type;
        end  
   catch
       index = find(cellfun('length',regexp(list,callsigns{i,2})) == 1);
            if ~isempty(index)
                row = char(list(index,:));
                blanks = find(row == ' ');
                try
                    ac_type = row(blanks(end)+1:blanks(end)+4);
                catch
                    ac_type = row(blanks(end)+1:blanks(end)+3);
                end
                callsigns{i,3} = ac_type;
            else
                callsigns{i,2} = icao24;
%                 callsigns{i,3} = icao24;
            end
    end

end

end

function intervals_states = find_intervals_states(callsigns,OS_states)
size_callsigns = (size(callsigns));
for i = 1:size_callsigns(1)
    name = [callsigns{i,1},' '];
    index_flight = find(cellfun('length',regexp(OS_states,name)) == 1);
    flight_data = OS_states(index_flight,:);
    flight_size = max(size(flight_data));
    
    if i == 1
        intervals_states(1,1) = 1;
        intervals_states(1,2) = flight_size;
    else
        intervals_states(i,1) = intervals_states(i-1,2) + 1;
        intervals_states(i,2) = intervals_states(i,1) + flight_size - 1;
    end
    
end
end

function callsigns = find_BADA_model(callsigns)
size_callsigns = (size(callsigns));
for i = 1:size_callsigns(1)

switch callsigns{i,3}
    case 'A320'
        callsigns{i,4} = 'A320-232';
        callsigns{i,6} = 'M';
    case 'A319'
        callsigns{i,4} = 'A319-131';
        callsigns{i,6} = 'M';
    case 'A321'
        callsigns{i,4} = 'A321-131';
        callsigns{i,6} = 'M';
    case 'E195'
        callsigns{i,4} = 'EMB-195STD';
        callsigns{i,6} = 'M';
    case 'A333'
        callsigns{i,4} = 'A330-341';
        callsigns{i,6} = 'H';
    case 'B737'
        callsigns{i,4} = 'B737W24';
        callsigns{i,6} = 'M';
    case 'A20N'
        callsigns{i,4} = 'A320-271N';
        callsigns{i,6} = 'M';
    case 'B788'
        callsigns{i,4} = 'B788RR70';
        callsigns{i,6} = 'H';
    case 'B789'
        callsigns{i,4} = 'B789RR74';
        callsigns{i,6} = 'H';
    case 'B78X'
        callsigns{i,4} = 'B789RR74';
        callsigns{i,6} = 'H';
    case 'B732'
        callsigns{i,4} = 'B73215';
        callsigns{i,6} = 'M';
    case 'B738'
        callsigns{i,4} = 'B738W26';
        callsigns{i,6} = 'M';
    case 'B38M'
        callsigns{i,4} = 'B738W26';
        callsigns{i,6} = 'M';
    case 'B752'
        callsigns{i,4} = 'B752WRR40';
        callsigns{i,6} = 'M';
    case 'B753'
        callsigns{i,4} = 'B753RR';
        callsigns{i,6} = 'M';
    case 'B739'
        callsigns{i,4} = 'B739ERW26';
        callsigns{i,6} = 'M';
    case 'AT76'
        callsigns{i,4} = 'ATR72-600';
        callsigns{i,6} = 'M';
    case 'AN26'
        callsigns{i,4} = 'ATR72-600';
        callsigns{i,6} = 'M';
    case 'AT75'
        callsigns{i,4} = 'ATR72-500';
        callsigns{i,6} = 'M';
    case 'AT72'
        callsigns{i,4} = 'ATR72-210';
        callsigns{i,6} = 'M';
    case 'A21N'
        callsigns{i,4} = 'A321-131';
        callsigns{i,6} = 'M';
    case 'A359'
        callsigns{i,4} = 'A350-941';
        callsigns{i,6} = 'H';
    case 'A35K'
        callsigns{i,4} = 'A350-941';
        callsigns{i,6} = 'H';
    case 'B77W'
        callsigns{i,4} = 'B773ERGE115B';  
        callsigns{i,6} = 'H';
    case 'B736'
        callsigns{i,4} = 'B73622';  
        callsigns{i,6} = 'M';
    case 'CRJ9'
        callsigns{i,4} = 'EMB-175STD';  
        callsigns{i,6} = 'M';
    case 'G650'
        callsigns{i,4} = 'EMB-175STD';  
        callsigns{i,6} = 'M';
    case 'CRJX'
        callsigns{i,4} = 'EMB-175STD';  
        callsigns{i,6} = 'M';
    case 'G550'
        callsigns{i,4} = 'EMB-175STD';  
        callsigns{i,6} = 'M';
    case 'BCS3'
        callsigns{i,4} = 'A319-131';  
        callsigns{i,6} = 'M';
    case 'B763'
        callsigns{i,4} = 'B763ERGE61';  
        callsigns{i,6} = 'H';
    case 'B742'
        callsigns{i,4} = 'B742RR'; 
        callsigns{i,6} = 'H';
    case 'SU95'
        callsigns{i,4} = 'EMB-175STD';  
        callsigns{i,6} = 'M';
    case 'A306'
        callsigns{i,4} = 'A300B4-622';
        callsigns{i,6} = 'H';
    case 'A318'
        callsigns{i,4} = 'A318-112';  
        callsigns{i,6} = 'M';
    case 'A388'
        callsigns{i,4} = 'A380-861';  
        callsigns{i,6} = 'J';
    case 'B733'
        callsigns{i,4} = 'B73320'; 
        callsigns{i,6} = 'M';
    case 'DH8D'
        callsigns{i,4} = 'ATR72-600'; 
        callsigns{i,6} = 'M';
    case 'PC12'
        callsigns{i,4} = 'ATR42-300'; 
        callsigns{i,6} = 'L';
    case 'PC24'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'C25B'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'L';
    case 'B735'
        callsigns{i,4} = 'B73518'; 
        callsigns{i,6} = 'M';
    case 'C560'
        callsigns{i,4} = 'EMB-505';
        callsigns{i,6} = 'M';
    case 'B734'
        callsigns{i,4} = 'B73423';
        callsigns{i,6} = 'M';
    case 'SF34'
        callsigns{i,4} = 'ATR42-300';
        callsigns{i,6} = 'M';
    case 'SB20'
        callsigns{i,4} = 'ATR42-300';
        callsigns{i,6} = 'M';
    case 'GYRO'
        callsigns{i,4} = 'A320-214';
        callsigns{i,6} = 'M';
    case 'A332'
        callsigns{i,4} = 'A330-243';  
        callsigns{i,6} = 'H';
    case 'A346'
        callsigns{i,4} = 'A340-642';  
        callsigns{i,6} = 'H';
    case 'E190'
        callsigns{i,4} = 'EMB-190STD'; 
        callsigns{i,6} = 'M';
    case 'E290'
        callsigns{i,4} = 'EMB-190STD'; 
        callsigns{i,6} = 'M';
    case 'E175'
        callsigns{i,4} = 'EMB-175STD'; 
        callsigns{i,6} = 'M';
    case 'C680'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'C68A'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'F900'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'FA50'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'CL60'
        callsigns{i,4} = 'EMB-135BJ-Legacy650'; 
        callsigns{i,6} = 'M';
    case 'CL64'
        callsigns{i,4} = 'EMB-135BJ-Legacy650'; 
        callsigns{i,6} = 'M';
    case 'CL65'
        callsigns{i,4} = 'EMB-135BJ-Legacy650'; 
        callsigns{i,6} = 'M';
    case 'C25A'
        callsigns{i,4} = 'EMB-500'; 
        callsigns{i,6} = 'L';
    case 'HDJT'
        callsigns{i,4} = 'EMB-500'; 
        callsigns{i,6} = 'L';
    case 'C25M'
        callsigns{i,4} = 'EMB-500'; 
        callsigns{i,6} = 'L';
    case 'LJ35'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'BE40'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'LJ45'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'LJ70'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'LJ75'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'FA7X'
        callsigns{i,4} = 'EMB-145ER'; 
        callsigns{i,6} = 'M';
    case 'FA8X'
        callsigns{i,4} = 'EMB-145ER'; 
        callsigns{i,6} = 'M';
    case 'BCS1'
        callsigns{i,4} = 'EMB-195STD'; 
        callsigns{i,6} = 'M';
    case 'E75L'
        callsigns{i,4} = 'EMB-175STD'; 
        callsigns{i,6} = 'M';
    case 'C55B'
        callsigns{i,4} = 'EMB-505'; 
        callsigns{i,6} = 'M';
    case 'RJ1H'
        callsigns{i,4} = 'EMB-175STD'; 
        callsigns{i,6} = 'M';
    case 'RJ85'
        callsigns{i,4} = 'EMB-175STD'; 
        callsigns{i,6} = 'M';
    case 'A310'
        callsigns{i,4} = 'A310-324'; 
        callsigns{i,6} = 'H';
    case 'F2EX'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'F2TH'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'F2LX'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'E550'
        callsigns{i,4} = 'EMB-135BJ-Legacy600'; 
        callsigns{i,6} = 'M';
    case 'A342'
        callsigns{i,4} = 'A340-213'; 
        callsigns{i,6} = 'H';
    case 'A343'
        callsigns{i,4} = 'A340-313'; 
        callsigns{i,6} = 'H';
    case 'A345'
        callsigns{i,4} = 'A340-541'; 
        callsigns{i,6} = 'H';
    case 'B77L'
        callsigns{i,4} = 'B772LR'; 
        callsigns{i,6} = 'H';
    case 'B772'
        callsigns{i,4} = 'B772RR92';
        callsigns{i,6} = 'H';
    case 'MD11'
        callsigns{i,4} = 'B772RR92';
        callsigns{i,6} = 'H';
    case 'B748'
        callsigns{i,4} = 'B748F'; 
        callsigns{i,6} = 'H';
    case 'B744'
        callsigns{i,4} = 'B744GE';
        callsigns{i,6} = 'H';
    case 'AT43'
        callsigns{i,4} = 'ATR42-300'; 
        callsigns{i,6} = 'M';
    case 'AT44'
        callsigns{i,4} = 'ATR42-400'; 
        callsigns{i,6} = 'M';
    case 'AT46'
        callsigns{i,4} = 'ATR42-400'; 
        callsigns{i,6} = 'M';
    case 'ATP'
        callsigns{i,4} = 'ATR42-300'; 
        callsigns{i,6} = 'M';
    case 'CRJ2'
        callsigns{i,4} = 'EMB-145ER';  
        callsigns{i,6} = 'M';
    case 'B762'
        callsigns{i,4} = 'B762GE50';
        callsigns{i,6} = 'H';
    case 'MD81'
        callsigns{i,4} = 'MD808120';
        callsigns{i,6} = 'M';
    case 'MD82'
        callsigns{i,4} = 'MD808221';
        callsigns{i,6} = 'M';
    case 'MD83'
        callsigns{i,4} = 'MD808321';
        callsigns{i,6} = 'M';
    case 'MD87'
        callsigns{i,4} = 'MD808720';
        callsigns{i,6} = 'M';
    case 'MD88'
        callsigns{i,4} = 'MD808821';
        callsigns{i,6} = 'M';
    case 'F70'
        callsigns{i,4} = 'F70-620';
        callsigns{i,6} = 'M';
    case 'F100'
        callsigns{i,4} = 'F100-650';
        callsigns{i,6} = 'M';
    case 'E50P'
        callsigns{i,4} = 'EMB-500';
        callsigns{i,6} = 'L';
    case 'E75S'
        callsigns{i,4} = 'EMB-175STD';
        callsigns{i,6} = 'M';
    case 'E170'
        callsigns{i,4} = 'EMB-170STD';
        callsigns{i,6} = 'M';
    case 'E145'
        callsigns{i,4} = 'EMB-145ER';
        callsigns{i,6} = 'M';
    case 'E135'
        callsigns{i,4} = 'EMB-135ER';
        callsigns{i,6} = 'M';
    case 'E35L'
        callsigns{i,4} = 'EMB-135BJ-Legacy650';
        callsigns{i,6} = 'M';
    case 'B764'
        callsigns{i,4} = 'B764ER';
        callsigns{i,6} = 'H';
    case 'B743'
        callsigns{i,4} = 'B743PW';
        callsigns{i,6} = 'H';
    case 'GL6T'
        callsigns{i,4} = 'EMB-145ER';
        callsigns{i,6} = 'M';
    case 'GL5T'
        callsigns{i,4} = 'EMB-145ER';
        callsigns{i,6} = 'M';
    case 'GLEX'
        callsigns{i,4} = 'EMB-145ER';
        callsigns{i,6} = 'M';
    case 'GLF4'
        callsigns{i,4} = 'EMB-145ER';
        callsigns{i,6} = 'M';
    case 'C510'
        callsigns{i,4} = 'EMB-500';
        callsigns{i,6} = 'L';
    case 'G200'
        callsigns{i,4} = 'EMB-135ER';
        callsigns{i,6} = 'M';
    case 'GALX'
        callsigns{i,4} = 'EMB-135ER';
        callsigns{i,6} = 'M';
    case 'C525'
        callsigns{i,4} = 'EMB-500';
        callsigns{i,6} = 'L';
    case 'CL35'
        callsigns{i,4} = 'EMB-135BJ-Legacy600';
        callsigns{i,6} = 'M';
    case 'C56X'
        callsigns{i,4} = 'EMB-505';
        callsigns{i,6} = 'M';
    case 'CL30'
        callsigns{i,4} = 'EMB-135BJ-Legacy600';
        callsigns{i,6} = 'M';
    case 'CL85'
        callsigns{i,4} = 'EMB-135BJ-Legacy650';
        callsigns{i,6} = 'M';
    case 'GLF5'
        callsigns{i,4} = 'EMB-175STD';
        callsigns{i,6} = 'M';
    case 'GLF6'
        callsigns{i,4} = 'EMB-175STD';
        callsigns{i,6} = 'M';
    case 'E55P'
        callsigns{i,4} = 'EMB-505';
        callsigns{i,6} = 'M';
    case 'C25C'
        callsigns{i,4} = 'EMB-500';
        callsigns{i,6} = 'M';
    case 'G150'
        callsigns{i,4} = 'EMB-505';
        callsigns{i,6} = 'M';
    case 'G450'
        callsigns{i,4} = 'EMB-170STD';
        callsigns{i,6} = 'M';
    case 'DH8C'
        callsigns{i,4} = 'ATR42-500';
        callsigns{i,6} = 'M';
    case 'DH8A'
        callsigns{i,4} = 'ATR42-300';
        callsigns{i,6} = 'M';
    case 'BE20'
        callsigns{i,4} = 'ATR42-300';
        callsigns{i,6} = 'L';
    case 'BE30'
        callsigns{i,4} = 'ATR42-300';
        callsigns{i,6} = 'L';
    case 'H25B'
        callsigns{i,4} = 'EMB-505';
        callsigns{i,6} = 'M';
end
end
    empty = cellfun(@isempty,callsigns(:,4));
    if sum(empty >= 1)

        index = find(empty == 1);
        for j = index'
            clc
            fprintf('%s\n','--------------------------------------')
            fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
            fprintf('%s\n','--------------------------------------')
            fprintf('%s\n','Matching BADA model not found!') 
            fprintf('%s\n','--------------------------------------')
           fprintf('%s %s\n','Callsign = ',callsigns{j,1});
           fprintf('%s %s\n','ICAO 24 = ',callsigns{j,2});
           ac_type = input('Enter BADA model: ','s');
           callsigns{j,4} = ac_type;
           wtc = input('Enter WTC: ','s');
           callsigns{j,6} = wtc;
        end
    end
end

function [callsigns,BADA_list] = fill_empty_model(callsigns,airframe_data_dir)

empty = cellfun(@isempty,callsigns(:,3));
empty = find(empty == 1);
c = 1;
BADA_list = [];
[a,list,d] = xlsread([airframe_data_dir,'missing_ac_list.csv']);
list_size = max(size(list));
for i = empty'
    clc
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','#       FUEL AND CDO CALCULATOR      #')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s\n','           MISSING A/C TYPE')
    fprintf('%s\n','--------------------------------------')
    fprintf('%s %s\n','Callsign:',callsigns{i,1});
    fprintf('%s %s\n','A/C type:',callsigns{i,2});
    ICAO_model = input('Enter ICAO a/c type: ','s');
    callsigns{i,3} = ICAO_model;
    BADA_list{c,1} = callsigns{i,3};
    BADA_list{c,2} = ICAO_model;
    list(list_size+c,:) = join([callsigns{i,2},' ',cellstr(ICAO_model)]);
    c = c + 1;
    clc 
end

[~,idx]=unique(strcat(list(:), 'rows'));
list = list(sort(idx));
fid = fopen([airframe_data_dir,'missing_ac_list.csv'], 'wt' );
fprintf(fid,'%s\n',list{:});
fclose(fid);
end

function intervals_tracks = find_intervals_tracks(callsigns,OS_tracks,date)

for i = 1:max(size(OS_tracks))
    row = OS_tracks{i};
    blanks = find(row == ' ');
    keep{i,:} = row(1:blanks(1)-1);
end

Index = find(contains(keep,date));
flight_data = OS_tracks(Index);
size_callsigns = (size(callsigns));
for i = 1:size_callsigns(1)
    name = [callsigns{i,1},' '];
    Index = find(contains(flight_data,name));

    intervals_tracks(i,1) = Index(1);
    intervals_tracks(i,2) = Index(end);

end
end


function callsigns = find_cruise_alt(OS_tracks,intervals_tracks,callsigns,date,single_callsign)

for i = 1:max(size(OS_tracks))
    row = OS_tracks{i};
    blanks = find(row == ' ');
    keep{i,:} = row(1:blanks(1)-1);
end

Index = find(contains(keep,date));
flight_data = OS_tracks(Index);

if isempty(single_callsign)
    PM_profile = size(intervals_tracks);
    PM_profile = PM_profile(1);
else
    name = [single_callsign,' ']
    Index = find(contains(flight_data,name));

    intervals_tracks(1,1) = Index(1);
    intervals_tracks(1,2) = Index(end);
    PM_profile = 1;
end

for i = 1:PM_profile
    c = 1;
    for j = intervals_tracks(i,1):intervals_tracks(i,2)
        row = flight_data{j,:};
        
        blanks = find(row == ' ');
        alt(c) = str2num(row(blanks(end)+1:end));
        c = c + 1;
%         pause
    end
    callsigns{i,5} = ceil(max(alt)*3.2808/10)*10;
    alt = [];
    c = 0;
end

end
    


