function counting_overlap_voxels_tom(dir_base, name_subj,probabilistic_tractography,all_fiber_mask)
% This function will calculate the voxel overlap between FSL-probtrack fibers and AFQ fibers
% INPUT
% dir_base: the directory level containng all subjects folder, e.g. dir_base = 'C:\Users\Desktop\AFQ_test';
% name_subj: the current subject folder, e.g. name_subj = '100206';
% probabilistic_tractography: the folder name storing all results from FSL probtrack. e.g. 'probabilistic_tractography_tom';
% all_fiber_mask: a new folder will be created by this function where all probtrack and AFQ fiber masks will be stored. e.g.  'all_fiber_mask_tom'; 
% OUTPUT
% this function will create a mat file called 'AFQ_Probtrax_overlap_data.mat' in 'all_fiber_mask' folder
% 
% To run this script, you also need to install jason yeatman's AFQ toolbox, and Brian Wandell's VISTASOFT (e.g. load_nii)
% This script is created by Dr. Yin Wang from Temple University



%%% following is just for testing this function, DON'T USE
% dir_base = 'C:\Users\Desktop\AFQ_test';
% name_subj = '100206'; % need to specify every time
% probabilistic_tractography = 'probabilistic_tractography_tom';
% all_fiber_mask = 'all_fiber_mask_tom';

fs = filesep; % platform-specific file separator

sub_dir = fullfile(dir_base,name_subj);
cd(sub_dir); mkdir(all_fiber_mask); % all fiber masks will be saved here
fiber_dir = fullfile(sub_dir,all_fiber_mask); %% Where we will do all fiber overlap percentage analysis

%% copy probabilistic_tractography masks to all_fiber_mask folder 
cd(fullfile(sub_dir,probabilistic_tractography));

%get all track names  %%% need to change if its a unilateral region such as VTA
a=dir('L*'); b=dir('R*'); 
probtrack_names = [{a.name},{b.name}]'; 
clear a b
% probtrack_names = [ls('L*');ls('R*')]; % this is for windows system 

for i=1: size(probtrack_names,1)
    cd(fullfile(sub_dir,probabilistic_tractography,probtrack_names{i,:}));
    oldfilename = ['fdt_paths_native_sd_thr01_bin.nii.gz'];  %%% can be changed to 5% percentage threshold (P5/P25)
    newfilename = [fiber_dir,fs,probtrack_names{i,:},'_',oldfilename];
    copyfile(oldfilename,newfilename);
end

%% copy AFQ output (reslieced, r-prefix) fiber masks to all_fiber_mask folder 
cd(fullfile(sub_dir,'fibers'));
copyfile('rLeft*_binary.nii.gz',fiber_dir);
copyfile('rRight*_binary.nii.gz',fiber_dir);
copyfile('rCallosum*_binary.nii.gz',fiber_dir)


%% fiber names from ProbtrackX and AFQ 
%% afqpt is a domain storing all information for probalistic tractography and afq
afqpt.AFQ_fiber_name_left={'Left_Thalamic_Radiation'
    'Left_Corticospinal'
    'Left_Cingulum_Cingulate'
    'Left_Cingulum_Hippocampus'
    'Callosum_Forceps_Major'
    'Callosum_Forceps_Minor'
    'Left_IFOF'
    'Left_ILF'
    'Left_SLF'
    'Left_Uncinate'
    'Left_Arcuate'};

afqpt.AFQ_fiber_name_right={'Right_Thalamic_Radiation'
    'Right_Corticospinal'
    'Right_Cingulum_Cingulate'
    'Right_Cingulum_Hippocampus'
    'Callosum_Forceps_Major'
    'Callosum_Forceps_Minor'
    'Right_IFOF'
    'Right_ILF'
    'Right_SLF'
    'Right_Uncinate'
    'Right_Arcuate'};

afqpt.probtrackROI_left={'L_OcG','L_FuG','L_TPJ','L_PreC','L_AMG','L_ATL','L_IFG','L_VMPFC','L_DMPFC','L_SPL'};  %% Our project mainly focused on five mentalizing ROIs, but for exploratory analysis, we examined 10 mentalizing related ROIs
afqpt.probtrackROI_right={'R_OcG','R_FuG','R_TPJ','R_PreC','R_AMG','R_ATL','R_IFG','R_VMPFC','R_DMPFC','R_SPL'};

