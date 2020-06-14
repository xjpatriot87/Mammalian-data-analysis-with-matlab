# Mammalian-data-analysis-with-matlab
Matlab code for analyzing flow cytomety data of mammalian cells with internal control.
Step 1 Rename .fcs files.
Step 1.1 Make sure your .fcs files are named in this format "Specimen_001_A1_A01";
Step 1.2 Open file "filerename" with Matlab;
Step 1.3 Type in the dir of your .fcs files in line 3;
Step 1.4 Type in the row letter of your backgound sample in line 6;
Step 1.5 Type in the row letter of your samples in line 23;
Step 1.6 Type in the total number of your samples in line 30;
Step 1.7 Run;
Step 2 Run your samples.
Step 2.1 Open file "batread_LCB" with Matlab;
Step 2.2 Type in the dir of your .fcs files in line 3;
Step 2.3 Type in the total number of your background samples in line 6;
Step 2.3 Type in the total number of your samples in line 7;
Step 2.4 Change the data structure in line 156;
Step 2.5 Run;
Step 3 Find your data.
Step 3.1 The FITC/RFP ratio of each sample is stored in "mean_FITC-ratio";
