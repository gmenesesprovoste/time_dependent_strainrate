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
#velfile=$vel_dir0"/"$3
#/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/montecarlo_test/test2_i50
#seismicity
seism=/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/ITALY/seismicity/sismos_decyearformat_addyear.dat
#faults
faults=/home/gmeneses/local/compearth-master/surfacevel2strain/matlab_output/ITALY/faults/Faults/active_faults.gmt

#--------------------------------------------------------------------------------------------------------------------
psfile1=$vel_dir0"/SIstrainrate_tape2009.ps"

grdfile=$vel_dir0"/tapestrain.grd"



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
#gmt psbasemap $J1 $R1 -B -K -V -P $origin > $psfile1
awk '{print $1,$2}' $strain_mag > lonlattape.temp
awk 'NR!=1 {print sqrt(($1*$1)+($4*$4)+($6*$6)+2*($2*$2)+2*($3*$3)+2*($5*$5))}' $strain_tensor > a.temp
paste lonlattape.temp a.temp > SRtape.temp
#awk -v var=$norm3 '{print $1,$2,$5/var}' $strain_mag | gmt surface -G$grdfile $interp_surf $R1
awk -v var=$norm3 '{print $1,$2,$3/var}' SRtape.temp | gmt surface -G$grdfile $interp_surf $R1
gmt makecpt -C$colorbar $Tstrain -D > $cptstrain
gmt grdimage $grdfile $R1 $J1 -C$cptstrain -n+c -K  -V > $psfile1

gmt psmask $mask_file $R1 $J1 $mask_info -K -O -V >> $psfile1
gmt psmask -C -K -O -V >> $psfile1

#seismicity, year is passed as a user variable in position 4 
awk -v year=$4 '$5 == year {print $1, $2,$3, $4*$4/130}' $seism > seis.temp

iyear=$4
fyear=$(($4 + 1))
gmt makecpt  -C$colorbarseism -T$iyear/$fyear/0.1 -Z > fechaseism.cpt
gmt psxy seis.temp  $R1 $J1 -Sc -Cfechaseism.cpt -K  -O -V  >> $psfile1
gmt psscale  -Cfechaseism.cpt -I -O -Dx15.5c/0.5c+w1.7i/0.1i  -Bx0.1+lTime -K -V >> $psfile1

#-W0.3p
### ppal strain rates
#ppal_strain=$vel_dir0"/ppal_strain_rate_masked.gmt"
##echo $ppal_strain
#awk -v var=$norm3 '{print $1,$2,$3/var}' $ppal_strain > e1.dat
#awk -v var=$norm3 '{print $1,$2,$4/var}' $ppal_strain > e2.dat
#awk '{print $1,$2,$5}' $ppal_strain > phi.dat
#gmt xyz2grd e1.dat -Ge1.grd -I0.2 $R1 -NNaN -V
#gmt xyz2grd e2.dat -Ge2.grd -I0.2 $R1 -NNaN -V
#gmt xyz2grd phi.dat -Gphi.grd -I0.2 $R1 -NNaN -V
#gmt grd2xyz e1.grd > e1Down.dat
#gmt grd2xyz e2.grd | awk '{print $3}' > e2Down.dat
#gmt grd2xyz phi.grd | awk '{print $3}' > phiDown.dat
#paste e1Down.dat e2Down.dat phiDown.dat > ppalDown.dat
#awk '{print $1,$2,$3,0,$5}' ppalDown.dat > e1.gmt
#awk '{print $1,$2,0,$4,$5}' ppalDown.dat > e2.gmt
##
###
#gmt psvelo e1.gmt  $J1 $R1 -Sx0.005  -A5p+e -Gred -W1p,red -O -K -V >>$psfile1
#gmt psvelo e2.gmt  $J1 $R1 -Sx0.005  -A5p+e -Gblue3 -W1p,blue3 -O -K -V >>$psfile1

# faults
gmt psxy $faults $R1 $J1 -Sf0.2/1.5p+l+t -Wthinner,black -O -K >> $psfile1

#awk '$1 !~ "#"{print $1,$2,$3,$4,$6,$7,"0"}' $velfile > hvelhor.dat
#gmt psvelo hvelhor.dat $R1 $J1 -Se0.0333c/0.95  -A0.1c+e+p1.5p+gblue -Wthinnest,blue -K -V -O >> $psfile1

