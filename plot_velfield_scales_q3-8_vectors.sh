#!/bin/bash

#west=-81
#east=-58
#south=40
#north=52
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
gmt gmtset FONT_ANNOT_PRIMARY 18 FONT_LABEL 18 MAP_FRAME_WIDTH 0.15c FONT_TITLE 18p,Arial
gmt gmtset PS_MEDIA ${PAPER_SIZE}
gmt gmtset COLOR_MODEL hsv

#reso="-I"$1"/"$1
#projscale=6000000
#J1="-Jm24/37/1:$projscale"

##files to change------------------------------------------------------------------------------------------
#e_outgrdgps="e_dd_"$1"I_"$1"gps_large.grd"
#n_outgrdgps="n_dd_"$1"I_"$1"gps_large.grd"


origin="-X1.5 -Y1.75"
#color
colorbar="/home/gmeneses/Documents/RUB/Research/GMT/ScientificColourMaps7/vik/vik.cpt"
#colorbar="/home/gmeneses/Documents/RUB/Research/GMT/ScientificColourMaps7/lajolla/lajolla.cpt"


colorbarseism="/home/gmeneses/Documents/RUB/Research/GMT/ScientificColourMaps7/batlow/batlow.cpt"

#dir0="/home/gmeneses/local/compearth-master/surfacevel2strain"
#vel_dir0=$dir0"/matlab_output/CHVX/test4_velmore2.5mm"
vel_dir0="./"$1
inputvel=$vel_dir0"/"$3
#with error ellipse
#awk '{print $1,$2,$3,$4,$6,$7,"0"}' $inputvel > inputvel_h.temp
#awk '{print $1,$2,"0",$5}' $inputvel > inputvel_up.temp
#without
awk '{print $1,$2,$3,$4}' $inputvel > inputvel_h.temp
awk '{print $1,$2,"0",$5}' $inputvel > inputvel_up.temp
awk '{print $1,$2,"0",$14}' $inputvel > stanames.temp

#label file names
itag="italy"
dlab="d02"
qlab="q03_q08"
blab="b1"
nlab="3D"
slab="s1"
ulab="u0"
name=$itag"_"$dlab"_"$qlab"_"$blab"_"$nlab"_"$slab"_"$ulab


#velocity field
vfield_e=$vel_dir0"/"$name"_vfield_east_plot.dat"
vfield_s=$vel_dir0"/"$name"_vfield_south_plot.dat"
vfield_up=$vel_dir0"/"$name"_vfield_up_plot.dat"

res1=0.4
res2=0.2
#east
awk '{print $1,$2,$4}' $vfield_e >3-5e.temp
awk '{print $1,$2,$5}' $vfield_e > 6e.temp
awk '{print $1,$2,$6}' $vfield_e > 7e.temp
awk '{print $1,$2,$7}' $vfield_e > 8e.temp
#awk '{print $1,$2,$8}' $vfield_e  > 9e.temp
awk '{print $1,$2,$3}' $vfield_e  > alle.temp
#less vectors east
gmt xyz2grd 3-5e.temp -G3-5e.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 3-5e.grd > 3-5e.temp
gmt xyz2grd 6e.temp -G6e.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 6e.grd > 6e.temp
gmt xyz2grd 7e.temp -G7e.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 7e.grd > 7e.temp
gmt xyz2grd 8e.temp -G8e.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 8e.grd > 8e.temp
gmt xyz2grd 9e.temp -G9e.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 9e.grd > 9e.temp
gmt xyz2grd alle.temp -Galle.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz alle.grd > alle.temp
#south (important that for GMT I need to give the north component, mult. by -1)
awk '{print $1,$2,$4*-1}' $vfield_s >3-5s.temp
awk '{print $1,$2,$5*-1}' $vfield_s > 6s.temp
awk '{print $1,$2,$6*-1}' $vfield_s > 7s.temp
awk '{print $1,$2,$7*-1}' $vfield_s > 8s.temp
#awk '{print $1,$2,$8*-1}' $vfield_s  > 9s.temp
awk '{print $1,$2,$3*-1}' $vfield_s  > alls.temp
#less vectors south
gmt xyz2grd 3-5s.temp -G3-5s.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 3-5s.grd | awk '{print $3}' > 3-5s.temp
gmt xyz2grd 6s.temp -G6s.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 6s.grd | awk '{print $3}' > 6s.temp
gmt xyz2grd 7s.temp -G7s.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 7s.grd | awk '{print $3}' > 7s.temp
gmt xyz2grd 8s.temp -G8s.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 8s.grd | awk '{print $3}' > 8s.temp
#gmt xyz2grd 9s.temp -G9s.grd -I$res1 $R1 $J1 -NNaN -V
#gmt grd2xyz 9s.grd | awk '{print $3}' > 9s.temp
gmt xyz2grd alls.temp -Galls.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz alls.grd | awk '{print $3}' > alls.temp