afqpt.probtract_left = {'L_OcG_L_OcG'   'L_FuG_L_OcG'   'L_OcG_L_TPJ'   'L_OcG_L_PreC'   'L_AMG_L_OcG'   'L_ATL_L_OcG'   'L_IFG_L_OcG'   'L_OcG_L_VMPFC'   'L_DMPFC_L_OcG'   'L_OcG_L_SPL'                            
'L_FuG_L_OcG'   'L_FuG_L_FuG'   'L_FuG_L_TPJ'   'L_FuG_L_PreC'   'L_AMG_L_FuG'   'L_ATL_L_FuG'   'L_FuG_L_IFG'   'L_FuG_L_VMPFC'   'L_DMPFC_L_FuG'   'L_FuG_L_SPL'                                                                                                                                                      
'L_OcG_L_TPJ'   'L_FuG_L_TPJ'   'L_TPJ_L_TPJ'   'L_PreC_L_TPJ'   'L_AMG_L_TPJ'   'L_ATL_L_TPJ'   'L_IFG_L_TPJ'   'L_TPJ_L_VMPFC'   'L_DMPFC_L_TPJ'   'L_SPL_L_TPJ'            
'L_OcG_L_PreC'  'L_FuG_L_PreC'  'L_PreC_L_TPJ'  'L_PreC_L_PreC'  'L_AMG_L_PreC'  'L_ATL_L_PreC'  'L_IFG_L_PreC'  'L_PreC_L_VMPFC'  'L_DMPFC_L_PreC'  'L_PreC_L_SPL'              
'L_AMG_L_OcG'   'L_AMG_L_FuG'   'L_AMG_L_TPJ'   'L_AMG_L_PreC'   'L_AMG_L_AMG'   'L_AMG_L_ATL'   'L_AMG_L_IFG'   'L_AMG_L_VMPFC'   'L_AMG_L_DMPFC'   'L_AMG_L_SPL'                  
'L_ATL_L_OcG'   'L_ATL_L_FuG'   'L_ATL_L_TPJ'   'L_ATL_L_PreC'   'L_AMG_L_ATL'   'L_ATL_L_ATL'   'L_ATL_L_IFG'   'L_ATL_L_VMPFC'   'L_ATL_L_DMPFC'   'L_ATL_L_SPL'                                                          
'L_IFG_L_OcG'   'L_FuG_L_IFG'   'L_IFG_L_TPJ'   'L_IFG_L_PreC'   'L_AMG_L_IFG'   'L_ATL_L_IFG'   'L_IFG_L_IFG'   'L_IFG_L_VMPFC'   'L_DMPFC_L_IFG'   'L_IFG_L_SPL'                                    
'L_OcG_L_VMPFC' 'L_FuG_L_VMPFC' 'L_TPJ_L_VMPFC' 'L_PreC_L_VMPFC' 'L_AMG_L_VMPFC' 'L_ATL_L_VMPFC' 'L_IFG_L_VMPFC' 'L_VMPFC_L_VMPFC' 'L_DMPFC_L_VMPFC' 'L_SPL_L_VMPFC'                                            
'L_DMPFC_L_OcG' 'L_DMPFC_L_FuG' 'L_DMPFC_L_TPJ' 'L_DMPFC_L_PreC' 'L_AMG_L_DMPFC' 'L_ATL_L_DMPFC' 'L_DMPFC_L_IFG' 'L_DMPFC_L_VMPFC' 'L_DMPFC_L_DMPFC' 'L_DMPFC_L_SPL'                                                               
'L_OcG_L_SPL'   'L_FuG_L_SPL'   'L_SPL_L_TPJ'   'L_PreC_L_SPL'   'L_AMG_L_SPL'   'L_ATL_L_SPL'   'L_IFG_L_SPL'   'L_SPL_L_VMPFC'   'L_DMPFC_L_SPL'   'L_SPL_L_SPL'};

