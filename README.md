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

Using the FIJI script, the two specific SN regions of interest were manually outlined using the polygon tool (prompted by the script) and converted to a binary-filled mask area to be added to analysis. The two regions being the smaller SN pars compacta (SNc) region and the larger SNc + SN pars reticulata (SNr) region. Following ROI selection in the FIJI script, the SOD1 channel intensity was manually thresholded  in FIJI to predetermined/arbitrary signal-to-noise values while the background pixels were reduced to no value. This accounted for variable illumination and image intensities between all images 

<p align="center">
<img  src="read_me_files/ROIS.png"/> 
</p>

###### Example of the 3D maks: the smaller SN pars compacta (SNc) region in red and the the larger SNc + SN pars reticulata (SNr) region in blu

