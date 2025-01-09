//Veronica Cottam June 2024
//This macro will batch process slide scanner mulit-channel images for Miriams's SpC image analysis
//ISL-1 staining is segmented using analysis particle and temporally associated CHAT 
//staining is measured for colocalisation to confirm motor neurons. Double positive neurons will be counted in excel for data analysisi

//Ask user to select folder to process
Input_dir=getDirectory("Select folder"); 

//generate list of files in folder to process
list=getFileList(Input_dir);
list =Array.sort(list);
Array.print(list); //optional prints files in folder to log

//Loop to open .tif image and run segmentaion processes 
for(i=0; i<list.length; i++){
	filename=Input_dir+list[i];
if(endsWith(list[i], ".tif")){


 open(filename);
//shortens file name to be animal ID only
 nameStore=File.nameWithoutExtension;
 length = lengthOf(nameStore);
 lengthb = length -11;
 nameOnly = substring(nameStore, 0, length-lengthb);
 Output_dir= Input_dir+File.separator+nameOnly+"_Results"+File.separator;
 Excel_dir= Input_dir+File.separator+"Excel_Files"+File.separator;
 File.makeDirectory(Output_dir);
  File.makeDirectory(Excel_dir);
 //print (length);
// print (lengthb);
// print(nameOnly);

//Setting up measures to be recoreded- see analyze> set measure  for options
 roiManager("reset");
 run("Clear Results");
 run("Set Measurements...", "area mean min centroid perimeter feret's display add redirect=None decimal=3");
 
// Duplicate image and split the colour channels
 title = getTitle(); // grabbing the image title
 run("Duplicate...", "title=copy duplicate");
 run("Split Channels");//C1-Hoescht C2-ChAT C3-ISL-1

//Select ISL-1 channel and auto threshold using Yen method
selectImage("C3-copy");
//run("Brightness/Contrast...");
//setMinAndMax(100,250);
run("Enhance Contrast...", "saturated=0.2 normalize");
run("Subtract Background...", "rolling=100");
setAutoThreshold("Yen dark no-reset");
setOption("BlackBackground", true); 
run("Convert to Mask");
run("Erode");
 run("Fill Holes");
  run("Median", "radius=3");
//Segment ISL-1 nuclei using anlayse particle
run("Analyze Particles...", "size=50-Infinity circularity=0.15-1.00 show=[Overlay Masks] exclude overlay add");
   //}
 saveAs("Tiff",Output_dir+nameOnly+"_ISL1_segmentation.tif");
 close();
 roi_count = roiManager("count");
// print (roi_count);
if(roi_count==0){run("Close All"); print(nameOnly+"No Cells");}
if(roi_count>0){
//Measue intensity of ChAT staining surrounding segmented ISL-1 nuclei
selectImage("C2-copy");//ChAT channel
setMinAndMax(50, 700);
 rename (nameOnly);
 roiManager("show all"); //show ISL-1 segmentation on Chat channel
 roiManager("Save",Output_dir+nameOnly+"_ISL1.zip"); //save ISL-1 segmentations in ROI manager
  
	 for(j=0; j< roi_count; j++){
    	roiManager("select", j);
    	roiManager("rename",j+1 +"_ISL1");
    	run("Measure"); //Measures ChAT staining intensity for area of ISL-1 nuclei
    	
    	feret=getValue("Feret"); //longest "diameter" of ISL-1 nuclei
    	radius=feret/4; //selected proportion used to enlarge nuclei area - seems to cover cell area appropriately
    	//print(radius);
    	roiManager("select", j);
    	roiManager("rename",j+1 +"_ChAT");
    	run("Enlarge...", "enlarge=radius"); //enlarges ISL-1 area proportional to ISL segmentation
    	roiManager("add");
    	roiManager("Update");
    	run("Measure");
    
	 }
    	 roiManager("show all");
    	saveAs("Tiff",Output_dir+nameOnly+"_ChAT_segmentation.tif");
    	roiManager("Save",Output_dir+nameOnly+"_ChAT.zip");
    lengthc= lengthOf(nameOnly);
 lengthd = lengthc-5;
    nameOnlyms=substring(nameOnly,0,lengthc-lengthd);
   
    
    saveAs("Results",Excel_dir+nameOnly+"Results.xls"); 
    	roiManager("reset");
  run("Close All");
    }}}
run("Close All");
