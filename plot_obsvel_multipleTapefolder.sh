#!/bin/bash

#west=-81
#east=-58
#south=40
#north=52
#change here depending on input velocities
west=8
east=19
south=36
north=46.5
#
R1="-R$west/$east/$south/$north"
wid=4.5
J1="-JM"$wid"i"
#
frame=1
PAPER_SIZE="a4"
gmt gmtset DIR_GSHHG ~/local/gshhg-gmt-2.3.7
gmt gmtset MAP_FRAME_TYPE fancy
gmt gmtset PS_PAGE_ORIENTATION portrait
gmt gmtset FONT_ANNOT_PRIMARY 15 FONT_LABEL 15 MAP_FRAME_WIDTH 0.15c FONT_TITLE 15p,Arial
gmt gmtset PS_MEDIA ${PAPER_SIZE}
gmt gmtset COLOR_MODEL hsv
#reso="-I"$1"/"$1
#projscale=6000000
#J1="-Jm24/37/1:$projscale"

##files to change------------------------------------------------------------------------------------------
#e_outgrdgps="e_dd_"$1"I_"$1"gps_large.grd"
#n_outgrdgps="n_dd_"$1"I_"$1"gps_large.grd"

#psfile2="SIstrainrate_gpsgridder.ps"
#psfile3="SIstrainrate_shen2015.ps"
##-----------------------------------------------------------------------------------------------------------------------
#real velocities, GPS coordinates
#real_vel="SLVsitesGPS_dates_errors.dat"
#real_vel="ngl_subset_psvelo.dat"
#gps_coords="ngl_subset_points.dat"

#grdfile2="gpsgridderstrain.grd"
#grdfile3="shenstrain.grd"


origin="-X1.5 -Y1.75"
#color
colorbar="/home/gmeneses/Documents/RUB/Research/GMT/ScientificColourMaps7/lajolla/lajolla.cpt"
colorbarseism="/home/gmeneses/Documents/RUB/Research/GMT/ScientificColourMaps7/batlow/batlow.cpt"

#dir0="/home/gmeneses/local/compearth-master/surfacevel2strain"
#vel_dir0=$dir0"/matlab_output/CHVX/test4_velmore2.5mm"
vel_dir0="./"$1
velfile=$vel_dir0"/"$3
#/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/montecarlo_test/test2_i50
#seismicity
seism=/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/ITALY/seismicity/sismos_decyearformat.dat
#faults
faults=/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/ITALY/faults/Faults/active_faults.gmt

#--------------------------------------------------------------------------------------------------------------------
psfile1=$vel_dir0"/hor_vel.ps"
psfile2=$vel_dir0"/ver_vel.ps"

#grdfile=$vel_dir0"/tapestrain.grd"



#label file names
itag="italy"
dlab="d02"
qlab="q03_q08"
blab="b1"
nlab="3D"
slab="s1"
ulab="u0"
name=$itag"_"$dlab"_"$qlab"_"$blab"_"$nlab"_"$slab"_"$ulab

#verify here with gmt grdinfo the min and max of the *grd files
#values for italy initial area (less velocities)
#cminstrain=$(echo 0 | bc -l)
#cmaxstrain=$(echo 60 | bc -l)
cminstrain=$(echo 0 | bc -l)
cmaxstrain=$(echo 200 | bc -l)
#echo $cminstrainpre
cpwr3=$(echo -9 | bc -l)
norm3=$(echo 10 ^ $cpwr3 | bc -l)
#cminstrain=$(echo $cminstrainpre*$norm3 | bc -l)
#cmaxstrain=`echo $cmaxstrainpre*$norm3 | bc -l`

cran=`echo $cmaxstrain - $cminstrain | bc -l`
dc=`echo $cran / 100 | bc -l`
Tstrain="-T"$cminstrain"/"$cmaxstrain"/"$dc
echo $Tstrain


cptstrain=$vel_dir0"/strain_all.cpt"
strain_mag=$vel_dir0"/"$name"_strain.dat"
strain_tensor=$vel_dir0"/"$name"_Dtensor_6entries.dat"
mask_file=$vel_dir0"/"$name"_masked_pts.dat"
mask_info="-I0.1 -G200 -S0.2"
interp_surf="-I0.05 -T0"

