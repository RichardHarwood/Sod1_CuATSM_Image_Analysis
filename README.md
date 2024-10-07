# Sod1_CuATSM_Image_Analysis

The image analysis workflow has 5 main parts:
1) Hand annotate the region of interest and a sub region of interest containing the neurons
2) Identify a threshold range to capture SOD1 protein aggregates  
3) Create a deep learning model (retraining cellpose) to segment neurons (insert notebook name)
4) Run a batch process to analyze all the images (insert notebook name)
5) Collate all the CSVs created in step 4 (insert notebook name)

Briefly, here is an example of each step. 
## Hand annotate the region of interest and a sub region of interest containing the neurons
