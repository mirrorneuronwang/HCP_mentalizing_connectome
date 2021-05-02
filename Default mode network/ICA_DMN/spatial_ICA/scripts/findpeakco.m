%find the coordinates of the maximum
for i=1:9%length(sublist)
compfile=['D:\matlabsoft\GroupICATv4.0a\icatb\icatb_templates\Converted_3D_files\groupICA2\wy2_sub00', mat2str(i),'_component_ica_s1__00011.nii'];
comp_hdr = spm_vol(compfile);
comp_vol = spm_read_vols(comp_hdr);
comp_ind = reshape(comp_vol~=0,1,[]);
[dim1,dim2,dim3]=size(comp_vol);
comp_mask_vol=comp_vol.* mask_vol; %only select voxels in the mask
[C,I]=max(comp_mask_vol(:));
[cor(:,1),cor(:,2),cor(:,3)]=ind2sub([dim1,dim2,dim3],I);
mni = cor2mni(cor,T);

TPJ_r(i,1:3)=mni;
TPJ_r(i,4)=C;

end

%change a new mask
maskfile=['ICA11_0.15_TPJ_r_mask.nii'];
mask_hdr = spm_vol(maskfile);
mask_vol = spm_read_vols(mask_hdr);
mask_ind = reshape(mask_vol~=0,1,[]);
[vec1,vec2,vec3]=size(mask_vol);

%split the mask into two hemispheres
for x=1:91
    
if x > 46 
    
    mask_vol(x,:,:)=0;
    
end
end
mask_hdr.fname='pfc_l_mask.nii';
mask_hdr.dt=[16,0]; % 
spm_write_vol(mask_hdr,mask_vol);


for z=1:91
    
if z <= 37 
    
    mask_vol(:,:,z)=0;
    
end
end
mask_hdr.fname='dmpfc_r_mask.nii';
mask_hdr.dt=[16,0]; % 
spm_write_vol(mask_hdr,mask_vol);


%for each subject, calculate the Eucledian distance between peak coordinates and neurosynth coordinates 

 D=pdist(TPJ_r,'euclidean');
 D_real=D.* 0.2;
 find(D_real(1,1:672)>10);
 TPJ_r_dis=D_real(1,1:672)';
 
 







for i=662:length(sublist)
    
    gunzip(['/HeLabData2/HCP1200/rfMRI_REST2_preproc/',mat2str(sublist(i)),'/MNINonLinear/Results/rfMRI_REST2_LR/rfMRI_REST2_LR_hp2000_clean.nii.gz'],['/home/ymxia/HCP_wangyin/FunImgARW/',mat2str(sublist(i)),'/rfMRI_REST2_LR']);
    
    gunzip(['/HeLabData2/HCP1200/rfMRI_REST2_preproc/',mat2str(sublist(i)),'/MNINonLinear/Results/rfMRI_REST2_RL/rfMRI_REST2_RL_hp2000_clean.nii.gz'],['/home/ymxia/HCP_wangyin/FunImgARW/',mat2str(sublist(i)),'/rfMRI_REST2_RL']);
    
end

subname=dir('REST2/*');

for i=662:length(subname);
movefile(['REST2/',mat2str(sublist(i)),'/rfMRI_REST2_LR'],['REST1/',mat2str(sublist(i)),'/']);
movefile(['REST2/',mat2str(sublist(i)),'/rfMRI_REST2_RL'],['REST1/',mat2str(sublist(i)),'/']);
end