afqpt.probtract_right = {'R_OcG_R_OcG'   'R_FuG_R_OcG'   'R_OcG_R_TPJ'   'R_OcG_R_PreC'   'R_AMG_R_OcG'   'R_ATL_R_OcG'   'R_IFG_R_OcG'   'R_OcG_R_VMPFC'   'R_DMPFC_R_OcG'   'R_OcG_R_SPL'                            
'R_FuG_R_OcG'   'R_FuG_R_FuG'   'R_FuG_R_TPJ'   'R_FuG_R_PreC'   'R_AMG_R_FuG'   'R_ATL_R_FuG'   'R_FuG_R_IFG'   'R_FuG_R_VMPFC'   'R_DMPFC_R_FuG'   'R_FuG_R_SPL'                                                                                                                                                      
'R_OcG_R_TPJ'   'R_FuG_R_TPJ'   'R_TPJ_R_TPJ'   'R_PreC_R_TPJ'   'R_AMG_R_TPJ'   'R_ATL_R_TPJ'   'R_IFG_R_TPJ'   'R_TPJ_R_VMPFC'   'R_DMPFC_R_TPJ'   'R_SPL_R_TPJ'            
'R_OcG_R_PreC'  'R_FuG_R_PreC'  'R_PreC_R_TPJ'  'R_PreC_R_PreC'  'R_AMG_R_PreC'  'R_ATL_R_PreC'  'R_IFG_R_PreC'  'R_PreC_R_VMPFC'  'R_DMPFC_R_PreC'  'R_PreC_R_SPL'              
'R_AMG_R_OcG'   'R_AMG_R_FuG'   'R_AMG_R_TPJ'   'R_AMG_R_PreC'   'R_AMG_R_AMG'   'R_AMG_R_ATL'   'R_AMG_R_IFG'   'R_AMG_R_VMPFC'   'R_AMG_R_DMPFC'   'R_AMG_R_SPL'                  
'R_ATL_R_OcG'   'R_ATL_R_FuG'   'R_ATL_R_TPJ'   'R_ATL_R_PreC'   'R_AMG_R_ATL'   'R_ATL_R_ATL'   'R_ATL_R_IFG'   'R_ATL_R_VMPFC'   'R_ATL_R_DMPFC'   'R_ATL_R_SPL'                                                          
'R_IFG_R_OcG'   'R_FuG_R_IFG'   'R_IFG_R_TPJ'   'R_IFG_R_PreC'   'R_AMG_R_IFG'   'R_ATL_R_IFG'   'R_IFG_R_IFG'   'R_IFG_R_VMPFC'   'R_DMPFC_R_IFG'   'R_IFG_R_SPL'                                    
'R_OcG_R_VMPFC' 'R_FuG_R_VMPFC' 'R_TPJ_R_VMPFC' 'R_PreC_R_VMPFC' 'R_AMG_R_VMPFC' 'R_ATL_R_VMPFC' 'R_IFG_R_VMPFC' 'R_VMPFC_R_VMPFC' 'R_DMPFC_R_VMPFC' 'R_SPL_R_VMPFC'                                            
'R_DMPFC_R_OcG' 'R_DMPFC_R_FuG' 'R_DMPFC_R_TPJ' 'R_DMPFC_R_PreC' 'R_AMG_R_DMPFC' 'R_ATL_R_DMPFC' 'R_DMPFC_R_IFG' 'R_DMPFC_R_VMPFC' 'R_DMPFC_R_DMPFC' 'R_DMPFC_R_SPL'                                                               
'R_OcG_R_SPL'   'R_FuG_R_SPL'   'R_SPL_R_TPJ'   'R_PreC_R_SPL'   'R_AMG_R_SPL'   'R_ATL_R_SPL'   'R_IFG_R_SPL'   'R_SPL_R_VMPFC'   'R_DMPFC_R_SPL'   'R_SPL_R_SPL'};                                    

