#!/bin/bash

#T-Test Steps
#Need to conduct on all 30 subjects

#Blur Data
derDir=~/Desktop/Checkerboard/derivatives

cd $derDir
for i in sub*; do
    cd $i
    3dmerge -prefix checker_stats_blur8 -1blur_fwhm 8 -doall checker_stats+tlrc 
    cd $derDir
done

#Make Group Analysis Folder
mkdir ~/Desktop/Checkerboard/derivatives/grp-2020-12-03

#Mask
derDir=~/Desktop/Checkerboard/derivatives
outputDir=${derDir}/grp-2020-12-03
overlap=1 #proportion of overlap between scan runs required for mask. 0=any runs; 1=all runs

3dmask_tool -input ${derDir}/sub*/fmriprep_run*func_mask.nii.gz -frac $overlap -prefix ${outputDir}/func_mask

#T-Test, Group Analysis of Checkerboard - Blank Screen with Music
derDir=~/Desktop/Checkerboard/derivatives
outputDir=${derDir}/grp-2020-12-03

3dttest++ -prefix ${outputDir}/checker-music_blur8_masked \
-mask ${outputDir}/func_mask+tlrc \
-setA \
../sub-01/checker_stats_blur8+tlrc'[5]' \
../sub-02/checker_stats_blur8+tlrc'[5]' \
../sub-03/checker_stats_blur8+tlrc'[5]' \
../sub-04/checker_stats_blur8+tlrc'[5]' \
../sub-05/checker_stats_blur8+tlrc'[5]' \
../sub-06/checker_stats_blur8+tlrc'[5]' \
../sub-07/checker_stats_blur8+tlrc'[5]' \
../sub-08/checker_stats_blur8+tlrc'[5]' \
../sub-09/checker_stats_blur8+tlrc'[5]' \
../sub-10/checker_stats_blur8+tlrc'[5]' \
../sub-11/checker_stats_blur8+tlrc'[5]' \
../sub-12/checker_stats_blur8+tlrc'[5]' \
../sub-13/checker_stats_blur8+tlrc'[5]' \
../sub-14/checker_stats_blur8+tlrc'[5]' \
../sub-15/checker_stats_blur8+tlrc'[5]' \
../sub-16/checker_stats_blur8+tlrc'[5]' \
../sub-17/checker_stats_blur8+tlrc'[5]' \
../sub-18/checker_stats_blur8+tlrc'[5]' \
../sub-19/checker_stats_blur8+tlrc'[5]' \
../sub-20/checker_stats_blur8+tlrc'[5]' \
../sub-21/checker_stats_blur8+tlrc'[5]' \
../sub-22/checker_stats_blur8+tlrc'[5]' \
../sub-23/checker_stats_blur8+tlrc'[5]' \
../sub-24/checker_stats_blur8+tlrc'[5]' \
../sub-25/checker_stats_blur8+tlrc'[5]' \
../sub-26/checker_stats_blur8+tlrc'[5]' \
../sub-27/checker_stats_blur8+tlrc'[5]' \
../sub-28/checker_stats_blur8+tlrc'[5]' \
../sub-29/checker_stats_blur8+tlrc'[5]' \
../sub-30/checker_stats_blur8+tlrc'[5]' 

