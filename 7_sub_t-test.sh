#!/bin/bash

#T-Test Steps
#Subjects 24-30

#Blur Data
derDir=~/Desktop/Checker7/derivatives

cd $derDir
for i in sub*; do
    cd $i
    3dmerge -prefix checker_stats_blur8 -1blur_fwhm 8 -doall checker_stats+tlrc 
    cd $derDir
done

#Make Group Analysis Folder
mkdir ~/Desktop/Checkerboard/derivatives/grp-2020-12-07

#Mask
derDir=~/Desktop/Checker7/derivatives
outputDir=${derDir}/grp-2020-12-07
overlap=1 #proportion of overlap between scan runs required for mask. 0=any runs; 1=all runs

3dmask_tool -input ${derDir}/sub*/fmriprep_run*func_mask.nii.gz -frac $overlap -prefix ${outputDir}/func_mask

#T-Test (n=7), Group Analysis of Checkerboard - Blank Screen with Music
derDir=~/Desktop/Checker7/derivatives
outputDir=${derDir}/grp-2020-12-07

3dttest++ -prefix ${outputDir}/checker-music_blur8_masked \
-mask ${outputDir}/func_mask+tlrc \
-setA \
../sub-24/checker_stats_blur8+tlrc'[5]' \
../sub-25/checker_stats_blur8+tlrc'[5]' \
../sub-26/checker_stats_blur8+tlrc'[5]' \
../sub-27/checker_stats_blur8+tlrc'[5]' \
../sub-28/checker_stats_blur8+tlrc'[5]' \
../sub-29/checker_stats_blur8+tlrc'[5]' \
../sub-30/checker_stats_blur8+tlrc'[5]' 