%%% final output percentage matrix will be something like this
%               'L_OcG'          'L_FuG'        'L_TPJ'         'L_PreC'         'L_AMG'         'L_ATL'         'L_IFG'         'L_VMPFC'         'L_DMPFC'         'L_SPL'
% 'L_OcG'    'L_OcG_L_OcG'   'L_FuG_L_OcG'   'L_OcG_L_TPJ'   'L_OcG_L_PreC'   'L_AMG_L_OcG'   'L_ATL_L_OcG'   'L_IFG_L_OcG'   'L_OcG_L_VMPFC'   'L_DMPFC_L_OcG'   'L_OcG_L_SPL'                            
% 'L_FuG'    'L_FuG_L_OcG'   'L_FuG_L_FuG'   'L_FuG_L_TPJ'   'L_FuG_L_PreC'   'L_AMG_L_FuG'   'L_ATL_L_FuG'   'L_FuG_L_IFG'   'L_FuG_L_VMPFC'   'L_DMPFC_L_FuG'   'L_FuG_L_SPL'                                                                                                                                                      
% 'L_TPJ'    'L_OcG_L_TPJ'   'L_FuG_L_TPJ'   'L_TPJ_L_TPJ'   'L_PreC_L_TPJ'   'L_AMG_L_TPJ'   'L_ATL_L_TPJ'   'L_IFG_L_TPJ'   'L_TPJ_L_VMPFC'   'L_DMPFC_L_TPJ'   'L_SPL_L_TPJ'            
% 'L_PreC'   'L_OcG_L_PreC'  'L_FuG_L_PreC'  'L_PreC_L_TPJ'  'L_PreC_L_PreC'  'L_AMG_L_PreC'  'L_ATL_L_PreC'  'L_IFG_L_PreC'  'L_PreC_L_VMPFC'  'L_DMPFC_L_PreC'  'L_PreC_L_SPL'              
% 'L_AMG'    'L_AMG_L_OcG'   'L_AMG_L_FuG'   'L_AMG_L_TPJ'   'L_AMG_L_PreC'   'L_AMG_L_AMG'   'L_AMG_L_ATL'   'L_AMG_L_IFG'   'L_AMG_L_VMPFC'   'L_AMG_L_DMPFC'   'L_AMG_L_SPL'                  
% 'L_ATL'    'L_ATL_L_OcG'   'L_ATL_L_FuG'   'L_ATL_L_TPJ'   'L_ATL_L_PreC'   'L_AMG_L_ATL'   'L_ATL_L_ATL'   'L_ATL_L_IFG'   'L_ATL_L_VMPFC'   'L_ATL_L_DMPFC'   'L_ATL_L_SPL'                                                          
% 'L_IFG'    'L_IFG_L_OcG'   'L_FuG_L_IFG'   'L_IFG_L_TPJ'   'L_IFG_L_PreC'   'L_AMG_L_IFG'   'L_ATL_L_IFG'   'L_IFG_L_IFG'   'L_IFG_L_VMPFC'   'L_DMPFC_L_IFG'   'L_IFG_L_SPL'                                    
% 'L_VMPFC'  'L_OcG_L_VMPFC' 'L_FuG_L_VMPFC' 'L_TPJ_L_VMPFC' 'L_PreC_L_VMPFC' 'L_AMG_L_VMPFC' 'L_ATL_L_VMPFC' 'L_IFG_L_VMPFC' 'L_VMPFC_L_VMPFC' 'L_DMPFC_L_VMPFC' 'L_SPL_L_VMPFC'                                            
% 'L_DMPFC'  'L_DMPFC_L_OcG' 'L_DMPFC_L_FuG' 'L_DMPFC_L_TPJ' 'L_DMPFC_L_PreC' 'L_AMG_L_DMPFC' 'L_ATL_L_DMPFC' 'L_DMPFC_L_IFG' 'L_DMPFC_L_VMPFC' 'L_DMPFC_L_DMPFC' 'L_DMPFC_L_SPL'                                                               
% 'L_SPL'    'L_OcG_L_SPL'   'L_FuG_L_SPL'   'L_SPL_L_TPJ'   'L_PreC_L_SPL'   'L_AMG_L_SPL'   'L_ATL_L_SPL'   'L_IFG_L_SPL'   'L_SPL_L_VMPFC'   'L_DMPFC_L_SPL'   'L_SPL_L_SPL'                                     


