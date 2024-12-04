## EIDW Point Merge Optimization ##

##### Sets and parameters #####

param nbrArrAC;								# number of arriving aircrafts
param nbrDepAC;								# number of departing aircrafts
param nbrProf;								# number of profiles
param M;								# big number
param TO_delay;
param sep_1;
param sep_2;
param sep_to;
param sep_to_H;

set A := 1..nbrArrAC;							# set of arriving aircraft
set P := 1..nbrProf;							# set of profile
set G := 1..nbrDepAC;							# set of departing aircraft
	
param ETA{A};								# ETA for each aircraft
param RTA{P};								# RTA for each profile
param TT{P};								# TT for each profile
param FUEL{P};

set AP{a in A} within P;						# set of profiles available for each aircraft

set IP within A cross P cross A cross P;				# set of incompatibles profiles: (ai, pr, aj, pq) ai flying pr and aj flying pq is not possible 

##### Variable #####

var x {a in A, p in AP[a]} binary;					# binary variable for each profile, =1 if selected, =0 otherwise

var y1 {a in A, p in AP[a]} binary; 					# binary variable for each set of constraints for departing a/c 1

var y2 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 2

var y3 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 3

var y4 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 4

var y5 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y6 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y7 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y8 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y9 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y10 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y11 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y12 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y13 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y14 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y15 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y16 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y17 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y18 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y19 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y20 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y21 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y22 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y23 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y24 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y25 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y26 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y27 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y28 {a in A, p in AP[a]} binary; 					# binary variable for each set of constraints for departing a/c 1

var y29 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 2

var y30 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 3

var y31 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 4

var y32 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y33 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y34 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y35 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y36 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y37 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y38 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y39 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y40 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y41 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y42 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y43 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y44 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y45 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y46 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y47 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y48 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y49 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y50 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y51 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y52 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y53 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y54 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y55 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y56 {a in A, p in AP[a]} binary; 					# binary variable for each set of constraints for departing a/c 1

var y57 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 2

var y58 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 3

var y59 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 4

var y60 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y61 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y62 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y63 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y64 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y65 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y66 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y67 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y68 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y69 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y70 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y71 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y72 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y73 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y74 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y75 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y76 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y77 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y78 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y79 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y80 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y81 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y82 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y83 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y84 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y85 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y86 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y87 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y88 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y89 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y90 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y91 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y92 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y93 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y94 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5

var y95 {a in A, p in AP[a]} binary;					# binary variable for each set of constraints for departing a/c 5


#var y28 binary; #binary variable for spacing constraints between a/c 4 and a/c 5

#var y29 binary;  # binary variable for spacing constraints between a/c 7 and a/c 8

#var y30 binary;  # binary variable for spacing constraints between a/c 8 and a/c 9

#var y31 binary;  # binary variable for spacing constraints between a/c 10 and a/c 11

#var y32 binary;  # binary variable for spacing constraints between a/c 15 and a/c 16

#var y33 binary;  # binary variable for spacing constraints between a/c 17 and a/c 18

#var y34 binary;  # binary variable for spacing constraints between a/c 19 and a/c 20

#var y35 binary;  # binary variable for spacing constraints between a/c 20 and a/c 21
#
#var y36 binary;  # binary variable for spacing constraints between a/c 23 and a/c 24

#var y37 binary;  # binary variable for spacing constraints between a/c 24 and a/c 25

#var y38 binary;  # binary variable for spacing constraints between a/c 2 and a/c 3




