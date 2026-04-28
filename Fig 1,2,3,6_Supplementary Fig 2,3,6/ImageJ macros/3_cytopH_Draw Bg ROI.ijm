//Set Parent Directory
Parent = "Path_to_experiment_folder";

//Input Directory
Input = Parent+"input_images_subfolder 2D Aligned/"
//Get list of all files from Input
filelist = getFileList(Input);
//Output Directory
Output = Parent+"input_images_subfolder Bg ROI/"
File.makeDirectory(Output);


setTool("rectangle");
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) {
    	//Open file and get name
    	open(Input+"/"+filelist[i]);
    	name = File.nameWithoutExtension;
    	setMinAndMax(500, 800);
    	waitForUser("Make Background");
    	roiManager("add");
    	roiManager("Save", Output+name+".zip");
    	close("*"); 
    	close("Roi Manager");
    }
}