%               'R_OcG'          'R_FuG'        'R_TPJ'         'R_PreC'         'R_AMG'         'R_ATL'         'R_IFG'         'R_VMPFC'          'R_DMPFC'        'R_SPL'
% 'R_OcG'    'R_OcG_R_OcG'   'R_FuG_R_OcG'   'R_OcG_R_TPJ'   'R_OcG_R_PreC'   'R_AMG_R_OcG'   'R_ATL_R_OcG'   'R_IFG_R_OcG'   'R_OcG_R_VMPFC'   'R_DMPFC_R_OcG'   'R_OcG_R_SPL'                            
% 'R_FuG'    'R_FuG_R_OcG'   'R_FuG_R_FuG'   'R_FuG_R_TPJ'   'R_FuG_R_PreC'   'R_AMG_R_FuG'   'R_ATL_R_FuG'   'R_FuG_R_IFG'   'R_FuG_R_VMPFC'   'R_DMPFC_R_FuG'   'R_FuG_R_SPL'                                                                                                                                                      
% 'R_TPJ'    'R_OcG_R_TPJ'   'R_FuG_R_TPJ'   'R_TPJ_R_TPJ'   'R_PreC_R_TPJ'   'R_AMG_R_TPJ'   'R_ATL_R_TPJ'   'R_IFG_R_TPJ'   'R_TPJ_R_VMPFC'   'R_DMPFC_R_TPJ'   'R_SPL_R_TPJ'            
% 'R_PreC'   'R_OcG_R_PreC'  'R_FuG_R_PreC'  'R_PreC_R_TPJ'  'R_PreC_R_PreC'  'R_AMG_R_PreC'  'R_ATL_R_PreC'  'R_IFG_R_PreC'  'R_PreC_R_VMPFC'  'R_DMPFC_R_PreC'  'R_PreC_R_SPL'              
% 'R_AMG'    'R_AMG_R_OcG'   'R_AMG_R_FuG'   'R_AMG_R_TPJ'   'R_AMG_R_PreC'   'R_AMG_R_AMG'   'R_AMG_R_ATL'   'R_AMG_R_IFG'   'R_AMG_R_VMPFC'   'R_AMG_R_DMPFC'   'R_AMG_R_SPL'                  
% 'R_ATL'    'R_ATL_R_OcG'   'R_ATL_R_FuG'   'R_ATL_R_TPJ'   'R_ATL_R_PreC'   'R_AMG_R_ATL'   'R_ATL_R_ATL'   'R_ATL_R_IFG'   'R_ATL_R_VMPFC'   'R_ATL_R_DMPFC'   'R_ATL_R_SPL'                                                          
% 'R_IFG'    'R_IFG_R_OcG'   'R_FuG_R_IFG'   'R_IFG_R_TPJ'   'R_IFG_R_PreC'   'R_AMG_R_IFG'   'R_ATL_R_IFG'   'R_IFG_R_IFG'   'R_IFG_R_VMPFC'   'R_DMPFC_R_IFG'   'R_IFG_R_SPL'                                    
% 'R_VMPFC'  'R_OcG_R_VMPFC' 'R_FuG_R_VMPFC' 'R_TPJ_R_VMPFC' 'R_PreC_R_VMPFC' 'R_AMG_R_VMPFC' 'R_ATL_R_VMPFC' 'R_IFG_R_VMPFC' 'R_VMPFC_R_VMPFC' 'R_DMPFC_R_VMPFC' 'R_SPL_R_VMPFC'                                            
% 'R_DMPFC'  'R_DMPFC_R_OcG' 'R_DMPFC_R_FuG' 'R_DMPFC_R_TPJ' 'R_DMPFC_R_PreC' 'R_AMG_R_DMPFC' 'R_ATL_R_DMPFC' 'R_DMPFC_R_IFG' 'R_DMPFC_R_VMPFC' 'R_DMPFC_R_DMPFC' 'R_DMPFC_R_SPL'                                                               
% 'R_SPL'    'R_OcG_R_SPL'   'R_FuG_R_SPL'   'R_SPL_R_TPJ'   'R_PreC_R_SPL'   'R_AMG_R_SPL'   'R_ATL_R_SPL'   'R_IFG_R_SPL'   'R_SPL_R_VMPFC'   'R_DMPFC_R_SPL'   'R_SPL_R_SPL'                                     
        


%% unzip all fiber masks so that we can use the function load_nii
cd(fiber_dir);
gunzip('*.nii.gz'); 

%%% left hemisphere