var t_dep1 integer >= 38982,<= 38982+TO_delay;
var t_dep2 integer >= 34279,<= 34279+TO_delay;
var t_dep3 integer >= 65800,<= 65800+TO_delay;
var t_dep4 integer >= 18025,<= 18025+TO_delay;
var t_dep5 integer >= 70968,<= 70968+TO_delay;
var t_dep6 integer >= 40812,<= 40812+TO_delay;
var t_dep7 integer >= 20272,<= 20272+TO_delay;
var t_dep8 integer >= 59004,<= 59004+TO_delay;
var t_dep9 integer >= 33329,<= 33329+TO_delay;
var t_dep10 integer >= 39840,<= 39840+TO_delay;
var t_dep11 integer >= 20769,<= 20769+TO_delay;
var t_dep12 integer >= 38496,<= 38496+TO_delay;
var t_dep13 integer >= 15008,<= 15008+TO_delay;
var t_dep14 integer >= 16601,<= 16601+TO_delay;
var t_dep15 integer >= 38197,<= 38197+TO_delay;
var t_dep16 integer >= 47078,<= 47078+TO_delay;
var t_dep17 integer >= 70053,<= 70053+TO_delay;
var t_dep18 integer >= 35454,<= 35454+TO_delay;
var t_dep19 integer >= 33465,<= 33465+TO_delay;
var t_dep20 integer >= 62315,<= 62315+TO_delay;
var t_dep21 integer >= 29805,<= 29805+TO_delay;
var t_dep22 integer >= 26121,<= 26121+TO_delay;
var t_dep23 integer >= 39283,<= 39283+TO_delay;
var t_dep24 integer >= 65941,<= 65941+TO_delay;
var t_dep25 integer >= 55926,<= 55926+TO_delay;
var t_dep26 integer >= 32024,<= 32024+TO_delay;
var t_dep27 integer >= 28612,<= 28612+TO_delay;
var t_dep28 integer >= 36934,<= 36934+TO_delay;
var t_dep29 integer >= 15411,<= 15411+TO_delay;
var t_dep30 integer >= 22361,<= 22361+TO_delay;
var t_dep31 integer >= 31549,<= 31549+TO_delay;
var t_dep32 integer >= 60211,<= 60211+TO_delay;
var t_dep33 integer >= 25469,<= 25469+TO_delay;
var t_dep34 integer >= 19234,<= 19234+TO_delay;
var t_dep35 integer >= 44387,<= 44387+TO_delay;
var t_dep36 integer >= 62910,<= 62910+TO_delay;
var t_dep37 integer >= 55144,<= 55144+TO_delay;
var t_dep38 integer >= 33721,<= 33721+TO_delay;
var t_dep39 integer >= 78844,<= 78844+TO_delay;
var t_dep40 integer >= 16716,<= 16716+TO_delay;
var t_dep41 integer >= 52230,<= 52230+TO_delay;
var t_dep42 integer >= 74806,<= 74806+TO_delay;
var t_dep43 integer >= 30126,<= 30126+TO_delay;
var t_dep44 integer >= 41490,<= 41490+TO_delay;
var t_dep45 integer >= 33559,<= 33559+TO_delay;
var t_dep46 integer >= 21545,<= 21545+TO_delay;
var t_dep47 integer >= 66465,<= 66465+TO_delay;
var t_dep48 integer >= 71581,<= 71581+TO_delay;
var t_dep49 integer >= 27928,<= 27928+TO_delay;
var t_dep50 integer >= 53024,<= 53024+TO_delay;
var t_dep51 integer >= 28904,<= 28904+TO_delay;
var t_dep52 integer >= 18397,<= 18397+TO_delay;
var t_dep53 integer >= 61803,<= 61803+TO_delay;
var t_dep54 integer >= 24202,<= 24202+TO_delay;
var t_dep55 integer >= 33223,<= 33223+TO_delay;
var t_dep56 integer >= 52496,<= 52496+TO_delay;
var t_dep57 integer >= 57370,<= 57370+TO_delay;
var t_dep58 integer >= 20889,<= 20889+TO_delay;
var t_dep59 integer >= 60289,<= 60289+TO_delay;
var t_dep60 integer >= 42298,<= 42298+TO_delay;
var t_dep61 integer >= 17143,<= 17143+TO_delay;
var t_dep62 integer >= 49601,<= 49601+TO_delay;
var t_dep63 integer >= 18175,<= 18175+TO_delay;
var t_dep64 integer >= 39503,<= 39503+TO_delay;
var t_dep65 integer >= 51499,<= 51499+TO_delay;
var t_dep66 integer >= 28243,<= 28243+TO_delay;
var t_dep67 integer >= 45391,<= 45391+TO_delay;
var t_dep68 integer >= 63239,<= 63239+TO_delay;
var t_dep69 integer >= 16366,<= 16366+TO_delay;
var t_dep70 integer >= 14750,<= 14750+TO_delay;
var t_dep71 integer >= 23805,<= 23805+TO_delay;
var t_dep72 integer >= 26769,<= 26769+TO_delay;
var t_dep73 integer >= 30645,<= 30645+TO_delay;
var t_dep74 integer >= 44792,<= 44792+TO_delay;
var t_dep75 integer >= 49473,<= 49473+TO_delay;
var t_dep76 integer >= 50767,<= 50767+TO_delay;
var t_dep77 integer >= 17032,<= 17032+TO_delay;
var t_dep78 integer >= 52685,<= 52685+TO_delay;
var t_dep79 integer >= 56522,<= 56522+TO_delay;
var t_dep80 integer >= 60000,<= 60000+TO_delay;
var t_dep81 integer >= 65463,<= 65463+TO_delay;
var t_dep82 integer >= 18586,<= 18586+TO_delay;
var t_dep83 integer >= 20988,<= 20988+TO_delay;
var t_dep84 integer >= 63882,<= 63882+TO_delay;
var t_dep85 integer >= 30518,<= 30518+TO_delay;
var t_dep86 integer >= 65598,<= 65598+TO_delay;
var t_dep87 integer >= 75008,<= 75008+TO_delay;
var t_dep88 integer >= 59799,<= 59799+TO_delay;
var t_dep89 integer >= 22747,<= 22747+TO_delay;
var t_dep90 integer >= 68897,<= 68897+TO_delay;
var t_dep91 integer >= 29104,<= 29104+TO_delay;
var t_dep92 integer >= 57757,<= 57757+TO_delay;
var t_dep93 integer >= 50100,<= 50100+TO_delay;
var t_dep94 integer >= 50231,<= 50231+TO_delay;
var t_dep95 integer >= 29609,<= 29609+TO_delay;

