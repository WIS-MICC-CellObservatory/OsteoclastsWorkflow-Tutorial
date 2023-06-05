run("Duplicate...", "title=OCL duplicate channels=1");
run("Configure ilastik executable location", "executablefile=[C:\\Program Files\\ilastik-1.4.0-gpu\\ilastik.exe] numthreads=-1 maxrammb=150000");
run("Run Pixel Classification Prediction", "projectfilename=[D:\\Ofra_Sync\\Docs\\BioImaging Training\\ISM-2023\\Classifiers\\OCL-PixelClassifier.ilp] inputimage=OCL pixelclassificationtype=Segmentation");
selectWindow("d:\Users\ofrag\AppData\Local\Temp\ilastik4j9010447186865156826_out.h5\exported_data");
rename("ilastikLabelImage");
run("glasbey on dark");

setAutoThreshold("Default no-reset");
//run("Threshold...");
//setThreshold(0, 1);
run("Convert to Mask");
selectWindow("OCL");

run("Set Measurements...", "area mean standard modal perimeter fit shape feret's display redirect=None decimal=2");
run("Analyze Particles...", "size=300-Infinity circularity=0.1-1.00 show=[Count Masks] display exclude clear include add");
selectWindow("Count Masks of ilastikLabelImage");
rename("OCL_Label");
run("Fire");

selectWindow("OCL");
roiManager("Show All without labels");
run("Flatten");
saveAs("Jpeg", "A9_OCLOverlay.jpg");

