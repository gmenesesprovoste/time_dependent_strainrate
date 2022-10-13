#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 31 13:24:47 2022

@author: gmeneses
"""

import numpy as np
import matplotlib.pyplot as plt

"""
['dates_columns',   ---> dates corresponding to each columnn in the data table and signal tables
 'coords',          ----> coords of stations
 'names',       ---> names of stations
 'data_matrix', --->  rows for each station, columns for each day
 'signals_tensor',  --->   decomposed signal.  3rd dimension is described by the list 'signals_type'
 'model_uncertainty_tensor',  --->  uncertainty as a function of time for each decomposed signal type
 'signals_type']  --->   types of signals in the 3rd dimension of the signals_tensor
"""
"""
signals_tensor:
['steps_real',  [0]     --->  assumed tectonic steps (e.g. earthquakes) that have been found or pre-assigned in GrAtSiD
 'polynomial'   [1]     ---> nth order polynomial ("trend") of the data
 'steady_state_seasonal',  [2]   --->   steady state seasonal (fourier) oscillation
 'multi_transients',  [3]    --->   gradual transients or postseismic decays
 'rooted_polynomials', [4]  --->   an alternative type of transient function.  Often this is switched off in gratsid, therefore output is nans
 'artificial_steps', [5]   --->   Displacements for times when GrAtSiD knows there is an artificial step
 'residuals',     [6]      --->   residual after GrAtSiD fit
 'tectonic_velocity'] [7]  --->   differential of (steps_real+polynomial+multi_transients)
