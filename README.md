# Sod1_CuATSM_Image_Analysis

The image analysis workflow has 5 main parts:
1) Hand annotate the region of interest and a sub region of interest containing the neurons
2) Identify a threshold range to capture SOD1 protein aggregates  
3) Create a deep learning model (retraining cellpose) to segment neurons (insert notebook name)
4) Run a batch process to analyze all the images (insert notebook name)
5) Collate all the CSVs created in step 4 (insert notebook name)

Briefly, here is an example of each step. 

## Hand annotate the region of interest and a sub region of interest containing the neurons

Raw slide scanner z-stack immunofluorescence images (.vsi files) of slides stained with SOD1, TH, GFAP and Hoechst were prepared for downstream analysis by first cropping and exporting a large substantia nigral (SN) region of interest (ROI) using QuPath (v.0.5.1) as an ome.tiff with no compression. These exported ome files were loaded into a FIJI macro script (see github files 1) which allowed for consistent file preparation. The script involves multiple prompts requiring inputs at each stage of image preparation. From this script, the second series of the ome files (resolution 2200x1889) were saved as tiff files for which the brightness and contrast of all images were set to a defined grayscale intensity 115-700 to ensure uniform SOD1 thresholding between mice and z-slices where all channels were in focus were noted for downstream quantitative analysis.

Using the FIJI script, the two specific SN regions of interest were manually outlined using the polygon tool (prompted by the script) and converted to a binary-filled mask area to be added to analysis. The two regions being the smaller SN pars compacta (SNc) region (an example shown in red below) and the larger SNc + SN pars reticulata (SNr) region (an example shown in blue below). 

<p align="center">
<img  src="read_me_files/ROIS.png" width="50%" height="50%" /> 
</p>


## Identify a threshold range to capture SOD1 protein aggregates 

Following ROI selection in the FIJI script, the SOD1 channel intensity was manually thresholded  in FIJI to predetermined/arbitrary signal-to-noise values while the background pixels were reduced to no value. This accounted for variable illumination and image intensities between all images 

###### Create a deep learning model (retraining cellpose) to segment neurons

A custom trained deep learning artificial intelligence (AI) cellpose model called “cellpose-residual_on_styple_on_concatenation_off_train_folder_2024_04_11_16_19_30.312228”  (see github files 2) was trained for use in downstream neuron stereological analysis. This cellpose model was trained on 50 2-dimensional image slices from 16 z-stack images (from 8 different mice; 10% of cohort) which had been manually segmented by one investigator. It was then applied to an additional set of 8 slices in which neurons had also been manually segmented and counted, resulting stereological counts exhibited an accuracy of 0.72 and f1 score of 0.83. These performance results are similar to previous studies utilising AI tissue-based cell segmentation for images with an increased signal-to-noise ratio (Ghoddousi, 2022; Han, 2023 ). 

<p align="center">
<img  src="read_me_files/raw.png" width="30%" height="30%"/> 
</p>
###### Example 2-dimensional raw image slices from z-stack.

<p align="center">
<img  src="read_me_files/raw.png" width="30%" height="30%"/> 
</p>
###### Example 2-dimensional raw image slices from z-stack with corresponding mask to (re)train cellpose. 