gmt psscale -C$cptstrain $Dscale $Bscale1 $Bscale2 -K -O -V >> $psfile1
gmt pscoast $J1 $R1 -Ba2f1g0WSen:.$2: $coast_infoW  -O -V >> $psfile1


gmt psconvert $psfile1 -A -Tg
rm $psfile1

##### PLOT gpsgridder strain rate magnitude ############################################################################################
#Compute 2ndInvariant gpsgridder
#ST_gpsgridder="gpsgridder_results/SRgpsgridder_velmore2.5/SRtensor_gpsgridder_more2.5y.dat"
#ST_gpsgridder="gpsgridder_results/SRgpsgridder_velmore2.5/SRtensor_gpsgridder_more2.5y_NA_mm_larger.dat"
#ST_gpsgridder="gpsgridder_results/SRgpsgridder_velmore2.5/SRtensor_gpsgridder_more2.5y_NA_mm_larger_no_outliers.dat"
#
#
##gpsgridder_2D_SRtensor_I0.1_div4.dat
#
#awk '{print $1,$2,sqrt(($3*$3)+($4*$4)+2*($5*$5))}' $ST_gpsgridder > SRgpsgridder.temp
#
#
##gmt psbasemap $J1 $R1 -B -K -V -P $origin > $psfile2
#awk -v var=$norm3 '{print $1,$2,$3/var}'  SRgpsgridder.temp| gmt surface -G$grdfile2 $interp_surf $R1
#gmt makecpt -C$colorbar $Tstrain -D > $cptstrain
#gmt grdimage $grdfile2 $R1 $J1 -C$cptstrain -n+c -K  -V > $psfile2
#
##gmt psmask $mask_file $R1 $J1 $mask_info -K -O -V >> $psfile2
##gmt psmask -C -K -O -V >> $psfile2
##seismicity
#gmt psxy seis_cat2.temp  $R1 $J1 -Sc -W0.3p -Cfechaseism.cpt -K  -O -V  >> $psfile2
#gmt psxy seis.temp  $R1 $J1 -Sc -W0.3p -Cfechaseism.cpt -K  -O -V  >> $psfile2
#gmt psscale  -Cfechaseism.cpt -I -O -Dx15.5c/0.5c+w1.7i/0.1i  -Bx100+lTime -K >> $psfile2
#
#
#gmt psscale -C$cptstrain $Dscale $Bscale1 $Bscale2 -K -O -V >> $psfile2
#gmt pscoast $J1 $R1 -Ba2f1g0WSen:."Magnitude strain rate gpsgridder": $coast_infoW  -O -V >> $psfile2 
#
#
#
###### PLOT shen 2015 strain rate magnitude ############################################################################################
##Compute 2ndInvariant gpsgridder
##ST_straintool="straintool_results/large/Wt24/strain_info_straintool_large_Wt24.dat"
#ST_straintool="straintool_results/large/Wt24_no_outliers/strain_info_NA_mm_larger_Wt24_no_outliers.dat"
#
##gpsgridder_2D_SRtensor_I0.1_div4.dat
#
#awk '$1 !~ /Latitude/ && $1 !~ /deg/{print $2,$1,sqrt(($9*$9)+($13*$13)+2*($11*$11))}' $ST_straintool > SRstraintool.temp
#
#
##gmt psbasemap $J1 $R1 -B -K -V -P $origin > $psfile2
#awk  '{print $1,$2,$3}'  SRstraintool.temp| gmt surface -G$grdfile3 $interp_surf $R1
#gmt grdimage $grdfile3 $R1 $J1 -C$cptstrain -n+c -K  -V > $psfile3
#
##gmt psmask $mask_file $R1 $J1 $mask_info -K -O -V >> $psfile2
##gmt psmask -C -K -O -V >> $psfile2
##seismicity
#gmt psxy seis_cat2.temp  $R1 $J1 -Sc -W0.3p -Cfechaseism.cpt -K  -O -V  >> $psfile3
#gmt psxy seis.temp  $R1 $J1 -Sc -W0.3p -Cfechaseism.cpt -K  -O -V  >> $psfile3
#gmt psscale  -Cfechaseism.cpt -I -O -Dx15.5c/0.5c+w1.7i/0.1i  -Bx100+lTime -K >> $psfile3
#
#
#gmt psscale -C$cptstrain $Dscale $Bscale1 $Bscale2 -K -O -V >> $psfile3
#gmt pscoast $J1 $R1 -Ba2f1g0WSen:."Magnitude strain rate shen 2015": $coast_infoW  -O -V >> $psfile3 
#
#
#
#




