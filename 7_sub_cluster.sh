#!/bin/bash

#Clustering, run in the group analysis folder

#Blurring residuals

derDir=~/Desktop/Checker7/derivatives

cd $derDir
for i in sub*; do
cd $i
3dmerge -prefix checker_errts_blur8 -1blur_fwhm 8 -doall checker_errts+tlrc 
cd $derDir
done

#Estimate autocorrelation function (ACF)

derDir=~/Desktop/Checker7/derivatives
outputDir=${derDir}/grp-2020-12-07
mask=${outputDir}/func_mask+tlrc
acfFile=${outputDir}/ACF_raw.txt
cd $derDir

for i in sub*; do
cd $i
3dFWHMx -mask $mask -input checker_errts_blur8+tlrc -acf >> $acfFile
cd $derDir
done

#Monte Carlo Simulation

derDir=~/Desktop/Checker7/derivatives
outputDir=${derDir}/grp-2020-12-07
mask=${outputDir}/func_mask+tlrc
acfFile=${outputDir}/ACF_raw.txt

cd $outputDir

sed '/ 0 0 0 0/d' $acfFile > tmp

xA=`awk '{ total += $1 } END { print total/NR }' tmp`
xB=`awk '{ total += $2 } END { print total/NR }' tmp`
xC=`awk '{ total += $3 } END { print total/NR }' tmp`

3dClustSim -mask $mask -LOTS -iter 10000 -acf $xA $xB $xC > ACF_MC.txt
rm tmp

