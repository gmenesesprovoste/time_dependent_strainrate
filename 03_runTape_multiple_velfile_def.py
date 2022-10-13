#! /usr/bin/python

import re,os,subprocess,glob
import shutil
import numpy as np
import math
import matlab.engine

# create here velocity random file from cGPS_italy_compearth_more2.5y_EU_mm_noislands.dat

localdir=os.getcwd()
outdir="/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/current_test_results" 
veldir="/home/gmeneses/local/compearth-master/surfacevel2strain/data/ITALY"

#velfile="/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/outlier_test/low_rms_velocities.dat"
inputdir="./vel_files/IGS14_dispvel_witheqs"

# =============================================================================
#         if i % 100 == 0:
#             print("values for the east:\n")
#             print("original: ",ve,ee)
#             print("borders: ",mue-sigmae,mue+sigmae)
#             print("aleatorio: ",se)            
# ============================================================================= 
                
        
        

eng = matlab.engine.start_matlab()
s = eng.genpath('/home/gmeneses/local/compearth-master/surfacevel2strain')
eng.addpath(s, nargout=0)

 
for vfile in sorted(glob.glob(inputdir+"/*.vel")):
    vname = vfile.split("/")[-1]
    label = "".join(vname.split(".")[0:3]).split("_")[5] + "_" + "".join(vname.split(".")[0:3]).split("_")[6]
    shutil.copy(inputdir+"/"+vname,veldir+"/italy.vel")
    eng.surfacevel2strain(nargout=0)
    source = outdir + "/"
    dest = localdir+ "/test_"+label+"/"
    os.makedirs(dest,exist_ok=True)
    shutil.move(veldir+"/italy.vel",dest+vname)
    allfiles = os.listdir(source)
    for f in allfiles:
        shutil.move(source + f, dest + f)

             

        
        
    
    
  

  


