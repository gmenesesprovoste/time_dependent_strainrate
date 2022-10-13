time_dependent_strainrate

------------------------------------------------------------------------------------------------------------

02a_vel_per_period

Use: 
* Estimate velocity per year (or in customizable time periods that overlapp) of continuous GPS time series.

Description: 

- Input: 
    - zipped data tables containing different signals product of the decomposition of GNSS time series (GrAtSiD, description below)
    - id_only.txt (list of station names), ve_EU.txt and vn_EU.txt (?) in a folder declared in variables all_sta_id, fve_eu and vn_eu respectively.  
- Output: 
    - text files in an specific format (see surfacevel2strain input format, Tape et al., 2009) containing geographic coordinates, velocities and errors for the 3 components (east, north, up), initial and final dates and station name.

- Velocity can be estimated using 2 approaches: (Df - Di)/t or GrAtSiD modeled velocities. 
- Surfacevel2strain estimate a velocity field from discrete velocity observations. This approach uses wavelets to interpolate velocity observations, obtaining spatial scale-dependent velocity field, an thus, multiscale velocity derived quantities (strain rate, dilatation rate, rotation, etc).

Description input files:
- Signals produced by the Greedy Automatic Signal Decomposition (GrAtSiD, Bedford and Bevis, 2018), an algorithm to fit GNSS time series using a multitransient approach.
- The zipped tables contain the raw data (in this case time series recording one position per day during 10 years), decomposed signals (artifitial and earthquake steps, nth order polynomial, seasonal, transients, residuals and tectonic velocity among others) and model uncertainty.

------------------------------------------------------------------------------------------------------------

03_runmatlab_surfacevel2strain_multiplevelfiles

Use: 
* Runs surfacevel2strain matlab script (Tape et al., 2009) for each of the velocity fields in ./vel_files folder.

- It needs to run in a kernel where Matlab engine is installed.
- In surfacevel2strain/matlab folder, modify "get_gps_dataset.m" according to your region (variables ropt, dopt)
- Modify as well "surfacevel2strain.m" for your particular study case. I used a modified version of this script where figure plotting is commented, and user prompt is given (ropt, dopt, ireg, basistype, icov, ndim, imask,iwrite, dir_output, dir_data, qmin, qmax, etc.)

Description: 
- Input: velocity files stored in "vel_files" folder 
- Output: creates folders "test_datei_datef" containing surfacevel2strain output dat files + velocity file for that particular period. 

------------------------------------------------------------------------------------------------------------

04_plot_strainrate

Use: 
- Plot strain rate  

Description: 
- Input: "plot_secondinv_multipleTapefolder.sh", test folders with vel files inside 
- Output: strain rate "png files" stored in the folder "videostrainrate"

Description bash script plot_secondinv_multipleTapefolder.sh:
 
 

------------------------------------------------------------------------------------------------------------

05_plot_velfield

Use: 
- Plot velocity field (all spatial scales) 

Description: 
- Input: "plot_obsvel_multipleTapefolder.sh", test folders with vel files inside 
- Output: velocity field "png files" stored in the folder "videovelfield"

Description bash script plot_obsvel_multipleTapefolder.sh:
 
 

------------------------------------------------------------------------------------------------------------

06_plot_multiscalevelfield

Use: 
- Plot velocity field (different spatial scales) 

Description: 
- Input: "plot_velfield_scales_q3-8_vectors.sh", test folders with vel files inside 
- Output: velocity field "png files" stored in the folder "videovelfield_obsmodel"

Description bash script plot_velfield_scales_q3-8_vectors.sh:
 
 
