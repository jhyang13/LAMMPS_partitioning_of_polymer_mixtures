#!/bin/bash 

NP=1
NSETS=1
INCR=0.05 # step size for epsilon

for L in 50
do
	for H in 100
	do
		for NA in 50 75 100 125
		do
			for PHIA in 0.0075
			do
				for NB in 30
				do
					for PHIB in 0
					do
						for R in 2.21
						do
							for D in 50
							do
								for EPS in 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00
								do 
									for REP in $(seq -f "%03g" 2 5)
									do
										for DATE in 20220712
										do
									
											DIR="${DATE}_L${L}_N${NA}_EPS${EPS}_${REP}"
											mkdir $DIR
											cp templates/in.critical templates/job.pbs $DIR
											cd $DIR
	
											python3 ../chain.py $NA
								
											HBOX=$(bc <<< "scale=2;$L/2")	
											ZLO=$(bc <<< "scale=2;$D+1")
											ZHI=$(bc <<< "scale=2;$H")
											RADHI=$(bc <<< "scale=2;$R+$R")
											LO=$(bc <<< "scale=2;$RADHI-$R")
											RAD=$(bc <<< "scale=2;$R-0.21")
											LENGTH=$(bc <<< "scale=2;$D-$R")
											#EPSILON=$(bc <<< "scale=2;$EPS*$INCR")
											RANDOM1=$RANDOM
											RANDOM2=$RANDOM
											RANDOM3=$RANDOM
											RANDOM4=$RANDOM
											sed '{s/{RAND1}/'"$RANDOM1"'/g}' < in.critical > tmp1
											sed '{s/{HBOX}/'"$HBOX"'/g}' < tmp1 > tmp2
											sed '{s/{EPS}/'"$EPS"'/g}' < tmp2 > tmp3
											sed '{s/{D}/'"$D"'/g}' < tmp3 > tmp4
											sed '{s/{R}/'"$R"'/g}' < tmp4 > tmp5
											sed '{s/{RADHI}/'"$RADHI"'/g}' < tmp5 > tmp6
											sed '{s/{ZLO}/'"$ZLO"'/g}' < tmp6 > tmp7
											sed '{s/{ZHI}/'"$ZHI"'/g}' < tmp7 > tmp8
											sed '{s/{LO}/'"$LO"'/g}' < tmp8 > tmp9
											sed '{s/{RAND2}/'"$RANDOM2"'/g}' < tmp9 > tmp10
											sed '{s/{RAND3}/'"$RANDOM3"'/g}' < tmp10 > tmp11
											sed '{s/{RAND4}/'"$RANDOM4"'/g}' < tmp11 > tmp12
											sed '{s/{LENGTH}/'"$LENGTH"'/g}' < tmp12 > tmp13
											sed '{s/{RAD}/'"$RAD"'/g}' < tmp13 > tmp14
											mv tmp14 in.run
											rm tmp* in.critical

											sed '{s/{NP}/'"$NP"'/g}' < job.pbs > tmp1
											sed '{s/{DIR}/'"$DIR"'/g}' < tmp1 > tmp2
											mv tmp2 job.pbs
											rm tmp*	
											
											qsub job.pbs 
											cd ..
	 									
										done
									done
								done
							done
						done
					done
				done
			done
		done
	done
done