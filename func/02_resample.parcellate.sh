#!/bin/bash
############################################################
# 1. Convert fake nifti to gifti                           #
# 2. Resample fsaverage giftis to fs_LR standard surface   #
# 3. Merge giftis to ciftis and parcellate                 #
############################################################

# Example call:
# bash 02_resample.parcellate.sh /data3/cdb/jcho/jaewook/func/Rest/s1 \
  func.pp \
  ".nofilt" \
  ".sm0" \
  ".fsaverage5" \
  "/data3/cdb/jcho/HCPpipelines/global/templates/standard_mesh_atlases/resample_fsaverage" \
  "/data3/cdb/DATASET_DOWNLOAD/HCP_unrel_457/data/100206/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii" \
  "/data3/cdb/jcho/Glasser2016/HCP_MMP_P210_32k.dlabel.nii"

input=$1 
basename=$2 
filt=$3 
smooth=$4 
data_surface=$5 
data_surf_notag=`echo ${data_surface} | cut -d '.' -f2`
std_mesh_atlas_dir=$6 
ciftitemplate=$7
parcellation=$8

if [ "${data_surface}" == ".fsaverage5" ] ; then
     resolution=10k
else
    resolution=32k
fi

##################
# Print options:
echo "######################################################"
echo "######################################################"
echo ''
echo "Scan path: ${input}"
echo "Basename: ${basename}"
echo "Filtering tag: ${filt}"
echo "Smoothing tag: ${smooth}"
echo "Original surface: ${data_surface}"
echo "Standard mesh directory: ${std_mesh_atlas_dir}"
echo "Surface nodes per hemisphere: ${resolution}"
echo ''
echo "######################################################"
echo "######################################################"

OLDIFS=$IFS; IFS=','; 
for hemi in "lh","L" "rh","R"; do 
  set -- $hemi 
  echo $1 and $2 
  lower=$1;upper=$2

  echo "Converting nii.gz to .func.gii"
  wb_command -metric-convert -from-nifti ${input}/${basename}${filt}${smooth}${data_surface}.${lower}.nii.gz ${std_mesh_atlas_dir}/from_local/${data_surf_notag}.${upper}.midthickness.surf.gii ${input}/${upper}.${basename}${filt}${smooth}${data_surface}.func.gii

  echo "Resampling ${data_surface} to fs_LR"
  wb_command -metric-resample ${input}/${2}.${basename}${filt}${smooth}${data_surface}.func.gii \
    ${std_mesh_atlas_dir}/${data_surf_notag}_std_sphere.${2}.${resolution}_fsavg_${2}.surf.gii \
    ${std_mesh_atlas_dir}/fs_LR-deformed_to-fsaverage.${2}.sphere.32k_fs_LR.surf.gii \
    ADAP_BARY_AREA \
    ${input}/${2}.${basename}${filt}${smooth}.32k.fs_LR.func.gii \
    -area-metrics \
    ${std_mesh_atlas_dir}/${data_surf_notag}.${2}.midthickness_va_avg.${resolution}_fsavg_${2}.shape.gii \
    ${std_mesh_atlas_dir}/fs_LR.${2}.midthickness_va_avg.32k_fs_LR.shape.gii \

done; IFS=$OLDIFS

echo "Creating cifti from giftis"
wb_command -cifti-create-dense-from-template ${ciftitemplate} \
  ${input}/${basename}${filt}${smooth}.32k.fs_LR.dtseries.nii \
  -series 2.1 0 \
  -metric CORTEX_LEFT ${input}/L.${basename}${filt}${smooth}.32k.fs_LR.func.gii \
  -metric CORTEX_RIGHT ${input}/R.${basename}${filt}${smooth}.32k.fs_LR.func.gii

echo "Parcellating"
wb_command -cifti-parcellate ${input}/${basename}${filt}${smooth}.32k.fs_LR.dtseries.nii \
  ${parcellation} \
  COLUMN \
  ${input}/${basename}${filt}${smooth}.32k.fs_LR.ptseries.nii


