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
os.makedirs(localdir+"/videovelfield",exist_ok=True)
for testdir in sorted(glob.glob(localdir+"/test_*/")):
    namedir = testdir.split("/")[-2]
    ini = namedir.split("_")[1][0:4] + "." + namedir.split("_")[1][4:]
    print(ini)
    fin = namedir.split("_")[2][0:4] + "." + namedir.split("_")[2][4:]
    velfile = "cGPS_GrAtSiD_velocities_"+ref+"_italy_"+ini+"_"+fin+"_compearth_format.vel"
    time = ini+"_"+fin
    label = namedir[5:]
    print(namedir,label, velfile)
    subprocess.call("bash plot_obsvel_multipleTapefolder.sh "+namedir+" "+label+" "+velfile , shell=True)
    dest = localdir+ "/videovelfield"
    png1 = "hor_vel.png"
    newname1 = png1.split(".")[0]+"_"+label+".png"
    png2 = "ver_vel.png"
    newname2 = png2.split(".")[0]+"_"+label+".png"
    shutil.move(localdir+"/"+namedir+"/"+png1 , dest+"/"+newname1)
    shutil.move(localdir+"/"+namedir+"/"+png2 , dest+"/"+newname2)
