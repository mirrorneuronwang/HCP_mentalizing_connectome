#!/bin/sh
#PBS -N tom_PPI_STEP3_L1ppi_1st_45ss
#PBS -q normal
#PBS -l nodes=12:ppn=28
#PBS -l walltime=48:00:00
#PBS

cd $PBS_O_WORKDIR

module load fsl/5.0.10
fslinit

rm -f cmd_${PBS_JOBID}.txt
touch cmd_${PBS_JOBID}.txt

for subj in `cat sublist_1st_45ss`; do
  for RUN in LR RL; do
    for H in R L; do
      for PPItype in partial; do
        for PPIseed in TPJ PreC ATL VMPFC DMPFC; do

          SCRIPTNAME=L1ppi.txt
          echo bash $SCRIPTNAME $RUN $subj $H $PPIseed $PPItype  >> cmd_${PBS_JOBID}.txt

        done
      done
    done
  done
done

torque-launch -p chkpt_${PBS_JOBID}.txt cmd_${PBS_JOBID}.txt
