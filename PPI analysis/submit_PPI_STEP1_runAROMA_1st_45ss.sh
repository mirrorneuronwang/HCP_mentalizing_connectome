#!/bin/bash
#PBS -N tom_PPI_STEP1_runAROMA_1st_45ss
#PBS -q normal
#PBS -l nodes=4:ppn=28
#PBS -l walltime=24:00:00
#PBS

cd $PBS_O_WORKDIR

source myenv/bin/activate

module load fsl/5.0.10
source ${FSLDIR}/etc/fslconf/fsl.sh

rm -f cmd_${PBS_JOBID}.txt
touch cmd_${PBS_JOBID}.txt


for task in SOCIAL; do
    for subj in `cat sublist_1st_45ss`; do 
	for RUN in LR RL; do

		SCRIPTNAME=runAROMA.txt
		echo bash $SCRIPTNAME $task $RUN $subj >> cmd_${PBS_JOBID}.txt

	done
    done
done

torque-launch -p chkpt_${PBS_JOBID}.txt cmd_${PBS_JOBID}.txt

