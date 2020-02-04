1. Structural:
   - FreeSurfer recon-all 
2. Functional:
  - CCS pipeline to preprocess data:
    - Remove first 5 TR's
    - Motion correction
    - Grand mean scaling to 10,000
    - anatomical alignment
    - Nuisance regression (no global signal regression)
    - bandpass filtering (0.01 Hz < f < 0.1 Hz)
    - Spatial smoothing to 6 mm FWHM
  - Create surface files (gifti, cifti) and parcellation
3. wait for dti?
4. Analysis:
  - Connectivity heatmaps and "spring-embedded" plots
  - Find comparable metrics
  - 