# color bar
Dlen=9.5
xlegend=5.5
ylegend=4

Dx=`echo $xlegend + 2.7 + $Dlen/2 | bc -l`
Dy=`echo $ylegend + 0.5 | bc -l`
Dscale="-Dx"$Dx"/"$Dy"/"$Dlen"/0.35"
Bscale1="-Bx20+lSecInvStrainRate"
Bscale2="-By+lnstrain/y"

#pscoast parameters
coast_res="-A500 -Di"
coast_infoW="$coast_res -W1 -N1"
xtick1=2 
xtick2=0.25
#B0="-Ba"$xtick1"f"$xtick2"d::"
#B=$B0

# both strain rate calculation must use the same group of velocities

##### PLOT Tape 2009 strain rate magnitude ############################################################################################ 

# faults
#gmt psxy $faults $R1 $J1 -Sf0.2/1.5p+l+t -Wthinner,black  -K -V >> $psfile1

awk '$1 !~ "#"{print $1,$2,$3,$4,$6,$7,"0"}' $velfile > hvelhor.dat
gmt psvelo hvelhor.dat $R1 $J1 -Se0.02c/0.95  -A0.1c+e+p1.5p+gblue -Wthinnest,blue -K -V  > $psfile1
#LEGEND
gmt psvelo $R1 $J1 -Se0.02c/0.95 -Wthinnest,blue -A0.1c+e+p1.5p+gblue -K -O -V  << EOF >>$psfile1
17.0 37.9 30 0 3 3 0 
EOF
gmt pstext $R1 $J1 -O -V -K -F+f12,1,black+j << EOF >>$psfile1
16.8 37.5 0 30+-3 mm/y 
EOF
#gmt psscale -C$cptstrain $Dscale $Bscale1 $Bscale2 -K -O -V >> $psfile1
gmt pscoast $J1 $R1 -Ba2f1g0WSen:.$2: $coast_infoW  -O -V >> $psfile1


# vertical vel ##############################################################
colorbarvert="/home/gmeneses/Documents/RUB/Research/GMT/ScientificColourMaps7/vik/vik.cpt"
#obs="cGPS_italy_compearth_more2.5y_EU_mm_noislands.dat"
#expressing in cm (/10), the unit by default, augmenting by 1 (*1)
awk '$8 < 3{print $1,$2,$5,$8/10*1}' $velfile > hvelver.dat
awk '$8 >= 3{print $1,$2,$5,$8/10*1}' $velfile > hvelverh.dat



gmt makecpt  -C$colorbarvert -T-20/20/1 > velver.cpt

gmt psxy hvelverh.dat  $R1 $J1 -Sc -Cvelver.cpt -Wthinner,black -K  -V  > $psfile2
gmt psxy hvelver.dat  $R1 $J1 -Sc -Cvelver.cpt -Wthinner,black -K  -O -V  >> $psfile2
gmt pstext $R1 $J1 -K -O -V -F+f12,1,black+j << EOF >> $psfile2
10.5 37.5 0 1, 3, 5 mm/y uncertainties 
EOF
#units expressed in cm augmented by 5 (0.1 cm = 1 mm --> 0.5, ...)
gmt psxy $R1 $J1 -Sc0.1 -Wthinner,black -K -O -V << EOF >> $psfile2
10.5 37.3  
EOF
gmt psxy $R1 $J1 -Sc0.3 -Wthinner,black -K -O -V << EOF >> $psfile2
10.5 36.95 
EOF
gmt psxy $R1 $J1 -Sc0.5 -Wthinner,black -K -O -V << EOF >> $psfile2
10.5 36.45 
EOF

gmt psscale $J1 $R1 -Cvelver.cpt -I $Dscale  -Bx5+l"Vertical rate [mm/y]" -K -O -V >> $psfile2
#gmt psscale -C$cptstrain $Dscale $Bscale1 $Bscale2 -K -O -V >> $psfile1
gmt pscoast $J1 $R1 -Ba2f1g0WSen:.$2: $coast_infoW  -O -V >> $psfile2

gmt psconvert $psfile1 -A -Tg
rm $psfile1
gmt psconvert $psfile2 -A -Tg
rm $psfile2





