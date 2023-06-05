var IlastikExeLocation = "C:\\Program Files\\ilastik-1.4.0-gpu\\ilastik.exe";
var maxRAM = 24000; // MB , set to 50-80% of available RAM
var pixelClassifierLocation = "D:\\Ofra_Sync\\Docs\\BioImaging Training\\ISM-2023\\Classifiers\\OCL-PixelClassifier.ilp";

var minOCLSize = 300; 
var minOCLCircularity = 0.1; 

// Get Image name
origName = getTitle();
origNameNoExt = File.getNameWithoutExtension(origName);

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
saveAs("Jpeg", origNameNoExt+"_OCLOverlay.jpg");

