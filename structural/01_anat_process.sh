
## subject
subject=jaewook
## analysisdirectory
dir=/data3/cdb/jcho
## name of the anatomical scan
anat=jaewook.cho
## name of anat directory
anat_dir_name=anat/s1
## if use sanlm denoised anat
sanlm_denoised=false
# if multiple scans
num_scans=1
## if use g-cut
gcut=false
## directory setup
CCSDIR=/data3/cdb/jcho/CCS
## if use GPU
use_gpu=false
## clean files
clean_tmp_files=true
## Fake subjects list:
echo "jaewook" >> ${dir}/${subject}/subject.list
subjects_list=${dir}/${subject}/subject.list
## Template:
standard_head=${FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz
standard_brain=${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz
standard_template=${scripts_dir}/templates/MNI152_T1_3mm_brain.nii.gz
fsaverage=fsaverage5

# Process:
# FreeSurfer:
bash ${CCSDIR}/H1/ccs_01_anatpreproc.sh ${subject} ${dir} ${anat} ${anat_dir_name} ${sanlm_denoised} ${num_scans} ${gcut} ${CCSDIR}
bash ${CCSDIR}/H1/ccs_01_anatsurfrecon.sh ${subject} ${dir} ${anat} ${anat_dir_name} ${use_gpu}

# Registration check:
bash ${CCSDIR}/H1/ccs_01_anatcheck_surf.sh ${dir} ${subjects_list} ${anat_dir_name} ${clean_tmp_files}

## Registering to MNI152:
bash ${CCSDIR}/H1/ccs_02_anatregister.sh ${subject} ${dir} ${anat_dir_name}

## Quality assurances of spatial normalization
reg_refine=false
bash ${CCSDIR}/H1/ccs_02_anatcheck_fnirt.sh ${dir} ${subjects_list} ${anat_dir_name} ${standard_brain} ${reg_refine}
