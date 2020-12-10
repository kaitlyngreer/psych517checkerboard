#!/bin/bash

#First Level Analyses

#Moving to Folder on Desktop
derDir=~/Desktop/Checkerboard/derivatives

for sub in sub-*; do 
    mkdir ${derDir}/${sub}
    cd $sub
    for run in 1; do
        cp dt-neuro-anat-t1w.tag-fmriprep.run-${run}.id-*/t1.nii.gz ${derDir}/${sub}/fmriprep_run-${run}_t1.nii.gz
        cp dt-neuro-func-regressors.tag-fmriprep.run-${run}.id-*/regressors.json ${derDir}/${sub}/fmriprep_run-${run}_regressors.json
        cp dt-neuro-func-regressors.tag-fmriprep.run-${run}.id-*/regressors.tsv ${derDir}/${sub}/fmriprep_run-${run}_regressors.tsv
        cp dt-neuro-func-task.tag-flanker.tag-bold.tag-fmriprep.tag-preprocessed.run-${run}.id-*/bold.nii.gz ${derDir}/${sub}/fmriprep_run-${run}_bold.nii.gz
        cp dt-neuro-mask.tag-anat.tag-brain.run-${run}.id-*/mask.nii.gz ${derDir}/${sub}/fmriprep_run-${run}_anat_mask.nii.gz
        cp dt-neuro-mask.tag-task.tag-brain.tag-bold.run-${run}.id-*/mask.nii.gz ${derDir}/${sub}/fmriprep_run-${run}_func_mask.nii.gz
        cp -r dt-report-html.tag-fmriprep.run-${run}.id-* ${derDir}/${sub}/fmriprep_output_run-${run}
    done
    cp -r dt-neuro-freesurfer.id-* ${derDir}/${sub}/freesurfer
    cd ..
done

#Creating Timing Files (20 seconds of checkerboard & 20 seconds of music)
#Read in the events.tsv file as the timing file 
#Create a text file from the events.tsv for each number corresponding to the checkerboard (0 40 80 etc) and save as checkerboard.txt
#Create a text file from the events.tsv for each number corresponding to the music task (20 60 100 etc) and save as music.txt

#Motion Regressors
for i in sub*; do 
    cd $i
    1dcat fmriprep_run-1_regressors.tsv'[trans_x,trans_y,trans_z,rot_x,rot_y,rot_z]' >> motion.txt
    cd ..
done

for i in sub*; do 
    cd $i
    1d_tool.py -infile motion.txt -set_nruns 1 -demean -write motion_demean.txt
    1d_tool.py -infile motion_demean.txt -set_nruns 1 -show_censor_count -censor_prev_TR -censor_motion 0.3 motion
    1d_tool.py -infile motion_demean.txt -set_nruns 1 -split_into_pad_runs motion_demean_split
    cd ..
done

#Mask
for i in sub*; do
    cd $i
    3dmask_tool -union -input fmriprep_run-1_func_mask.nii.gz -prefix func_mask.nii.gz
    cd ..
done

#First-Level Regression Analysis
derDir=~/Desktop/Checkerboard/derivatives

cd $derDir

for i in sub*; do
cd $i

3dDeconvolve -input fmriprep_run-1_bold.nii.gz \
     -censor motion_censor.1D \
     -mask func_mask.nii.gz \
     -polort A \
     -num_stimts 8 \
     -stim_file 1 motion_demean.txt'[0]' -stim_base 1 -stim_label 1 trans_x \
     -stim_file 2 motion_demean.txt'[1]' -stim_base 2 -stim_label 2 trans_y \
     -stim_file 3 motion_demean.txt'[2]' -stim_base 3 -stim_label 3 trans_z \
     -stim_file 4 motion_demean.txt'[3]' -stim_base 4 -stim_label 4 rot_x \
     -stim_file 5 motion_demean.txt'[4]' -stim_base 5 -stim_label 5 rot_y \
     -stim_file 6 motion_demean.txt'[5]' -stim_base 6 -stim_label 6 rot_z \
     -stim_times 7 checkerboard.txt 'BLOCK(20,1)'   -stim_label 7 checkerboard \
     -stim_times 8 music.txt 'BLOCK(20,1)' -stim_label 8 music \
     -gltsym 'SYM: checkerboard -music' -glt_label 1 checker-music \
     -tout \
     -x1D X.generalize.xmat.1D \
     -xjpeg X.checker.jpg \
     -errts checker_errts \
     -bucket checker_stats\
     -jobs 2

cd $derDir
done



