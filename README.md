# Preprocessing:
1. Structural:
   - FreeSurfer recon-all 
   ```
   01_anat_process.sh
   ```
2. Functional:
   - CCS pipeline to preprocess data:
    - Remove first 5 TR's
    - Motion correction
    - Grand mean scaling to 10,000
    - anatomical alignment
    - Nuisance regression (no global signal regression)
    - bandpass filtering (0.01 Hz < f < 0.1 Hz)
    - Spatial smoothing to 6 mm FWHM
    ```
    01_func_preproc.sh
    ``` 
   - Create surface files (gifti, cifti) and parcellation
    ```
    02_resample.parcellate.sh
    ```
3. wait for dti?

# Analyses:
1. Connectivity heatmaps and "spring-embedded" plots
2. Find comparable metrics