"""

### LOADING DATA TABLES FOR A PARTICULAR COMPONENT
file_e = 'SIGNALS_E.npz'
file_n = 'SIGNALS_N.npz'
file_u = 'SIGNALS_U.npz'

##east
data_e = np.load(file_e)
# common to all components
dates_columns = data_e['dates_columns']
coords = data_e['coords']
names = data_e['names']


data_matrix_e = data_e['data_matrix']
signals_tensor_e = data_e['signals_tensor']
model_uncertainty_tensor_e = data_e['model_uncertainty_tensor'],
signals_type_e = data_e['signals_type']

## #north
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
###########################################################################################################
# getting displacements station i
#sta = 'CERA','ALRA' 'LNSS'
sta='ITRN'
ix = np.where(names == sta)[0]

nsta = data_matrix_e.shape[0]
points = data_matrix_e.shape[1]

disp_e = data_matrix_e[ix,:]*1000
disp_n = data_matrix_n[ix,:]*1000
disp_u = data_matrix_u[ix,:]*1000
#uncertainty for the signal components
unc_e = model_uncertainty_tensor_e[0][ix,:]
unc_n = model_uncertainty_tensor_n[0][ix,:]
unc_u = model_uncertainty_tensor_u[0][ix,:]
#polynomial
pol_e = signals_tensor_e[ix,:,1]
pol_n = signals_tensor_n[ix,:,1]
pol_u = signals_tensor_u[ix,:,1]
#seasonal
sea_e = signals_tensor_e[ix,:,2]*1000
sea_n = signals_tensor_n[ix,:,2]*1000
sea_u = signals_tensor_u[ix,:,2]*1000
#artificial
art_e = signals_tensor_e[ix,:,5]*1000
art_n = signals_tensor_n[ix,:,5]*1000
art_u = signals_tensor_u[ix,:,5]*1000
#residuals
res_e = signals_tensor_e[ix,:,6]*1000
res_n = signals_tensor_n[ix,:,6]*1000
res_u = signals_tensor_u[ix,:,6]*1000
#velocities, originally in m/d ?
vel_e = signals_tensor_e[ix,:,7]*1000*365.25
vel_n = signals_tensor_n[ix,:,7]*1000*365.25
vel_u = signals_tensor_u[ix,:,7]*1000*365.25
# earthquakes
eqs_e = signals_tensor_e[ix,:,0]*1000
eqs_n = signals_tensor_n[ix,:,0]*1000
eqs_u = signals_tensor_u[ix,:,0]*1000

gfit_minus_art_sea_e = disp_e.ravel()- res_e.ravel() - art_e.ravel() - sea_e.ravel()
gfit_minus_art_sea_n = disp_n.ravel()- res_n.ravel() - art_n.ravel() - sea_n.ravel()
gfit_minus_art_sea_u = disp_u.ravel()- res_u.ravel() - art_u.ravel() - sea_u.ravel()
#error_gfit_minus_art_sea_e = error_disp_e (NGL?) + unc_e[0,ix,6] + unc_e[0,ix,5] + unc_e[0,ix,2]
gfit_minus_art_sea_eqs_e = disp_e.ravel()- res_e.ravel() - art_e.ravel() - sea_e.ravel() - eqs_e.ravel()
gfit_minus_art_sea_eqs_n = disp_n.ravel()- res_n.ravel() - art_n.ravel() - sea_n.ravel() - eqs_n.ravel()
gfit_minus_art_sea_eqs_u = disp_u.ravel()- res_u.ravel() - art_u.ravel() - sea_u.ravel() - eqs_u.ravel()

yini = 2010
yfin = 2019
#listpoints = np.arange(data_matrix_e.shape[1])
list_years = [x for x in range(yini,yfin + 1)]
# list of lists, each element-list contains indexes for specific year
ix_sep_years = [np.where(dates_columns[:,0] == x)[0] for x in list_years]


#common to all components
days = np.arange(data_matrix_e.shape[1])

fig0 = plt.figure(figsize=(10,10))
ax10 = fig0.add_subplot(3,1,1)
ax20 = fig0.add_subplot(3,1,2)
ax30 = fig0.add_subplot(3,1,3)

# for each year, a vector with a different signal
disp_per_year_e = []
disp_per_year_n = []
disp_per_year_u = []
vel_per_year_e = []
vel_per_year_n = []
vel_per_year_u = []
gdisp_with_eqs_e = []
gdisp_with_eqs_n = []
gdisp_with_eqs_u = []
DD_e = []
DD_n = []
DD_u = []
for i in range(0,len(list_years)):
    indexes = ix_sep_years[i]
    disp_per_year_e.append(disp_e[0,indexes,0])
    disp_per_year_n.append(disp_n[0,indexes,0])
    disp_per_year_u.append(disp_u[0,indexes,0])
    vel_per_year_e.append(vel_e[0,indexes])
    vel_per_year_n.append(vel_n[0,indexes])
    vel_per_year_u.append(vel_u[0,indexes])
    gdisp_with_eqs_e.append(gfit_minus_art_sea_e[indexes])
    gdisp_with_eqs_n.append(gfit_minus_art_sea_n[indexes])
    gdisp_with_eqs_u.append(gfit_minus_art_sea_u[indexes])
    #signal per year without nan values
    dd_e = gfit_minus_art_sea_e[indexes][np.logical_not(np.isnan(gfit_minus_art_sea_e[indexes]))][-1] - gfit_minus_art_sea_e[indexes][np.logical_not(np.isnan(gfit_minus_art_sea_e[indexes]))][0]
    dd_n = gfit_minus_art_sea_n[indexes][np.logical_not(np.isnan(gfit_minus_art_sea_n[indexes]))][-1] - gfit_minus_art_sea_n[indexes][np.logical_not(np.isnan(gfit_minus_art_sea_n[indexes]))][0]
    dd_u = gfit_minus_art_sea_u[indexes][np.logical_not(np.isnan(gfit_minus_art_sea_u[indexes]))][-1] - gfit_minus_art_sea_u[indexes][np.logical_not(np.isnan(gfit_minus_art_sea_u[indexes]))][0]
    # append velocities in mm/y, im assuming that there are no many nan values at the beginning and at the end
    DD_e.append(dd_e/len(indexes)*365.25)
    DD_n.append(dd_n/len(indexes)*365.25)
    DD_u.append(dd_u/len(indexes)*365.25)
    trend_e = np.arange(len(indexes))*np.nanmedian(vel_per_year_e[i])
    ax10.plot(indexes,trend_e, label='{:.2f}'.format(np.nanmedian(vel_per_year_e[i])))
    trend_n = np.arange(len(indexes))*np.nanmedian(vel_per_year_n[i])
    ax20.plot(indexes,trend_n, label='{:.2f}'.format(np.nanmedian(vel_per_year_n[i])))
    trend_u = np.arange(len(indexes))*np.nanmedian(vel_per_year_u[i])
    ax30.plot(indexes,trend_u, label='{:.2f}'.format(np.nanmedian(vel_per_year_u[i])))
ax10.set_title('GrAtSiD median trend per year, station='+sta,fontsize=12)
ax10.legend(title='velocities [mm/y]') 
ax20.legend(title='velocities [mm/y]')
ax30.legend(title='velocities [mm/y]')        
#ax10.spines.left.set_visible(False)
#ax10.xaxis.set_ticks_position('bottom') 
#ax10.yaxis.set_ticks_position(False)
ax10.set_ylabel('East [mm]')
ax20.set_ylabel('North [mm]')
ax30.set_ylabel('Up [mm]')
ax30.set_xlabel('days since 01.06.2010')

fig = plt.figure(figsize=(10,10))
ax1 = fig.add_subplot(3,1,1);ax1.grid()
ax2 = fig.add_subplot(3,1,2);ax2.grid()
ax3 = fig.add_subplot(3,1,3);ax3.grid()

#upper plot ############################################################################################
ax1.set_title(sta,fontsize=12)
ax1.plot(days,disp_e.ravel(),label='original positions (de-spiked)')
ax1.plot(days,disp_e.ravel()- res_e.ravel(),label='GrAtSiD fit')
#ax1.plot(days,disp_e.ravel() - signals_tensor_e[i,:,6],label='GrAtSiD fit')
#ax1.plot(days,disp_e.ravel() - sea_e.ravel() - art_e.ravel() - res_e.ravel() - eqs_e.ravel() ,label='de-spiked timeseries with seasonal, artifical steps and residuals removed')

#ax1.plot(days,sea_e.ravel(),label='seasonal')
#ax1.plot(days,vel_e.ravel(),label='velocity')
ax1.legend()
ax1.set_ylabel('East [mm]')
#middle plot ############################################################################################
ax2.plot(days,disp_n.ravel())
ax2.plot(days,disp_n.ravel()- res_n.ravel())
#ax2.plot(days,disp_e.ravel() - signals_tensor_e[i,:,6],label='GrAtSiD fit')
#ax2.plot(days,disp_n.ravel() - sea_n.ravel() - art_n.ravel() - res_n.ravel()- eqs_n.ravel())
#ax2.plot(days,vel_n.ravel(),label='velocity')

#ax2.plot(days,sea_n.ravel())
ax2.set_ylabel('North [mm]')
#bottom plot ############################################################################################
ax3.plot(days,disp_u.ravel())
ax3.plot(days,disp_u.ravel()- res_u.ravel())
#ax3.plot(days,disp_e.ravel() - signals_tensor_e[i,:,6],label='GrAtSiD fit')
#ax3.plot(days,disp_u.ravel() - sea_u.ravel() - art_u.ravel() - res_u.ravel()- eqs_u.ravel() )

#ax3.plot(days,sea_u.ravel())
#ax3.plot(days,vel_u.ravel(),label='velocity')
ax3.set_ylabel('Up [mm]')
ax3.set_xlabel('days since 01.06.2010')



fig2 = plt.figure(figsize=(10,10))
ax12 = fig2.add_subplot(3,1,1);ax12.grid()
ax22 = fig2.add_subplot(3,1,2);ax22.grid()
ax32 = fig2.add_subplot(3,1,3);ax32.grid()

#upper plot ############################################################################################
ax12.set_title(sta,fontsize=12)
#ax12.plot(days,disp_e.ravel()- res_e.ravel(),label='GrAtSiD fit')
#ax1.plot(days,disp_e.ravel() - sea_e.ravel() - art_e.ravel() - res_e.ravel() - eqs_e.ravel() ,label='de-spiked timeseries with seasonal, artifical steps and residuals removed')
#ax12.plot(days,disp_e.ravel()- res_e.ravel() - art_e.ravel() - sea_e.ravel() ,label='GrAtSiD fit with artificial steps and seasonal removed')
#ax12.plot(days,unc_e[0,:,7]*1000*365.25,label='artificial')
ax12.plot(days,art_e.ravel(),label='art')

ax12.plot(days,gfit_minus_art_sea_eqs_e,label='minus_art_sea_eqs')
ax12.legend()
ax12.set_ylabel('East [mm]')
#middle plot ############################################################################################
#ax22.plot(days,disp_n.ravel()- res_n.ravel())
#ax2.plot(days,disp_n.ravel() - sea_n.ravel() - art_n.ravel() - res_n.ravel()- eqs_n.ravel())
#ax22.plot(days,disp_n.ravel()- res_n.ravel() - art_n.ravel()- sea_n.ravel())
#ax22.plot(days,unc_n[0,:,7]*1000*365.25)
ax22.plot(days,art_n.ravel())
ax22.plot(days,gfit_minus_art_sea_eqs_n,label='minus_art_sea_eqs')
ax22.set_ylabel('North [mm]')
#bottom plot ############################################################################################
#ax32.plot(days,disp_u.ravel()- res_u.ravel())
#ax3.plot(days,disp_u.ravel() - sea_u.ravel() - art_u.ravel() - res_u.ravel()- eqs_u.ravel() )
#ax32.plot(days,disp_u.ravel()- res_u.ravel() - art_u.ravel()- sea_u.ravel())
#ax32.plot(days,unc_u[0,:,7]*1000*365.25)
ax32.plot(days,art_u.ravel())
ax32.plot(days,gfit_minus_art_sea_eqs_u,label='minus_art_sea_eqs')
ax32.set_ylabel('Up [mm]')
ax32.set_xlabel('days since 01.06.2010')
















