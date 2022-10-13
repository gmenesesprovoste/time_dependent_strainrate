#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep  6 13:41:06 2022

@author: gmeneses
"""

import re,os,subprocess,glob
import shutil
import numpy as np
import subprocess

ref = "IGS14"
localdir=os.getcwd()
os.makedirs(localdir+"/videovelfield_obsmodel",exist_ok=True)
for testdir in sorted(glob.glob(localdir+"/test_*/")):
    namedir = testdir.split("/")[-2]
    ini = namedir.split("_")[1][0:4] + "." + namedir.split("_")[1][4:]
    fin = namedir.split("_")[2][0:4] + "." + namedir.split("_")[2][4:]
    velfile = "cGPS_GrAtSiD_velocities_"+ref+"_italy_"+ini+"_"+fin+"_compearth_format.vel"
    time = ini+"_"+fin
    label = namedir[5:]
    print(namedir,label, velfile)
    subprocess.call("bash plot_velfield_scales_q3-8_vectors.sh "+namedir+" "+label+" "+velfile , shell=True)
    dest = localdir+ "/videovelfield_obsmodel"
    
    png1h = "predicted_vfield_q3-5_h.png"
    newname1h = png1h.split(".")[0]+"_"+label+".png"
    png2h = "predicted_vfield_q6_h.png"
    newname2h = png2h.split(".")[0]+"_"+label+".png"
    png3h = "predicted_vfield_q7_h.png"
    newname3h = png3h.split(".")[0]+"_"+label+".png"
    png4h = "predicted_vfield_q8_h.png"
    newname4h = png4h.split(".")[0]+"_"+label+".png"
    png5h = "predicted_vfield_qall_h.png"
    newname5h = png5h.split(".")[0]+"_"+label+".png"

    png1u = "predicted_vfield_q3-5_up.png"
    newname1u = png1u.split(".")[0]+"_"+label+".png"
    png2u = "predicted_vfield_q6_up.png"
    newname2u = png2u.split(".")[0]+"_"+label+".png"
    png3u = "predicted_vfield_q7_up.png"
    newname3u = png3u.split(".")[0]+"_"+label+".png"
    png4u = "predicted_vfield_q8_up.png"
    newname4u = png4u.split(".")[0]+"_"+label+".png"
    png5u = "predicted_vfield_qall_up.png"
    newname5u = png5u.split(".")[0]+"_"+label+".png"
    
    shutil.move(localdir+"/"+namedir+"/"+png1h , dest+"/"+newname1h)
    shutil.move(localdir+"/"+namedir+"/"+png2h , dest+"/"+newname2h)
    shutil.move(localdir+"/"+namedir+"/"+png3h , dest+"/"+newname3h)
    shutil.move(localdir+"/"+namedir+"/"+png4h , dest+"/"+newname4h)
    shutil.move(localdir+"/"+namedir+"/"+png5h , dest+"/"+newname5h)
    shutil.move(localdir+"/"+namedir+"/"+png1u , dest+"/"+newname1u)
    shutil.move(localdir+"/"+namedir+"/"+png2u , dest+"/"+newname2u)
    shutil.move(localdir+"/"+namedir+"/"+png3u , dest+"/"+newname3u)
    shutil.move(localdir+"/"+namedir+"/"+png4u , dest+"/"+newname4u)
    shutil.move(localdir+"/"+namedir+"/"+png5u , dest+"/"+newname5u)