#horizontal velocity field text files
paste 3-5e.temp 3-5s.temp > 3-5h.temp
paste 6e.temp 6s.temp > 6h.temp
paste 7e.temp 7s.temp > 7h.temp
paste 8e.temp 8s.temp > 8h.temp
#paste 9e.temp 9s.temp > 9h.temp
paste alle.temp alls.temp > allh.temp

#vertical (up)
awk '{print $1,$2,$4}' $vfield_up >3-5up.temp
awk '{print $1,$2,$5}' $vfield_up > 6up.temp
awk '{print $1,$2,$6}' $vfield_up > 7up.temp
awk '{print $1,$2,$7}' $vfield_up > 8up.temp
#awk '{print $1,$2,$8}' $vfield_up  > 9up.temp
awk '{print $1,$2,$3}' $vfield_up  > allup.temp
#less vectors up
gmt xyz2grd 3-5up.temp -G3-5up.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 3-5up.grd | awk '{print $1,$2,"0",$3}' > 3-5up.temp
gmt xyz2grd 6up.temp -G6up.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 6up.grd | awk '{print $1,$2,"0",$3}' > 6up.temp
gmt xyz2grd 7up.temp -G7up.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 7up.grd | awk '{print $1,$2,"0",$3}' > 7up.temp
gmt xyz2grd 8up.temp -G8up.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz 8up.grd | awk '{print $1,$2,"0",$3}' > 8up.temp
#gmt xyz2grd 9up.temp -G9up.grd -I$res1 $R1 $J1 -NNaN -V
#gmt grd2xyz 9up.grd | awk '{print $1,$2,"0",$3}' > 9up.temp
gmt xyz2grd allup.temp -Gallup.grd -I$res1 $R1 $J1 -NNaN -V
gmt grd2xyz allup.grd | awk '{print $1,$2,"0",$3}' > allup.temp


mask_info="-I0.1 -G200 -S0.2"
interp_surf="-I0.05 -T0"

# color bar
Dlen=9.5
xlegend=5.5
ylegend=4

Dx=`echo $xlegend + 2.7 + $Dlen/2 | bc -l`
Dy=`echo $ylegend + 0.5 | bc -l`
Dscale="-Dx"$Dx"/"$Dy"/"$Dlen"/0.35"
Bscale1="-Bx1+lv"$1
Bscale2="-By+lmm/y"
#pscoast parameters
coast_res="-A500 -Di"
coast_infoW="$coast_res -W1 -N1"
xtick1=2 
xtick2=0.25
#B0="-Ba"$xtick1"f"$xtick2"d::"
#B=$B0
psfile1u=$vel_dir0"/predicted_vfield_q3-5_up.ps"
psfile2u=$vel_dir0"/predicted_vfield_q6_up.ps"
psfile3u=$vel_dir0"/predicted_vfield_q7_up.ps"
psfile4u=$vel_dir0"/predicted_vfield_q8_up.ps"
#psfile5u=$vel_dir0"/predicted_vfield_q9_up.ps"
psfile6u=$vel_dir0"/predicted_vfield_qall_up.ps"

psfile1h=$vel_dir0"/predicted_vfield_q3-5_h.ps"
psfile2h=$vel_dir0"/predicted_vfield_q6_h.ps"
psfile3h=$vel_dir0"/predicted_vfield_q7_h.ps"
psfile4h=$vel_dir0"/predicted_vfield_q8_h.ps"
#psfile5h=$vel_dir0"/predicted_vfield_q9_h.ps"
psfile6h=$vel_dir0"/predicted_vfield_qall_h.ps"

scale="0.02c"

####################################### horizontal plots ###################################################
lhvel=20
lhvel2=2
#horizontal vel
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."horizontal predicted velocity field (q=3-5) - "$2:  -K > $psfile1h
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile1h
gmt psvelo 3-5h.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta -K -V -O >> $psfile1h
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile1h
16.5 38 $lhvel 0 $lhvel2 $lhvel2 
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile1h
16 37.5 0 $lhvel+-$lhvel2 mm/y 
EOF

#plot 2 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."horizontal predicted velocity field (q=6) - "$2:  -K > $psfile2h
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile2h
gmt psvelo 6h.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile2h
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile2h
16.5 38 $lhvel 0 $lhvel2 $lhvel2 
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile2h
16 37.5 0 $lhvel+-$lhvel2 mm/y 
EOF

#plot 3 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."horizontal predicted velocity field (q=7) - "$2:  -K > $psfile3h
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile3h
gmt psvelo 7h.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile3h
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile3h
16.5 38 $lhvel 0 $lhvel2 $lhvel2
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile3h
16 37.5 0 $lhvel+-$lhvel2 mm/y 
EOF

#plot 4 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."horizontal predicted velocity field (q=8) - "$2:  -K > $psfile4h
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile4h
gmt psvelo 8h.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile4h
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile4h
16.5 38 $lhvel 0 $lhvel2 $lhvel2
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile4h
16 37.5 0 $lhvel+-$lhvel2 mm/y 
EOF

