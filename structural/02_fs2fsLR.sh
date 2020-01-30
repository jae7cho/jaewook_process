#!/bin/bash
# Create 164 and 32k surfaces HCPstyle. 
# From https://github.com/Washington-University/HCPpipelines/blob/master/Examples/Scripts/PostFreeSurferPipelineBatch.sh

Subject=jaewook
echo $Subject
HCPPIPEDIR=/data3/cdb/jcho/HCPpipelines
source ${HCPPIPEDIR}/Examples/Scripts/SetUpHCPPipeline.sh
#Input Variables
SurfaceAtlasDIR="${HCPPIPEDIR}/global/templates/standard_mesh_atlases"
GrayordinatesSpaceDIR="${HCPPIPEDIR}/global/templates/91282_Greyordinates"
GrayordinatesResolutions="2" 
HighResMesh="164" 
LowResMeshes="32"
SubcorticalGrayLabels="${HCPPIPEDIR}/global/config/FreeSurferSubcorticalLabelTableLut.txt"
FreeSurferLabels="${HCPPIPEDIR}/global/config/FreeSurferAllLut.txt"
ReferenceMyelinMaps="${HCPPIPEDIR}/global/templates/standard_mesh_atlases/Conte69.MyelinMap_BC.164k_fs_LR.dscalar.nii"
RegName="FS" 

${HCPPIPEDIR}/PostFreeSurfer/PostFreeSurferPipeline.sh \
    --path="$StudyFolder" \
    --subject="$Subject" \
    --surfatlasdir="$SurfaceAtlasDIR" \
    --grayordinatesdir="$GrayordinatesSpaceDIR" \
    --grayordinatesres="$GrayordinatesResolutions" \
    --hiresmesh="$HighResMesh" \
    --lowresmesh="$LowResMeshes" \
    --subcortgraylabels="$SubcorticalGrayLabels" \
    --freesurferlabels="$FreeSurferLabels" \
    --regname="$RegName" \
    --processing-mode="LegacyStyleData"