for i=1:size(afqpt.probtrackROI_left,2)
    
    for j=1:size(afqpt.probtrackROI_left,2)
        
        if ~isempty(dir(['*',afqpt.probtract_left{i,j},'*.nii'])); %% if the probtract file exist (some subjects don't have one or two ROIs, so they don't have that ROI-pairwise tract)
            afqpt.ProbtrackX_tract_exist_LH(i,j) = 1;
            probtract_file_LH = dir(['*',afqpt.probtract_left{i,j},'*.nii']);
            ProbtrackX_fiber_images_LH = load_nii(probtract_file_LH.name);
            afqpt.count_ProbtrackX_voxels_LH(i,j) = sum(ProbtrackX_fiber_images_LH.img(:));  %%% the voxel number within the probatrack fibers
            
            for k=1:size(afqpt.AFQ_fiber_name_left,1)
                
                if ~isempty(dir(['*',afqpt.AFQ_fiber_name_left{k},'*.nii'])); %% if the AFQ tract file exist (AFQ might not be able to get all tracts for every subject)
                    afqpt.AFQ_tract_exist_LH(i,j,k) = 1;
                    %%% counting voxels in each fiber
                    AFQ_tract_file_LH = dir(['*',afqpt.AFQ_fiber_name_left{k},'*.nii']);
                    AFQ_fiber_images_LH= load_nii(AFQ_tract_file_LH.name);
                    afqpt.count_AFQ_voxels_LH(i,j,k) = sum(AFQ_fiber_images_LH.img(:));
                    
                    %%% counting overlap voxels between AFQ fiber mask and probabilistic fiber mask
                    overlapImage_LH = AFQ_fiber_images_LH.img & ProbtrackX_fiber_images_LH.img;
                    % To count number of pixels
                    afqpt.numOverlapPixels_LH(i,j,k) = nnz(overlapImage_LH);
                    afqpt.Percentage_OverlapPixels_LH(i,j,k)= afqpt.numOverlapPixels_LH(i,j,k)/afqpt.count_ProbtrackX_voxels_LH(i,j);
                    
                    clear AFQ_tract_file_LH AFQ_fiber_images_LH overlapImage_LH
                    
                else
                    afqpt.AFQ_tract_exist_LH(i,j,k) = 0;
                    afqpt.count_AFQ_voxels_LH(i,j,k) = NaN;
                    afqpt.numOverlapPixels_LH(i,j,k) = NaN;
                    afqpt.Percentage_OverlapPixels_LH(i,j,k) = NaN;
                end

            end
            
        else  %% if the ROI-pairwise tract does not exist
            afqpt.ProbtrackX_tract_exist_LH(i,j) = 0;
            afqpt.count_ProbtrackX_voxels_LH(i,j)= NaN;
     
            for k=1:size(afqpt.AFQ_fiber_name_left,1)
                
                if ~isempty(dir(['*',afqpt.AFQ_fiber_name_left{k},'*.nii'])); %% if the AFQ tract file exist (AFQ might not be able to get all tracts for every subject)
                    afqpt.AFQ_tract_exist_LH(i,j,k) = 1;
                    %%% counting voxels in each fiber
                    AFQ_tract_file_LH = dir(['*',afqpt.AFQ_fiber_name_left{k},'*.nii']);
                    AFQ_fiber_images_LH= load_nii(AFQ_tract_file_LH.name);
                    afqpt.count_AFQ_voxels_LH(i,j,k) = sum(AFQ_fiber_images_LH.img(:)); 
                    afqpt.numOverlapPixels_LH(i,j,k) = NaN;
                    afqpt.Percentage_OverlapPixels_LH(i,j,k)= NaN;
                    
                    clear AFQ_tract_file_LH AFQ_fiber_images_LH
                    
                else
                    afqpt.AFQ_tract_exist_LH(i,j,k) = 0;
                    afqpt.count_AFQ_voxels_LH(i,j,k) = NaN;
                    afqpt.numOverlapPixels_LH(i,j,k) = NaN;
                    afqpt.Percentage_OverlapPixels_LH(i,j,k) = NaN;
                end

            end
        end
        
        clear probtract_file_LH ProbtrackX_fiber_images_LH 
        
    end
end

%%% right hemisphere

