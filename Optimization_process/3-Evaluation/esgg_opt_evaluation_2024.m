clear
clc
close all

c1_data = readtable('x\ESGG_PM_opt\3-Evaluation\Data\Clusters\osn_ESGG_states_TMA_rwy03_2019_04_cluster1.csv');
c1_callsigns = unique(c1_data.flightID);
c2_data = readtable('x\ESGG_PM_opt\3-Evaluation\Data\Clusters\osn_ESGG_states_TMA_rwy03_2019_04_cluster2.csv');
c2_callsigns = unique(c2_data.flightID);
c3_data = readtable('x\ESGG_PM_opt\3-Evaluation\Data\Clusters\osn_ESGG_states_TMA_rwy03_2019_04_cluster3.csv');
c3_callsigns = unique(c3_data.flightID);
c4_data = readtable('x\ESGG_PM_opt\3-Evaluation\Data\Clusters\osn_ESGG_states_TMA_rwy03_2019_04_cluster4.csv');
c4_callsigns = unique(c4_data.flightID);
c5_data = readtable('x\ESGG_PM_opt\3-Evaluation\Data\Clusters\osn_ESGG_states_TMA_rwy03_2019_04_cluster5.csv');
c5_callsigns = unique(c5_data.flightID);
c6_data = readtable('x\ESGG_PM_opt\3-Evaluation\Data\Clusters\osn_ESGG_states_TMA_rwy03_2019_04_cluster6.csv');
c6_callsigns = unique(c6_data.flightID);

files_OPT = dir(['x\ESGG_PM_opt\3-Evaluation\Data\CDO_full\*CDO*.csv']);
files_OS = dir(['x\ESGG_PM_opt\3-Evaluation\Data\OS_full\*.csv']);


goteborg_TMA_lat = [58.7661 58.7328 58.5169 58.2953 58.0969 57.7672 57.2275 56.9856 57.2136 57.7514 58.1278 58.6456 58.4653 58.7661];
goteborg_TMA_lon = [12.4975 13.1639 13.3244 13.3244 13.2769 13.1992 12.6958 11.7661 11.5828 11.1406 11.4503 12.2956 11.9975 12.4975];

PM_or_not = zeros(90,1);
PM = [1 25 27 46 58 65 74 75 80 89];

IF = [57.481,12.115];

h_THR_save_arr = zeros(1,24);