#plot 5 
#gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."horizontal predicted velocity field (q=9)":  -K > $psfile5h
#gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile5h
#gmt psvelo 9h.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile5h
##LEGEND
#gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile5h
#16.5 38 1 0 0.1 0.1 0
#EOF
#gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile5h
#16 37.5 0 1 +- 0.1 mm/y 
#EOF

#plot 6 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."horizontal predicted velocity field (q=3-8) - "$2:  -K > $psfile6h
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile6h
gmt psvelo allh.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A0.3c+e+p1.5p+gmagenta -Wthinnest,magenta  -V -O -K >> $psfile6h
gmt psvelo inputvel_h.temp $R1 $J1 -Se$scale/0.95  -A0.3c+e+p1.5p+gblue -Wthinnest,blue -K -V -O >> $psfile6h
gmt pstext stanames.temp $R1 $J1 -O -V -F+f12,1,black+j -K >> $psfile6h

#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile6h
16.5 38 $lhvel 0 $lhvel2 $lhvel2
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile6h
16 37.5 0 $lhvel+-$lhvel2 mm/y 
EOF

######################################### vertical plots ##########################################################################

#vertical vel
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."vertical predicted velocity field (q=3-5) - "$2:  -K > $psfile1u
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile1u
gmt psvelo 3-5up.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta -K -V -O >> $psfile1u
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile1u
16.5 38 5 0 0.5 0.5 0
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile1u
16 37.5 0 5 +- 0.5 mm/y 
EOF

#plot 2 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."vertical predicted velocity field (q=6) - "$2:  -K > $psfile2u
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile2u
gmt psvelo 6up.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile2u
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile2u
16.5 38 1 0 0.1 0.1 0
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile2u
16 37.5 0 1 +- 0.1 mm/y
EOF

#plot 3 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."vertical predicted velocity field (q=7) - $2":  -K > $psfile3u
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile3u
gmt psvelo 7up.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile3u
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile3u
16.5 38 1 0 0.1 0.1 0
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile3u
16 37.5 0 1 +- 0.1 mm/y 
EOF

#plot 4 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."vertical predicted velocity field (q=8) - $2":  -K > $psfile4u
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile4u
gmt psvelo 8up.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile4u
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile4u
16.5 38 1 0 0.1 0.1 0
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile4u
16 37.5 0 1 +- 0.1 mm/y 
EOF

#plot 5 
#gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."vertical predicted velocity field (q=9)":  -K > $psfile5u
#gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile5u
#gmt psvelo 9up.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A+n+e -Wthickest,magenta  -V -O -K >> $psfile5u
##LEGEND
#gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile5u
#16.5 38 1 0 0.1 0.1 0
#EOF
#gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile5u
#16 37.5 0 1 +- 0.1 mm/y 
#EOF

#plot 6 
gmt psbasemap $R1 $J1  -Ba2f1g0WSen:."vertical predicted velocity field (q=3-8) - "$2:  -K > $psfile6u
gmt pscoast $R1 $J1 -W0.25  -Di -A200 -K  -O -V  -N1  >> $psfile6u
gmt psvelo allup.temp $R1 $J1 -Se$scale/0.95  -Gmagenta -A0.3c+e+p1.5p+gmagenta -Wthinnest,magenta  -V -O -K >> $psfile6u
gmt psvelo inputvel_up.temp $R1 $J1 -Se$scale/0.95  -A0.3c+e+p1.5p -Wthinnest,blue -K -V -O >> $psfile6u
#LEGEND
gmt psvelo $R1 $J1 -Se$scale/0.95 -Gblack -Wthick,black -A+n+e -K -O -V  << EOF >> $psfile6u
16.5 37 0 5 
EOF
gmt pstext $R1 $J1 -O -V -F+f12,1,black+j << EOF >>$psfile6u
16 36.5 0 5 +- 0.5 mm/y 
EOF

gmt psconvert $psfile1h -A -Tg
rm $psfile1h
gmt psconvert $psfile2h -A -Tg
rm $psfile2h
gmt psconvert $psfile3h -A -Tg
rm $psfile3h
gmt psconvert $psfile4h -A -Tg
rm $psfile4h
#gmt psconvert $psfile5h -A -Tf
#rm $psfile5h
gmt psconvert $psfile6h -A -Tg
rm $psfile6h


gmt psconvert $psfile1u -A -Tg
rm $psfile1u
gmt psconvert $psfile2u -A -Tg
rm $psfile2u
gmt psconvert $psfile3u -A -Tg
rm $psfile3u
gmt psconvert $psfile4u -A -Tg
rm $psfile4u
#gmt psconvert $psfile5u -A -Tf
#rm $psfile5u
gmt psconvert $psfile6u -A -Tg
rm $psfile6u


