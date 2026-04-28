//Set Parent Directory
Parent = "Path_to_experiment_folder";

//Input Directory
Input = Parent+"input_images_subfolder 2D Aligned/"
//Input = Parent+"Deconvolved Avg/"
Input2 = Parent+"input_images_subfolder Bg ROI/"
//Get list of all files from Input
filelist = getFileList(Input);
filelist2 = getFileList(Input2);
Array.sort(filelist);
Array.sort(filelist2);
//Output Directory
Output = Parent+"input_images_subfolder 2D BgS/"
//Output = Parent+"Deconvolved Avg BgS/"
File.makeDirectory(Output);


setTool("rectangle");
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) {
    	//Open file and get name
    	print(filelist[i]);
    	print(filelist2[i]);
    	open(Input+filelist[i]);
    	name = File.nameWithoutExtension;
    	
    	open(Input2+filelist2[i]);
   		roiManager("Select", 0);
   		//wait(1000);
   		close("Roi Manager");
    	BgS_3D();
    	saveAs("Tiff", Output+name);
    	close("*"); 	
    }
}



function BgS_2D() { 
	//Ask User to make background ROI
	//waitForUser("Make Background");
	//Measure Mean Background Intensity
	run("Measure");
	//Read measured background intensity
	bg = getResult("Mean", 0);
	close("Results");
	//Unselect background ROI
	run("Select None");
	//Subtract background
	run("Subtract...", "value="+bg);
	resetMinAndMax;
}


function BgS_3D() { 
	//Ask User to make background ROI
	//waitForUser("Make Background");
	getSelectionBounds(x, y, width, height);
	run("Select None");
	//Measure Mean Background Intensity
	for (i = 1; i <= nSlices; i++) {
    	setSlice(i);
    	makeRectangle(x, y, width, height);
    	run("Measure");
    	//wait(1000);
    	//Read measured background intensity
    	bg = getResult("Mean", 0);
    	close("Results");
		//Unselect background ROI
		run("Select None");
		//Subtract background
		run("Subtract...", "value="+bg+" slice");
	}
	setSlice(nSlices/2);
	resetMinAndMax;
}
