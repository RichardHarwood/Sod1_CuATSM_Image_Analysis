//Veronica Cottam September 2023
//This macro will batch process slide scanner mulit-channel images 
//for Greta's Honours thesis image analysis

//Ask user to select folder to process
Input_dir=getDirectory("Select folder"); 

//generate list of files in folder to process
list=getFileList(Input_dir);
list =Array.sort(list);
Array.print(list); //optional prints files in folder to log



//Loop to open images, split channels, process to masks
for(i=0; i<list.length; i++){
	filename=Input_dir+list[i];
if(endsWith(list[i], "ome.tif")){



//run Bioformats Importer
run("Bio-Formats Importer", "open=[filename]" + "autoscale color_mode=Grayscale view=Hyperstack stack_order=XYCZT openwindowless=true series_2");
 nameStore=File.nameWithoutExtension;
length = lengthOf(nameStore);
nameOnly = substring(nameStore, 0, length-4);
Output_dir= Input_dir+File.separator+"TIFF&MASK"+File.separator;
File.makeDirectory(Output_dir);
print(nameOnly);
  
  
  saveAs("Tiff",Output_dir+nameOnly+"_Tiff_format.tif");
  //Processing images ready for analysis 
  imgArray = newArray(nImages);
for (j=0; j<nImages; j++){
    selectImage(j+1);
    imgArray[j] = getImageID();
}
for (j=0; j<imgArray.length; j++) {
    selectImage(imgArray[j]);
   
    title = getTitle(); // grabbing the image title
    
    run("Duplicate...", "title=copy duplicate");
    //run("Z Project...", "projection=[Max Intensity]");
    run("Split Channels");
    for( k=1; k<=nImages; k++) {
       selectImage (k);
        setMinAndMax(115, 700);
   }
    
    run("Merge Channels...","c3=C1-copy c5=C3-copy c6=C2-copy c7=C4-copy ignore");
	print(title);
run("Color Balance...");
}


  
  setTool("polygon");

// Wait for user to define ROI and record slices
while (selectionType()<0){waitForUser("ROI","Draw ROI, then hit OK");}

//process to mask image
run("Fill", "stack");
run("Clear Outside", "stack");
run("Make Binary", "method=Default background=Dark calculate black");

//Saves msk image as .Tif


saveAs("Tiff",Output_dir+nameOnly+"_mask.tif");
close();

//CREATE NEURON MASK OUTLINE
for (j=0; j<imgArray.length; j++) {
    selectImage(imgArray[j]);
   
    title = getTitle(); // grabbing the image title
    
    run("Duplicate...", "title=copy duplicate");
    //run("Z Project...", "projection=[Max Intensity]");
    run("Split Channels");
    for( k=1; k<=nImages; k++) {
       selectImage (k);
        setMinAndMax(115, 700);
   }
    
    run("Merge Channels...","c3=C1-copy c5=C3-copy c6=C2-copy c7=C4-copy ignore");
	print(title);
run("Color Balance...");
}

//Wait for user to define 2nd ROI by Pressing Ctr+shift+E
while (selectionType()<0){waitForUser("Copy ROI","Select image, Press Ctrl + Shift + E, adjust, then hit OK");}
  


//process to mask image
run("Fill", "stack");
run("Clear Outside", "stack");
run("Make Binary", "method=Default background=Dark calculate black");

//Saves msk image as .Tif
saveAs("Tiff",Output_dir+nameOnly+"_neuron_outline.tif");
close();


//Wait for User to record slices
//CONTINUE

run("Split Channels");
    for( l=1; l<=nImages; l++) {
       selectImage (l);
        setMinAndMax(115, 700);
   }
//Prompts user to record min and max slice for analysis and move to SOD1 channel image    
waitForUser("Slices","Record min and max slices in excel, navigate to SOD1 channel then hit OK");

//Opens Theshold window
run("Threshold...");

//Prompts user to record threshold min and max values in excel
waitForUser("Threshold","Record Threshold min and max in excel then hit OK");



        
//Set tool to hand to avoid errors and close all images  
setTool("hand");
run("Close All");
 	
}}