for i = 1:max(size(files_OPT))
% for i = 1:500
    clc
    i
    % Get current file with its lat and lon coordinates
    name = files_OPT(i).name;
    folder = files_OPT.folder;
    data = readtable([folder,'\',name]);
    figure(1)
    geoplot(data.Var10,data.Var11,'Color','#606060')
    hold on
    THR_time_arr(i,2) = data.Var2(end)+225;
    THR_time_arr(i,1) = i;
    OPT_fuel(i,1) = data.Var15(end);
    OPT_dist(i,1) = data.Var4(1);
    OPT_TT(i,1) = data.Var1(1);
    figure(40)
    plot(data.Var4,data.Var8/100,'Color','#606060')
    alt_CDO = data.Var8;
    dist_CDO = data.Var4;
    set(gca,'Xdir','reverse')
    set(gca,'FontSize',12)
    xlabel('Distance to IF [NM]')
    ylabel('FL [-]')
    hold on

    f60 = figure(60);

    hold on
    plot(dist_CDO,alt_CDO/100,'Color',[0 102 102]/255)
    set(gca,'Xdir','reverse')
    set(gca,'FontSize',12)
    xlabel('Distance to IF [NM]')
    ylabel('FL [-]')
    t_THR = data.Var2(end) + 225;
    h_THR = floor((t_THR - 1554854400)/3600);

    h_THR_save_arr(h_THR+1) = h_THR_save_arr(h_THR+1) + 1;
end

f1 = figure(1);
geoplot(IF(1),IF(2),'Color','#4C9900','Marker','o','MarkerFaceColor','#4C9900','MarkerSize',4)

zero_three_lon = 12.26771;
zero_three_lat = 57.64952;
two_one_lon = 12.29193;
two_one_lat = 57.67615;
geoplot([zero_three_lat two_one_lat],[zero_three_lon two_one_lon],'LineWidth',1.5,'Color','k')

geoplot(goteborg_TMA_lat,goteborg_TMA_lon,'Color','#003366','LineWidth',1.15)
geobasemap none
grid off
f1.Position = [100 100 420 550];

% geoplot(RYR.Var10,RYR.Var11,'r')

for i = 1:max(size(files_OS))
figure(2)
    clc
    i
    name = files_OS(i).name;
    u = find(name == '_');
    ID = ['190410',name(1:u(1)-1)];

    if sum(strcmp(c1_callsigns,ID))
        color = '#0080FF';
    elseif sum(strcmp(c2_callsigns,ID))
        color = '#66CC00';
    elseif sum(strcmp(c3_callsigns,ID))
        color = '#FF8000';
    elseif sum(strcmp(c4_callsigns,ID))
        color = '#404040';
    elseif sum(strcmp(c5_callsigns,ID))
        color = '#B266FF';
    elseif sum(strcmp(c6_callsigns,ID))
        color = '#990099';
    end


    folder = files_OS.folder;
    data = readtable([folder,'\',name]);
    geoplot(data.Var10,data.Var11,'Color',color)
    drawnow
    hold on
    OS_fuel(i,1) = data.Var15(end);
    OS_dist(i,1) = data.Var4(1);
    OS_TT(i,1) = data.Var1(1);
    figure(41)
    plot(data.Var4,data.Var8/100,'Color','#606060')
    alt_OS = data.Var8;
    dist_OS = data.Var4;
    set(gca,'Xdir','reverse')
    set(gca,'FontSize',12)
    xlabel('Distance to IF [NM]')
    ylabel('FL [-]')
    hold on

    f60 = figure(60);
    plot(dist_OS,alt_OS/100,'Color','#606060')
    hold on
    set(gca,'Xdir','reverse')
    set(gca,'FontSize',12)
    xlabel('Distance to IF [NM]')
    ylabel('FL [-]')

end

f2 = figure(2);
geoplot(IF(1),IF(2),'Color','#4C9900','Marker','o','MarkerFaceColor','#4C9900','MarkerSize',4)

zero_three_lon = 12.26771;
zero_three_lat = 57.64952;
two_one_lon = 12.29193;
two_one_lat = 57.67615;
geoplot([zero_three_lat two_one_lat],[zero_three_lon two_one_lon],'LineWidth',1.5,'Color','k')

geoplot(goteborg_TMA_lat,goteborg_TMA_lon,'Color','#003366','LineWidth',1.15)
geobasemap none
grid off
f2.Position = [100 100 420 550];

files_ALL = dir(['C:\Users\henha22\OneDrive - Linköpings universitet\Desktop\ESGG_PM_opt\3-Evaluation\Data\CDO_all_trajectories\*.csv']);

figure(3)
for i = 1:max(size(files_ALL))
    clc
    i
    name = files_ALL(i).name;
    folder = files_ALL.folder;
    data = readtable([folder,'\',name]);
    geoplot(data.Var10,data.Var11,'k')
    drawnow
    % pause
    hold on
    clc
end

dep = [38982
34279
65800
18025
70968
40812
20272
59004
33329
39840
20769
38496
15008
16601
38197
47078
70053
35454
33465
62315
29805
26121
39283
65941
55926
32024
28612
36934
15411
22361
31549
60211
25469
19234
44387
62910
55144
33721
78844
16716
52230
74806
30126
41490
33559
21545
66465
71581
27928
53024
28904
18397
61803
24202
33223
52496
57370
20889
60289
42298
17143
49601
18175
39503
51499
28243
45391
63239
16366
14750
23805
26769
30645
44792
49473
50767
17032
52685
56522
60000
65463
18586
20988
63882
30518
65598
75008
59799
22747
68897
29104
57757
50100
50231
29609];


h_THR_save_dep = zeros(1,24);

for i = 1:95
    t_THR = dep(i);
    h_THR = floor(t_THR/3600);

    h_THR_save_dep(h_THR+1) = h_THR_save_dep(h_THR+1) + 1;
end

data = [h_THR_save_dep', h_THR_save_arr',(h_THR_save_dep + h_THR_save_arr)'];
data = [h_THR_save_dep', h_THR_save_arr'];
data = [(h_THR_save_dep + h_THR_save_arr)'];

figure(50);
hbar50 = bar(data, 'grouped');


xlabel('UTC (HH)');
ylabel('Number of movements');

xticklabels({'00-01','01-02','02-03','03-04','04-05','05-06','06-07','07-08','08-09','09-10','10-11','11-12','12-13','13-14','14-15','15-16','16-17','17-18','18-19','19-20','20-21','21-22','22-23','23-24',}); % Label x-axis ticks as group numbers
hbar50(1).FaceColor = [0 102 102]/255;
set(gca,'FontSize',18)


grid on;


dep(:,1) = dep(:,1) + 1554854400;

THR_time_dep(:,2) = dep;
THR_time_dep(:,1) = [101:195]';

THR_time_ALL = [THR_time_arr;THR_time_dep];

THR_time_ALL = sortrows(THR_time_ALL,2);

sep = [THR_time_ALL(1) 0];

for i = 2:max(size(THR_time_ALL))
    sep(i,1) = THR_time_ALL(i,1);
    sep(i,2) = THR_time_ALL(i,2) - THR_time_ALL(i-1,2);
end

figure(4)
group = [ ones(size(OS_TT)); 2*ones(size(OPT_TT))];
f4 = boxplot([OS_TT/60;OPT_TT/60], group);
ylim([0 20])
ylabel('TT [min]')


set(gca,'TickLabelInterpreter', 'tex');



xticklabels({'Actual','Optimized'})

set(gca,'FontSize',12)

colors = [129 124 138;129 124 138;129 124 138]./255;

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
end


figure(5)
group = [ ones(size(OS_dist)); 2*ones(size(OPT_dist))];
f5 = boxplot([OS_dist;OPT_dist], group);
ylim([0 100])
ylabel('Distance to IF [NM]')


set(gca,'TickLabelInterpreter', 'tex');


xticklabels({'Actual','Optimized'})

set(gca,'FontSize',12)


colors = [129 124 138;129 124 138;129 124 138]./255;

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
end

figure(6)
group = [ ones(size(OS_fuel)); 2*ones(size(OPT_fuel))];
f6 = boxplot([OS_fuel;OPT_fuel], group);
ylim([0 230])
ylabel('Fuel burn [kg]')


set(gca,'TickLabelInterpreter', 'tex');


xticklabels({'Actual','Optimized'})

set(gca,'FontSize',12)
colors = [129 124 138;129 124 138;129 124 138]./255;

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
end


figure(10)
timestamps_arr = [THR_time_arr(:,2)]; 

datetime_values = datetime(timestamps_arr, 'ConvertFrom', 'posixtime');

for k = 1:90
    hold on;
    if ismember(k, PM)
        plot_color = 'r';
    else
        plot_color = 'b';
    end
    plot(datetime_values(k), zeros(size(timestamps_arr)),'Color',plot_color, 'MarkerSize', 4,'Marker','o');
end

datetick('x', 'HH:MM', 'keepticks'); 
xlabel('Time (HH:MM)');
title('Unix Timestamps on 24-hour Timeline');
grid on;

set(gcf, 'Position', [100, 100, 1200, 400]);

timestamps_dep = [THR_time_dep(:,2)];

datetime_values = datetime(timestamps_dep, 'ConvertFrom', 'posixtime');

hold on;
plot(datetime_values, zeros(size(timestamps_dep)), 'go', 'MarkerSize', 4);  % Plot dots at y=0


datetick('x', 'HH:MM', 'keepticks');
xlabel('Time (HH:MM)');
title('Unix Timestamps on 24-hour Timeline');
grid on;

set(gcf, 'Position', [100, 100, 1200, 400]);


c1_callsigns = c1_data.flightID;
c2_callsigns = c2_data.flightID;
c3_callsigns = c3_data.flightID;
c4_callsigns = c4_data.flightID;
c5_callsigns = c5_data.flightID;
c6_callsigns = c6_data.flightID;

c1_index = [];
c2_index = [];
c3_index = [];
c4_index = [];
c5_index = [];
c6_index = [];

for i = 1:max(size(files_OPT))
    callsign = files_OPT(i).name;
    u = find(callsign == '_');
    callsign = ['190410',callsign(1:u(1)-1)];
    if sum(strcmp(c1_callsigns,callsign)) > 0
        c1_index(end+1) = i;
    elseif sum(strcmp(c2_callsigns,callsign)) > 0
        c2_index(end+1) = i;
    elseif sum(strcmp(c3_callsigns,callsign)) > 0
        c3_index(end+1) = i;
    elseif sum(strcmp(c4_callsigns,callsign)) > 0
        c4_index(end+1) = i;
    elseif sum(strcmp(c5_callsigns,callsign)) > 0
        c5_index(end+1) = i;
    elseif sum(strcmp(c6_callsigns,callsign)) > 0
        c6_index(end+1) = i;
    end
end



figure(11)

data = [(sum(OS_TT(c1_index)/60)/length(OS_TT(c1_index))) (sum(OS_TT(c2_index)/60)/length(OS_TT(c2_index))) (sum(OS_TT(c3_index)/60)/length(OS_TT(c3_index))) (sum(OS_TT(c4_index)/60)/length(OS_TT(c4_index))) (sum(OS_TT(c5_index)/60)/length(OS_TT(c5_index))) (sum(OS_TT(c6_index)/60)/length(OS_TT(c6_index)));
    (sum(OPT_TT(c1_index)/60)/length(OPT_TT(c1_index))) (sum(OPT_TT(c2_index)/60)/length(OPT_TT(c2_index))) (sum(OPT_TT(c3_index)/60)/length(OPT_TT(c3_index))) (sum(OPT_TT(c4_index)/60)/length(OPT_TT(c4_index))) (sum(OPT_TT(c5_index)/60)/length(OPT_TT(c5_index))) (sum(OPT_TT(c6_index)/60)/length(OPT_TT(c6_index)))];


hBar1 = bar(data', 'grouped');

hBar1(1).FaceColor = [0 102 102]/255;
hBar1(2).FaceColor = [204 102 0]/255;


xticks(1:6);  
xticklabels({'1', '2', '3', '4', '5', '6'});
xlabel('Cluster')


ylabel('Time to IF [min]');


legend({'Actual', 'Optimized'}, 'Location', 'northeast');
set(gca,'FontSize',12)
figure(12)

data = [(sum(OS_dist(c1_index))/length(OS_dist(c1_index))) (sum(OS_dist(c2_index))/length(OS_dist(c2_index))) (sum(OS_dist(c3_index))/length(OS_dist(c3_index))) (sum(OS_dist(c4_index))/length(OS_dist(c4_index))) (sum(OS_dist(c5_index))/length(OS_dist(c5_index))) (sum(OS_dist(c6_index))/length(OS_dist(c6_index)));
    (sum(OPT_dist(c1_index))/length(OPT_dist(c1_index))) (sum(OPT_dist(c2_index))/length(OPT_dist(c2_index))) (sum(OPT_dist(c3_index))/length(OPT_dist(c3_index))) (sum(OPT_dist(c4_index))/length(OPT_dist(c4_index))) (sum(OPT_dist(c5_index))/length(OPT_dist(c5_index))) (sum(OPT_dist(c6_index))/length(OPT_dist(c6_index)))];


hBar2 = bar(data', 'grouped');

xticks(1:6); 
xticklabels({'1', '2', '3', '4', '5', '6'});
xlabel('Cluster')

hBar2(1).FaceColor = [0 102 102]/255;
hBar2(2).FaceColor = [204 102 0]/255;


ylabel('Distance to IF [NM]');


legend({'Actual', 'Optimized'}, 'Location', 'northeast');
set(gca,'FontSize',12)
figure(13)

data = [(sum(OS_fuel(c1_index))/length(OS_fuel(c1_index))) (sum(OS_fuel(c2_index))/length(OS_fuel(c2_index))) (sum(OS_fuel(c3_index))/length(OS_fuel(c3_index))) (sum(OS_fuel(c4_index))/length(OS_fuel(c4_index))) (sum(OS_fuel(c5_index))/length(OS_fuel(c5_index))) (sum(OS_fuel(c6_index))/length(OS_fuel(c6_index)));
    (sum(OPT_fuel(c1_index))/length(OPT_fuel(c1_index))) (sum(OPT_fuel(c2_index))/length(OPT_fuel(c2_index))) (sum(OPT_fuel(c3_index))/length(OPT_fuel(c3_index))) (sum(OPT_fuel(c4_index))/length(OPT_fuel(c4_index))) (sum(OPT_fuel(c5_index))/length(OPT_fuel(c5_index))) (sum(OPT_fuel(c6_index))/length(OPT_fuel(c6_index)))];



hBar3 = bar(data', 'grouped');

xticks(1:6);
xticklabels({'1', '2', '3', '4', '5', '6'});
xlabel('Cluster')

ylabel('Fuel consumption [kg]');

legend({'Actual', 'Optimized'}, 'Location', 'northeast');

hBar3(1).FaceColor = [0 102 102]/255;
hBar3(2).FaceColor = [204 102 0]/255;
set(gca,'FontSize',12)
clc
TT_actual_avg = (sum(OS_TT)/length(OS_TT))/60
TT_opt_avg = (sum(OPT_TT)/length(OPT_TT))/60

dist_actual_avg = sum(OS_dist)/length(OS_dist)
dist_opt_avg = sum(OPT_dist)/length(OPT_dist)

fuel_actual_avg = sum(OS_fuel)/length(OS_fuel)
fuel_opt_avg = sum(OPT_fuel)/length(OPT_fuel)


timeline_1 = find(timestamps_arr < 1554876000);
timeline_2 = find((timestamps_arr >= 1554876000) & (timestamps_arr < 	1554897600));
timeline_3 = find((timestamps_arr >= 1554897600) & (timestamps_arr < 	1554919200));
timeline_4 = find((timestamps_arr >= 1554919200) & (timestamps_arr < 	1557532800));


figure(20)
timestamps_arr_1 = timestamps_arr(timeline_1);

datetime_values = datetime(timestamps_arr_1, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_1))
    
    if ismember(timeline_1(i), PM)
        plot_color = [204 102 0]/255;
        plot([datetime_values(i) datetime_values(i)],[-0.05 -0.15],'Color',plot_color,'LineWidth',1.5)
        hold on
    else
        plot_color = [204 102 0]/255;
    end
    
    plot(datetime_values(i), zeros(size(timestamps_arr_1)),'Color',plot_color, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',plot_color)
    hold on;

    i

    xlim([datetime(2019,4,10,0,0,0), datetime(2019,4,10,6,0,0)]);

    xticks(datetime(2019,4,10,0,0,0):hours(1):datetime(2019,4,10,6,0,0));

end

c = 1;
datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');
grid on;


set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])





figure(21)

timestamps_arr_2 = timestamps_arr(timeline_2);

datetime_values = datetime(timestamps_arr_2, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_2))
    
    if ismember(timeline_2(i), PM)
        plot_color = [204 102 0]/255;
        plot([datetime_values(i) datetime_values(i)],[-0.05 -0.15],'Color',plot_color,'LineWidth',1.5)
        hold on
    else
        plot_color = [204 102 0]/255;
    end
    
    plot(datetime_values(i), zeros(size(timestamps_arr_2)),'Color',plot_color, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',plot_color)
    hold on;

    i

        xlim([datetime(2019,4,10,6,0,0), datetime(2019,4,10,12,0,0)]);

    xticks(datetime(2019,4,10,6,0,0):hours(1):datetime(2019,4,10,12,0,0));
end
set(gca,'FontSize',12)

c = 1;
datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');

grid on;

set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])



figure(22)
timestamps_arr_3 = timestamps_arr(timeline_3);

datetime_values = datetime(timestamps_arr_3, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_3))
    
    if ismember(timeline_3(i), PM)
        plot_color = [204 102 0]/255;
        plot([datetime_values(i) datetime_values(i)],[-0.05 -0.15],'Color',plot_color,'LineWidth',1.5)
        hold on
    else
        plot_color = [204 102 0]/255;
    end
    
    plot(datetime_values(i), zeros(size(timestamps_arr_3)),'Color',plot_color, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',plot_color)
    hold on;
end
c = 1;
datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');

grid on;

set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])


figure(23)
timestamps_arr_4 = timestamps_arr(timeline_4);

datetime_values = datetime(timestamps_arr_4, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_4))
    
    if ismember(timeline_4(i), PM)
        plot_color = [204 102 0]/255;
        plot([datetime_values(i) datetime_values(i)],[-0.05 -0.15],'Color',plot_color,'LineWidth',1.5)
        hold on
    else
        plot_color = [204 102 0]/255;
    end
    
    plot(datetime_values(i), zeros(size(timestamps_arr_4)),'Color',plot_color, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',plot_color)
    hold on;

xlim([datetime(2019,4,10,18,0,0), datetime(2019,4,11,0,0,0)]);

xticks(datetime(2019,4,10,18,0,0):hours(1):datetime(2019,4,11,0,0,0));
end
c = 1;

datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');
grid on;

set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])






timeline_1 = find(timestamps_dep < 1554876000);
timeline_2 = find((timestamps_dep >= 1554876000) & (timestamps_dep < 	1554897600));
timeline_3 = find((timestamps_dep >= 1554897600) & (timestamps_dep < 	1554919200));
timeline_4 = find((timestamps_dep >= 1554919200) & (timestamps_dep < 	1557532800));


figure(20)

timestamps_dep_1 = timestamps_dep(timeline_1);

datetime_values = datetime(timestamps_dep_1, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_1))
    
    plot(datetime_values(i), zeros(size(timestamps_dep_1)),'Color',[0 128 255]/255,'MarkerSize', 4,'Marker','o','MarkerFaceColor',[0 128 255]/255)
    hold on;
    xlim([datetime(2019,4,10,0,0,0), datetime(2019,4,10,6,0,0)]);

    xticks(datetime(2019,4,10,0,0,0):hours(1):datetime(2019,4,10,6,0,0));
    i
end
c = 1;
datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');
grid on;

set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])