for i=1:size(afqpt.probtrackROI_right,2)
    
    for j=1:size(afqpt.probtrackROI_right,2)
        
        if ~isempty(dir(['*',afqpt.probtract_right{i,j},'*.nii'])); %% if the probtract file exist (some subjects don't have one or two ROIs, so they don't have that ROI-pairwise tract)
            afqpt.ProbtrackX_tract_exist_RH(i,j) = 1;
            probtract_file_RH = dir(['*',afqpt.probtract_right{i,j},'*.nii']);
            ProbtrackX_fiber_images_RH = load_nii(probtract_file_RH.name);
            afqpt.count_ProbtrackX_voxels_RH(i,j) = sum(ProbtrackX_fiber_images_RH.img(:));  %%% the voxel number within the probatrack fibers
            
            for k=1:size(afqpt.AFQ_fiber_name_right,1)
                
                if ~isempty(dir(['*',afqpt.AFQ_fiber_name_right{k},'*.nii'])); %% if the AFQ tract file exist (AFQ might not be able to get all tracts for every subject)
                    afqpt.AFQ_tract_exist_RH(i,j,k) = 1;
                    %%% counting voxels in each fiber
                    AFQ_tract_file_RH = dir(['*',afqpt.AFQ_fiber_name_right{k},'*.nii']);
                    AFQ_fiber_images_RH= load_nii(AFQ_tract_file_RH.name);
                    afqpt.count_AFQ_voxels_RH(i,j,k) = sum(AFQ_fiber_images_RH.img(:));
                    
                    %%% counting overlap voxels between AFQ fiber mask and probabilistic fiber mask
                    overlapImage_RH = AFQ_fiber_images_RH.img & ProbtrackX_fiber_images_RH.img;
                    % To count number of pixels
                    afqpt.numOverlapPixels_RH(i,j,k) = nnz(overlapImage_RH);
                    afqpt.Percentage_OverlapPixels_RH(i,j,k)= afqpt.numOverlapPixels_RH(i,j,k)/afqpt.count_ProbtrackX_voxels_RH(i,j);
                    
                    clear AFQ_tract_file_RH AFQ_fiber_images_RH overlapImage_RH
                    
                else
                    afqpt.AFQ_tract_exist_RH(i,j,k) = 0;
                    afqpt.count_AFQ_voxels_RH(i,j,k) = NaN;
                    afqpt.numOverlapPixels_RH(i,j,k) = NaN;
                    afqpt.Percentage_OverlapPixels_RH(i,j,k) = NaN;
                end
            end
            
        else  %% if the ROI-pairwise tract does not exist
            afqpt.ProbtrackX_tract_exist_RH(i,j) = 0;
            afqpt.count_ProbtrackX_voxels_RH(i,j)= NaN;
     
            for k=1:size(afqpt.AFQ_fiber_name_right,1)
                
                if ~isempty(dir(['*',afqpt.AFQ_fiber_name_right{k},'*.nii'])); %% if the AFQ tract file exist (AFQ might not be able to get all tracts for every subject)
                    afqpt.AFQ_tract_exist_RH(i,j,k) = 1;
                    %%% counting voxels in each fiber
                    AFQ_tract_file_RH = dir(['*',afqpt.AFQ_fiber_name_right{k},'*.nii']);
                    AFQ_fiber_images_RH= load_nii(AFQ_tract_file_RH.name);
                    afqpt.count_AFQ_voxels_RH(i,j,k) = sum(AFQ_fiber_images_RH.img(:));
                    afqpt.numOverlapPixels_RH(i,j,k) = NaN;
                    afqpt.Percentage_OverlapPixels_RH(i,j,k)= NaN;
                    
                    clear AFQ_tract_file_RH AFQ_fiber_images_RH 
                    
                else
                    afqpt.AFQ_tract_exist_RH(i,j,k) = 0;
                    afqpt.count_AFQ_voxels_RH(i,j,k) = NaN;
                    afqpt.numOverlapPixels_RH(i,j,k) = NaN;
                    afqpt.Percentage_OverlapPixels_RH(i,j,k) = NaN;
                end
            end
        end
        
        clear probtract_file_RH ProbtrackX_fiber_images_RH 
        
    end
end

delete('*.nii') %% to save some space


save('AFQ_Probtrax_overlap_data.mat', 'afqpt');
% save('AFQ_Probtrax_overlap_data.mat',...   %%% file name saving all overlap information
% 'afqpt.Percentage_OverlapPixels_RH',...  %%% RIGHT HEMESPHERE the percentage of voxels in the probtrack fibers that overlaps with AFQ major fibers
% 'afqpt.numOverlapPixels_RH',...   %%% RIGHT HEMESPHERE number of voxels in the probtrax fibers that overlaps with AFQ major fibers
% 'afqpt.count_AFQ_voxels_RH',...   %%% total number of voxels in the AFQ major fibers
% 'afqpt.count_ProbtrackX_voxels_RH',...  %%%%%% total number of voxels within the probatrack fibers
% 'afqpt.ProbtrackX_tract_exist_RH',...
% 'afqpt.AFQ_tract_exist_RH',...
% 'afqpt.Percentage_OverlapPixels_LH',...
% 'afqpt.numOverlapPixels_LH',...
% 'afqpt.count_AFQ_voxels_LH',...
% 'afqpt.count_ProbtrackX_voxels_LH',...
% 'afqpt.ProbtrackX_tract_exist_LH',...
% 'afqpt.AFQ_tract_exist_LH',...
% 'afqpt.AFQ_fiber_name_left',...
% 'afqpt.AFQ_fiber_name_right',...
% 'afqpt.probtrackROI_left',...
% 'afqpt.probtrackROI_right'...
% 'afqpt.probtrack_left',...
% 'afqpt.probtrack_right');


