/* 
 *  Macro for Quantification of Osteoclasts (OCL) and the number of Nuclei within each of them
 *  for ISM-2023 workshop on "Incorporating machine learning tools into image analysis workflows using Fiji, Ilastik and StarDist"
 *  
 * By: Ofra Golani, MICC-Cell Observatory, Weizmann Institute of Science
 * 
 * This macro process single composite image, ch1 for OCL, ch2 for Nuc
 * Related images are courtesy of Sabina Winograd-Katz and Benny Geiger 
 */
 
var IlastikExeLocation = "C:\\Program Files\\ilastik-1.4.0-gpu\\ilastik.exe";
var maxRAM = 24000; // MB , set to 50-80% of available RAM
var pixelClassifierLocation = "D:\\Ofra_Sync\\Docs\\BioImaging Training\\ISM-2023\\Classifiers\\OCL-PixelClassifier.ilp";

var minOCLSize = 300; 
var minOCLCircularity = 0.1; 

var outSubDir = "Results";

var setFixCountRange = 0;  // Use 1 to set fixed range of count color map 
var maxCountDisplay = 45;
var cleanupFlag = 0;

// Get Image name
origName = getTitle();
origNameNoExt = File.getNameWithoutExtension(origName);

// Create Output folder
inDir = File.directory;
outDir = inDir + File.separator + outSubDir + File.separator;
File.makeDirectory(outDir);

// Segment Nuc
run("Duplicate...", "title=Nuc duplicate channels=2");
selectWindow("Nuc");
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'Nuc', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'4', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
selectWindow("Label Image");
rename("NucLabel");
selectWindow("Nuc");
//roiManager("Show All");
roiManager("Show All without labels");
run("Flatten");
saveAs("Jpeg", outDir+origNameNoExt+"_AllNucOverlay.jpg");


// Segment OCL
selectWindow(origName);
run("Duplicate...", "title=OCL duplicate channels=1");
run("Configure ilastik executable location", "executablefile=["+IlastikExeLocation+"] numthreads=-1 maxrammb="+maxRAM);
run("Run Pixel Classification Prediction", "projectfilename=["+pixelClassifierLocation+"] inputimage=OCL pixelclassificationtype=Segmentation");
rename("ilastikLabelImage");
run("glasbey on dark");

setAutoThreshold("Default no-reset");
//setThreshold(0, 1);
run("Convert to Mask");
roiManager("reset");
run("Set Measurements...", "area mean standard modal perimeter fit shape feret's display redirect=None decimal=2");
run("Analyze Particles...", "size="+minOCLSize+"-Infinity circularity="+minOCLCircularity+"-1.00 show=[Count Masks] display exclude clear include add");
selectWindow("Count Masks of ilastikLabelImage");
rename("OCL_Label");
run("Fire");

selectWindow("OCL");
roiManager("Show All without labels");
run("Flatten");
saveAs("Jpeg", outDir+origNameNoExt+"_AllOCLOverlay.jpg");

// Associate Nuc with OCL
run("Object Inspector (2D/3D)", "primary_imageplus=OCL_Label secondary_imageplus=NucLabel original_1_title=OCL original_2_title=Nuc primary_volume_range=0-Infinity primary_mmer_range=0.00-1.00 secondary_volume_range=0-Infinity secondary_mmer_range=0.00-1.00 exclude_primary_objects_on_edges=true pad_stack_tops=false display_results_tables=true display_analyzed_label_maps=true show_count_map=true");

// Save Count Map with overlay (to show OCL with zero count)
selectWindow("CountMap_OCL_Label");
//selectWindow(origNameNoExt+"_CountMap_OCL");
roiManager("Show None");
roiManager("Show All");
if (setFixCountRange) { setMinAndMax(0, maxCountDisplay); }
run("Calibration Bar...", "location=[Lower Right] fill=White label=Black number=5 decimal=0 font=12 zoom=2 overlay");
run("Flatten");
saveAs("Jpeg", outDir+origNameNoExt+"_CountMap_OCL.jpg");

// Save Table of shape features & count (Mode) 
selectWindow("CountMap_OCL_Label");
rename(origNameNoExt+"_CountMap_OCL");  // rename to have the image name in the table 
run("Clear Results");
run("Set Measurements...", "area modal perimeter fit shape feret's display redirect=None decimal=2");
roiManager("Measure");
selectWindow("Results");
saveAs("Results", outDir+origNameNoExt+"_Results.csv");

// Save OCL Rois
roiManager("Save", outDir+origNameNoExt+"_OCLRoiSet.zip");

// Final QA Image
selectWindow(origName);
roiManager("Show All");
run("Flatten");
rename("tmpFlatten");

// replace OCL Rois with Final Nuc Rois
roiManager("reset");
selectWindow("final_NucLabel");
run("Label image to ROIs");
selectWindow("tmpFlatten");
roiManager("Set Color", "magenta");
roiManager("Set Line Width", 0);
roiManager("Show All");
run("Flatten");
saveAs("Jpeg", outDir+origNameNoExt+"_FinalOverlay.jpg");

// Save final Nuc Rois
roiManager("Save", outDir+origNameNoExt+"_FinalNucRoiSet.zip");

// Cleanup 
if (cleanupFlag)
{
	// close all image windows
	run("Close All");
	
	// reset RoiManger
	roiManager("reset");
	
	// close tables
	selectWindow("Primary_Results");
	run("Close");
	selectWindow("Secondary_Results");
	run("Close");
	//selectWindow(outDir+origNameNoExt+"_Results.csv");
	selectWindow("Results");
	run("Close");
}

