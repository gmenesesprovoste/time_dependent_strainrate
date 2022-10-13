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
os.makedirs(localdir+"/videostrainrate",exist_ok=True)
for testdir in sorted(glob.glob(localdir+"/test_*/")):
    namedir = testdir.split("/")[-2]
    ini = namedir.split("_")[1][0:4] + "." + namedir.split("_")[1][4:]
    print(ini)
    print(namedir)
    fin = namedir.split("_")[2][0:4] + "." + namedir.split("_")[2][4:]
    velfile = "cGPS_GrAtSiD_velocities_"+ref+"_italy_"+ini+"_"+fin+"_compearth_format.vel"
    time = ini+"_"+fin
    label = namedir[5:]
    year = label[0:4]
    print(namedir,label, velfile,year)
    subprocess.call("bash plot_secondinv_multipleTapefolder.sh "+namedir+" "+label+" "+velfile+" "+year, shell=True)
    dest = localdir+ "/videostrainrate"
    png = "SIstrainrate_tape2009.png"
    newname = png.split(".")[0]+"_"+label+".png"
    
    shutil.move(localdir+"/"+namedir+"/"+png , dest+"/"+newname)
    
