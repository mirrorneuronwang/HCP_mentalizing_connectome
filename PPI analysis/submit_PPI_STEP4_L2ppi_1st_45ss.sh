#!/bin/sh
#PBS -N tom_PPI_STEP4_L2ppi_small_size_1st_45ss
#PBS -q normal
#PBS -l nodes=4:ppn=28
#PBS -l walltime=12:00:00
#PBS

cd $PBS_O_WORKDIR

module load fsl/5.0.10
fslinit

rm -f cmd_${PBS_JOBID}.txt
touch cmd_${PBS_JOBID}.txt


for subj in `cat sublist_1st_45ss`; do
  for H in R L; do
    for PPItype in partial; do
      for PPIseed in TPJ PreC ATL VMPFC DMPFC; do

        SCRIPTNAME=L2ppi.txt
        echo bash $SCRIPTNAME $subj $H $PPIseed $PPItype >> cmd_${PBS_JOBID}.txt

      done
    done
  done
done

torque-launch -p chkpt_${PBS_JOBID}.txt cmd_${PBS_JOBID}.txt

# To save disk space, we need to delete the L1 results in tfMRI_SOCIAL_LR and tfMRI_SOCIAL_RL (each ~9GB)
for subj in `cat sublist_1st_45ss`; do
	rm -rf /home/work/tom_PPI/fsl/${subj}/MNINonLinear/Results/tfMRI_SOCIAL_LR
	rm -rf /home/work/tom_PPI/fsl/${subj}/MNINonLinear/Results/tfMRI_SOCIAL_RL
done