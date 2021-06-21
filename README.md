# hippocampal_ranging

Calculate the interrater reliability for the hippocampal ranging process, using
test sets and correct slices from the (HPC group)[https://gitlab.com/viraganna.varga/hippocampal-subfield-ranging/-/wikis/home/The-Hippocampal-Ranging-Process].

The script irr.R calculates the inter-rater reliability of the hippocampal segmentations, comparing 
ratings of starting and ending slices (right and left) with either correct slices (from the HPC group) or two independent raters. 

It requires to add the names of the file in the rater1 and rater2 folders in the following format:
`rater<1 or 2>.<test set>.<round>.`
For example, the the first round of ratings from the first set of images should be added in the following format:
`rater1.1.1` for rater 1; `rater2.1.1` for rater 2. 

The correct slices are already in the `correct.slices` folder. 

Description of the files:
### correct.slices
.csv files that are indicated as correct from the (Hippocampal Ranging Group)[https://gitlab.com/viraganna.varga/hippocampal-subfield-ranging/-/wikis/home/The-Hippocampal-Ranging-Process]
### rater1
.csv files containing information about the ranging for rater1 testsets
### test_sets
.csv files containing information about the ranging for rater2 for the testsets
### hippocampal_ranging.Rproj
R project file - useful to set the working directory automatically and save temporary changes
### irr.R 
R script that calculates the inter-rater reliability and plots the results
### irr.jpg
Plot of the irr as a function of test set