figure(21)
timestamps_dep_2 = timestamps_dep(timeline_2);

datetime_values = datetime(timestamps_dep_2, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_2))
    plot(datetime_values(i), zeros(size(timestamps_dep_2)),'Color',[0 128 255]/255, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',[0 128 255]/255)
    hold on;
    i
end

c = 1;
datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');
grid on;

set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])



figure(22)
timestamps_dep_3 = timestamps_dep(timeline_3);

datetime_values = datetime(timestamps_dep_3, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_3))
    plot(datetime_values(i), zeros(size(timestamps_dep_3)),'Color',[0 128 255]/255, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',[0 128 255]/255)
    hold on;
    i
end
c = 1;
datetick('x', 'HH:MM', 'keepticks');
xlabel('UTC (HH:MM)');
grid on;

set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])


figure(23)
timestamps_dep_4 = timestamps_dep(timeline_4);
datetime_values = datetime(timestamps_dep_4, 'ConvertFrom', 'posixtime');

for i = 1:max(size(timeline_4))
    plot(datetime_values(i), zeros(size(timestamps_dep_4)),'Color',[0 128 255]/255, 'MarkerSize', 4,'Marker','o','MarkerFaceColor',[0 128 255]/255)
    hold on;
    i
    xlim([datetime(2019,4,10,18,0,0), datetime(2019,4,11,0,0,0)]);
    xticks(datetime(2019,4,10,18,0,0):hours(1):datetime(2019,4,11,0,0,0));
end
c = 1;
datetick('x', 'HH:MM', 'keepticks')
xlabel('UTC (HH:MM)');
grid on;
set(gca,'YTickLabel',[]);
set(gca,'ytick',0)
set(gca,'FontSize',15)
ylim([-0.2 0.2])
