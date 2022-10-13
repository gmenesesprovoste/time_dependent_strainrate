#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep  5 16:12:50 2022

@author: gmeneses
"""

import numpy as np
import matplotlib.pyplot as plt

### LOADING DATA TABLES FOR A PARTICULAR COMPONENT
file_e = 'SIGNALS_E.npz'
file_n = 'SIGNALS_N.npz'
file_u = 'SIGNALS_U.npz'

all_sta_id = '/home/gmeneses/Documents/RUB/Research/05_Italy_NGL_decomposition_Gianina/vel_files/vel_conversion/EU/id_only.txt'
all_ids = []
with open(all_sta_id) as ids:
    for line in ids:
        all_ids.append(line.split()[0])

fve_eu = '/home/gmeneses/Documents/RUB/Research/05_Italy_NGL_decomposition_Gianina/vel_files/vel_conversion/EU/ve_EU.txt'
fvn_eu = '/home/gmeneses/Documents/RUB/Research/05_Italy_NGL_decomposition_Gianina/vel_files/vel_conversion/EU/vn_EU.txt'
ve_eu = []
vn_eu = []
with open(fve_eu) as fve:
    for line in fve:
        ve_eu.append(float(line.split()[0]))        
with open(fvn_eu) as fvn:
    for line in fvn:
        vn_eu.append(float(line.split()[0]))    
##east
data_e = np.load(file_e)
data_matrix_e = data_e['data_matrix']
signals_tensor_e = data_e['signals_tensor']
model_uncertainty_tensor_e = data_e['model_uncertainty_tensor'],
signals_type_e = data_e['signals_type']
# common to all components
dates_columns = data_e['dates_columns']
coords = data_e['coords']
names = data_e['names']

### north
data_n = np.load(file_n)
data_matrix_n = data_n['data_matrix']
signals_tensor_n = data_n['signals_tensor']
model_uncertainty_tensor_n = data_n['model_uncertainty_tensor'],
signals_type_n = data_n['signals_type']

## vertical 
data_u = np.load(file_u)
data_matrix_u = data_u['data_matrix']
signals_tensor_u = data_u['signals_tensor']
model_uncertainty_tensor_u = data_u['model_uncertainty_tensor'],
signals_type_u = data_u['signals_type']

nsta = data_matrix_e.shape[0]
points = data_matrix_e.shape[1]
ncompearth = 14

yini = 2010
yfin = 2019
#listpoints = np.arange(data_matrix_e.shape[1])
#the important here is that each element of list_years corresponds to the first element of the different periods
list_years = [x for x in range(yini,yfin + 1)]
# list of lists, each element-list contains indexes for specific year
# here, if I want to be more general, need to involve more columns in the loop below
ix_sep_years = [np.where(dates_columns[:,0] == x)[0] for x in list_years]


for i in range(0,len(list_years)):
    #A = np.empty((nsta, ncompearth)) 
    indexes = ix_sep_years[i]
    datei = list_years[i] + 0.0
    datef = list_years[i] + 0.11
    outfile = open('cGPS_GrAtSiD_velocities_IGS14_italy_'+str(datei)+'_'+str(datef)+'_compearth_format.vel','w')
    outfile2 = open('cGPS_GrAtSiD_velocities_EU_italy_'+str(datei)+'_'+str(datef)+'_compearth_format.vel','w')
    for sta in names:
        ix = np.where(names == sta)[0]
        ix_allsta = np.where(np.array(all_ids) == sta)[0]
        ve_eu = np.array(ve_eu)
        vn_eu = np.array(vn_eu)
        rest_east = ve_eu[ix_allsta]*1000
        rest_north = vn_eu[ix_allsta]*1000
        lon = coords[ix,:][0][0]
        lat = coords[ix,:][0][1]
        #uncertainty for the signal components
        unc_e = model_uncertainty_tensor_e[0][ix,:]
        unc_n = model_uncertainty_tensor_n[0][ix,:]
        unc_u = model_uncertainty_tensor_u[0][ix,:]
        #velocities for certain station in mm/y for the whole period, originally in m/d 
        vel_e = signals_tensor_e[ix,:,7]*1000*365.25
        vel_n = signals_tensor_n[ix,:,7]*1000*365.25
        vel_u = signals_tensor_u[ix,:,7]*1000*365.25
        #velocities station for a certain period
        pvel_e = vel_e[0,indexes]
        pvel_n = vel_n[0,indexes]
        pvel_u = vel_u[0,indexes]
        #velocity uncertainties for a certain station and period
        puncvel_e = unc_e[0,:,7][indexes]*1000*365.25
        puncvel_n = unc_n[0,:,7][indexes]*1000*365.25
        puncvel_u = unc_u[0,:,7][indexes]*1000*365.25
        #median velocities per period
        ve_median = np.nanmedian(pvel_e)
        vn_median = np.nanmedian(pvel_n)
        vu_median = np.nanmedian(pvel_u)
        ve_median_eu = np.nanmedian(pvel_e) - rest_east[0]
        vn_median_eu = np.nanmedian(pvel_n) - rest_north[0]
        vu_median_eu = vu_median
        #median uncertainties per period
        rve_median = np.nanmedian(puncvel_e)
        rvn_median = np.nanmedian(puncvel_n)
        rvu_median = np.nanmedian(puncvel_u)
        
        if rve_median == 0:
            rve_median = 0.01 
        if rvn_median == 0:
            rvn_median = 0.01
        if rvu_median == 0:
            rvu_median = 0.01
            
            
            #print("Station "+sta+" has invalid uncertainty in year "+str(datei))
            
        
        string = " ".join(map(str,[lon, lat, ve_median, vn_median, vu_median, rve_median, rvn_median, rvu_median, 0,0,0, datei, datef, sta]))
        print(string,file=outfile)
        string_eu = " ".join(map(str,[lon, lat, ve_median_eu, vn_median_eu, vu_median_eu, rve_median, rvn_median, rvu_median, 0,0,0, datei, datef, sta]))
        print(string_eu,file=outfile2)
    outfile.close()  
    outfile2.close()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    