% visualization of percentage matrix

for i=1:size(afqpt.AFQ_fiber_name_left,1)
    if (max(max(afqpt.Percentage_OverlapPixels_LH(:,:,i)))~= min(min(afqpt.Percentage_OverlapPixels_LH(:,:,i)))) & (max(max(afqpt.AFQ_tract_exist_LH(:,:,i)))==1) %% tract must exist
        h1=HeatMap(afqpt.Percentage_OverlapPixels_LH(:,:,i), 'RowLabels',afqpt.probtrackROI_left,'ColumnLabels', afqpt.probtrackROI_left, 'Standardize',3 ,'Colormap',jet, 'Annotate','on');
        addTitle(h1,afqpt.AFQ_fiber_name_left(i)); %%% e.g. 'Left_IFOF'
        h1Fig = plot(h1);
        saveas(h1Fig,afqpt.AFQ_fiber_name_left{i},'png');
        close all hidden
    else if max(max(afqpt.AFQ_tract_exist_LH(:,:,i)))==1   %%% if all overlap elements are zero (no overlapping), we have to do some tricks to still plot the heatmap 
        replace_matrix = afqpt.Percentage_OverlapPixels_LH(:,:,i);
        replace_matrix(1,2) = 0.0000000000000000000001;  %%% this trick will not be saved, but just for producing a heatmap.png
        h1=HeatMap(replace_matrix, 'RowLabels',afqpt.probtrackROI_left,'ColumnLabels', afqpt.probtrackROI_left, 'Standardize',3 ,'Colormap',jet, 'Annotate','on');
        addTitle(h1,afqpt.AFQ_fiber_name_left(i)); %%% e.g. 'Left_IFOF'
        h1Fig = plot(h1);
        saveas(h1Fig,afqpt.AFQ_fiber_name_left{i},'png');  
        close all hidden
        clear replace_matrix
        end
    end
end

for i=1:size(afqpt.AFQ_fiber_name_right,1)
    if (max(max(afqpt.Percentage_OverlapPixels_RH(:,:,i)))~= min(min(afqpt.Percentage_OverlapPixels_RH(:,:,i)))) & (max(max(afqpt.AFQ_tract_exist_RH(:,:,i)))==1) %% tract must exist
        h1=HeatMap(afqpt.Percentage_OverlapPixels_RH(:,:,i), 'RowLabels',afqpt.probtrackROI_right,'ColumnLabels', afqpt.probtrackROI_right, 'Standardize',3 ,'Colormap',jet, 'Annotate','on');
        addTitle(h1,afqpt.AFQ_fiber_name_right(i)); %%% e.g. 'right_IFOF'
        h1Fig = plot(h1);
        saveas(h1Fig,afqpt.AFQ_fiber_name_right{i},'png');
        close all hidden
    else if max(max(afqpt.AFQ_tract_exist_RH(:,:,i)))==1   %%% if all overlap elements are zero (no overlapping), we have to do some tricks to still plot the heatmap 
        replace_matrix = afqpt.Percentage_OverlapPixels_RH(:,:,i);
        replace_matrix(1,2) = 0.0000000000000000000001;  %%% this trick will not be saved, but just for producing a heatmap.png
        h1=HeatMap(replace_matrix, 'RowLabels',afqpt.probtrackROI_right,'ColumnLabels', afqpt.probtrackROI_right, 'Standardize',3 ,'Colormap',jet, 'Annotate','on');
        addTitle(h1,afqpt.AFQ_fiber_name_right(i)); %%% e.g. 'right_IFOF'
        h1Fig = plot(h1);
        saveas(h1Fig,afqpt.AFQ_fiber_name_right{i},'png'); 
        close all hidden
        clear replace_matrix
        end
    end
end

clear afqpt

