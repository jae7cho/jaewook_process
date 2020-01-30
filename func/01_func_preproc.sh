#!/usr/bin/env bash
# Of note: afni python command runs on python2.7, not 3.6, use 2.7 environment.
# input is path to scan: ex. jaewook/func/Rest/s1/JAE_BOLD_Rest_ECG_20191112143936_3.nii
input=$1
subject=`echo "$input" | cut -d "/" -f 1` # jaewook
func_dir_name=`echo "$input" | cut -d "/" -f 2-4` # func/Rest/s1

## directory where scripts are located
scripts_dir=/data3/cdb/jcho/CCS
local_scripts_dir=/data3/cdb/jcho/CCS
## full/path/to/site
analysisdirectory=/data3/cdb/jcho
## full/path/to/site/subject_list
subject_list=${analysisdirectory}/${subject}/subject.list
## name of anatomical scan (no extension)
anat_name=jaewook.cho
## name of resting-state scan (no extension)
rest_name=func
## anat_dir_name
anat_dir_name=anat
## tpattern
tpattern=altminus
## TR
TR=2.1
## if do anat registration
do_anat_reg=true 
## if do anat segmentation
do_anat_seg=true
## if use freesurfer derived volumes
fs_brain=true
## if use svd to extract the mean ts
svd=false
## standard brain
standard_head=${FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz
standard_brain=${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz
standard_template=${scripts_dir}/templates/MNI152_T1_3mm_brain.nii.gz
fsaverage=fsaverage5

########
done_refine_anatreg=false
hp=0.01
lp=0.1


## SUBJECT LOOP
## Preprocessing functional images
numDropping=5
bash ${local_scripts_dir}/H1/ccs_01_funcpreproc.sh ${subject} ${analysisdirectory} ${rest_name} \
${numDropping} ${TR} ${anat_dir_name} ${func_dir_name} ${tpattern}

use_epi0=false
anat_reg_refine=false
redo_reg=true
clean_bool=True
anat_reg_dir_name=reg
func_reg_dir_name=func_reg
anat_reg_refine=false
bash ${local_scripts_dir}/H1/ccs_02_anatregister.sh ${subject} ${analysisdirectory} ${anat_dir_name} # Something went wrong with directory names :/
bash ${local_scripts_dir}/H1/ccs_02_funcbbregister.sh ${subject} ${analysisdirectory} ${func_dir_name} ${rest_name} \
${anat_dir_name} ${fsaverage} ${use_epi0} ${redo_reg} 
bash ${local_scripts_dir}/H1/ccs_02_funcregister.sh ${subject} ${analysisdirectory} ${anat_dir_name} ${func_dir_name} \
${standard_head} ${anat_reg_refine} ${reg_dir_name}

# Check registrations: 
bash ${local_scripts_dir}/H1/ccs_02_funccheck_bbregister.sh ${analysisdirectory} ${subject_list} ${func_dir_name} ${rest_name} \ 
${use_epi0} ${fsaverage}
bash ${local_scripts_dir}/H1/ccs_02_funccheck_fnirt.sh ${analysisdirectory} ${subject_list} ${func_dir_name} ${standard_brain}

# Get WM/CSF/GM/
bash ${local_scripts_dir}/H1/ccs_03_funcsegment.sh ${subject} ${analysisdirectory} ${rest_name} ${anat_dir_name} ${func_dir_name}

# Regress out nuisance parameters:
bash ${local_scripts_dir}/H1/ccs_04_funcnuisance.sh ${subject} ${analysisdirectory} ${rest_name} ${func_dir_name} ${func_reg_dir_name} ${svd}

# Bandpass, smoothing
bash ${local_scripts_dir}/H1/ccs_05_funcpreproc_cortex.sh ${subject} ${analysisdirectory} ${rest} ${anat_dir_name} ${func_dir_name} ${fsaverage}
bash ${local_scripts_dir}/H1/ccs_05_funcpreproc_nofilt_cortex.sh ${subject} ${analysisdirectory} ${rest_name} ${anat_dir_name} ${func_dir_name} ${done_refine_anatreg} ${standard_template} ${fsaverage} ${anat_reg_dir_name} ${func_reg_dir_name}