##### Objective function #####

#minimize Delay{a in A}: sum{p in AP[a]} x[a,p] * abs(ETA[a] - RTA[p]);	# minimizing the delay for each profile selected
#minimize Delay: sum{a in A,p in AP[a]} x[a,p] * abs(ETA[a] - RTA[p]);
minimize Fuel: sum{a in A,p in AP[a]} x[a,p] * FUEL[p];	# minimizing the delay for each profile selected

##### Constraints #####

subject to Oneprofile{a in A}: sum{p in AP[a]} x[a,p] = 1;						# only one profile per aircraft

subject to IncompatibleProfiles {(i,q,j,r) in IP}: x[i,q] + x[j,r] <= 1;				# incompatibles profiles can't both be selected

subject to Dep3{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep1) <= M*y1[a,p];	# arriving a/c cannot arrive too late, before departing a/c 1
subject to Dep4{a in A, p in AP[a]}: (t_dep1 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y1[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 1

subject to Dep5{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep2) <= M*y2[a,p];	# arriving a/c cannot arrive too late, before departing a/c 2
subject to Dep6{a in A, p in AP[a]}: (t_dep2 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y2[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 2

subject to Dep7{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep3) <= M*y3[a,p];	# arriving a/c cannot arrive too late, before departing a/c 3
subject to Dep8{a in A, p in AP[a]}: (t_dep3 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y3[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 3

subject to Dep9{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep4) <= M*y4[a,p];	# arriving a/c cannot arrive too late, before departing a/c 4
subject to Dep10{a in A, p in AP[a]}: (t_dep4 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y4[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 4

subject to Dep11{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep5) <= M*y5[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep12{a in A, p in AP[a]}: (t_dep5 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y5[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep13{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep6) <= M*y6[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep14{a in A, p in AP[a]}: (t_dep6 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y6[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep15{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep7) <= M*y7[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep16{a in A, p in AP[a]}: (t_dep7 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y7[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep17{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep8) <= M*y8[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep18{a in A, p in AP[a]}: (t_dep8 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y8[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep19{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep9) <= M*y9[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep20{a in A, p in AP[a]}: (t_dep9 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y9[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep21{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep10) <= M*y10[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep22{a in A, p in AP[a]}: (t_dep10 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y10[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep23{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep11) <= M*y11[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep24{a in A, p in AP[a]}: (t_dep11 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y11[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep25{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep12) <= M*y12[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep26{a in A, p in AP[a]}: (t_dep12 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y12[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep27{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep13) <= M*y13[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep28{a in A, p in AP[a]}: (t_dep13 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y13[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep29{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep14) <= M*y14[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep30{a in A, p in AP[a]}: (t_dep14 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y14[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep31{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep15) <= M*y15[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep32{a in A, p in AP[a]}: (t_dep15 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y15[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep33{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep16) <= M*y16[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep34{a in A, p in AP[a]}: (t_dep16 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y16[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep35{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep17) <= M*y17[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep36{a in A, p in AP[a]}: (t_dep17 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y17[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep37{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep18) <= M*y18[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep38{a in A, p in AP[a]}: (t_dep18 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y18[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep39{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep19) <= M*y19[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep40{a in A, p in AP[a]}: (t_dep19 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y19[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep41{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep20) <= M*y20[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep42{a in A, p in AP[a]}: (t_dep20 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y20[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep43{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep21) <= M*y21[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep44{a in A, p in AP[a]}: (t_dep21 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y21[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep45{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep22) <= M*y22[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep46{a in A, p in AP[a]}: (t_dep22 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y22[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep47{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep23) <= M*y23[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep48{a in A, p in AP[a]}: (t_dep23 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y23[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep49{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep24) <= M*y24[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep50{a in A, p in AP[a]}: (t_dep24 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y24[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep51{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep25) <= M*y25[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep52{a in A, p in AP[a]}: (t_dep25 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y25[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep53{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep26) <= M*y26[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep54{a in A, p in AP[a]}: (t_dep26 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y26[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep55{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep27) <= M*y27[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep56{a in A, p in AP[a]}: (t_dep27 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y27[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep57{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep28) <= M*y28[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep58{a in A, p in AP[a]}: (t_dep28 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y28[a,p]);	# arriving a/c cannot arrive too early, after departing a/c 5

subject to Dep59{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep29) <= M*y29[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep60{a in A, p in AP[a]}: (t_dep29 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y29[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep61{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep30) <= M*y30[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep62{a in A, p in AP[a]}: (t_dep30 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y30[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep63{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep31) <= M*y31[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep64{a in A, p in AP[a]}: (t_dep31 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y31[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep65{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep32) <= M*y32[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep66{a in A, p in AP[a]}: (t_dep32 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y32[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep67{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep33) <= M*y33[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep68{a in A, p in AP[a]}: (t_dep33 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y33[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep69{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep34) <= M*y34[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep70{a in A, p in AP[a]}: (t_dep34 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y34[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep71{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep35) <= M*y35[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep72{a in A, p in AP[a]}: (t_dep35 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y35[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep73{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep36) <= M*y36[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep74{a in A, p in AP[a]}: (t_dep36 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y36[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep75{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep37) <= M*y37[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep76{a in A, p in AP[a]}: (t_dep37 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y37[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep77{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep38) <= M*y38[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep78{a in A, p in AP[a]}: (t_dep38 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y38[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep79{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep39) <= M*y39[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep80{a in A, p in AP[a]}: (t_dep39 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y39[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep81{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep40) <= M*y40[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep82{a in A, p in AP[a]}: (t_dep40 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y40[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep83{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep41) <= M*y41[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep84{a in A, p in AP[a]}: (t_dep41 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y41[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep85{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep42) <= M*y42[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep86{a in A, p in AP[a]}: (t_dep42 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y42[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep87{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep43) <= M*y43[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep88{a in A, p in AP[a]}: (t_dep43 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y43[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep89{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep44) <= M*y44[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep90{a in A, p in AP[a]}: (t_dep44 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y44[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep91{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep45) <= M*y45[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep92{a in A, p in AP[a]}: (t_dep45 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y45[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep93{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep46) <= M*y46[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep94{a in A, p in AP[a]}: (t_dep46 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y46[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep95{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep47) <= M*y47[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep96{a in A, p in AP[a]}: (t_dep47 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y47[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep97{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep48) <= M*y48[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep98{a in A, p in AP[a]}: (t_dep48 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y48[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep99{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep49) <= M*y49[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep100{a in A, p in AP[a]}: (t_dep49 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y49[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep101{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep50) <= M*y50[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep102{a in A, p in AP[a]}: (t_dep50 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y50[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep103{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep51) <= M*y51[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep104{a in A, p in AP[a]}: (t_dep51 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y51[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep105{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep52) <= M*y52[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep106{a in A, p in AP[a]}: (t_dep52 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y52[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep107{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep53) <= M*y53[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep108{a in A, p in AP[a]}: (t_dep53 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y53[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep109{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep54) <= M*y54[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep110{a in A, p in AP[a]}: (t_dep54 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y54[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep111{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep55) <= M*y55[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep112{a in A, p in AP[a]}: (t_dep55 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y55[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep113{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep56) <= M*y56[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep114{a in A, p in AP[a]}: (t_dep56 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y56[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep115{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep57) <= M*y57[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep116{a in A, p in AP[a]}: (t_dep57 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y57[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep117{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep58) <= M*y58[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep118{a in A, p in AP[a]}: (t_dep58 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y58[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep119{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep59) <= M*y59[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep120{a in A, p in AP[a]}: (t_dep59 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y59[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep121{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep60) <= M*y60[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep122{a in A, p in AP[a]}: (t_dep60 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y60[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep123{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep61) <= M*y61[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep124{a in A, p in AP[a]}: (t_dep61 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y61[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep125{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep62) <= M*y62[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep126{a in A, p in AP[a]}: (t_dep62 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y62[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep127{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep63) <= M*y63[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep128{a in A, p in AP[a]}: (t_dep63 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y63[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep129{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep64) <= M*y64[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep130{a in A, p in AP[a]}: (t_dep64 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y64[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep131{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep65) <= M*y65[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep132{a in A, p in AP[a]}: (t_dep65 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y65[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep133{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep66) <= M*y66[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep134{a in A, p in AP[a]}: (t_dep66 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y66[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep135{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep67) <= M*y67[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep136{a in A, p in AP[a]}: (t_dep67 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y67[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep137{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep68) <= M*y68[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep138{a in A, p in AP[a]}: (t_dep68 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y68[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep139{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep69) <= M*y69[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep140{a in A, p in AP[a]}: (t_dep69 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y69[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep141{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep70) <= M*y70[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep142{a in A, p in AP[a]}: (t_dep70 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y70[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep143{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep71) <= M*y71[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep144{a in A, p in AP[a]}: (t_dep71 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y71[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep145{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep72) <= M*y72[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep146{a in A, p in AP[a]}: (t_dep72 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y72[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep147{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep73) <= M*y73[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep148{a in A, p in AP[a]}: (t_dep73 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y73[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep149{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep74) <= M*y74[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep150{a in A, p in AP[a]}: (t_dep74 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y74[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep151{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep75) <= M*y75[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep152{a in A, p in AP[a]}: (t_dep75 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y75[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep153{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep76) <= M*y76[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep154{a in A, p in AP[a]}: (t_dep76 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y76[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep155{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep77) <= M*y77[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep156{a in A, p in AP[a]}: (t_dep77 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y77[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep157{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep78) <= M*y78[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep158{a in A, p in AP[a]}: (t_dep78 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y78[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep159{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep79) <= M*y79[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep160{a in A, p in AP[a]}: (t_dep79 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y79[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep161{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep80) <= M*y80[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep162{a in A, p in AP[a]}: (t_dep80 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y80[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep163{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep81) <= M*y81[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep164{a in A, p in AP[a]}: (t_dep81 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y81[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep165{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep82) <= M*y82[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep166{a in A, p in AP[a]}: (t_dep82 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y82[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep167{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep83) <= M*y83[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep168{a in A, p in AP[a]}: (t_dep83 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y83[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep169{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep84) <= M*y84[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep170{a in A, p in AP[a]}: (t_dep84 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y84[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep171{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep85) <= M*y85[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep172{a in A, p in AP[a]}: (t_dep85 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y85[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep173{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep86) <= M*y86[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep174{a in A, p in AP[a]}: (t_dep86 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y86[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep175{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep87) <= M*y87[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep176{a in A, p in AP[a]}: (t_dep87 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y87[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep177{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep88) <= M*y88[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep178{a in A, p in AP[a]}: (t_dep88 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y88[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep179{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep89) <= M*y89[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep180{a in A, p in AP[a]}: (t_dep89 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y89[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep181{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep90) <= M*y90[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep182{a in A, p in AP[a]}: (t_dep90 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y90[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep183{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep91) <= M*y91[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep184{a in A, p in AP[a]}: (t_dep91 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y91[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep185{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep92) <= M*y92[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep186{a in A, p in AP[a]}: (t_dep92 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y92[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep187{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep93) <= M*y93[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep188{a in A, p in AP[a]}: (t_dep93 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y93[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep189{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep94) <= M*y94[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep190{a in A, p in AP[a]}: (t_dep94 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y94[a,p]);	# arriving a/c cannot arrive too early, after departing a

subject to Dep191{a in A, p in AP[a]}: (225 + sep_1 + x[a,p]*(RTA[p] - 1554854400) - t_dep95) <= M*y95[a,p];	# arriving a/c cannot arrive too late, before departing a/c 5
subject to Dep192{a in A, p in AP[a]}: (t_dep95 - x[a,p]*(RTA[p] - 1554854400) - (225 - sep_2)) <= M*(1-y95[a,p]);	# arriving a/c cannot arrive too early, after departing a