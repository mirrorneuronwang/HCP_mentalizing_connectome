for s in L_TPJ_L_PreC L_TPJ_L_ATL L_TPJ_L_VMPFC L_TPJ_L_DMPFC L_PreC_L_ATL L_PreC_L_VMPFC L_PreC_L_DMPFC L_ATL_L_VMPFC L_ATL_L_DMPFC L_VMPFC_L_DMPFC R_TPJ_R_PreC R_TPJ_R_ATL R_TPJ_R_VMPFC R_TPJ_R_DMPFC R_PreC_R_ATL R_PreC_R_VMPFC R_PreC_R_DMPFC R_ATL_R_VMPFC R_ATL_R_DMPFC R_VMPFC_R_DMPFC 
do
  mkdir -p /path/tract_roi_to_roi_excl_25000/${s}
  for n in 263436 627549
  do
     probtrackx2 --network -x /path/seeds_targets/${n}/${s}.txt  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 25000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm=/data/projects/fmri/${n}/MNINonLinear/xfms/standard2acpc_dc.nii.gz --invxfm=/data/projects/fmri/${n}/MNINonLinear/xfms/acpc_dc2standard.nii.gz --avoid=/path/cerebellum_mask.nii.gz --forcedir --opd -s /gpfs/projects/fmri/bedpostX_gpu_g_rician/${n}.bedpostX/merged -m  /gpfs/projects/fmri/bedpostX_gpu_g_rician/${n}.bedpostX/nodif_brain_mask  --dir=/path/tract_roi_to_roi_excl_25000/${s}/${n}
  done
done