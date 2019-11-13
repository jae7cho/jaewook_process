
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



bash /data3/cdb/jcho/CCS/H1/ccs_01_anatpreproc.sh jaewook /data3/cdb/jcho jaewook.cho anat/s1 false 1 false /data3/cdb/jcho/CCS/
