// Get Image name
origName = getTitle();
origNameNoExt = File.getNameWithoutExtension(origName);

run("Duplicate...", "title=Nuc duplicate channels=2");
selectWindow("Nuc");
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'Nuc', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'4', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
selectWindow("Label Image");
rename("NucLabel");
selectWindow("Nuc");
roiManager("Show All without labels");
run("Flatten");
saveAs("Jpeg", origNameNoExt+"NucOverlay.jpg");


